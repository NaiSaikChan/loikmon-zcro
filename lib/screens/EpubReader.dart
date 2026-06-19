import 'dart:convert';
import 'dart:math';

import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loikmon/audio_player/BookAudioPlayerPage.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/AudioPlayerModel.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:http/http.dart' as http;
import 'package:internet_file/internet_file.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EpubReader extends StatefulWidget {
  const EpubReader({Key? key, this.epub}) : super(key: key);
  static const routeName = "/EpubReader";
  final Books? epub;

  @override
  State<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends State<EpubReader> {
  late AppStateManager appStateManager;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Books? books;

  bool isloading = true;
  bool isfullscreen = false;

  double fontsize = 18;
  double linespacing = 20;
  int fonttype = 0;

  List<dynamic> _audiochapters = [];
  bool _loadingChapters = true;
  bool _hasAudio = false;

  epubx.EpubBook? _epubBook;
  List<epubx.EpubChapter> _chapters = [];
  final PageController _chapterController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    books = widget.epub;
    _init();
    _fetchBookChapters();
  }

  Future<void> _init() async {
    await getFontType();
    await getFontSize();
    await getLineSpacing();
    await openBook();
  }

  @override
  void deactivate() {
    if (!kIsWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (!kIsWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
    _chapterController.dispose();
    super.dispose();
  }

  Future<void> setFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("epubfontsize", fontsize);
  }

  Future<void> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    fontsize = prefs.getDouble("epubfontsize") ?? 18;
  }

  Future<void> setFontType(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("fonttype", value);
  }

  Future<void> getFontType() async {
    final prefs = await SharedPreferences.getInstance();
    fonttype = prefs.getInt("fonttype") ?? 0;
  }

  Future<void> setLineSpacing() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("depublinespacing", linespacing);
  }

  Future<void> getLineSpacing() async {
    final prefs = await SharedPreferences.getInstance();
    linespacing = prefs.getDouble("depublinespacing") ?? 20;
  }

  String _backendOrigin() {
    final uri = Uri.parse(ApiUrl.GET_BOOK_CHAPTERS);
    return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  }

  String _normalizeUrl(String value) {
    String v = value.trim();
    if (v.isEmpty) return '';

    v = v.replaceAll('\\', '/');

    if (v.startsWith('http://') || v.startsWith('https://')) {
      return Uri.encodeFull(v);
    }

    final origin = _backendOrigin();
    if (v.startsWith('/')) {
      return Uri.encodeFull('$origin$v');
    }

    return Uri.encodeFull('$origin/$v');
  }

  String _cleanHtmlText(String? html) {
    if (html == null || html.trim().isEmpty) return '';

    return html
        .replaceAll(
          RegExp(r'<script[\s\S]*?</script>', caseSensitive: false),
          '',
        )
        .replaceAll(
          RegExp(r'<style[\s\S]*?</style>', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  bool _hasReadableHtml(String? html) {
    if (html == null || html.trim().isEmpty) return false;

    final hasImage = RegExp(r'<img\b', caseSensitive: false).hasMatch(html);
    final cleaned = _cleanHtmlText(html);

    return cleaned.isNotEmpty || hasImage;
  }

  bool _matchesBookTitleOrAuthor(String text) {
    final cleaned = text.trim().toLowerCase();
    final bookTitle = (books?.title ?? '').trim().toLowerCase();
    final author = (books?.author ?? '').trim().toLowerCase();

    if (cleaned.isEmpty) return false;
    if (bookTitle.isNotEmpty && cleaned == bookTitle) return true;
    if (author.isNotEmpty && cleaned == author) return true;
    if (bookTitle.isNotEmpty &&
        cleaned.contains(bookTitle) &&
        cleaned.length < 80) {
      return true;
    }
    return false;
  }

  bool _isFrontMatterCoverLike(epubx.EpubChapter chapter, int index) {
    if (index > 2) return false;

    final title = (chapter.Title ?? '').trim().toLowerCase();
    final html = (chapter.HtmlContent ?? '').trim().toLowerCase();
    final cleaned = _cleanHtmlText(chapter.HtmlContent).toLowerCase();
    final hasImageTag = RegExp(r'<img\b', caseSensitive: false).hasMatch(html);

    final looksLikeCoverTitle = title == 'cover' ||
        title == 'cover page' ||
        title == 'title page' ||
        title == 'book cover' ||
        title == 'titlepage';

    final looksLikeCoverFile = html.contains('cover.') ||
        html.contains('/cover') ||
        html.contains('cover-image') ||
        html.contains('titlepage') ||
        html.contains('title-page');

    final isImageOnlyPage = hasImageTag && cleaned.isEmpty;

    final isVeryShortFrontMatter = cleaned.isNotEmpty &&
        cleaned.length < 80 &&
        _matchesBookTitleOrAuthor(cleaned);

    return looksLikeCoverTitle ||
        looksLikeCoverFile ||
        isImageOnlyPage ||
        isVeryShortFrontMatter;
  }

  List<epubx.EpubChapter> _flattenChapter(epubx.EpubChapter chapter) {
    final list = <epubx.EpubChapter>[];

    if (_hasReadableHtml(chapter.HtmlContent)) {
      list.add(chapter);
    }

    final subs = chapter.SubChapters ?? [];
    for (final c in subs) {
      list.addAll(_flattenChapter(c));
    }

    return list;
  }

  Future<void> openBook() async {
    try {
      if (books?.epub == null || books!.epub!.trim().isEmpty) {
        if (!mounted) return;
        setState(() {
          _epubBook = null;
          _chapters = [];
          _currentPage = 0;
          isloading = false;
        });
        return;
      }

      final epubUrl = _normalizeUrl(books!.epub!);
      final bytes = await InternetFile.get(epubUrl);

      final epubx.EpubBook book = await epubx.EpubReader.readBook(bytes);

      final List<epubx.EpubChapter> flat = [];
      final rootChapters = book.Chapters ?? [];
      for (final ch in rootChapters) {
        flat.addAll(_flattenChapter(ch));
      }

      final filteredChapters = <epubx.EpubChapter>[];
      for (int i = 0; i < flat.length; i++) {
        final chapter = flat[i];
        if (_isFrontMatterCoverLike(chapter, i)) {
          continue;
        }
        filteredChapters.add(chapter);
      }

      if (!mounted) return;

      setState(() {
        _epubBook = book;
        _chapters = filteredChapters;
        _currentPage = 0;
        isloading = false;
      });
    } catch (e) {
      print("EPUB open error: $e");
      if (!mounted) return;
      setState(() {
        _epubBook = null;
        _chapters = [];
        _currentPage = 0;
        isloading = false;
      });
    }
  }

  bool _chapterHasAudio(Map<String, dynamic> chapter) {
    final candidates = [
      (chapter["audio"] ?? "").toString().trim(),
      (chapter["audio_file"] ?? "").toString().trim(),
      (chapter["stream_url"] ?? "").toString().trim(),
    ];

    return candidates.any((e) => e.isNotEmpty);
  }

  Future<void> _fetchBookChapters() async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.GET_BOOK_CHAPTERS),
        body: jsonEncode({
          "data": {"book_id": widget.epub?.id}
        }),
      );

      final res = jsonDecode(response.body);

      if (!mounted) return;

      if (res["status"] == "success") {
        final raw = List<dynamic>.from(res["data"] ?? []);
        final filtered = raw.where((e) {
          if (e is! Map<String, dynamic>) return false;
          return _chapterHasAudio(e);
        }).toList();

        setState(() {
          _audiochapters = filtered;
          _hasAudio = filtered.isNotEmpty;
          _loadingChapters = false;
        });
      } else {
        setState(() {
          _audiochapters = [];
          _hasAudio = false;
          _loadingChapters = false;
        });
      }
    } catch (e) {
      print("Error loading audio chapters: $e");

      if (!mounted) return;

      setState(() {
        _audiochapters = [];
        _hasAudio = false;
        _loadingChapters = false;
      });
    }
  }

  Future<void> _openAudioPlayer() async {
    if (_loadingChapters) {
      Alerts.showToast(context, "Loading audio chapters...");
      return;
    }

    if (_audiochapters.isEmpty) {
      Alerts.showToast(context, "No audio chapters found");
      return;
    }

    final model = Provider.of<AudioPlayerModel>(context, listen: false);

    await model.playBookAudio(
      widget.epub!,
      _audiochapters,
      0,
      preserveCurrentIfSameBook: true,
    );

    if (!mounted) return;

    Navigator.pushNamed(
      context,
      UnifiedAudioPlayerPage.routeName,
    );
  }

  Widget _buildCover() {
    final book = _epubBook;
    if (book == null) return const SizedBox();

    final images = book.Content?.Images;
    if (images == null || images.isEmpty) return const SizedBox();

    final firstImage = images.values.first;
    final List<int>? rawBytes = firstImage.Content;
    if (rawBytes == null || rawBytes.isEmpty) return const SizedBox();

    final Uint8List bytes = Uint8List.fromList(rawBytes);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Image.memory(
        bytes,
        fit: BoxFit.contain,
      ),
    );
  }

  double _maxReaderWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (isfullscreen) return width;

    if (width > 1600) return 950;
    if (width > 1200) return 850;
    if (width > 900) return 760;
    return width;
  }

  void _toggleFullscreen() {
    if (kIsWeb) {
      setState(() {
        isfullscreen = !isfullscreen;
      });
      return;
    }

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    if (isPortrait) {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      setState(() {
        isfullscreen = true;
      });
    } else {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
      setState(() {
        isfullscreen = false;
      });
    }
  }

  String getFontFamily() {
    switch (fonttype) {
      case 0:
        return "Style1";
      case 1:
        return "Style2";
      case 2:
        return "Style3";
      case 3:
        return "Style4";
      case 4:
        return "Style5";
      default:
        return "Style1";
    }
  }

  Widget _chapterTitle(epubx.EpubChapter ch, int index) {
    final title = (ch.Title ?? "").trim();
    if (title.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.display1(context).copyWith(
          fontSize: fontsize,
          fontWeight: FontWeight.bold,
          fontFamily: getFontFamily(),
        ),
      ),
    );
  }

  void showsettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(0, 131, 128, 128),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setstate) {
            return SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 10,
                    bottom: 6,
                    top: 40,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                      maxHeight: 500,
                    ),
                    child: Material(
                      color: !appStateManager.isDarkModeOn
                          ? const Color.fromARGB(235, 212, 210, 210)
                          : const Color.fromARGB(228, 26, 29, 58),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                t.epubsettings,
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: getFontFamily(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                t.fontstyle,
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: getFontFamily(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: .8,
                                  color: Colors.grey,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 3,
                              ),
                              child: DropdownButton<String>(
                                items: t.fonts.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style:
                                          TextStyles.display1(context).copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                isExpanded: true,
                                underline: Container(),
                                value: t.fonts[fonttype],
                                dropdownColor: appStateManager.isDarkModeOn
                                    ? const Color.fromARGB(222, 29, 29, 33)
                                    : const Color.fromARGB(199, 223, 220, 220),
                                onChanged: (itm) {
                                  final index = t.fonts.indexOf(itm!);
                                  if (index != -1) {
                                    setstate(() => fonttype = index);
                                    setState(() => fonttype = index);
                                    setFontType(fonttype);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                t.fontsize,
                                style: TextStyles.display1(context).copyWith(
                                  fontFamily: getFontFamily(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _squareButton(
                                    onTap: () {
                                      if (fontsize <= 5) return;
                                      final s = dp(fontsize - 1, 0);
                                      setstate(() => fontsize = s);
                                      setState(() => fontsize = s);
                                      setFontSize();
                                    },
                                    icon: FontAwesomeIcons.font,
                                    trailing: Icons.remove,
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    fontsize.toString(),
                                    style:
                                        TextStyles.display1(context).copyWith(
                                      fontSize: 15,
                                      fontFamily: getFontFamily(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  _squareButton(
                                    onTap: () {
                                      final s = dp(fontsize + 1, 0);
                                      setstate(() => fontsize = s);
                                      setState(() => fontsize = s);
                                      setFontSize();
                                    },
                                    icon: FontAwesomeIcons.font,
                                    trailing: Icons.add,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                t.linespace,
                                style: TextStyles.display1(context).copyWith(
                                  fontFamily: getFontFamily(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _squareButton(
                                    onTap: () {
                                      if (linespacing <= 5) return;
                                      final s = dp(linespacing - 1, 1);
                                      setstate(() => linespacing = s);
                                      setState(() => linespacing = s);
                                      setLineSpacing();
                                    },
                                    icon: FontAwesomeIcons.font,
                                    trailing: Icons.remove,
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    linespacing.toString(),
                                    style:
                                        TextStyles.display1(context).copyWith(
                                      fontSize: 16,
                                      fontFamily: getFontFamily(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  _squareButton(
                                    onTap: () {
                                      final s = dp(linespacing + 1, 1);
                                      setstate(() => linespacing = s);
                                      setState(() => linespacing = s);
                                      setLineSpacing();
                                    },
                                    icon: FontAwesomeIcons.font,
                                    trailing: Icons.add,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                t.background,
                                style: TextStyles.display1(context).copyWith(
                                  fontFamily: getFontFamily(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _squareTextButton(
                                    text: t.light,
                                    onTap: () {
                                      appStateManager.setColor(false);
                                    },
                                  ),
                                  const SizedBox(width: 80),
                                  _squareTextButton(
                                    text: t.dark,
                                    onTap: () {
                                      appStateManager.setColor(true);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _squareButton({
    required VoidCallback onTap,
    required IconData icon,
    required IconData trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(width: .8, color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15),
            Icon(trailing, size: 15),
          ],
        ),
      ),
    );
  }

  Widget _squareTextButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(width: .8, color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.display1(context).copyWith(
              fontFamily: getFontFamily(),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  double dp(double val, int places) {
    final mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  @override
  Widget build(BuildContext context) {
    appStateManager = Provider.of<AppStateManager>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.epub?.title ?? "",
          style: TextStyles.display0(context).copyWith(
            fontFamily: getFontFamily(),
            fontSize: 19,
          ),
        ),
        actions: [
          // IconButton(
          //   tooltip: "Chapters",
          //   onPressed: () {
          //     _scaffoldKey.currentState?.openDrawer();
          //   },
          //   icon: const Icon(Icons.menu_book_rounded),
          // ),
          Visibility(
            visible:
                widget.epub?.hasAudio == true && !_loadingChapters && _hasAudio,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: _openAudioPlayer,
              icon: const Icon(Icons.audiotrack, size: 24),
            ),
          ),
          Container(width: 15),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: showsettings,
            icon: const Icon(FontAwesomeIcons.font, size: 20),
          ),
          Container(width: 15),
          IconButton(
            onPressed: _toggleFullscreen,
            icon: Icon(
              isfullscreen
                  ? Icons.fullscreen_exit_outlined
                  : Icons.fullscreen_outlined,
            ),
          ),
          Container(width: 15),
          IconButton(
            tooltip: "Close",
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              if (!kIsWeb &&
                  MediaQuery.of(context).orientation == Orientation.landscape) {
                SystemChrome.setPreferredOrientations(const [
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.portraitUp,
                ]);
              }
              Navigator.of(context).pop();
            },
          ),
          Container(width: 30),
        ],
      ),
      drawer: isloading || _chapters.isEmpty
          ? const Drawer()
          : Drawer(
              child: ListView.builder(
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  final ch = _chapters[index];
                  final title = (ch.Title ?? "Chapter ${index + 1}").trim();
                  final selected = _currentPage == index + 1;

                  return ListTile(
                    selected: selected,
                    title: Text(
                      title.isEmpty ? "Chapter ${index + 1}" : title,
                      style: TextStyles.display1(context).copyWith(
                        fontSize: 17,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        color: appStateManager.isDarkModeOn
                            ? const Color.fromARGB(255, 207, 209, 209)
                            : const Color.fromARGB(255, 41, 40, 40),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _chapterController.jumpToPage(index + 1);
                      setState(() {
                        _currentPage = index + 1;
                      });
                    },
                  );
                },
              ),
            ),
      body: isloading
          ? const Center(child: CupertinoActivityIndicator())
          : _chapters.isEmpty
              ? Center(
                  child: Text(
                    "Unable to open EPUB",
                    style: TextStyles.display1(context).copyWith(
                      fontFamily: getFontFamily(),
                    ),
                  ),
                )
              : Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: _maxReaderWidth(context),
                    ),
                    child: PageView.builder(
                      controller: _chapterController,
                      itemCount: _chapters.length + 1,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 24,
                            ),
                            child: Column(
                              children: [
                                _buildCover(),
                                Text(
                                  widget.epub?.title ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyles.display1(context).copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: getFontFamily(),
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 196, 196, 198)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.epub?.author ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyles.display1(context).copyWith(
                                    fontFamily: getFontFamily(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final ch = _chapters[index - 1];
                        final html = ch.HtmlContent ?? "<p></p>";

                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _chapterTitle(ch, index - 1),
                              Html(
                                data: html,
                                shrinkWrap: true,
                                style: {
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 194, 204, 208)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                    fontSize: FontSize(fontsize),
                                    lineHeight: LineHeight(linespacing / 10),
                                    fontFamily: getFontFamily(),
                                  ),
                                  "p": Style(
                                    fontSize: FontSize(fontsize),
                                    lineHeight: LineHeight(linespacing / 10),
                                    fontFamily: getFontFamily(),
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 214, 226, 230)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                  ),
                                  "div": Style(
                                    fontSize: FontSize(fontsize),
                                    lineHeight: LineHeight(linespacing / 10),
                                    fontFamily: getFontFamily(),
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 214, 226, 230)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                  ),
                                  "span": Style(
                                    fontSize: FontSize(fontsize),
                                    lineHeight: LineHeight(linespacing / 10),
                                    fontFamily: getFontFamily(),
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 196, 196, 198)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                  ),
                                  "h1": Style(
                                    textAlign: TextAlign.center,
                                    fontSize: FontSize(fontsize + 6),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: getFontFamily(),
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 196, 196, 198)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                  ),
                                  "h2": Style(
                                    textAlign: TextAlign.center,
                                    fontSize: FontSize(fontsize + 4),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: getFontFamily(),
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 196, 196, 198)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                  ),
                                  "h3": Style(
                                    textAlign: TextAlign.center,
                                    fontSize: FontSize(fontsize + 2),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: getFontFamily(),
                                    color: appStateManager.isDarkModeOn
                                        ? const Color.fromARGB(
                                            255, 196, 196, 198)
                                        : const Color.fromARGB(255, 41, 40, 40),
                                  ),
                                  "img": Style(
                                    margin: Margins.symmetric(vertical: 10),
                                  ),
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}

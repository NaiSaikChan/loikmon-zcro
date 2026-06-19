import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/AudioPlayerModel.dart';
import 'package:loikmon/screens/AppPdfViewer.dart';
import 'package:loikmon/screens/EpubReader.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

class UnifiedAudioPlayerPage extends StatefulWidget {
  static const routeName = "/UnifiedAudioPlayerPage";
  const UnifiedAudioPlayerPage({super.key});

  @override
  State<UnifiedAudioPlayerPage> createState() => _UnifiedAudioPlayerPageState();
}

class _UnifiedAudioPlayerPageState extends State<UnifiedAudioPlayerPage> {
  get container => null;

  bool _hasPdf(Books? book) {
    return book != null && (book.book ?? "").trim().isNotEmpty;
  }

  bool _hasEpub(Books? book) {
    return book != null && (book.epub ?? "").trim().isNotEmpty;
  }

  void _openBookPage(AudioPlayerModel ap) {
    final book = ap.currentBook;
    if (book == null) return;

    final hasPdf = _hasPdf(book);
    final hasEpub = _hasEpub(book);

    if (hasPdf && !hasEpub) {
      Navigator.pushNamed(
        context,
        AppPdfViewer.routeName,
        arguments: ScreenArguements(
          position: 0,
          items: book,
        ),
      );
      return;
    }

    if (!hasPdf && hasEpub) {
      Navigator.pushNamed(
        context,
        EpubReader.routeName,
        arguments: ScreenArguements(
          position: 0,
          items: book,
        ),
      );
      return;
    }

    if (hasPdf && hasEpub) {
      Navigator.pushNamed(
        context,
        AppPdfViewer.routeName,
        arguments: ScreenArguements(
          position: 0,
          items: book,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AudioPlayerModel>(context);

    final isBook = ap.isBookAudio;
    final book = ap.currentBook;
    final chapter = isBook &&
            ap.bookChapters.isNotEmpty &&
            ap.currentBookChapterIndex >= 0 &&
            ap.currentBookChapterIndex < ap.bookChapters.length
        ? ap.bookChapters[ap.currentBookChapterIndex]
        : null;

    final coverUrl = isBook
        ? (ap.currentBook?.thumbnail ?? "")
        : (ap.currentMedia?.thumbnail ?? "");

    return SafeArea(
      bottom: true,
      minimum: const EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 10),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 6, 29, 61),
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: const Color.fromARGB(255, 9, 45, 95),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.only(left: 10),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 40,
              color: Color.fromARGB(255, 240, 238, 238),
            ),
          ),
          leadingWidth: 55,
          actionsPadding: EdgeInsets.only(
            left: 10,
          ),
          elevation: 0,
          title: Text(
            isBook ? (book?.title ?? "") : (ap.currentMedia?.title ?? ""),
            style: TextStyles.display0(context).copyWith(
                color: Color.fromARGB(255, 241, 239, 239), fontSize: 20),
          ),
          actions: [
            if (isBook)
              IconButton(
                icon: const Icon(Icons.menu_book,
                    color: Color.fromARGB(255, 244, 242, 242)),
                tooltip: t.openbook,
                onPressed: () {
                  _openBookPage(ap);
                },
              ),
            Padding(padding: EdgeInsetsGeometry.only(right: 10)),
            if (isBook)
              IconButton(
                icon: const Icon(LineAwesomeIcons.share_solid,
                    color: Color.fromARGB(255, 244, 242, 242)),
                tooltip: t.share,
                onPressed: () {
                  Utility.sharebook(context, book);
                },
              ),
            Padding(padding: EdgeInsetsGeometry.only(right: 20))
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(
            bottom: 5,
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),

              Center(
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.grey.shade900,
                  //   borderRadius: BorderRadius.circular(15),

                  // ),
                  padding: EdgeInsets.all(2),

                  child: Image.network(
                    ap.currentBook?.thumbnail ?? "",
                    height: 367,
                    width: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.music_note,
                      size: 120,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),
              ListTile(
                title: Text(
                  isBook
                      ? (chapter?["chapter_title"] ?? "")
                      : (ap.currentMedia?.title ?? ""),
                  maxLines: 1,
                  style: TextStyles.display1(context).copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              // Spacer(),
              _buildSeekbar(ap),
              const SizedBox(height: 10),

              _buildControls(ap),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeekbar(AudioPlayerModel ap) {
    return StreamBuilder<double>(
      stream: ap.audioProgressStreams.stream,
      builder: (context, snapshot) {
        final double pos = snapshot.data ?? 0;

        final double maxDuration = ap.backgroundAudioDurationSeconds <= 0
            ? 1
            : ap.backgroundAudioDurationSeconds;

        final double safeValue = pos.clamp(0, maxDuration);
        const SizedBox(height: 30);
        return Column(
          children: [
            Slider(
              value: safeValue,
              max: maxDuration,
              min: 0,
              activeColor: MyColors.mainC0lor,
              inactiveColor: Colors.white24,
              onChanged: (value) => ap.seekTo(value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _format(pos),
                    style: TextStyles.display1(context)
                        .copyWith(color: Colors.white70, fontSize: 17),
                  ),
                  Text(
                    _format(ap.backgroundAudioDurationSeconds),
                    style: TextStyles.display1(context)
                        .copyWith(color: Colors.white70, fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControls(AudioPlayerModel ap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            Icons.replay_outlined,
            size: 35,
            color: Color.fromARGB(255, 244, 243, 243),
          ),
          onPressed: () {
            ap.seekTo(0);
          },
        ),
        SizedBox(
          width: 50,
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
            size: 40,
            color: Color.fromARGB(255, 244, 243, 243),
          ),
          onPressed: () => ap.skipPrevious(),
        ),
        const SizedBox(width: 40),
        GestureDetector(
          onTap: () => ap.onPressed(),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
            ),
            child: ap.icon(),
          ),
        ),
        const SizedBox(width: 40),
        IconButton(
          icon: const Icon(
            Icons.skip_next,
            size: 40,
            color: Color.fromARGB(255, 244, 243, 243),
          ),
          onPressed: () => ap.skipNext(),
        ),
        SizedBox(
          width: 50,
        ),
        IconButton(
          icon: const Icon(
            Icons.queue_music,
            size: 35,
            color: Colors.white,
          ),
          tooltip: "Open Chapters",
          onPressed: () => _showChapterList(context, ap),
        ),
      ],
    );
  }

  String _format(double sec) {
    final d = Duration(seconds: sec.toInt());
    return d.toString().split(".").first.padLeft(8, "0");
  }

  void _showChapterList(BuildContext context, AudioPlayerModel ap) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromARGB(150, 3, 16, 30),
      isScrollControlled: true,
      builder: (_) {
        return Consumer<AudioPlayerModel>(
          builder: (context, apModel, child) {
            return SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 100,
                    left: 16,
                    right: 16,
                    bottom: 2,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                      maxHeight: 600,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Material(
                        color: const Color.fromARGB(221, 7, 30, 57),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 206, 208, 206),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      t.bookchapter,
                                      style:
                                          TextStyles.display1(context).copyWith(
                                        color:
                                            Color.fromARGB(255, 241, 240, 240),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white24, height: 1),
                            Expanded(
                              child: ListView.builder(
                                itemCount: apModel.bookChapters.length,
                                itemBuilder: (_, index) {
                                  final chap = apModel.bookChapters[index];
                                  final bool isPlaying =
                                      apModel.currentBookChapterIndex == index;
                                  final bool isCurrentlyPlaying =
                                      isPlaying && apModel.remoteAudioPlaying;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    color: isPlaying
                                        ? Colors.white.withOpacity(0.08)
                                        : Colors.transparent,
                                    child: ListTile(
                                      leading: Icon(
                                        isCurrentlyPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_fill,
                                        color: isPlaying
                                            ? Colors.green
                                            : Colors.white70,
                                        size: 28,
                                      ),
                                      title: Text(
                                        (chap["chapter_title"] ??
                                                chap["title"] ??
                                                "")
                                            .toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.display1(context)
                                            .copyWith(
                                          color: isPlaying
                                              ? const Color.fromARGB(
                                                  255, 95, 208, 99)
                                              : const Color.fromARGB(
                                                  222, 228, 216, 228),
                                          fontWeight: isPlaying
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onTap: () {
                                        if (isPlaying) {
                                          apModel.onPressed();
                                          return;
                                        }

                                        if (apModel.currentBook == null) return;

                                        apModel.playBookAudio(
                                          apModel.currentBook!,
                                          apModel.bookChapters,
                                          index,
                                          preserveCurrentIfSameBook: false,
                                        );
                                      },
                                    ),
                                  );
                                },
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
}

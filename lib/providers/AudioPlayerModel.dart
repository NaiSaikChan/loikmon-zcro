import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/UserEvents.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/events.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Articles.dart';
import '../utils/ApiUrl.dart';
import '../utils/my_colors.dart';

class AudioPlayerModel with ChangeNotifier {
  List<Articles?> currentPlaylist = [];
  BuildContext? context;
  Articles? currentMedia;
  int currentMediaPosition = 0;
  Color backgroundColor = MyColors.primary;
  bool isDialogShowing = false;
  bool isCompleted = false;

  double backgroundAudioDurationSeconds = 0.0;
  double backgroundAudioPositionSeconds = 0.0;

  bool isSeeking = false;
  final AudioPlayer _remoteAudio = AudioPlayer();
  bool remoteAudioPlaying = false;
  bool _remoteAudioLoading = false;
  bool isUserSubscribed = false;
  late StreamController<double> audioProgressStreams;
  bool isRadio = false;

  bool isBookAudio = false;
  Books? currentBook;
  List<dynamic> bookChapters = [];
  int currentBookChapterIndex = 0;

  final StreamController<String> _curPositionController =
      StreamController<String>.broadcast();
  Stream<String> get curPositionStream => _curPositionController.stream;

  Duration? curSongDuration;

  static const String replayButtonId = 'replayButtonId';
  static const String newReleasesButtonId = 'newReleasesButtonId';
  static const String skipPreviousButtonId = 'skipPreviousButtonId';
  static const String skipNextButtonId = 'skipNextButtonId';

  AudioPlayerModel() {
    getRepeatMode();
    audioProgressStreams = StreamController<double>.broadcast();
    audioProgressStreams.add(0);
    initplayer();
  }

  void setContext(BuildContext context) {
    this.context = context;
    notifyListeners();
  }

  void initplayer() {
    _remoteAudio.onDurationChanged.listen((Duration duration) {
      curSongDuration = duration;
      _remoteAudioLoading = false;

      if (!isRadio) {
        backgroundAudioDurationSeconds = duration.inSeconds.toDouble();
      }

      notifyListeners();
    });

    _remoteAudio.onPositionChanged.listen((Duration position) {
      if (!isRadio && curSongDuration != null) {
        final int cappedMs =
            position.inMilliseconds > curSongDuration!.inMilliseconds
                ? curSongDuration!.inMilliseconds
                : position.inMilliseconds;

        sinkProgress(cappedMs);
        backgroundAudioPositionSeconds = position.inSeconds.toDouble();
        audioProgressStreams.add(backgroundAudioPositionSeconds);
        notifyListeners();
      }
    });

    _remoteAudio.onPlayerStateChanged.listen((PlayerState playerState) async {
      if (playerState == PlayerState.completed) {
        isCompleted = true;

        if (isBookAudio && bookChapters.isNotEmpty && currentBook != null) {
          skipNext();
          return;
        }

        if (_isRepeat == true) {
          await startAudioPlayBack(currentMedia);
        } else {
          final int nextpos = await skipNextReturn();
          eventBus.fire(OnNavigateArticle(nextpos));
        }
      }

      if (playerState == PlayerState.paused ||
          playerState == PlayerState.stopped) {
        remoteAudioPlaying = false;
        notifyListeners();
      }

      if (playerState == PlayerState.playing) {
        remoteAudioPlaying = true;
        _remoteAudioLoading = false;
        notifyListeners();
      }
    });

    remoteAudioPlaying = false;
  }

  void sinkProgress(int m) {
    if (curSongDuration == null) return;
    _curPositionController.sink.add('$m-${curSongDuration!.inMilliseconds}');
  }

  bool? _isRepeat = false;
  bool? get isRepeat => _isRepeat;

  Future<void> changeRepeat() async {
    _isRepeat = !_isRepeat!;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("_isRepeatMode", _isRepeat!);
  }

  Future<void> getRepeatMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("_isRepeatMode") != null) {
      _isRepeat = prefs.getBool("_isRepeatMode");
    }
  }

  void setUserSubscribed(bool isUserSubscribed) {
    this.isUserSubscribed = isUserSubscribed;
  }

  bool _showList = false;
  bool get showList => _showList;

  void setShowList(bool showList) {
    _showList = showList;
    notifyListeners();
  }

  Future<void> preparePlaylist(List<Articles?> playlist, Articles media) async {
    isBookAudio = false;
    isRadio = false;
    currentBook = null;
    bookChapters = [];
    currentBookChapterIndex = 0;

    currentPlaylist = playlist;
    await startAudioPlayBack(media);
  }

  Future<void> prepareradioplayer(
      List<Articles?> playlist, Articles media) async {
    isBookAudio = false;
    isRadio = true;
    currentBook = null;
    bookChapters = [];
    currentBookChapterIndex = 0;

    currentPlaylist = playlist;
    await startAudioPlayBack(media);
  }

  Future<void> setPlaylistData(List<Articles?> playlist) async {
    currentPlaylist = playlist;
    notifyListeners();
  }

  String _backendOriginFromApi() {
    final uri = Uri.parse(ApiUrl.GET_BOOK_CHAPTERS);
    return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  }

  bool _isAbsoluteUrl(String value) {
    final v = value.trim().toLowerCase();
    return v.startsWith('http://') || v.startsWith('https://');
  }

  String _normalizeAndEncodeAudioUrl(String value) {
    String v = value.trim();
    if (v.isEmpty) return '';

    v = v.replaceAll('\\', '/');

    if (!_isAbsoluteUrl(v)) {
      final origin = _backendOriginFromApi();
      if (v.startsWith('/')) {
        v = '$origin$v';
      } else {
        v = '$origin/$v';
      }
    }

    return Uri.encodeFull(v);
  }

  Future<void> startAudioPlayBack(Articles? media) async {
    if (media == null || media.streamUrl == null || media.streamUrl!.isEmpty) {
      return;
    }

    isCompleted = false;
    isBookAudio = false;
    currentBook = null;
    bookChapters = [];
    currentBookChapterIndex = 0;

    currentMedia = media;
    setCurrentMediaPosition();

    _remoteAudioLoading = true;
    remoteAudioPlaying = false;
    backgroundAudioPositionSeconds = 0;
    backgroundAudioDurationSeconds = 0;
    audioProgressStreams.add(0);
    notifyListeners();

    try {
      final String source =
          _normalizeAndEncodeAudioUrl(currentMedia!.streamUrl!);
      print("articleaudiosource => $source");

      await _remoteAudio.stop();
      await _remoteAudio.setSource(UrlSource(source));

      if (context != null &&
          !Provider.of<AppStateManager>(context!, listen: false)
              .isArticlePurchased(currentMedia!)) {
        _remoteAudioLoading = false;
        remoteAudioPlaying = false;
        notifyListeners();
        return;
      }

      await _remoteAudio.resume();
    } catch (e) {
      _remoteAudioLoading = false;
      remoteAudioPlaying = false;
      notifyListeners();
      print("Error loading audio source: $e");
    }
  }

  String _bookAudioSourceFromChapter(Map<String, dynamic> chapter) {
    final String audio = (chapter["audio"] ?? "").toString().trim();
    final String audioFile = (chapter["audio_file"] ?? "").toString().trim();
    final String streamUrl = (chapter["stream_url"] ?? "").toString().trim();

    final List<String> candidates = [audio, audioFile, streamUrl];

    for (final value in candidates) {
      final normalized = _normalizeAndEncodeAudioUrl(value);
      if (normalized.isNotEmpty) return normalized;
    }

    return "";
  }

  bool _isSameBookSession(Books book) {
    return isBookAudio && currentBook != null && currentBook!.id == book.id;
  }

  Future<void> playBookAudio(
    Books book,
    List chapters,
    int index, {
    bool preserveCurrentIfSameBook = false,
  }) async {
    if (chapters.isEmpty) {
      print("BookAudio => No chapters available");
      return;
    }

    final int safeIndex;
    if (index < 0) {
      safeIndex = 0;
    } else if (index >= chapters.length) {
      safeIndex = chapters.length - 1;
    } else {
      safeIndex = index;
    }

    final bool sameBookSession = _isSameBookSession(book);

    if (sameBookSession && preserveCurrentIfSameBook) {
      currentBook = book;
      bookChapters = chapters;

      if (!remoteAudioPlaying && !_remoteAudioLoading) {
        await _resumeBackgroundAudio();
      } else {
        notifyListeners();
      }
      return;
    }

    final Map<String, dynamic> chapter =
        chapters[safeIndex] as Map<String, dynamic>;
    final String source = _bookAudioSourceFromChapter(chapter);

    if (source.isEmpty) {
      print("BookAudio => No valid chapter audio source");
      return;
    }

    if (sameBookSession &&
        currentBookChapterIndex >= 0 &&
        currentBookChapterIndex < bookChapters.length) {
      final Map<String, dynamic> currentChapter =
          bookChapters[currentBookChapterIndex] as Map<String, dynamic>;
      final String currentSource = _bookAudioSourceFromChapter(currentChapter);

      if (currentBookChapterIndex == safeIndex && currentSource == source) {
        currentBook = book;
        bookChapters = chapters;

        if (!remoteAudioPlaying && !_remoteAudioLoading) {
          await _resumeBackgroundAudio();
        } else {
          notifyListeners();
        }
        return;
      }
    }

    isCompleted = false;
    isBookAudio = true;
    isRadio = false;

    currentBook = book;
    bookChapters = chapters;
    currentBookChapterIndex = safeIndex;
    currentMedia = null;

    _remoteAudioLoading = true;
    remoteAudioPlaying = false;
    backgroundAudioDurationSeconds = 0;
    backgroundAudioPositionSeconds = 0;
    audioProgressStreams.add(0);
    notifyListeners();

    print("bookaudiosource => $source");

    try {
      await _remoteAudio.stop();
      await _remoteAudio.setSource(UrlSource(source));
      await _remoteAudio.resume();
    } catch (e) {
      _remoteAudioLoading = false;
      remoteAudioPlaying = false;
      notifyListeners();
      print("BookAudio playback error: $e");
    }
  }

  String get currentBookChapterTitle {
    if (!isBookAudio ||
        bookChapters.isEmpty ||
        currentBookChapterIndex < 0 ||
        currentBookChapterIndex >= bookChapters.length) {
      return "";
    }

    final Map<String, dynamic> chapter =
        bookChapters[currentBookChapterIndex] as Map<String, dynamic>;

    return (chapter["chapter_title"] ?? chapter["title"] ?? "Untitled Chapter")
        .toString();
  }

  void setCurrentMediaPosition() {
    currentMediaPosition = currentPlaylist.indexOf(currentMedia);
    if (currentMediaPosition == -1) {
      currentMediaPosition = 0;
    }
    print("currentMediaPosition = $currentMediaPosition");
  }

  void cleanUpResources() {
    _stopBackgroundAudio();
    currentMedia = null;
    currentPlaylist = [];
    notifyListeners();
  }

  Widget icon() {
    if (_remoteAudioLoading) {
      return Theme(
        data: ThemeData(
          cupertinoOverrideTheme:
              const CupertinoThemeData(brightness: Brightness.dark),
        ),
        child: const CupertinoActivityIndicator(),
      );
    }
    if (remoteAudioPlaying) {
      return const Icon(
        Icons.pause,
        size: 40,
        color: Colors.white,
      );
    }
    return const Icon(
      Icons.play_arrow,
      size: 40,
      color: Colors.white,
    );
  }

  Widget radioicon() {
    if (_remoteAudioLoading) {
      return Theme(
        data: ThemeData(
          cupertinoOverrideTheme:
              const CupertinoThemeData(brightness: Brightness.dark),
        ),
        child: const CupertinoActivityIndicator(),
      );
    }
    if (remoteAudioPlaying) {
      return const Icon(
        Icons.pause,
        size: 60,
        color: Colors.white,
      );
    }
    return const Icon(
      Icons.play_arrow,
      size: 60,
      color: Colors.white,
    );
  }

  Widget miniicon() {
    if (_remoteAudioLoading) {
      return Theme(
        data: ThemeData(
          cupertinoOverrideTheme:
              const CupertinoThemeData(brightness: Brightness.light),
        ),
        child: const CupertinoActivityIndicator(),
      );
    }
    if (remoteAudioPlaying) {
      return const Icon(
        Icons.pause,
        size: 40,
      );
    }
    return const Icon(
      Icons.play_arrow,
      size: 40,
    );
  }

  Widget radiominiicon() {
    if (_remoteAudioLoading) {
      return Theme(
        data: ThemeData(
          cupertinoOverrideTheme:
              const CupertinoThemeData(brightness: Brightness.light),
        ),
        child: const CupertinoActivityIndicator(),
      );
    }
    if (remoteAudioPlaying) {
      return const Icon(
        Icons.pause,
        size: 30,
      );
    }
    return const Icon(
      Icons.play_arrow,
      size: 30,
    );
  }

  void onPressed() {
    remoteAudioPlaying ? _pauseBackgroundAudio() : _resumeBackgroundAudio();
  }

  Future<void> _resumeBackgroundAudio() async {
    try {
      await _remoteAudio.resume();
      remoteAudioPlaying = true;
      notifyListeners();
    } catch (e) {
      print("resume error: $e");
    }
  }

  void _pauseBackgroundAudio() {
    _remoteAudio.pause();
    remoteAudioPlaying = false;
    notifyListeners();
  }

  void _stopBackgroundAudio() {
    _remoteAudio.pause();
    remoteAudioPlaying = false;

    currentMedia = null;
    currentPlaylist = [];

    isBookAudio = false;
    currentBook = null;
    bookChapters = [];
    currentBookChapterIndex = 0;

    backgroundAudioDurationSeconds = 0;
    backgroundAudioPositionSeconds = 0;
    audioProgressStreams.add(0);

    notifyListeners();
  }

  void shufflePlaylist() {
    if (currentPlaylist.isEmpty) return;
    currentPlaylist.shuffle();
    startAudioPlayBack(currentPlaylist[0]);
  }

  void skipPrevious() {
    if (isBookAudio && bookChapters.isNotEmpty && currentBook != null) {
      int previousIndex;
      if (currentBookChapterIndex - 1 >= 0) {
        previousIndex = currentBookChapterIndex - 1;
      } else {
        previousIndex = bookChapters.length - 1;
      }

      playBookAudio(currentBook!, bookChapters, previousIndex);
      return;
    }

    if (currentPlaylist.isEmpty || currentPlaylist.length == 1) return;

    int pos = currentMediaPosition - 1;
    if (pos == -1) {
      pos = currentPlaylist.length - 1;
    }

    final Articles? media = currentPlaylist[pos];
    startAudioPlayBack(media);
  }

  void skipNext() {
    if (isBookAudio && bookChapters.isNotEmpty && currentBook != null) {
      int nextIndex;
      if (currentBookChapterIndex + 1 < bookChapters.length) {
        nextIndex = currentBookChapterIndex + 1;
      } else {
        nextIndex = 0;
      }

      playBookAudio(currentBook!, bookChapters, nextIndex);
      return;
    }

    if (currentPlaylist.isEmpty || currentPlaylist.length == 1) return;

    int pos = currentMediaPosition + 1;
    if (pos >= currentPlaylist.length) {
      pos = 0;
    }

    final Articles? media = currentPlaylist[pos];
    startAudioPlayBack(media);
  }

  Future<int> skipNextReturn() async {
    if (currentPlaylist.isEmpty || currentPlaylist.length == 1) return -1;

    int pos = currentMediaPosition + 1;
    if (pos >= currentPlaylist.length) {
      pos = 0;
    }

    final Articles? media = currentPlaylist[pos];
    await startAudioPlayBack(media);
    return pos;
  }

  void seekTo(double positionSeconds) {
    if (positionSeconds.isNaN || positionSeconds < 0) {
      positionSeconds = 0;
    }

    backgroundAudioPositionSeconds = positionSeconds;
    _remoteAudio.seek(Duration(seconds: positionSeconds.toInt()));
    audioProgressStreams.add(backgroundAudioPositionSeconds);
    isSeeking = false;
    notifyListeners();
  }

  void onStartSeek() {
    isSeeking = true;
  }

  static Future<Uint8List> generateImageBytes(String coverphoto) async {
    final Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(coverphoto)).load(coverphoto))
            .buffer
            .asUint8List();
    return bytes;
  }

  @override
  void dispose() {
    _curPositionController.close();
    audioProgressStreams.close();
    _remoteAudio.dispose();
    super.dispose();
  }
}

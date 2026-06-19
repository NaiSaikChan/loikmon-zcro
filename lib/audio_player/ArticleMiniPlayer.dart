import 'package:flutter/material.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/utils/TimUtil.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../models/Articles.dart';
import '../providers/AudioPlayerModel.dart';

class ArticleMiniPlayer extends StatefulWidget {
  const ArticleMiniPlayer(this.items, this.article, this.showPrev,
      this.showNext, this.onPrevClick, this.onNextClick,
      {this.isMiniBar = false, Key? key})
      : super(key: key);
  final Articles? article;
  final List<Articles>? items;
  final bool? showNext;
  final bool? showPrev;
  final Function? onPrevClick;
  final Function onNextClick;
  final bool? isMiniBar;

  @override
  _AudioPlayout createState() => _AudioPlayout();
}

class _AudioPlayout extends State<ArticleMiniPlayer> {
  int progress = 0;
  bool downloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 0), () async {
      AppStateManager _appStateManager =
          Provider.of<AppStateManager>(context, listen: false);
      AudioPlayerModel _audioPlayerModel =
          Provider.of<AudioPlayerModel>(context, listen: false);
      if (widget.article!.streamUrl != "" &&
          _appStateManager.isArticlePurchased(widget.article!)) {
        if (!widget.isMiniBar!) {
          if (widget.article!.streamUrl != "") {
            _audioPlayerModel.cleanUpResources();
            _audioPlayerModel.preparePlaylist(widget.items!, widget.article!);
          } else {
            _audioPlayerModel.cleanUpResources();
          }
        }
      } else {
        _audioPlayerModel.cleanUpResources();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);

    return Consumer<AudioPlayerModel>(
      builder: (context, audioPlayerModel, child) {
        return GestureDetector(
          onTap: () {
            //do nothing
          },
          child: Card(
            elevation: 0,
            child: Column(
              children: [
                Visibility(
                    visible: widget.article!.streamUrl != "",
                    child: _timer(audioPlayerModel)),
                Container(
                    height: 65,

                    //color: Colors.grey[900],
                    decoration: BoxDecoration(
                      /*color: appStateManager.isDarkModeOn
                          ? MyColors.headerdark
                          : Colors.white,*/
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () => audioPlayerModel.changeRepeat(),
                            icon: audioPlayerModel.isRepeat == true
                                ? Icon(
                                    Icons.repeat_one,
                                    size: 30.0,
                                  )
                                : Icon(
                                    Icons.repeat,
                                    size: 30.0,
                                  ),
                          ),
                          IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            onPressed: () async {
                              if (widget.showPrev!) {
                                //await audioPlayerModel.cleanUpResources();
                                widget.onPrevClick!();
                                audioPlayerModel.skipPrevious();
                              }
                            },
                            icon: Icon(
                              Icons.skip_previous,
                              size: 30,
                              color: widget.showPrev!
                                  ? (appStateManager.isDarkModeOn
                                      ? Colors.white
                                      : Colors.black)
                                  : (appStateManager.isDarkModeOn
                                      ? Colors.grey[700]
                                      : Colors.grey[400]),
                              //color: Colors.white,
                            ),
                          ),
                          ClipOval(
                              child: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withAlpha(30),
                            width: 50.0,
                            height: 50.0,
                            child: IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onPressed: () {
                                if (!appStateManager.isArticlePurchased(
                                    widget.article!)) return;
                                audioPlayerModel.onPressed();
                                /*if (widget.article!.streamUrl != "") {
                                        if (audioPlayerModel
                                                .backgroundAudioPositionSeconds >
                                            0) {
                                          audioPlayerModel.onPressed();
                                        } else {
                                          audioPlayerModel.preparePlaylist(
                                              [widget.article!],
                                              widget.article!);
                                        }
                                      }*/
                              },
                              icon: (widget.article!.streamUrl! == "" ||
                                      !appStateManager
                                          .isArticlePurchased(widget.article!))
                                  ? Icon(
                                      Icons.play_arrow,
                                      color: (appStateManager.isDarkModeOn
                                          ? Colors.grey[700]
                                          : Colors.grey[400]),
                                    )
                                  : audioPlayerModel.miniicon(),
                            ),
                          )),
                          IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            onPressed: () async {
                              if (widget.showNext!) {
                                //await audioPlayerModel.cleanUpResources();
                                widget.onNextClick!();
                                audioPlayerModel.skipNext();
                              }
                            },
                            icon: Icon(
                              Icons.skip_next,
                              size: 30,
                              color: widget.showNext!
                                  ? (appStateManager.isDarkModeOn
                                      ? Colors.white
                                      : Colors.black)
                                  : (appStateManager.isDarkModeOn
                                      ? Colors.grey[700]
                                      : Colors.grey[400]),
                            ),
                          ),
                          /* Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    //width: 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    )),
                                    child: IconButton(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      onPressed: () {
                                        audioPlayerModel.cleanUpResources();
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),*/
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  /*Widget miniicon(AudioPlayerModel audioPlayerModel) {
    if (widget.article!.streamUrl == "") {
      return const Icon(
        Icons.play_arrow,
        size: 40,
        //color: Colors.white,
      );
    }

    if (audioPlayerModel.remoteAudioLoading) {
      return Theme(
          data: ThemeData(
              cupertinoOverrideTheme:
                  CupertinoThemeData(brightness: Brightness.light)),
          child: CupertinoActivityIndicator());
    }

    if (audioPlayerModel.remoteAudio.playing &&
        audioPlayerModel.backgroundAudioDurationSeconds > 0) {
      return const Icon(
        Icons.pause,
        size: 40,
        //color: Colors.white,
      );
    }

    return const Icon(
      Icons.play_arrow,
      size: 40,
      //color: Colors.white,
    );
  }*/

  Widget _timer(AudioPlayerModel audioPlayerModel) {
    var style = new TextStyle(
      fontSize: 15,
    );
    return StreamBuilder(
      initialData: audioPlayerModel.backgroundAudioPositionSeconds,
      stream: audioPlayerModel.audioProgressStreams.stream.asBroadcastStream(),
      builder: (BuildContext? context, dynamic snapshot) {
        double? seekSliderValue = 0;
        if (snapshot.data != null) {
          seekSliderValue = snapshot.data /
              audioPlayerModel.backgroundAudioDurationSeconds.floor();
          if (seekSliderValue!.isNaN || seekSliderValue < 0) {
            seekSliderValue = 0;
          }
          if (seekSliderValue > 1) {
            seekSliderValue = 1;
          }
          print("snapshot.data = " + snapshot.data.toString());
          print("backgroundAudioDurationSeconds = " +
              audioPlayerModel.backgroundAudioDurationSeconds.toString());
          print("seekSliderValue = " + seekSliderValue.toString());
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 20,
            ),
            Text(
              TimUtil.stringForSeconds(
                  (snapshot == null || snapshot.data == null)
                      ? 0.0
                      : snapshot.data),
              style: style,
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context!).copyWith(
                    trackHeight: 2,
                    thumbColor: Colors.transparent,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                child: Slider(
                    activeColor: MyColors.mainC0lor,
                    value: seekSliderValue,
                    onChangeEnd: (v) {
                      audioPlayerModel.onStartSeek();
                    },
                    onChanged: (double val) {
                      final double positionSeconds =
                          val * audioPlayerModel.backgroundAudioDurationSeconds;
                      audioPlayerModel.seekTo(positionSeconds);
                    }),
              ),
            ),
            new Text(
              TimUtil.stringForSeconds(
                  audioPlayerModel.backgroundAudioDurationSeconds),
              style: style,
            ),
            Container(
              width: 20,
            ),
          ],
        );
      },
    );
  }
}

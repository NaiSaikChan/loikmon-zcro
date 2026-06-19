import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/audio_player/BookAudioPlayerPage.dart';
import 'package:loikmon/utils/MarqueeWidget.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/TimUtil.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../providers/AudioPlayerModel.dart';

class BookMiniPlayer extends StatelessWidget {
  const BookMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerModel>(
      builder: (context, audio, child) {
        if (audio.currentBook == null || audio.bookChapters.isEmpty) {
          return SizedBox.shrink();
        }

        final chapter = audio.bookChapters[audio.currentBookChapterIndex];
        final title = (chapter["chapter_title"] ?? "Chapter").toString();

        return InkWell(
          onTap: () {
            //do nothing
            Navigator.of(context).pushNamed(
              UnifiedAudioPlayerPage.routeName,
            );
          },
          child: Container(
            width: 700,
            height: 65,
            color: const Color.fromARGB(31, 55, 53, 53),
            child: Column(
              children: [
                /// TIMER
                // _buildTimer(audio),

                Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: Colors.black26)),
                  child: Row(
                    children: [
                      /// BOOK THUMBNAIL
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 65,
                        width: 55,
                        child: CachedNetworkImage(
                          cacheKey: audio.currentBook?.thumbnail ?? "",
                          imageUrl: audio.currentBook?.thumbnail ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black12, BlendMode.darken)),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => Center(
                              child: Icon(
                            Icons.error,
                            color: Colors.grey,
                          )),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// CHAPTER TITLE
                      Expanded(
                          child: ListTile(
                        title: MarqueeWidget(
                          direction: Axis.horizontal,
                          child: Text(title,
                              maxLines: 1,
                              style: TextStyles.display1(context).copyWith(
                                  fontSize: 15,
                                  fontFamily: 'style2',
                                  fontWeight: FontWeight.w600)),
                        ),
                        subtitle: Text(
                          "Chapter ${chapter['chapter_number']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 14,
                            fontFamily: 'style1',
                          ),
                        ),
                      )),

                      /// PREV
                      /*IconButton(
                        icon: Icon(Icons.skip_previous,
                            size: 28, color: Colors.black87),
                        onPressed: audio.skipPrevious,
                      ),*/

                      /// PLAY / PAUSE
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
                            audio.onPressed();
                          },
                          icon: audio.miniicon(),
                        ),
                      )),

                      /// NEXT
                      /* IconButton(
                        icon: Icon(Icons.skip_next,
                            size: 28, color: Colors.black87),
                        onPressed: audio.skipNext,
                      ),*/
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //width: 25,
                        /*decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.black,
                                width: 2,
                              )),*/
                        child: IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          onPressed: () {
                            audio.cleanUpResources();
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            size: 24,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimer(AudioPlayerModel audio) {
    final style = const TextStyle(fontSize: 14);

    return StreamBuilder<double>(
      initialData: audio.backgroundAudioPositionSeconds,
      stream: audio.audioProgressStreams.stream,
      builder: (context, snapshot) {
        final double position = (snapshot.data ?? 0.0);

        double sliderValue = 0;
        if (audio.backgroundAudioDurationSeconds > 0) {
          sliderValue =
              (position / audio.backgroundAudioDurationSeconds).clamp(0.0, 1.0);
        }

        return Row(
          children: [
            const SizedBox(width: 18),

            /// CURRENT TIME
            Text(
              TimUtil.stringForSeconds(position),
              style: style,
            ),

            Expanded(
              child: Slider(
                value: sliderValue,
                activeColor: MyColors.mainC0lor,
                onChanged: (v) {
                  final pos = v * audio.backgroundAudioDurationSeconds;
                  audio.seekTo(pos);
                },
              ),
            ),

            /// TOTAL TIME
            Text(
              TimUtil.stringForSeconds(audio.backgroundAudioDurationSeconds),
              style: style,
            ),

            const SizedBox(width: 18),
          ],
        );
      },
    );
  }
}

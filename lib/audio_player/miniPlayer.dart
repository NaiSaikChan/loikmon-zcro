import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:provider/provider.dart';

import '../models/Articles.dart';
import '../providers/AudioPlayerModel.dart';
import '../utils/TextStyles.dart';
import '../widgets/MarqueeWidget.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _AudioPlayout createState() => _AudioPlayout();
}

class _AudioPlayout extends State<MiniPlayer> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<AudioPlayerModel>(context, listen: false).setContext(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerModel>(
      builder: (context, audioPlayerModel, child) {
        Articles? mediaItem = audioPlayerModel.currentMedia;
        return mediaItem == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  //do nothing
                  Navigator.of(context).pushNamed(
                    ArticleViewerScreen.routeName,
                    arguments: ScreenArguements(
                      position: audioPlayerModel.currentMediaPosition,
                      items: mediaItem,
                      itemsList: audioPlayerModel.currentPlaylist,
                      check: true,
                    ),
                  );
                },
                child: Container(
                  height: 65,
                  width: 500,
                  //clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        mediaItem == null
                            ? Container()
                            : (mediaItem.thumbnail == ""
                                ? Icon(Icons.audiotrack)
                                : Container(
                                    padding: EdgeInsets.all(5),
                                    height: 50,
                                    width: 60,
                                    child: CachedNetworkImage(
                                      cacheKey: mediaItem.thumbnail,
                                      imageUrl: mediaItem.thumbnail!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black12,
                                                  BlendMode.darken)),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: CupertinoActivityIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                              child: Icon(
                                        Icons.error,
                                        color: Colors.grey,
                                      )),
                                    ),
                                  )),
                        Container(
                          width: 12,
                        ),
                        Expanded(
                            child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          isThreeLine: false,
                          dense: false,
                          title: MarqueeWidget(
                            direction: Axis.horizontal,
                            child: Text(
                              mediaItem.title!,
                              maxLines: 1,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          subtitle: Text(
                            mediaItem.author!,
                            style: TextStyles.display1(context).copyWith(
                              fontSize: 13,
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 8,
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
                              audioPlayerModel.onPressed();
                            },
                            icon: audioPlayerModel.miniicon(),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
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
                              audioPlayerModel.cleanUpResources();
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

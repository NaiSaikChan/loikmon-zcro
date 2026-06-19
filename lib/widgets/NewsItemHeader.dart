import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/ArticleBookmarksModel.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/Articles.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';

class ItemHeaderTile extends StatelessWidget {
  final Articles object;
  final int index;
  final bool isBookmarks;
  final bool isSource;
  final List<Articles> items;
  final int position;
  final bool isFree;

  const ItemHeaderTile({
    Key? key,
    required this.index,
    required this.object,
    required this.isBookmarks,
    required this.isSource,
    required this.items,
    required this.position,
    required this.isFree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppStateManager appstate = Provider.of<AppStateManager>(context);
    return Container(
      height: 100.0,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ArticleViewerScreen.routeName,
                      arguments: ScreenArguements(
                        position: position,
                        items: object,
                        itemsList: items,
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 160,
                          child: CachedNetworkImage(
                            imageUrl: object.thumbnail!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
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
                        Visibility(
                          visible: object.streamUrl != "",
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, right: 6),
                              child: Icon(
                                LineAwesomeIcons.volume_up_solid,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          child: Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              margin: EdgeInsets.all(1),
                              padding:
                                  EdgeInsets.only(left: 3, right: 3, bottom: 0),
                              //width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                              child: Text(
                                isFree
                                    ? index.toString()
                                    : object.id.toString(),
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                  //fontFamily: "",
                                  color: MyColors.white,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
                            child: Text(
                              object.author!,
                              style: TextStyles.display1(context).copyWith(
                                  //fontWeight: FontWeight.bold,
                                  //fontFamily: 'style1',
                                  fontSize: 16),
                            ),
                          ),
                          Spacer(),
                          Text(object.date!,
                              style: TextStyles.caption(context).copyWith(
                                  //fontFamily: 'style1',
                                  fontSize: 14)
                              //.copyWith(color: MyColors.grey_60),
                              ),
                        ],
                      ),
                      // Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ArticleViewerScreen.routeName,
                            arguments: ScreenArguements(
                                position: index,
                                items: object,
                                itemsList: items),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(object.title!,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyles.display1(context).copyWith(
                                fontSize: 18,
                                //color: MyColors.grey_80,
                                fontWeight: FontWeight.w600,
                                //fontFamily: 'style2',
                              )),
                        ),
                      ),
                      // Spacer(),
                      Row(
                        children: <Widget>[
                          Text(object.category!.toUpperCase(),
                              style: TextStyles.display5(context).copyWith(
                                  //fontFamily: 'style1',
                                  fontSize: 15)
                              //.copyWith(color: MyColors.grey_60),
                              ),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Consumer<ArticleBookmarksModel>(
                                builder: (context, bookmarksModel, child) {
                                  bool isBookmarked = bookmarksModel
                                      .isArticleBookMarked(object.id);
                                  return InkWell(
                                    child: Icon(
                                        isBookmarked
                                            ? LineAwesomeIcons.bookmark_solid
                                            : LineAwesomeIcons.bookmark,
                                        color: isBookmarked
                                            ? Colors.red
                                            : appstate.isDarkModeOn
                                                ? const Color.fromARGB(
                                                    255, 240, 238, 238)
                                                : Colors.black,
                                        size: 22.0),
                                    onTap: () {
                                      if (isBookmarked)
                                        bookmarksModel
                                            .unBookmarkArticle(object.id);
                                      else
                                        bookmarksModel.bookmarkArticle(object);
                                    },
                                  );
                                },
                              ),
                              Container(
                                width: 15,
                                //margin: EdgeInsets.all(10),
                              ),
                              InkWell(
                                child: Icon(Icons.share,
                                    color: Colors.lightBlue, size: 20.0),
                                onTap: () async {
                                  Utility.sharearticle(context, object);
                                },
                              ),
                              Container(
                                width: 15,
                                //margin: EdgeInsets.all(10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 6.3,
          ),
          Divider(
            height: 0.1,
            //color: Colors.grey.shade800,
          )
        ],
      ),
    );
  }
}

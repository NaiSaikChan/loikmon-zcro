import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/ArticleBookmarksModel.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/Articles.dart';
import '../models/ScreenArguements.dart';
import '../utils/TextStyles.dart';

class ItemTile extends StatelessWidget {
  final Articles object;
  final int index;
  final List<Articles> items;
  final int position;
  final bool isFree;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.items,
    required this.position,
    required this.isFree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final articlesModel = Provider.of<ArticlesModel>(context);
    final appState = Provider.of<AppStateManager>(context);
    return Container(
      height: 70.4,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(7, 2, 13, 0),
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
                          height: 54,
                          width: 70,
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
                          child: Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: EdgeInsets.all(1),
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
                                  fontSize: 10.0,
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
                              style: TextStyles.caption(context).copyWith(
                                  //fontWeight: FontWeight.bold,
                                  //fontFamily: 'style1',
                                  fontSize: 12),
                            ),
                          ),
                          Spacer(),
                          Text(object.date!,
                              style: TextStyles.caption(context).copyWith(
                                  //fontFamily: 'style1',
                                  fontSize: 12)
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
                                //color: MyColors.grey_80,
                                fontWeight: FontWeight.w600,
                                // fontFamily: 'style1',
                              )),
                        ),
                      ),
                      // Spacer(),
                      Row(
                        children: <Widget>[
                          Text(object.category!.toUpperCase(),
                              style: TextStyles.caption(context).copyWith(
                                  //fontFamily: 'style1',
                                  fontSize: 12)
                              //.copyWith(color: MyColors.grey_60),
                              ),
                          Spacer(),
                          Visibility(
                            visible: object.streamUrl != "",
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Icon(
                                LineAwesomeIcons.volume_up_solid,
                                // color: Colors.orange[900],
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: 15,
                            //margin: EdgeInsets.all(10),
                          ),
                          Row(
                            children: <Widget>[
                              Consumer<ArticleBookmarksModel>(
                                builder: (context, bookmarksModel, child) {
                                  bool isBookmarked = bookmarksModel
                                      .isArticleBookMarked(object.id);
                                  return InkWell(
                                    child: Icon(
                                        isBookmarked
                                            ? LineAwesomeIcons.heart_solid
                                            : LineAwesomeIcons.heart,
                                        color: isBookmarked
                                            ? Colors.red
                                            : appState.isDarkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                        size: 18.0),
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
                                    color: Colors.lightBlue, size: 18.0),
                                onTap: () async {
                                  Utility.sharearticle(context, object);
                                },
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

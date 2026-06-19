import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/widgets/NewsItemHeader.dart';
import 'package:provider/provider.dart';

import '../providers/ArticleBookmarksModel.dart';

class ArticleBookmarkScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<ArticleBookmarkScreen> {
  late ArticleBookmarksModel mediaScreensModel;
  late List<Articles> items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<ArticleBookmarksModel>(context);
    items = mediaScreensModel.pinnedArticles;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Appbar(),
            Expanded(
              child: (items.length == 0)
                  ? Center(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(t.noitemstodisplay,
                              textAlign: TextAlign.center,
                              style: TextStyles.display1(context)
                                  .copyWith(fontSize: 18)),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ItemHeaderTile(
                          index: items.length - index,
                          position: index,
                          object: items[index],
                          isBookmarks: false,
                          isSource: true,
                          isFree: true,
                          items: items as List<Articles>,
                        );
                      },
                    ),
            ),
            // MiniPlayer(),
          ],
        ),
      ),
    );
  }
}

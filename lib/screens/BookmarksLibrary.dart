import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/screens/ArticleBookmarkScreen.dart';
import 'package:loikmon/screens/BookmarkScreen.dart';
import 'package:loikmon/screens/DownloadedBooks.dart';
import 'package:loikmon/screens/PurchasedArticles.dart';
import 'package:loikmon/screens/PurchasedBooks.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';

class BookmarksLibrary extends StatelessWidget {
  BookmarksLibrary();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Container(
        margin: MediaQuery.of(context).size.width > 1200
            ? EdgeInsets.only(left: 100, right: 100)
            : EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 48,
              // margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: TabBar(
                isScrollable: false,
                indicatorColor: MyColors.mainC0lor,
                labelPadding: EdgeInsets.all(2),

                //labelColor: MyColors.mainC0lor,
                labelStyle: TextStyles.display0(context).copyWith(
                  //fontWeight: FontWeight.bold,
                  color: MyColors.primaryLight,
                  fontSize: 20,
                ),
                tabs: [
                  Tab(text: t.bookbookmarks),
                  Tab(text: t.bookmarkedarticles),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 12,
                ),
                child: TabBarView(
                  children: [
                    BookmarksScreen(),
                    ArticleBookmarkScreen(),
                    DownloadedBooks(),
                    PurchasedBooks(),
                    PurchasedArticles(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

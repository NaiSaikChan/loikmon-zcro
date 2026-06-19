import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/screens/PurchasedArticles.dart';
import 'package:loikmon/screens/PurchasedBooks.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';

class Library extends StatelessWidget {
  Library();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Container(
        child: Column(
          children: [
            Container(
              height: 48,
              //margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: TabBar(
                isScrollable: false,
                indicatorColor: MyColors.mainC0lor,
                //labelColor: MyColors.mainC0lor,
                labelStyle: TextStyles.display0(context).copyWith(
                  //fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),

                tabs: [
                  Tab(text: t.purchasedbooks),
                  Tab(text: t.purchasedarticles),
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
                    //BookmarksScreen(),
                    //ArticleBookmarkScreen(),
                    //DownloadedBooks(),
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

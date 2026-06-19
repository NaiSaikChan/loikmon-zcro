import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/screens/ArticlesCatsScreen.dart';
import 'package:loikmon/screens/BooksScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';

class CategoriesViewScreen extends StatelessWidget {
  static const routeName = "/CategoriesViewScreen";
  CategoriesViewScreen(this.itms);
  final Itms? itms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          itms!.title!,
          style: TextStyles.display1(context).copyWith(
              //fontFamily: 'style2'
              fontSize: 22),
          maxLines: 1,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Container(
          margin: EdgeInsets.only(left: 50, right: 50),
          child: Column(
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.fromLTRB(6, 10, 6, 0),
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: TabBar(
                  isScrollable: false,
                  indicatorColor: MyColors.mainC0lor,
                  //labelColor: MyColors.mainC0lor,
                  labelStyle:
                      TextStyles.display1(context).copyWith(fontSize: 18),
                  tabs: [
                    Tab(text: t.articles),
                    Tab(text: t.books),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 0,
                  ),
                  child: TabBarView(
                    children: [
                      Container(
                        margin: MediaQuery.of(context).size.width > 1200
                            ? EdgeInsets.only(left: 150, right: 150)
                            : EdgeInsets.only(left: 0, right: 0),
                        padding: EdgeInsets.all(5),
                        child: ArticlesCatsScreen(itms),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: BooksScreen(itms),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/pages/ListBooks.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/DashboardModel.dart';
import 'package:loikmon/screens/EmptyListScreen.dart';
import 'package:loikmon/screens/OthersBooksScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

class EbookOverView extends StatefulWidget {
  EbookOverView(this.books);
  final Books? books;

  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<EbookOverView> {
  late DashboardModel dashboardModel;
  bool isSubscribed = false;

  onRetryClick() {
    dashboardModel.loadreviewItems(widget.books);
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<DashboardModel>(context, listen: false)
          .loadreviewItems(widget.books);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    dashboardModel = Provider.of<DashboardModel>(context);

    return Container(
      //color: Colors.white,
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Visibility(
            visible: widget.books!.description! != "",
            child: Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(0.0),
              //decoration: BoxDecoration(color: Colors.grey.shade200),
              child: ExpandablePanel(
                header: Text(
                  t.description,
                  style: TextStyles.display1(context)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                theme: ExpandableThemeData(
                    iconColor: appStateManager.isDarkModeOn
                        ? Colors.white
                        : MyColors.headerdark),
                collapsed: Text(
                  widget.books!.description!,
                  style: TextStyles.display1(context).copyWith(fontSize: 18),
                  softWrap: true,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Container(
                  child: Text(
                    widget.books!.description!,
                    style: TextStyles.display1(context).copyWith(fontSize: 18),
                  ),
                ),
              ),
            ),

            /* Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.books!.description!,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),*/
          ),
          Visibility(
              visible: widget.books!.description! != "",
              child: Container(height: 15)),
          Visibility(
              visible: dashboardModel.isloadingoverview,
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: 200,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )),
          Visibility(
              visible: dashboardModel.isoverviewError,
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: 200,
                child: Center(
                  child: EmptyListScreen(
                    message: t.failedtoloadoverview,
                  ),
                ),
              )),
          Visibility(
            visible: !dashboardModel.isloadingoverview &&
                !dashboardModel.isoverviewError,
            child: Column(
              children: [
                Visibility(
                  visible: dashboardModel.authorbooks!.length > 0,
                  child: header(t.authorbooks, () {
                    Navigator.of(context).pushNamed(OthersBooksScreen.routeName,
                        arguments: new ScreenArguements(position: 4));
                  }),
                ),
                Visibility(
                    visible: dashboardModel.authorbooks!.length > 0,
                    child: ListBooks(dashboardModel.authorbooks!)),
                SizedBox(
                  height: 20,
                ),
                header(t.booksyoumaylike, () {
                  Navigator.of(context).pushNamed(OthersBooksScreen.routeName,
                      arguments: new ScreenArguements(position: 0));
                }),
                ListBooks(dashboardModel.booksyoumaylike!),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget header(String title, Function onclick) {
    return Container(
      height: 20,
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyles.display1(context).copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color?> colors = [
    Colors.purple,
    Colors.teal,
    Colors.deepOrange,
    Colors.purple,
    Colors.lime[700],
    Colors.blueGrey[700]
  ];
}

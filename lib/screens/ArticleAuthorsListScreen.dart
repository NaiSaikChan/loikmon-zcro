import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/ArticlesListModel.dart';
import 'package:loikmon/screens/EmptyListScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/widgets/NewsItemHeader.dart';
import 'package:loikmon/widgets/NewsItemTile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screens/NoitemScreen.dart';

class ArticleAuthorsListScreen extends StatefulWidget {
  static const routeName = "/ArticleAuthorsListScreen";
  ArticleAuthorsListScreen(this.authors);
  final Authors authors;

  @override
  CategoriesScreenRouteState createState() => new CategoriesScreenRouteState();
}

class CategoriesScreenRouteState extends State<ArticleAuthorsListScreen> {
  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return ChangeNotifierProvider(
        create: (context) => ArticlesListModel(Itms(
              widget.authors.id,
              widget.authors.name,
              1,
            )),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.authors.name!,
              style: TextStyles.display1(context).copyWith(
                  //fontFamily: 'Style1',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            toolbarHeight: 70,
          ),
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 20.0),
                      Container(
                          width: 80.0,
                          height: 80.0,
                          child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              child: CircleAvatar(
                                  radius: 80.0,
                                  backgroundImage: NetworkImage(
                                      widget.authors.thumbnail!)))),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.authors.name!,
                            style: TextStyles.display1(context).copyWith(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.authors.email!,
                            style: TextStyles.display1(context)
                                .copyWith(fontSize: 14.0),
                          ),
                          Text(
                            widget.authors.education!,
                            style: TextStyles.display1(context)
                                .copyWith(fontSize: 14.0),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    //decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: ExpandablePanel(
                      header: Text(
                        t.description,
                        style: TextStyles.display1(context).copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      theme: ExpandableThemeData(
                          iconColor: appStateManager.isDarkModeOn
                              ? const Color.fromARGB(255, 237, 236, 236)
                              : MyColors.headerdark),
                      collapsed: Text(
                        widget.authors.description!,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      expanded: Container(
                        child: Text(widget.authors.description!),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.only(top: 12),
              child: AuthorsBooksScreen(),
            ),
          ),
        ));
  }
}

class AuthorsBooksScreen extends StatefulWidget {
  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<AuthorsBooksScreen> {
  ArticlesListModel? ebooksListModel;
  List<Articles?>? items;

  void _onRefresh() async {
    ebooksListModel!.loadItems();
  }

  void _onLoading() async {
    ebooksListModel!.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<ArticlesListModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    ebooksListModel = Provider.of<ArticlesListModel>(context);
    items = ebooksListModel!.booksList;

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 50.0,
            child: Center(child: body),
          );
        },
      ),
      controller: ebooksListModel!.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (ebooksListModel!.isError == true && items!.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : items!.length == 0
              ? EmptyListScreen(message: t.noitemstodisplay)
              : ListView.separated(
                  itemBuilder: (c, i) => i == 0
                      ? ItemHeaderTile(
                          index: i,
                          object: items![i]!,
                          isBookmarks: false,
                          isSource: true,
                          isFree: true,
                          items: items as List<Articles>,
                          position: i,
                        )
                      : ItemTile(
                          index: i,
                          isFree: true,
                          object: items![i]!,
                          items: items as List<Articles>,
                          position: i,
                        ),
                  //itemExtent: 130.0,
                  separatorBuilder: (context, position) {
                    return Container();
                  },
                  itemCount: items!.length,
                ),
    );
  }
}

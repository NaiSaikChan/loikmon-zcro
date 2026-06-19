import 'dart:convert';

import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/ArticlesListModel.dart';
import 'package:loikmon/providers/EbooksListModel.dart';
import 'package:loikmon/screens/AuthPage.dart';
import 'package:loikmon/screens/EmptyListScreen.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/widgets/ArtistCategoriesBooksHeader.dart';
import 'package:loikmon/widgets/AuthorArticlecategoriesNavHeader.dart';
import 'package:loikmon/widgets/BooksTile.dart';
import 'package:loikmon/widgets/NewsItemHeader.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../screens/NoitemScreen.dart';
import '../utils/TextStyles.dart';

class AuthorsListScreen extends StatefulWidget {
  static const routeName = "/AuthorsListScreen";
  AuthorsListScreen(this.authors, this.isfollowing);
  final Authors authors;
  final bool isfollowing;

  @override
  CategoriesScreenRouteState createState() => new CategoriesScreenRouteState();
}

class CategoriesScreenRouteState extends State<AuthorsListScreen> {
  bool isfollowing = false;
  Authors? authors;

  Future<void> getauthordata() async {
    try {
      Userdata? user = await SQLiteDbProvider.db.getUserData();
      final dio = Dio();

      final response = await dio.post(
        ApiUrl.GET_AUTHOR_DATA,
        data: jsonEncode({
          "data": {
            "email": user == null ? "" : user.email,
            "author": authors == null ? 0 : authors!.id,
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        print(response.data);
        final res = jsonDecode(response.data);
        authors = Authors.fromJson(res["author"]);
        isfollowing = authors!.isfollowing!;
        setState(() {});
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(response.data);
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      if (exception is DioError) {
        print(exception.message);
        print(exception.response);
        print(exception.error);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        authors = widget.authors;
        isfollowing = widget.isfollowing;
      });
      getauthordata();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () async {
                    await Share.share(
                      t.sharefiletitle +
                          widget.authors.name! +
                          "\n" +
                          t.sharefilebody, //TODO
                      subject: t.sharefiletitle, //TODO
                    );
                  }),
              Container(
                width: 10,
              ),
            ],
          ),
          /*appBar: AppBar(
            title: Text(
              widget.authors.name!,
              style: TextStyle(
                fontFamily: 'style2',
                fontSize: 17,
                // fontWeight: FontWeight.bold,
              ),
            ),
            toolbarHeight: 70,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    String packageName = packageInfo.packageName;
                    await Share.share(
                      t.sharefiletitle +
                          widget.authors.name! +
                          "\n" +
                          t.sharefilebody +
                          " http://play.google.com/store/apps/details?id=" +
                          packageName, //TODO
                      subject: t.sharefiletitle, //TODO
                    );
                  }),
              Container(
                width: 10,
              ),
            ],
          ),*/
          body: Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 20),
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 20.0),
                        Container(
                            width: 170.0,
                            height: 170.0,
                            child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: CircleAvatar(
                                    radius: 80.0,
                                    backgroundImage: NetworkImage(
                                        widget.authors.thumbnail!)))),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.authors.name!,
                              style: TextStyles.display0(context).copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                // fontFamily: 'style1'
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            // Text(
                            //   widget.authors.email!,
                            //   style: TextStyle(
                            //       fontSize: 16.0, fontFamily: 'style4'),
                            // ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.authors.education!,
                              style: TextStyles.display5(context)
                                  .copyWith(fontSize: 16.0),
                            ),
                            Container(
                              height: 20,
                            ),
                            Container(
                              height: 30,
                              width: 100,
                              // color: Colors.red,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    Userdata? userdata =
                                        await SQLiteDbProvider.db.getUserData();
                                    if (userdata == null) {
                                      Navigator.of(context)
                                          .pushNamed(AuthPage.routeName);
                                      return;
                                    }
                                    setState(() {
                                      isfollowing = !isfollowing;
                                    });
                                    await Utility.followunfollowauthor(
                                        widget.authors.id!,
                                        isfollowing,
                                        userdata.email!);
                                    getauthordata();
                                  },
                                  style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 5,
                                      )),
                                      backgroundColor: WidgetStatePropertyAll(
                                          MyColors.mainC0lor),
                                      shape: WidgetStatePropertyAll<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ))),
                                  child: Text(
                                    isfollowing ? "Unfollow" : "Follow",
                                    style: TextStyles.display1(context)
                                        .copyWith(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 244, 240, 241)),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: MediaQuery.of(context).size.width > 1200
                          ? EdgeInsets.only(
                              left: 100,
                              right: 100,
                            )
                          : EdgeInsets.only(
                              left: 100,
                              right: 100,
                            ),
                      padding: const EdgeInsets.all(3.0),
                      //decoration: BoxDecoration(color: Colors.grey.shade200),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 1,
                            ),
                            child: Card(
                              elevation: 0.1,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            Utility.openBrowserTab(
                                                widget.authors.facebook!);
                                          },
                                          icon: Icon(
                                            LineAwesomeIcons.facebook_f,
                                            color: Colors.blue,
                                            size: 30,
                                          ))),
                                  seperator(),
                                  Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            Utility.openBrowserTab(
                                                widget.authors.youtube!);
                                          },
                                          icon: Icon(
                                            LineAwesomeIcons.youtube,
                                            color: Colors.red,
                                            size: 30,
                                          ))),
                                  seperator(),
                                  Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            Utility.openBrowserTab(
                                                widget.authors.instagram!);
                                          },
                                          icon: Icon(
                                            LineAwesomeIcons.instagram,
                                            color: Colors.purple,
                                            size: 30,
                                          ))),
                                ],
                              ),
                            ),
                          ),
                          ExpandablePanel(
                            header: Text(
                              t.description,
                              style: TextStyles.display1(context).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                //fontFamily: 'style2'
                              ),
                            ),
                            theme: ExpandableThemeData(
                                iconColor: appStateManager.isDarkModeOn
                                    ? const Color.fromARGB(255, 243, 242, 242)
                                    : MyColors.headerdark),
                            collapsed: Text(
                              widget.authors.description!,
                              style: TextStyle(fontSize: 17),
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            expanded: Container(
                              child: Text(
                                widget.authors.description!,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Card(
                              elevation: 0.1,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: getItem(
                                    "Posts",
                                    authors == null ? 0 : authors!.posts!,
                                  )),
                                  seperator(),
                                  Expanded(
                                      child: getItem(
                                          "Likes",
                                          authors == null
                                              ? 0
                                              : authors!.likes!)),
                                  seperator(),
                                  Expanded(
                                      child: getItem(
                                          "Followers",
                                          authors == null
                                              ? 0
                                              : authors!.followers!)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: DefaultTabController(
                length: 2,
                child: Container(
                  margin: MediaQuery.of(context).size.width > 1200
                      ? EdgeInsets.only(
                          left: 100,
                          right: 100,
                        )
                      : EdgeInsets.only(
                          left: 100,
                          right: 100,
                        ),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(6, 10, 6, 0),
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        child: TabBar(
                          isScrollable: false,
                          indicatorColor: MyColors.mainC0lor,
                          labelColor: MyColors.mainC0lor,
                          labelStyle: TextStyles.display1(context).copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          tabs: [
                            Tab(text: t.articles),
                            Tab(text: t.books),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          /* margin: MediaQuery.of(context).size.width > 1200
                          ? EdgeInsets.only(
                              left: 200,
                              right: 200,
                            )
                          : EdgeInsets.only(
                              left: 60,
                              right: 60,
                            ),*/
                          padding: EdgeInsets.only(
                            top: 2,
                          ),
                          child: TabBarView(
                            children: [
                              ChangeNotifierProvider(
                                create: (context) => ArticlesListModel(Itms(
                                  widget.authors.id,
                                  widget.authors.name,
                                  1,
                                )),
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: AuthorsArticleScreen(),
                                ),
                              ),
                              ChangeNotifierProvider(
                                create: (context) => EbooksListModel(
                                    Itms(
                                      widget.authors.id,
                                      widget.authors.name,
                                      1,
                                    ),
                                    true),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: AuthorsBooksScreen(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  getItem(String title, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyles.display1(context).copyWith(
              fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'style1'),
        ),
        Text(
          title,
          style: TextStyles.display1(context)
              .copyWith(fontSize: 16, fontFamily: 'style1'),
        )
      ],
    );
  }

  seperator() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }
}

class AuthorsBooksScreen extends StatefulWidget {
  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class AuthorsArticleScreen extends StatefulWidget {
  @override
  _AuthorsArticleScreenScreenState createState() =>
      _AuthorsArticleScreenScreenState();
}

class _AuthorsArticleScreenScreenState extends State<AuthorsArticleScreen> {
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

    return Column(
      children: [
        AuthorArticlecategoriesNavHeader(ebooksListModel!),
        Expanded(
          child: SmartRefresher(
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
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: ebooksListModel!.refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: (ebooksListModel!.isError == true && items!.length == 0)
                ? NoitemScreen(
                    title: t.oops,
                    message: t.dataloaderror,
                    onClick: _onRefresh)
                : items!.length == 0
                    ? EmptyListScreen(message: t.noitemstodisplay)
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemHeaderTile(
                            index: items!.length - index,
                            position: index,
                            object: items![index]!,
                            isBookmarks: false,
                            isSource: true,
                            isFree: true,
                            items: items as List<Articles>,
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }
}

class _CategoriesMediaScreenState extends State<AuthorsBooksScreen> {
  EbooksListModel? ebooksListModel;
  List<Books?>? items;

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
      Provider.of<EbooksListModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    ebooksListModel = Provider.of<EbooksListModel>(context);
    items = ebooksListModel!.booksList;

    return Column(
      children: [
        ArtistCategoriesBooksHeader(ebooksListModel!),
        Expanded(
          child: SmartRefresher(
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
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: ebooksListModel!.refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: (ebooksListModel!.isError == true && items!.length == 0)
                ? NoitemScreen(
                    title: t.oops,
                    message: t.dataloaderror,
                    onClick: _onRefresh)
                : items!.length == 0
                    ? EmptyListScreen(message: t.noitemstodisplay)
                    : AutoHeightGridView(
                        itemCount: items!.length,
                        crossAxisCount: Utility.getBookItemCount(context),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 8.0,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        shrinkWrap: true,
                        builder: (context, index) {
                          return BooksTile(
                            false,
                            index: (items!.length - index),
                            books: items![index],
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }
}

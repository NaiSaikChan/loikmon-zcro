import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/utils/network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../i18n/strings.g.dart';
import '../models/Inbox.dart';
import '../utils/ApiUrl.dart';
import '../utils/TextStyles.dart';
import 'NoitemScreen.dart';

class InboxListScreenState extends StatelessWidget {
  static const routeName = "/inboxlist";
  InboxListScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: DefaultTabController(
        length: 2,
        child: Container(
          child: Column(
            children: [
              Container(
                //height: 48,
                child: TabBar(
                  isScrollable: false,
                  indicatorColor: MyColors.mainC0lor,
                  //labelColor: MyColors.mainC0lor,
                  labelStyle:
                      TextStyles.display0(context).copyWith(fontSize: 17),
                  tabs: [
                    Tab(text: "Content"),
                    Tab(text: "Bank"),
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
                      AuthorInboxScreenBody(),
                      InboxScreenBody(),
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

class InboxScreenBody extends StatefulWidget {
  @override
  InboxScreenBodyRouteState createState() => new InboxScreenBodyRouteState();
}

class InboxScreenBodyRouteState extends State<InboxScreenBody> {
  List<Inbox>? items = [];
  bool isLoading = false;
  bool isError = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  void _onRefresh() async {
    loadItems();
  }

  void _onLoading() async {
    loadMoreItems();
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    setState(() {});
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Inbox>? item) async {
    items!.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    setState(() {});
  }

  void setMoreItems(List<Inbox> item) {
    refreshController.loadComplete();
    isError = false;
    items!.addAll(item);
    setState(() {});
  }

  Future<void> fetchItems() async {
    try {
      Userdata? userdata = await SQLiteDbProvider.db.getUserData();
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.INBOX,
        data: jsonEncode({
          "data": {
            "page": page.toString(),
            "email": userdata == null ? "null" : userdata.email,
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        List<Inbox>? mediaList = parseSliderMedia(res);
        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList!);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      if (exception is DioError) {
        print(exception.message);
        print(exception.response);
      }
      setFetchError();
    }
  }

  static List<Inbox>? parseSliderMedia(dynamic res) {
    final parsed = res["inbox"].cast<Map<String, dynamic>>();
    return parsed.map<Inbox>((json) => Inbox.fromJson(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      setState(() {
        isError = true;
        refreshController.refreshFailed();
      });
    } else {
      setState(() {
        refreshController.loadFailed();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).size.width > 1200
          ? EdgeInsets.only(left: 250, right: 250)
          : EdgeInsets.only(left: 50, right: 50),
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
        controller: refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: (isError == true && items!.length == 0)
            ? NoitemScreen(
                title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
            : ListView.builder(
                itemCount: items!.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(3),
                itemBuilder: (BuildContext context, int index) {
                  return ItemTile(
                    object: items![index],
                  );
                },
              ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Inbox object;

  const ItemTile({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).pushNamed(InboxViewerScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items: object,
              itemsList: [],
            ));*/
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: object.approved == 1 ? Colors.blue : Colors.red,
          ),
        ),
        height: 100,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, top: 8),
              width: 50,
              height: 80,
              child: PNetworkImage(
                object.thumbnail!,
                fit: BoxFit.fill,
                height: double.infinity,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      //color: Colors.blue,
                      height: 20,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          Text(object.date!,
                              style: TextStyles.caption(context).copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)
                              //.copyWith(color: MyColors.grey_60),

                              ),
                          Container(
                            width: 12,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 6,
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t.paymentfor +
                              " " +
                              object.value!.toString() +
                              " " +
                              t.coins,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                          maxLines: 3,
                          softWrap: true,
                          style: TextStyles.display1(context).copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'style1'),
                        ),
                      ),
                    ),
                    Container(
                      height: 6,
                    ),
                    Container(
                      //color: Colors.blue,
                      height: 20,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 12,
                          ),
                          Text(
                              object.approved == 0
                                  ? t.pendingapproval
                                  : t.paymentapproved,
                              style: TextStyles.caption(context)
                                  .copyWith(fontSize: 12, fontFamily: 'style1')
                              //.copyWith(color: MyColors.grey_60),

                              ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AuthorInboxScreenBody extends StatefulWidget {
  @override
  AuthorInboxScreenBodyRouteState createState() =>
      new AuthorInboxScreenBodyRouteState();
}

class AuthorInboxScreenBodyRouteState extends State<AuthorInboxScreenBody> {
  List<Inbox>? items = [];
  bool isLoading = false;
  bool isError = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  void _onRefresh() async {
    loadItems();
  }

  void _onLoading() async {
    loadMoreItems();
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    setState(() {});
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Inbox>? item) async {
    items!.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    setState(() {});
  }

  void setMoreItems(List<Inbox> item) {
    refreshController.loadComplete();
    isError = false;
    items!.addAll(item);
    setState(() {});
  }

  Future<void> fetchItems() async {
    try {
      Userdata? userdata = await SQLiteDbProvider.db.getUserData();
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.AUTHOR_INBOX,
        data: jsonEncode({
          "data": {
            "page": page.toString(),
            "email": userdata == null ? "null" : userdata.email,
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        List<Inbox>? mediaList = parseSliderMedia(res);
        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList!);
        }
        if (mediaList!.length > 0) {
          SharedPreferences? _prefs = await SharedPreferences.getInstance();
          _prefs.setInt("lastseenartistinbox", mediaList[0].id!);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      if (exception is DioError) {
        print(exception.message);
        print(exception.response);
      }
      setFetchError();
    }
  }

  static List<Inbox>? parseSliderMedia(dynamic res) {
    final parsed = res["inbox"].cast<Map<String, dynamic>>();
    return parsed.map<Inbox>((json) => Inbox.fromJson2(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      setState(() {
        isError = true;
        refreshController.refreshFailed();
      });
    } else {
      setState(() {
        refreshController.loadFailed();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).size.width > 1200
          ? EdgeInsets.only(left: 250, right: 250)
          : EdgeInsets.only(left: 50, right: 50),
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
        controller: refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: (isError == true && items!.length == 0)
            ? NoitemScreen(
                title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
            : ListView.builder(
                itemCount: items!.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(3),
                itemBuilder: (BuildContext context, int index) {
                  return ItemTile2(
                    object: items![index],
                  );
                },
              ),
      ),
    );
  }
}

class ItemTile2 extends StatefulWidget {
  final Inbox object;

  const ItemTile2({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  State<ItemTile2> createState() => _ItemTile2State();
}

class _ItemTile2State extends State<ItemTile2> {
  processDeepLink(String id, String type) async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    Alerts.showProgressDialog(context, "Processing, please wait ...");
    try {
      var data = {
        "type": type,
        "id": id, //path.pathSegments[1].toString(),
        "email": userdata == null ? "null" : userdata.email,
      };
      print(data);

      final dio = Dio();

      final response = await dio.post(
        ApiUrl.getitem,
        data: jsonEncode({"data": data}),
      );
      print("response for deeplink");
      print(response.data);
      print("...response for deeplink");
      Navigator.of(context).pop();
      final res = jsonDecode(response.data);
      if (res['status'] == "ok") {
        if (type == "book") {
          Books book = Books.fromJson(res["book"]);
          Navigator.of(context).pushNamed(EbooksViewerScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: book,
                check: false,
              ));
        }
        if (type == "article") {
          Articles articles = Articles.fromJson(res["article"]);
          print("received = " + articles.title!);
          List<Articles> items = [];
          items.add(articles);
          Navigator.of(context).pushNamed(ArticleViewerScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: articles,
                itemsList: items,
                check: false,
              ));
        }
      } else {
        Alerts.show(context, "", "There was an issue processing the request");
      }
    } catch (exception) {
      // I get no exception here
      print("...response for deeplink");
      print(exception.toString());
      print("...response for deeplink");
      Navigator.of(context).pop();
      Alerts.show(context, "", "There was an issue processing the request");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        processDeepLink(widget.object.itmid!,
            int.parse(widget.object.type.toString()) == 0 ? "book" : "article");
      },
      child: Card(
        elevation: 0.3,
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          /*decoration: BoxDecoration(
            border: Border.all(
              color: object.approved == 1 ? Colors.blue : Colors.red,
            ),
          ),*/
          height: 100,
          child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 10, top: 8),
                  width: 80,
                  height: 80,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: PNetworkImage(
                      widget.object.thumbnail!,
                      fit: BoxFit.fill,
                      height: double.infinity,
                    ),
                  )),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        //color: Colors.blue,
                        height: 20,
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Text(widget.object.itmdate!,
                                style: TextStyles.display1(context).copyWith(
                                    fontSize: 14, fontWeight: FontWeight.bold)
                                //.copyWith(color: MyColors.grey_60),

                                ),
                            Container(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 6,
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.object.item!,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                            maxLines: 3,
                            softWrap: true,
                            style: TextStyles.display1(context).copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 6,
                      ),
                      Container(
                        //color: Colors.blue,
                        height: 20,
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 12,
                            ),
                            Text(
                                int.parse(widget.object.type!) == 0
                                    ? t.newbook
                                    : t.newarticle +
                                        t.fromauthor +
                                        widget.object.author!,
                                style: TextStyles.caption(context).copyWith(
                                  fontSize: 13, //fontFamily: 'style1'
                                )
                                //.copyWith(color: MyColors.grey_60),

                                ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

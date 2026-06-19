import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../i18n/strings.g.dart';
import '../models/Faqs.dart';
import '../utils/ApiUrl.dart';
import '../utils/TextStyles.dart';
import 'NoitemScreen.dart';

class FaqsScreen extends StatelessWidget {
  static const routeName = "/FaqsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQS"),
        titleTextStyle: TextStyle(fontSize: 20),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: InboxScreenBody(),
      ),
    );
  }
}

class InboxScreenBody extends StatefulWidget {
  @override
  InboxScreenBodyRouteState createState() => new InboxScreenBodyRouteState();
}

class InboxScreenBodyRouteState extends State<InboxScreenBody> {
  List<Faqs>? items = [];
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

  void setItems(List<Faqs>? item) async {
    items!.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    setState(() {});
  }

  void setMoreItems(List<Faqs> item) {
    refreshController.loadComplete();
    isError = false;
    items!.addAll(item);
    setState(() {});
  }

  Future<void> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.GET_FAQS),
      );
      //print(response.body);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.body);
        //print(res);
        List<Faqs>? mediaList = parseSliderMedia(res);
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
      setFetchError();
    }
  }

  static List<Faqs>? parseSliderMedia(dynamic res) {
    final parsed = res["faqs"].cast<Map<String, dynamic>>();
    return parsed.map<Faqs>((json) => Faqs.fromJson(json)).toList();
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
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
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
      //onLoading: _onLoading,
      child: (isError == true && items!.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : Container(
              margin: MediaQuery.of(context).size.width > 1200
                  ? EdgeInsets.only(left: 200, right: 200)
                  : EdgeInsets.only(left: 20, right: 20),
              child: ListView.builder(
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

class ItemTile extends StatefulWidget {
  final Faqs object;
  const ItemTile({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  bool isshowing = false;
  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return InkWell(
      onTap: () {
        /* Navigator.of(context).pushNamed(InboxViewerScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items: object,
              itemsList: [],
            ));*/
      },
      child: Container(
        //color: MyColors.mainC0lor,
        padding: EdgeInsets.all(isshowing ? 12 : 8),
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: appStateManager.isDarkModeOn
              ? const Color.fromARGB(255, 14, 24, 41)
              : const Color.fromARGB(255, 232, 234, 234),
          border: Border.all(color: Colors.grey),
        ),
        //height: 250,
        child: ListTile(
          onTap: () {
            setState(() {
              isshowing = !isshowing;
            });
          },
          trailing: Icon(
            isshowing ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 30,
          ),
          title: Text(
            widget.object.name!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: isshowing
              ? Container(
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
                  // decoration: BoxDecoration(
                  //     border: Border.all(
                  //   color: const Color.fromARGB(255, 166, 165, 165)!,
                  // )),
                  child: HtmlWidget(
                    widget.object.content!.trim(),
                    textStyle: TextStyles.medium(context).copyWith(
                      fontSize: 18,
                      color: appStateManager.isDarkModeOn
                          ? const Color.fromARGB(255, 239, 237, 237)
                          : Colors.black,
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  ExpansionTileBorderItem(
      {required Border border,
      required Text title,
      required GlobalKey<State<StatefulWidget>> expansionKey,
      required List<HtmlWidget> children}) {}
}

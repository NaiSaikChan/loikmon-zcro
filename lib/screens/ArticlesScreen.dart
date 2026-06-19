import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/widgets/NewsItemHeader.dart';
import 'package:loikmon/widgets/categoriesNavHeader.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../i18n/strings.g.dart';
import '../models/Articles.dart';
import '../providers/ArticlesModel.dart';
import '../utils/TextStyles.dart';

class ArticlesScreen extends StatefulWidget {
  static const routeName = "/ArticlesScreen";
  ArticlesScreen(this.type);
  final int? type;

  String getType(int type) {
    if (type == 0) {
      return t.articles;
    }
    if (type == 1) {
      return t.populararticles;
    }
    if (type == 4) {
      return "Free Articles";
    }
    return t.articles;
  }

  @override
  ArticlesScreenRouteState createState() => new ArticlesScreenRouteState();
}

class ArticlesScreenRouteState extends State<ArticlesScreen>
    with AutomaticKeepAliveClientMixin {
  bool issearchmode = false;
  var articlesModel;
  var appState;
  bool showClear = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();
  List<Articles>? items = [];

  @override
  bool get wantKeepAlive => true;

  void _onRefresh() async {
    articlesModel.fetch(widget.type!, query);
  }

  void _onLoading() async {
    articlesModel.fetchMore(widget.type!);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<ArticlesModel>(context, listen: false)
          .fetch(widget.type!, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    articlesModel = Provider.of<ArticlesModel>(context);
    items = articlesModel.items;

    bool isdarkmode =
        Provider.of<AppStateManager>(context, listen: false).isDarkModeOn;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: issearchmode ? 20 : 40,
        title: !issearchmode
            ? Text(
                t.articles,
                style: TextStyles.display1(context).copyWith(
                  //fontFamily: 'Style1',
                  fontSize: 25,
                  //fontWeight: FontWeight.bold
                ),
              )
            : Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.only(right: 30),
                  width: MediaQuery.of(context).size.width / 3,
                  child: TextField(
                      keyboardType: TextInputType.text,
                      onSubmitted: (_query) {
                        setState(() {
                          query = _query;
                          showClear = (_query.length > 0);
                        });
                        _onRefresh();
                      },
                      onChanged: (term) {
                        setState(() {
                          showClear = (term.length > 2);
                        });
                      },
                      controller: inputController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close,
                              color: isdarkmode
                                  ? const Color.fromARGB(255, 239, 237, 237)
                                  : Colors.black),
                          onPressed: () {
                            inputController.clear();
                            showClear = false;
                            issearchmode = false;
                            setState(() {
                              query = "";
                            });
                            _onRefresh();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 15),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: t.searchArticles,
                        labelStyle: TextStyles.display1(context).copyWith(
                            color: isdarkmode
                                ? const Color.fromARGB(255, 243, 241, 241)
                                : Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(25),
                          //gapPadding: 0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(25),
                          gapPadding: 0,
                        ),
                      )),
                ),
              ),
        actions: [
          Visibility(
            visible: !issearchmode,
            child: IconButton(
                padding: EdgeInsets.only(right: 20),
                onPressed: () {
                  setState(() {
                    issearchmode = true;
                  });
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                )),
          ),
          SizedBox(
            width: 30,
          )
        ],
      ),
      body: Container(
        margin: MediaQuery.of(context).size.width > 1200
            ? EdgeInsets.only(left: 150, right: 150)
            : EdgeInsets.only(left: 150, right: 150),
        child: Column(
          children: [
            categoriesNavHeader(articlesModel),
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
                      height: 50.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: articlesModel.refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: (articlesModel.isError == true &&
                        articlesModel.items.length == 0)
                    ? Center(
                        child: Text(t.dataloaderror,
                            textAlign: TextAlign.center,
                            style: TextStyles.medium(context)),
                      )
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemHeaderTile(
                            index: items!.length - index,
                            position: index,
                            object: items![index],
                            isBookmarks: false,
                            isSource: true,
                            isFree: widget.type == 4,
                            items: items as List<Articles>,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

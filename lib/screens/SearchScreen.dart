import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/widgets/BooksTile.dart';
import 'package:loikmon/widgets/NewsItemTile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../providers/SearchModel.dart';
import '../utils/TextStyles.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = "/search";
  SearchScreen();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchModel()),
      ],
      child: SearchScreenBody(),
    );
  }
}

class SearchScreenBody extends StatefulWidget {
  SearchScreenBody();

  @override
  SearchScreenRouteState createState() => new SearchScreenRouteState();
}

class SearchScreenRouteState extends State<SearchScreenBody> {
  bool finishLoading = true;
  bool showClear = false;

  final TextEditingController inputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateManager>(context);
    final searchModel = Provider.of<SearchModel>(context);
    List<Object> items = searchModel.items;

    void _onLoading() async {
      //searchModel.fetchMoreArticles();
    }

    void onItemClick(int indx) {}

    return new Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: TextStyles.display1(context)
              .copyWith(fontSize: 18, color: Colors.black),
          keyboardType: TextInputType.text,
          onSubmitted: (query) {
            searchModel.searchArticles(query);
          },
          onChanged: (term) {
            setState(() {
              showClear = (term.length > 2);
            });
          },
          decoration: InputDecoration(
            //border: InputBorder.none,
            hintText: searchModel.currentIndex == 0
                ? t.booksearchhint
                : t.articlesearchhint,
            hintStyle: TextStyles.display1(context)
                .copyWith(fontSize: 20.0, color: Colors.grey),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    searchModel.cancelSearch();
                  },
                )
              : Container(),
        ],
      ),
      body: Container(
        margin: MediaQuery.of(context).size.width > 1200
            ? EdgeInsets.only(left: 250, right: 250)
            : EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 3,
            ),
            AppinioAnimatedToggleTab(
              duration: const Duration(milliseconds: 150),
              offset: 0,
              callback: (int index) {
                searchModel.setCurrentIndex(index);
              },
              tabTexts: [
                t.books,
                t.articles,
              ],
              height: 40,
              width: 300,
              boxDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              animatedBoxDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFc3d2db).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
                color: MyColors.mainC0lor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              activeStyle: TextStyles.display1(context).copyWith(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              inactiveStyle: TextStyles.display1(context).copyWith(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp:
                      false, //searchModel.items.length > 20 ? true : false,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext? context, LoadStatus? mode) {
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
                  controller: searchModel.refreshController,
                  onLoading: _onLoading,
                  child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: buildContent(
                          context, searchModel, appState, items, onItemClick))),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context, SearchModel searchModel,
      AppStateManager appState, List<Object> items, Function onItemClick) {
    if (searchModel.isLoading) {
      return Align(
        child: Container(
          height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CupertinoActivityIndicator(
                radius: 30,
              ),
              Container(height: 5),
              Text(
                t.searching,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else if (searchModel.isError) {
      return Align(
        child: Container(
          width: 180,
          height: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(t.no_search_result,
                  style: TextStyles.caption(context)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
              Container(height: 5),
              Text(t.no_search_result_hint,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium(context).copyWith(fontSize: 13)),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else if (searchModel.isIdle) {
      return Align(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.search,
                size: 80,
              ),
              Container(height: 5),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else if (searchModel.items.length == 0) {
      return Align(
        child: Container(
          width: 180,
          height: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(t.no_search_result,
                  style: TextStyles.caption(context)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
              Container(height: 5),
              Text(t.no_search_result_hint,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium(context).copyWith(fontSize: 13)),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else {
      return searchModel.currentIndex == 0
          ? AutoHeightGridView(
              itemCount: items.length,
              crossAxisCount: Utility.getBookItemCount(context),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 8.0,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              builder: (context, index) {
                return BooksTile(
                  false,
                  index: (items.length - index),
                  books: items[index] as Books,
                );
              },
            )
          : ListView.separated(
              itemBuilder: (c, i) => ItemTile(
                position: i,
                index: i,
                isFree: true,
                object: items[i] as Articles,
                items: items as List<Articles>,
              ),
              //itemExtent: 130.0,
              separatorBuilder: (context, position) {
                return Container();
              },
              itemCount: items.length,
            );
    }
  }
}

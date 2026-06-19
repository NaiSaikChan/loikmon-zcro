import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/providers/ArticlesListModel.dart';
import 'package:loikmon/screens/EmptyListScreen.dart';
import 'package:loikmon/widgets/NewsItemHeader.dart';
import 'package:loikmon/widgets/SubCategoriesNavHeader.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screens/NoitemScreen.dart';

class ArticlesCatsScreen extends StatelessWidget {
  static const routeName = "/ArticlesCatsScreen";
  ArticlesCatsScreen(this.itms);
  final Itms? itms;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticlesListModel(itms!),
      child: Scaffold(
        // backgroundColor: Colors.white,
        /* appBar: AppBar(
          title: Text(
            itms!.title!,
            maxLines: 1,
          ),
        ),*/
        body: Container(
          padding: EdgeInsets.all(0),
          child: _BooksScreen(),
        ),
      ),
    );
  }
}

class _BooksScreen extends StatefulWidget {
  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<_BooksScreen> {
  ArticlesListModel? _bookScreensModel;
  List<Articles?>? items;

  void _onRefresh() async {
    _bookScreensModel!.loadItems();
  }

  void _onLoading() async {
    _bookScreensModel!.loadMoreItems();
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
    _bookScreensModel = Provider.of<ArticlesListModel>(context);
    items = _bookScreensModel!.booksList;

    return Column(
      children: [
        SubCategoriesNavHeader(_bookScreensModel!.subCategoriesList,
            _bookScreensModel!.isSubcategorySelected, (int id) {
          _bookScreensModel!.refreshPageOnCategorySelected(id);
        }),
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
            controller: _bookScreensModel!.refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: (_bookScreensModel!.isError == true)
                ? NoitemScreen(
                    title: t.oops,
                    message: t.dataloaderror,
                    onClick: _onRefresh)
                : (items!.length == 0)
                    ? EmptyListScreen(
                        message: t.noitemstodisplay,
                      )
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

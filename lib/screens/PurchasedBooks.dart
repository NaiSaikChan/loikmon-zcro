import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/providers/PurchasesMediaScreensModel.dart';
import 'package:loikmon/screens/EmptyListScreen.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/widgets/BooksTile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screens/NoitemScreen.dart';

class PurchasedBooks extends StatelessWidget {
  PurchasedBooks();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PurchasesMediaScreensModel(),
      child: Scaffold(
        //backgroundColor: Colors.white,

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
  PurchasesMediaScreensModel? _bookScreensModel;
  List<Books?>? items;

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
      Provider.of<PurchasesMediaScreensModel>(context, listen: false)
          .loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    _bookScreensModel = Provider.of<PurchasesMediaScreensModel>(context);
    items = _bookScreensModel!.mediaList;

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
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _bookScreensModel!.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (_bookScreensModel!.isError == true)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : (_bookScreensModel!.mediaList.length == 0)
              ? EmptyListScreen(message: t.noitemstodisplay)
              : Container(
                  margin: MediaQuery.of(context).size.width > 1200
                      ? EdgeInsets.only(left: 120, right: 120)
                      : EdgeInsets.only(left: 20, right: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return AutoHeightGridView(
                        itemCount: items!.length,
                        crossAxisCount: Utility.getBookItemCount(context),
                        crossAxisSpacing: 8.0,
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
                      );
                    },
                  ),
                ),
    );
  }
}

import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/providers/OtherbooksModel.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/widgets/BooksTile.dart';
import 'package:loikmon/widgets/categoriesBooksHeader.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screens/NoitemScreen.dart';

class OthersBooksScreen extends StatelessWidget {
  static const routeName = "/OthersBooksScreen";
  OthersBooksScreen(this.type);
  final int? type;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OtherbooksModel(type!),
      child: _BooksScreen(type!),
    );
  }
}

class _BooksScreen extends StatefulWidget {
  final int type;
  _BooksScreen(this.type);
  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<_BooksScreen> {
  OtherbooksModel? _bookScreensModel;
  bool issearchmode = false;
  List<Books?>? items;
  bool showClear = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();

  String getType(int type) {
    if (type == 0) {
      return t.allbooks;
    }
    if (type == 1) {
      return t.recommended;
    }
    if (type == 2) {
      return t.popularbooks;
    }
    return t.allbooks;
  }

  void _onRefresh() async {
    _bookScreensModel!.loadItems(query);
  }

  void _onLoading() async {
    _bookScreensModel!.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<OtherbooksModel>(context, listen: false).loadItems(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    _bookScreensModel = Provider.of<OtherbooksModel>(context);
    items = _bookScreensModel!.booksList;
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          //backgroundColor: Colors.white,
          appBar: AppBar(
            leadingWidth: issearchmode ? 20 : 40,
            title: !issearchmode
                ? Text(
                    getType(
                      widget.type,
                    ),
                    style: TextStyles.display1(context).copyWith(
                        //fontFamily: 'style2',
                        //fontWeight: FontWeight.w700,
                        fontSize: 24),
                    maxLines: 1,
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
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
                              icon: const Icon(
                                Icons.close,
                                size: 30,
                              ),
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
                            contentPadding:
                                EdgeInsets.only(left: 15, right: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: "Search Books",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(12),
                              //gapPadding: 0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(12),
                              gapPadding: 0,
                            ),
                          )),
                    ),
                  ),
            actions: [
              Visibility(
                visible: !issearchmode,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        issearchmode = true;
                      });
                    },
                    icon: Icon(Icons.search)),
              )
            ],
          ),
          body: Column(
            children: [
              categoriesBooksHeader(_bookScreensModel!),
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
                        height: 35.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _bookScreensModel!.refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: (_bookScreensModel!.isError == true &&
                          items!.length == 0)
                      ? NoitemScreen(
                          title: t.oops,
                          message: t.dataloaderror,
                          onClick: _onRefresh)
                      : Container(
                          margin: MediaQuery.of(context).size.width > 1200
                              ? EdgeInsets.only(left: 100, right: 100)
                              : EdgeInsets.only(left: 20, right: 20),
                          child: AutoHeightGridView(
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

                          /*GridView.builder(
                            itemCount: items!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        Utility.getBookItemCount(context),
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio:
                                        Utility.getBookAspectRatio(context)),
                            itemBuilder: (BuildContext context, int index) {
                              return BooksTile(
                                false,
                                index: (items!.length - index),
                                books: items![index],
                              );
                            },
                          ),*/
                        ),
                ),
              ),
            ],
          ));
    });
  }
}

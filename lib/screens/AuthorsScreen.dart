import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/AuthorsModel.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/widgets/AuthorsTile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screens/NoitemScreen.dart';

class AuthorsScreen extends StatelessWidget {
  static const routeName = "/AuthorsScreen";
  AuthorsScreen();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthorsModel(0),
      child: Container(
        // padding: EdgeInsets.all(12),
        child: CategoryScreen(),
      ),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<CategoryScreen> {
  AuthorsModel? authorsModel;
  List<Authors?>? items;
  bool showClear = false;
  bool issearchmode = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();

  void _onRefresh() async {
    authorsModel!.loadItems(query);
  }

  void _onLoading() async {
    authorsModel!.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<AuthorsModel>(context, listen: false).loadItems(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isdarkmode =
        Provider.of<AppStateManager>(context, listen: false).isDarkModeOn;
    authorsModel = Provider.of<AuthorsModel>(context);
    items = authorsModel!.items;

    return Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.only(right: 30),
          leadingWidth: issearchmode ? 20 : 30,
          title: !issearchmode
              ? Text(
                  t.authors,
                  style: TextStyles.display5(context).copyWith(
                      // fontFamily: 'Times New Roman',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                )
              : Align(
                  alignment: Alignment.centerRight,
                  child: Container(
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
                                    ? const Color.fromARGB(255, 244, 243, 243)
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
                          contentPadding: EdgeInsets.only(left: 15, right: 12),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: t.searchauthors,
                          labelStyle: TextStyles.display1(context).copyWith(
                              color: isdarkmode
                                  ? const Color.fromARGB(255, 239, 238, 238)
                                  : Colors.black,
                              fontSize: 18),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                        height: 45.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: authorsModel!.refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: (authorsModel!.isError == true && items!.length == 0)
                      ? NoitemScreen(
                          title: t.oops,
                          message: t.dataloaderror,
                          onClick: _onRefresh)
                      : GridView.builder(
                          itemCount: authorsModel!.items.length,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.all(3),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: Utility.getItemCount(context),
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio:
                                      Utility.getItemchildAspectRatio(context)),
                          itemBuilder: (BuildContext context, int index) {
                            return AuthorsTile(
                              index: index,
                              categories: items![index]!,
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ));
  }
}

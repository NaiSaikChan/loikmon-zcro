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

class AuthorsDashboard extends StatelessWidget {
  AuthorsDashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AuthorsModel(0),
        child: Container(
          padding: EdgeInsets.all(12),
          child: CategoryScreen(),
        ),
      ),
      /*DefaultTabController(
        length: 2,
        child: Container(
          child: Column(
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: TabBar(
                  isScrollable: false,
                  indicatorColor: MyColors.mainC0lor,
                  //labelColor: MyColors.mainC0lor,
                  labelStyle: TextStyle(fontSize: 15),
                  tabs: [
                    Tab(text: t.books),
                    Tab(text: t.articles),
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
                      ChangeNotifierProvider(
                        create: (context) => AuthorsModel(0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: CategoryScreen(),
                        ),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => AuthorsModel(1),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: CategoryScreen(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),*/
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
      Provider.of<AuthorsModel>(context, listen: false).loadItems("");
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isdarkmode =
        Provider.of<AppStateManager>(context, listen: false).isDarkModeOn;
    authorsModel = Provider.of<AuthorsModel>(context);
    items = authorsModel!.items;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38.0),
                  topRight: Radius.circular(8.0)),
            ),
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
                  suffixIcon: showClear
                      ? IconButton(
                          icon: Icon(Icons.close,
                              color: isdarkmode
                                  ? const Color.fromARGB(255, 222, 220, 220)
                                  : const Color.fromARGB(255, 41, 41, 41)),
                          onPressed: () {
                            inputController.clear();
                            showClear = false;
                            setState(() {
                              query = "";
                            });
                            _onRefresh();
                          },
                        )
                      : Icon(Icons.search,
                          color: isdarkmode
                              ? const Color.fromARGB(255, 229, 228, 228)
                              : const Color.fromARGB(255, 37, 36, 36)),
                  contentPadding: EdgeInsets.only(left: 15, right: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: t.searchauthors,
                  labelStyle: TextStyles.display1(context).copyWith(
                      fontSize: 18,
                      color: isdarkmode
                          ? const Color.fromARGB(255, 242, 240, 240)
                          : const Color.fromARGB(255, 12, 18, 25)),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      ],
    );
  }
}

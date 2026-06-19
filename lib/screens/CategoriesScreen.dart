import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/providers/CategoriesModel.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/widgets/CategoriesTile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screens/NoitemScreen.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = "/CategoriesScreen";
  CategoriesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            t.categories,
            style: TextStyles.display1(context).copyWith(
              //fontFamily: 'style1',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) => CategoriesModel(0),
          child: Container(
            padding: EdgeInsets.all(12),
            child: CategoryScreen(),
          ),
        )

        /* DefaultTabController(
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
                        create: (context) => CategoriesModel(0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: CategoryScreen(),
                        ),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => CategoriesModel(1),
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
  CategoriesModel? authorsModel;
  List<Categories?>? items;

  void _onRefresh() async {
    authorsModel!.loadItems();
  }

  void _onLoading() async {
    authorsModel!.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<CategoriesModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    authorsModel = Provider.of<CategoriesModel>(context);
    items = authorsModel!.items;

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
      controller: authorsModel!.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (authorsModel!.isError == true && items!.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : GridView.builder(
              itemCount: authorsModel!.items.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Utility.getItemCount(context),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: Utility.getItemchildAspectRatio(context)),
              itemBuilder: (BuildContext context, int index) {
                return CategoriesTile(
                  index: index,
                  categories: items![index]!,
                );
              },
            ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/DashboardModel.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/screens/ArticlesListView.dart';
import 'package:loikmon/screens/ArticlesScreen.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/screens/AuthorsListView.dart';
import 'package:loikmon/screens/AuthorsScreen.dart';
import 'package:loikmon/screens/BooksListView.dart';
import 'package:loikmon/screens/CategoriesListView.dart';
import 'package:loikmon/screens/CategoriesScreen.dart';
import 'package:loikmon/screens/CollectionDetailsScreen.dart';
import 'package:loikmon/screens/CollectionsScreen.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/screens/LeagueListView.dart';
import 'package:loikmon/screens/LeaguesScreen.dart';
import 'package:loikmon/screens/OthersBooksScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Toasts.dart';
import 'package:loikmon/utils/network_image.dart';
import 'package:loikmon/utils/rounded_bordered_container.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/NoitemScreen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen();

  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<DashboardScreen> {
  late DashboardModel dashboardModel;
  bool isSubscribed = false;

  onRetryClick() {
    dashboardModel.loadItems();
  }

  @override
  void initState() {
    Provider.of<DashboardModel>(context, listen: false).fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dashboardModel = Provider.of<DashboardModel>(context);
    double width = MediaQuery.of(context).size.width;
    if (dashboardModel.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 500,
                  height: 500,
                  child: Lottie.asset('assets/lottie/animation7.json'),
                ),
                // Container(
                //   width: 380,
                //   height: 200,
                //   child: Lottie.asset('assets/lottie/Animation7.json'),
                // ),
              ],
            ),
          ],
        ),
      );
      // return Container(
      //   width: double.infinity,
      //   // color: Colors.white,
      //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.max,
      //     children: <Widget>[
      //       Expanded(
      //         child: Shimmer.fromColors(
      //           baseColor: Colors.grey[300]!,
      //           highlightColor: Colors.grey[600]!,
      //           enabled: true,
      //           child: ListView.builder(
      //             itemBuilder: (_, __) => Padding(
      //               padding: const EdgeInsets.only(bottom: 8.0),
      //               child: Row(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Container(
      //                     width: 48.0,
      //                     height: 48.0,
      //                     color: Colors.grey[600],
      //                   ),
      //                   const Padding(
      //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
      //                   ),
      //                   Expanded(
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: <Widget>[
      //                         Container(
      //                           width: double.infinity,
      //                           height: 8.0,
      //                           color: Colors.grey[600],
      //                         ),
      //                         const Padding(
      //                           padding: EdgeInsets.symmetric(vertical: 2.0),
      //                         ),
      //                         Container(
      //                           width: double.infinity,
      //                           height: 8.0,
      //                           color: Colors.grey[600],
      //                         ),
      //                         const Padding(
      //                           padding: EdgeInsets.symmetric(vertical: 2.0),
      //                         ),
      //                         Container(
      //                           width: 40.0,
      //                           height: 8.0,
      //                           color: Colors.grey[600],
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ),
      //             itemCount: 12,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    } else if (dashboardModel.isError) {
      return NoitemScreen(
          title: t.oops, message: t.dataloaderror, onClick: onRetryClick);
    } else
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
        controller: dashboardModel.refreshController,
        onRefresh: () {
          dashboardModel.fetchItems();
        },
        onLoading: null,
        child: Container(
          //color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 450.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        //color: Colors.transparent,
                        margin: EdgeInsets.only(top: 5),
                        child: FlutterCarousel(
                          options: CarouselOptions(
                            height: 450.0,
                            showIndicator: true,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            autoPlay: true,
                            slideIndicator: CircularSlideIndicator(),
                          ),
                          items: dashboardModel.sliders!.map((slider) {
                            return Builder(
                              builder: (BuildContext context) {
                                return InkWell(
                                  onTap: () async {
                                    if (slider.type == "link") {
                                      print(
                                        "sliderlink is ==== " + slider.link!,
                                      );
                                      if (await canLaunchUrl(
                                        Uri.parse(slider.link!),
                                      )) {
                                        await launchUrl(
                                          Uri.parse(slider.link!),
                                        );
                                      } else {
                                        print('Unable to open URL link');
                                      }
                                    } else if (slider.type == "messenger") {
                                      if (await canLaunchUrl(
                                        Uri.parse(slider.link!),
                                      )) {
                                        await launchUrl(
                                          Uri.parse(slider.link!),
                                        );
                                      } else {
                                        print('Unable to open URL link');
                                      }
                                    } else {
                                      if (slider.item == null) {
                                        Toasts.info(
                                          context,
                                          "",
                                          "Cannot open this at the moment",
                                        );
                                        return;
                                      } else if (slider.type == "article") {
                                        List<Articles>? articles = [];
                                        articles.add(slider.item as Articles);
                                        Navigator.pushNamed(
                                          context,
                                          ArticleViewerScreen.routeName,
                                          arguments: ScreenArguements(
                                            position: 0,
                                            items: slider.item,
                                            check: false,
                                            itemsList: articles,
                                          ),
                                        );
                                        return;
                                      } else if (slider.type == "author") {
                                        Navigator.pushNamed(
                                          context,
                                          AuthorsListScreen.routeName,
                                          arguments: ScreenArguements(
                                            position: 0,
                                            items: slider.item,
                                            check: false,
                                          ),
                                        );
                                        return;
                                      }
                                      Navigator.pushNamed(
                                        context,
                                        EbooksViewerScreen.routeName,
                                        arguments: ScreenArguements(
                                          position: 0,
                                          items: slider.item,
                                          check: false,
                                        ),
                                      );
                                    }
                                  },
                                  child: Card(
                                    elevation: 0,
                                    child: Container(
                                      //color: colors[index],
                                      padding: const EdgeInsets.all(0.0),
                                      child: Stack(
                                        children: [
                                          RoundedContainer(
                                            //color: colors[index],
                                            borderRadius: BorderRadius.circular(
                                              5.0,
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 0,
                                            ),
                                            padding: EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  //flex: 3,
                                                  child: Container(
                                                    //color: MyColors.backgroundColor,
                                                    child: PNetworkImage(
                                                      slider.thumbnail,
                                                      fit: BoxFit.fill,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(height: 10),
                header(t.authors, () {
                  Navigator.of(context).pushNamed(AuthorsScreen.routeName);
                }),
                AuthorsListView(dashboardModel.bookAuthors!),
                Container(height: 15),
                header(t.categories, () {
                  Navigator.of(context).pushNamed(CategoriesScreen.routeName);
                }),
                Container(height: 0),
                CategoriesListView(dashboardModel.categories!),
                Container(height: 15),
                header(t.leagues, () {
                  Navigator.of(context).pushNamed(LeaguesScreen.routeName);
                }),
                LeagueListView(dashboardModel.leagues!),
                Container(height: 15),
                header(t.newarticles, () {
                  Navigator.of(context).pushNamed(ArticlesScreen.routeName,
                      arguments: new ScreenArguements(position: 0));
                }),
                ArticlesListView(dashboardModel.newarticles!),
                Container(height: 15),
                header(t.newbooks, () {
                  Navigator.of(context).pushNamed(OthersBooksScreen.routeName,
                      arguments: new ScreenArguements(position: 0));
                }),
                BooksListView(dashboardModel.newbooks!),

                // Container(height: 15),
                // header(t.freearticle, () {
                //   Navigator.of(context).pushNamed(ArticlesScreen.routeName,
                //       arguments: new ScreenArguements(position: 4));
                // }),
                // ArticlesListView(dashboardModel.freearticles!),
                Container(height: 20),
                header(t.populararticles, () {
                  Navigator.of(context).pushNamed(ArticlesScreen.routeName,
                      arguments: new ScreenArguements(position: 1));
                }),
                ArticlesListView(dashboardModel.populararticles!),
                ///////////
                Container(height: 20),
                header(t.popularbooks, () {
                  Navigator.of(context).pushNamed(OthersBooksScreen.routeName,
                      arguments: new ScreenArguements(position: 2));
                }),
                BooksListView(dashboardModel.popularbooks!),

                Container(height: 10),
                // header(t.audio, () {
                //   Navigator.of(context).pushNamed(ArticlesScreen.routeName,
                //       arguments: new ScreenArguements(position: 5));
                // }),
                // ArticlesListView(dashboardModel.audioarticles!),
                // =======================
// COLLECTIONS
// =======================
                if (dashboardModel.collections != null &&
                    dashboardModel.collections!.isNotEmpty) ...[
                  Container(height: 15),
                  header(t.collection, () {
                    // TODO: navigate to collections screen
                    Navigator.of(context).pushNamed(
                      CollectionsScreen.routeName,
                    );
                  }),
                  Container(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dashboardModel.collections!.length,
                      itemBuilder: (context, index) {
                        var item = dashboardModel.collections![index];

                        return InkWell(
                          onTap: () {
                            // TODO: open collection details
                            Navigator.of(context)
                                .pushNamed(CollectionDetailsScreen.routeName,
                                    arguments: ScreenArguements(
                                      position: item.id,
                                    ));
                          },
                          child: Container(
                            width: 250,
                            margin: EdgeInsets.only(left: 15),
                            child: Stack(
                              children: [
                                // IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: PNetworkImage(
                                    item.coverImage,
                                    fit: BoxFit.cover,
                                    height: 160,
                                    width: double.infinity,
                                  ),
                                ),

                                // DARK OVERLAY
                                Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                // TEXT
                                Positioned(
                                  bottom: 0,
                                  left: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.display1(context)
                                            .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "${item.bookCount ?? 0} books",
                                        style: TextStyles.display1(context)
                                            .copyWith(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                // Container(height: 15),
                // header(t.popularbooks, () {
                //   Navigator.of(context).pushNamed(OthersBooksScreen.routeName,
                //       arguments: new ScreenArguements(position: 2));
                // }),
                // BooksListView(dashboardModel.popularbooks!),
                // Container(height: 15),
                // header(t.recommended, () {
                //   Navigator.of(context).pushNamed(OthersBooksScreen.routeName,
                //       arguments: new ScreenArguements(position: 1));
                // }),
                // BooksListView(dashboardModel.recommended!),
                Container(height: 20),
              ],
            ),
          ),
        ),
      );
  }

  Widget header(String title, Function onclick) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 20, right: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyles.display5(context).copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MaterialButton(
            elevation: 0,
            textColor: Colors.grey[200],
            color: const Color.fromARGB(255, 95, 95, 95),
            height: 0,
            child: Icon(Icons.arrow_right_alt),
            minWidth: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20),
            onPressed: () {
              //Navigator.of(context)
              //   .pushNamed(Authos.routeName);
              onclick();
            },
          ),
          Container(
            width: 5,
          )
        ],
      ),
    );
  }

  List<Color?> colors = [
    Colors.purple,
    Colors.teal,
    Colors.deepOrange,
    Colors.purple,
    Colors.lime[700],
    Colors.blueGrey[700]
  ];
}

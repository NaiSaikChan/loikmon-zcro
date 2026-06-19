import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loikmon/audio_player/ArticleMiniPlayer.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/models/UserEvents.dart';
import 'package:loikmon/pages/ArticlesReviews.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/ArticleBookmarksModel.dart';
import 'package:loikmon/providers/AudioPlayerModel.dart';
import 'package:loikmon/providers/events.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/screens/HomePage.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/rounded_bordered_container%20copy.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../i18n/strings.g.dart';
import '../models/Articles.dart';
import '../models/Userdata.dart';
import '../utils/ApiUrl.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';

class ArticleViewerScreen extends StatefulWidget {
  static String routeName = "/articleviewer";
  final Articles? article;
  final int? position;
  final List<Articles>? items;
  final bool? isMiniBar;
  final bool? check;

  ArticleViewerScreen({
    Key? key,
    this.article,
    this.position,
    this.items,
    this.isMiniBar,
    this.check,
  }) : super(key: key);

  @override
  _ArticleViewerScreenState createState() => _ArticleViewerScreenState();
}

class _ArticleViewerScreenState extends State<ArticleViewerScreen> {
  late AppStateManager appStateManager;
  bool isPurchased = false;
  Userdata? _userdata;
  int? currentPage = 0;
  int? commentsCount = 0;
  int likesCount = 0;
  bool? isLiked = false;
  Articles? article;

  Future<void> updateViewsCount() async {
    var data = {
      "articleid": article!.id,
    };
    print(data.toString());
    try {
      final response = await http.post(
          Uri.parse(ApiUrl.update_article_total_views),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  openBrowserTab() async {
    if (await canLaunchUrl(Uri.parse(article!.link!))) {
      await launchUrl(Uri.parse(article!.link!));
    } else {
      print('Unable to open URL link');
    }
  }

  registerEvents() {
    //logged in event
    eventBus.on<OnNavigateArticle>().listen((event) async {
      setState(() {
        currentPage = event.pos;
        article = widget.items![currentPage!];
        updateViewsCount();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    registerEvents();
    currentPage = widget.position;

    Future.delayed(Duration(seconds: 0), () {
      Provider.of<AudioPlayerModel>(context, listen: false).setContext(context);
      article = widget.article;
      setState(() {});
      updateViewsCount();
      //Provider.of<AudioPlayerModel>(context, listen: false)
      //    .preparePlaylist(widget.items!, article!);
    });
  }

  @override
  Widget build(BuildContext context) {
    appStateManager = Provider.of<AppStateManager>(context);
    if (article != null) {
      isPurchased = appStateManager.isArticlePurchased(article!);
    }

    return WillPopScope(
      onWillPop: () async {
        if (widget.check == true) {
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          return false;
        } else {
          Navigator.pop(context, 0);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (widget.check == true) {
                    Navigator.of(context)
                        .pushReplacementNamed(HomePage.routeName);
                  } else {
                    Navigator.pop(context, 0);
                  }
                },
                //padding: EdgeInsets.only(left: 30),

                icon: Icon(
                  Icons.keyboard_backspace_rounded,
                  size: 30,
                )),
            title: Text(article == null ? "" : article!.category!,
                style: TextStyles.display1(context).copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,

                  //fontFamily: 'style2'
                )),
            actions: <Widget>[
              /*Row(
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.solidEye,
                size: 22,
              ),
              widget.article!.views == 0
                  ? Container()
                  : Text(widget.article!.views.toString(),
                      style: TextStyle(
                        fontSize: 15,
                      )),
            ],
          ),*/
              article == null
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : Visibility(
                      visible: article != null && article!.streamUrl != "",
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Icon(
                          LineAwesomeIcons.volume_up_solid,
                          size: 28,
                        ),
                      ),
                    ),
              article == null
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : Visibility(
                      visible: isPurchased,
                      child: InkWell(
                        onTap: () {
                          openBrowserTab();
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 16,
                            right: 10,
                          ),
                          /* child: FaIcon(
                      FontAwesomeIcons.chrome,
                      size: 22,
                    ),*/
                        ),
                      ),
                    ),
              Container(
                width: 15,
              ),
              IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () async {
                    Utility.sharearticle(context, article);
                  }),
              Container(
                width: 20,
              ),
              article == null
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : Consumer<ArticleBookmarksModel>(
                      builder: (context, bookmarksModel, child) {
                        bool isBookmarked =
                            bookmarksModel.isArticleBookMarked(article!.id);
                        return InkWell(
                          child: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked
                                  ? Colors.red
                                  : appStateManager.isDarkModeOn
                                      ? const Color.fromARGB(255, 243, 242, 242)
                                      : const Color.fromARGB(255, 5, 4, 9),
                              size: 25.0),
                          onTap: () {
                            if (isBookmarked)
                              bookmarksModel.unBookmarkArticle(article!.id);
                            else
                              bookmarksModel.bookmarkArticle(article!);
                          },
                        );
                      },
                    ),
              Container(
                width: 30,
              ),
            ]),
        /*floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: (article == null || article!.streamUrl == "")
            ? null
            : Container(
                margin: EdgeInsets.only(top: 550),
                child: FloatingActionButton(
                  backgroundColor: MyColors.mainC0lor,
                  onPressed: () {
                    Provider.of<AudioPlayerModel>(context, listen: false)
                        .preparePlaylist(widget.items!, article!);
                  },
                  mini: false,
                  child: const Icon(Icons.play_arrow_outlined,
                      color: Colors.white, size: 45),
                ),
              ),*/
        body: Column(
          children: [
            Expanded(
                child: article == null
                    ? Container()
                    : ArticleItem(
                        article: article!,
                        key: UniqueKey(),
                      )),
            article == null
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : Container(
                    margin: MediaQuery.of(context).size.width > 1200
                        ? EdgeInsets.only(left: 250, right: 250)
                        : EdgeInsets.only(left: 50, right: 50),
                    child: ArticleMiniPlayer(
                      widget.items,
                      article,
                      (widget.items!.length > 1 && currentPage != 0),
                      (widget.items!.length > 1 &&
                          widget.items!.length != (currentPage! + 1)),
                      () {
                        if (currentPage! > 0) {
                          currentPage = currentPage! - 1;
                          setState(() {
                            article = widget.items![currentPage!];

                            //Provider.of<AudioPlayerModel>(context,
                            //        listen: false)
                            //    .preparePlaylist(widget.items!, article!);
                          });
                          updateViewsCount();
                        }
                      },
                      () {
                        if ((currentPage! + 1) < widget.items!.length) {
                          currentPage = currentPage! + 1;
                          setState(() {
                            article = widget.items![currentPage!];
                            //Provider.of<AudioPlayerModel>(context,
                            //       listen: false)
                            //   .preparePlaylist(widget.items!, article!);
                          });
                          updateViewsCount();
                        }
                      },
                      isMiniBar: widget.isMiniBar,
                    ),
                  ),
            /* article == null
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : Visibility(
                    visible: widget.items!.length > 1,
                    child: Container(
                      height: 60,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible: currentPage != 0,
                              child: IconButton(
                                  onPressed: () {
                                    if (currentPage! > 0) {
                                      currentPage = currentPage! - 1;
                                      setState(() {
                                        article = widget.items![currentPage!];
                                        getDownloadedArticle(article!);
                                        //Provider.of<AudioPlayerModel>(context,
                                        //        listen: false)
                                        //    .preparePlaylist(widget.items!, article!);
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                            ),
                            Visibility(
                              visible:
                                  widget.items!.length != (currentPage! + 1),
                              child: IconButton(
                                  onPressed: () {
                                    if ((currentPage! + 1) <
                                        widget.items!.length) {
                                      currentPage = currentPage! + 1;
                                      setState(() {
                                        article = widget.items![currentPage!];
                                        getDownloadedArticle(article!);
                                        //Provider.of<AudioPlayerModel>(context,
                                        //       listen: false)
                                        //   .preparePlaylist(widget.items!, article!);
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_sharp)),
                            )
                          ],
                        ),
                      ),
                    ),
                  )*/
          ],
        ),
      ),
    );
  }
}

class ArticleItem extends StatefulWidget {
  const ArticleItem({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Articles article;

  @override
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  bool isLoadingContent = false;
  bool isFailedToLoadContent = false;
  String? content = "";
  bool isPurchased = false;
  List<String> sliders = [];

  @override
  void initState() {
    content = widget.article.content;
    Future.delayed(Duration(seconds: 0), () {
      if (widget.article.thumbnail != "") {
        sliders.add(widget.article!.thumbnail!);
      }
      if (widget.article.thumbnail2 != "") {
        sliders.add(widget.article!.thumbnail2!);
      }
      if (widget.article.thumbnail3 != "") {
        sliders.add(widget.article!.thumbnail3!);
      }
      if (widget.article.thumbnail4 != "") {
        sliders.add(widget.article!.thumbnail4!);
      }
      if (widget.article.thumbnail5 != "") {
        sliders.add(widget.article!.thumbnail5!);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPurchased = Provider.of<AppStateManager>(context)
        .isArticlePurchased(widget.article);
    bool isdarkmode = Provider.of<AppStateManager>(context).isDarkModeOn;
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
              margin: MediaQuery.of(context).size.width > 1200
                  ? EdgeInsets.only(left: 250, right: 250)
                  : EdgeInsets.only(left: 50, right: 50),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(widget.article.title!,
                        style: TextStyles.display1(context).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          //fontFamily: 'style3'
                        )),
                  ),
                  Container(height: 5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(widget.article.date!,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 13,
                              //fontFamily: 'style1',
                              color: isdarkmode
                                  ? const Color.fromARGB(255, 245, 244, 244)
                                  : const Color.fromARGB(255, 0, 0, 0),
                            )),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          height: 10,
                          width: 2,
                          color: MyColors.mainC0lor,
                        ),
                        Text(widget.article.views.toString() + " " + t.views,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 13,
                              //fontFamily: 'style1',
                              color: isdarkmode
                                  ? const Color.fromARGB(255, 246, 244, 244)
                                  : const Color.fromARGB(255, 0, 0, 0),
                            )),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          height: 10,
                          width: 2,
                          color: MyColors.mainC0lor,
                        ),
                        Text(widget.article.rating.toString() + " " + t.reviews,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 13,
                              //fontFamily: 'style1',
                              color: isdarkmode
                                  ? const Color.fromARGB(255, 242, 241, 241)
                                  : const Color.fromARGB(255, 0, 0, 0),
                            )),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            Alerts.showProgressDialog(
                              context,
                              t.processingpleasewait,
                            );
                            try {
                              var data = {
                                "id": widget.article.id,
                              };
                              print(data);
                              final dio = Dio();
                              final response = await dio.post(
                                ApiUrl.getauthor,
                                data: jsonEncode({"data": data}),
                              );
                              print("response for deeplink");
                              print(response.data);
                              print("...response for deeplink");
                              Navigator.of(context).pop();
                              final res = jsonDecode(response.data);
                              if (res['status'] == "ok") {
                                Authors author =
                                    Authors.fromJson(res["author"]);
                                Navigator.pushNamed(
                                    context, AuthorsListScreen.routeName,
                                    arguments: ScreenArguements(
                                      position: 0,
                                      items: author,
                                      check: author.isfollowing,
                                    ));
                              } else {
                                Alerts.show(context, "", t.dataloaderror);
                              }
                            } catch (exception) {
                              // I get no exception here
                              print("...response for deeplink");
                              print(exception.toString());
                              print("...response for deeplink");
                              Navigator.of(context).pop();
                              Alerts.show(context, "", t.data_load_error);
                              if (exception is DioError) {
                                print(exception.message);
                                print(exception.error);
                              }
                            }
                          },
                          child: Text(widget.article.author!,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                                //fontFamily: 'style3',
                                color: isdarkmode
                                    ? const Color.fromARGB(255, 249, 247, 247)
                                    : Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 5),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 500,
                        //padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: FlutterCarousel(
                          options: CarouselOptions(
                            height: 500.0,
                            showIndicator: true,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            autoPlay: false,
                            slideIndicator: CircularSlideIndicator(
                                slideIndicatorOptions: SlideIndicatorOptions(
                                    currentIndicatorColor: MyColors.mainC0lor,
                                    alignment: Alignment.bottomRight,
                                    padding: EdgeInsets.only(
                                      right: 12,
                                      bottom: 10,
                                    ))),
                          ),
                          items: sliders!.map((_slider) {
                            return Builder(
                              builder: (BuildContext context) {
                                return InkWell(
                                  child: Card(
                                    elevation: 0,
                                    child: Container(
                                      //color: colors[index],
                                      padding: const EdgeInsets.all(0.0),
                                      child: Stack(children: [
                                        RoundedContainer(
                                          //color: colors[index],
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          margin:
                                              const EdgeInsets.only(bottom: 0),
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

                                                  child: CachedNetworkImage(
                                                    cacheKey: _slider,
                                                    imageUrl: _slider,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    Colors
                                                                        .black12,
                                                                    BlendMode
                                                                        .darken)),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CupertinoActivityIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Center(
                                                                child: Icon(
                                                      Icons.error,
                                                      color: Colors.grey,
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Visibility(
                        visible: !isPurchased,
                        child: Positioned(
                          //bottom: 3,
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            //width: 60,
                            decoration: BoxDecoration(
                                color: MyColors.mainC0lor,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  LineAwesomeIcons.coins_solid,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                Text(
                                  widget.article.amount.toString(),
                                  style: TextStyles.display1(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    fontFamily: "",
                                    color: MyColors.white,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          color: Colors.black12,
                          width: double.infinity,
                          height: 50,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RatingStars(
                              value: double.parse(widget.article.rating!),
                              onValueChanged: (v) {},
                              starBuilder: (index, color) => Icon(
                                Icons.star_rate,
                                color: color,
                                size: 20,
                              ),
                              starCount: 5,
                              starSize: 20,
                              valueLabelColor: const Color(0xff9b9b9b),
                              valueLabelTextStyle: TextStyles.display1(context)
                                  .copyWith(
                                      color: const Color.fromARGB(
                                          255, 243, 241, 241),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 0.0),
                              valueLabelRadius: 0,
                              maxValue: 5,
                              starSpacing: 2,
                              //maxValueVisibility: true,
                              valueLabelVisibility: true,
                              animationDuration: Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              valueLabelMargin: const EdgeInsets.only(right: 0),
                              starOffColor: Colors.grey,
                              starColor: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      children: [],
                    ),
                  ),
                  Container(height: 1),
                  isPurchased
                      ? Container(
                          padding: EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Column(
                            children: [
                              HtmlWidget(
                                content!,
                                textStyle: TextStyles.medium(context).copyWith(
                                  fontSize: 18,
                                  //fontFamily: 'style1',
                                  height: 2,
                                  color: isdarkmode
                                      ? const Color.fromARGB(255, 217, 218, 219)
                                      : const Color.fromARGB(255, 10, 5, 21),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              ArticlesReviews(widget.article),
                            ],
                          ))
                      : Container(
                          margin: EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 12,
                          ),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 0,
                                  right: 0,
                                ),
                                //height: 250,
                                child: Text(
                                  Bidi.stripHtmlIfNeeded(
                                      widget.article.description!),
                                  //maxLines: 11,
                                  overflow: TextOverflow.fade,
                                  style: TextStyles.medium(context).copyWith(
                                      fontSize: 18,
                                      height: 2,
                                      //fontFamily: 'style1',
                                      color: isdarkmode
                                          ? Colors.grey[400]
                                          : const Color.fromARGB(
                                              255, 99, 98, 98)),
                                ),
                              ),
                              Container(
                                height: 20,
                              ),
                              Container(
                                  child: Text(
                                t.articlepurchasehint,
                                textAlign: TextAlign.center,
                                style: TextStyles.display1(context).copyWith(
                                  fontSize: 18,
                                  //fontFamily: 'style1',
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  color: MyColors.mainC0lor,
                                ),
                              )),
                              Align(
                                alignment: Alignment.center,
                                child: Visibility(
                                  visible: !isPurchased,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    width: 120,
                                    height: 40,
                                    child: TextButton(
                                      child: Text(t.buy,
                                          style: TextStyles.display1(context)
                                              .copyWith(
                                            color: const Color.fromARGB(
                                                255, 238, 236, 236),
                                            fontSize: 15,
                                          )),
                                      style: TextButton.styleFrom(
                                        backgroundColor: MyColors.mainC0lor,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: MyColors.mainC0lor),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      onPressed: () {
                                        Alerts.showArticlePaymentDialog(
                                            context, widget.article);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Container(height: 10),
                ],
              ),
            );
          }, childCount: 1),
        )
      ],
    );
  }
}

/*import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/pages/ArticlesReviews.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/ArticleBookmarksModel.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/screens/HomePage.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../i18n/strings.g.dart';
import '../models/Articles.dart';
import '../models/Userdata.dart';
import '../utils/ApiUrl.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';

class ArticleViewerScreen extends StatefulWidget {
  static String routeName = "/articleviewer";
  final Articles? article;
  final int? position;
  final List<Articles>? items;
  final bool check;

  ArticleViewerScreen(this.check,
      {Key? key, this.article, this.position, this.items})
      : super(key: key);

  @override
  _ArticleViewerScreenState createState() => _ArticleViewerScreenState();
}

class _ArticleViewerScreenState extends State<ArticleViewerScreen> {
  Userdata? _userdata;
  int? currentPage = 0;
  int? commentsCount = 0;
  int likesCount = 0;
  bool? isLiked = false;
  Articles? article;

  Future<void> updateViewsCount() async {
    var data = {
      "articleid": article!.id,
    };
    print(data.toString());
    try {
      final response = await http.post(
          Uri.parse(ApiUrl.update_article_total_views),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  openBrowserTab() async {
    if (await canLaunchUrl(Uri.parse(article!.link!))) {
      await launchUrl(Uri.parse(article!.link!));
    } else {
      print('Unable to open URL link');
    }
  }

  updateviews() {
    Future.delayed(const Duration(seconds: 30), () {
      if (Provider.of<AppStateManager>(context, listen: false)
          .isArticlePurchased(widget.article!)) {
        updateViewsCount();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentPage = widget.position;
    article = widget.article;
    updateViewsCount();
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    bool isPurchased = appStateManager.isArticlePurchased(article!);
    return WillPopScope(
      onWillPop: () async {
        if (widget.check == true) {
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          return false;
        } else {
          Navigator.pop(context, 0);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (widget.check == true) {
                    Navigator.of(context)
                        .pushReplacementNamed(HomePage.routeName);
                  } else {
                    Navigator.pop(context, 0);
                  }
                },
                icon: Icon(Icons.keyboard_backspace_rounded)),
            title: Text(widget.article!.category!,
                style: TextStyles.display1(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'style2')),
            actions: <Widget>[
              /*Row(
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.solidEye,
                size: 22,
              ),
              widget.article!.views == 0
                  ? Container()
                  : Text(widget.article!.views.toString(),
                      style: TextStyle(
                        fontSize: 15,
                      )),
            ],
          ),*/

              Visibility(
                visible: isPurchased,
                child: InkWell(
                  onTap: () {
                    openBrowserTab();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 16,
                      right: 20,
                    ),
                    /* child: FaIcon(
                      FontAwesomeIcons.chrome,
                      size: 22,
                    ),*/
                  ),
                ),
              ),
              Container(
                width: 15,
              ),
              IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () async {
                    Utility.sharearticle(context, article);
                  }),
              Container(
                width: 10,
              ),
              Consumer<ArticleBookmarksModel>(
                builder: (context, bookmarksModel, child) {
                  bool isBookmarked =
                      bookmarksModel.isArticleBookMarked(article!.id);
                  return InkWell(
                    child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked
                            ? Colors.red
                            : appStateManager.isDarkModeOn
                                ? Colors.white
                                : Colors.black,
                        size: 22.0),
                    onTap: () {
                      if (isBookmarked)
                        bookmarksModel.unBookmarkArticle(article!.id);
                      else
                        bookmarksModel.bookmarkArticle(article!);
                    },
                  );
                },
              ),
              Container(
                width: 10,
              ),
            ]),
        body: Column(
          children: [
            Expanded(
                child: ArticleItem(
              article: article!,
              key: UniqueKey(),
            )),
            Container(
              height: 60,
              margin: MediaQuery.of(context).size.width > 1200
                  ? EdgeInsets.only(left: 250, right: 250)
                  : EdgeInsets.only(left: 50, right: 50),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: currentPage != 0,
                      child: IconButton(
                          onPressed: () {
                            if (currentPage! > 0) {
                              currentPage = currentPage! - 1;
                              setState(() {
                                article = widget.items![currentPage!];
                              });
                              updateViewsCount();
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                    ),
                    Visibility(
                      visible: widget.items!.length != (currentPage! + 1),
                      child: IconButton(
                          onPressed: () {
                            if ((currentPage! + 1) < widget.items!.length) {
                              currentPage = currentPage! + 1;
                              setState(() {
                                article = widget.items![currentPage!];
                              });
                              updateViewsCount();
                            }
                          },
                          icon: Icon(Icons.arrow_forward_ios_sharp)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ArticleItem extends StatefulWidget {
  const ArticleItem({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Articles article;

  @override
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  bool isLoadingContent = false;
  bool isFailedToLoadContent = false;
  String? content = "";
  bool isPurchased = false;

  @override
  void initState() {
    content = widget.article.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPurchased = Provider.of<AppStateManager>(context)
        .isArticlePurchased(widget.article);
    bool isdarkmode = Provider.of<AppStateManager>(context).isDarkModeOn;
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
              margin: MediaQuery.of(context).size.width > 1200
                  ? EdgeInsets.only(left: 250, right: 250)
                  : EdgeInsets.only(left: 50, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(widget.article.title!,
                        style: TextStyles.display1(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontFamily: 'style3')),
                  ),
                  Container(height: 5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(widget.article.date!,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 16,
                              fontFamily: 'style1',
                              color: isdarkmode ? Colors.white : Colors.black,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          height: 10,
                          width: 2,
                          color: MyColors.mainC0lor,
                        ),
                        Text(widget.article.views.toString() + " " + t.views,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 16,
                              fontFamily: 'style1',
                              color: isdarkmode ? Colors.white : Colors.black,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          height: 10,
                          width: 2,
                          color: MyColors.mainC0lor,
                        ),
                        Text(
                            (widget.article.rating! == ""
                                        ? 0
                                        : double.parse(widget.article.rating!)
                                            .toStringAsFixed(0))
                                    .toString() +
                                " " +
                                t.reviews,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 16,
                              fontFamily: 'style1',
                              color: isdarkmode ? Colors.white : Colors.black,
                            )),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            Alerts.showProgressDialog(
                                context, t.processingpleasewait);
                            try {
                              var data = {
                                "id": widget.article.id,
                              };
                              print(data);
                              final response = await http.post(
                                Uri.parse(ApiUrl.getauthor),
                                body: jsonEncode({"data": data}),
                              );
                              print("...response for deeplink");
                              Navigator.of(context).pop();
                              final res = jsonDecode(response.body);
                              if (res['status'] == "ok") {
                                Authors author =
                                    Authors.fromJson(res["author"]);
                                Navigator.pushNamed(
                                    context, AuthorsListScreen.routeName,
                                    arguments: ScreenArguements(
                                      position: 0,
                                      items: author,
                                      check: author.isfollowing,
                                    ));
                              } else {
                                Alerts.show(context, "", t.dataloaderror);
                              }
                            } catch (exception) {
                              // I get no exception here
                              print("...response for deeplink");
                              print(exception.toString());
                              print("...response for deeplink");
                              Navigator.of(context).pop();
                              Alerts.show(context, "", t.data_load_error);
                            }
                          },
                          child: Text(widget.article.author!,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 16,
                                fontFamily: 'style3',
                                color: isdarkmode ? Colors.white : Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 5),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        //margin: EdgeInsets.only(left: 100, right: 100),
                        child: InteractiveViewer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.article.thumbnail!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black12, BlendMode.darken)),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                Icons.error,
                                color: Colors.grey,
                              )),
                            ),
                          ),
                        ),
                        width: double.infinity,
                        height: 500,
                      ),
                      Visibility(
                        visible: !isPurchased,
                        child: Positioned(
                          bottom: 3,
                          right: 3,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            //width: 60,
                            decoration: BoxDecoration(
                                color: MyColors.mainC0lor,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  LineAwesomeIcons.coins_solid,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                Text(
                                  widget.article.amount.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    fontFamily: "",
                                    color: MyColors.white,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.black12,
                          width: double.infinity,
                          height: 50,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RatingStars(
                              value: double.parse(widget.article.rating!),
                              onValueChanged: (v) {},
                              starBuilder: (index, color) => Icon(
                                Icons.ac_unit_outlined,
                                color: color,
                                size: 18,
                              ),
                              starCount: 5,
                              starSize: 20,
                              valueLabelColor: const Color(0xff9b9b9b),
                              valueLabelTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 0.0),
                              valueLabelRadius: 0,
                              maxValue: 5,
                              starSpacing: 2,
                              //maxValueVisibility: true,
                              valueLabelVisibility: true,
                              animationDuration: Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              valueLabelMargin: const EdgeInsets.only(right: 0),
                              starOffColor: Colors.grey,
                              starColor: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      children: [],
                    ),
                  ),
                  Container(height: 1),
                  Container(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      decoration: isPurchased
                          ? null
                          : BoxDecoration(
                              color: !isdarkmode
                                  ? Colors.grey[400]
                                  : const Color.fromARGB(255, 99, 98, 98),
                              border: Border.all(
                                color: Colors.grey[300]!,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !isPurchased
                              ? Text(
                                  Bidi.stripHtmlIfNeeded(
                                      widget.article.description!),
                                  style: TextStyles.medium(context).copyWith(
                                    fontSize: 19,
                                    height: 2,
                                    fontFamily: 'style1',
                                    color: isdarkmode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )
                              : Text(
                                  Bidi.stripHtmlIfNeeded(content!),
                                  style: TextStyles.medium(context).copyWith(
                                    fontSize: 19,
                                    height: 2,
                                    fontFamily: 'style1',
                                    color: isdarkmode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                          /*HtmlWidget(
                            isPurchased ? content! : content!.substring(0, 500),
                            //renderMode: RenderMode.column,
                            textStyle: TextStyles.medium(context).copyWith(
                              fontSize: 19,
                              height: 2,
                              fontFamily: 'style1',
                              color: isdarkmode ? Colors.white : Colors.black,
                            ),
                          ),*/
                          SizedBox(
                            height: 30,
                          ),
                          !isPurchased
                              ? Container()
                              : ArticlesReviews(widget.article),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                    ),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: !isdarkmode
                            ? Colors.grey[400]
                            : const Color.fromARGB(255, 99, 98, 98),
                        border: Border.all(
                          color: Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Column(
                      children: [
                        /*  Container(
                          // height: 250,
                          child: Text(
                            content!,
                            maxLines: 11,
                            overflow: TextOverflow.fade,
                            style: TextStyles.medium(context).copyWith(
                              fontSize: 16,
                              fontFamily: 'style1',
                              color: MyColors.mainC0lor,
                            ),
                          ),
                        ),*/
                        Container(
                          height: 20,
                        ),
                        isPurchased
                            ? Container()
                            : Container(
                                child: Text(
                                t.articlepurchasehint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'style1',
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  color: MyColors.mainC0lor,
                                ),
                              )),
                        Align(
                          alignment: Alignment.center,
                          child: Visibility(
                            visible: !isPurchased,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 12,
                                bottom: 12,
                              ),
                              width: 120,
                              height: 40,
                              child: TextButton(
                                child: Text(t.buy,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    )),
                                style: TextButton.styleFrom(
                                  backgroundColor: MyColors.mainC0lor,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: MyColors.mainC0lor),
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                onPressed: () {
                                  Alerts.showArticlePaymentDialog(
                                      context, widget.article);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 30),
                ],
              ),
            );
          }, childCount: 1),
        )
      ],
    );
  }
}*/

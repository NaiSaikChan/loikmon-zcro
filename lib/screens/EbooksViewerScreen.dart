import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:loikmon/audio_player/BookAudioPlayerPage.dart';
import 'package:loikmon/audio_player/BookMiniPlayer.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/pages/EbookOverView.dart';
import 'package:loikmon/pages/EbookReviews.dart';
import 'package:loikmon/pages/EbooksInfo.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/AudioPlayerModel.dart';
import 'package:loikmon/providers/BookmarksModel.dart';
import 'package:loikmon/screens/AppPdfViewer.dart';
import 'package:loikmon/screens/EpubReader.dart';
import 'package:loikmon/screens/HomePage.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/MarqueeWidget.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EbooksViewerScreen extends StatefulWidget {
  static const routeName = "/EbooksViewerScreen";
  EbooksViewerScreen(this.check, this.books, this.isDownloads);
  final Books books;
  final bool isDownloads;
  final bool check;

  @override
  _EbooksViewerScreenState createState() => _EbooksViewerScreenState();
}

class _EbooksViewerScreenState extends State<EbooksViewerScreen>
    with SingleTickerProviderStateMixin {
  bool isPurchased = false;
  bool isPending = false;
  double? ratevalue = 0.0;
  int selected = 0;
  Userdata? userdata;
  TabController? _tabController;
  List<dynamic> _chapters = [];
  bool _loadingChapters = true;
  bool _hasAudio = false;

  List<String> paymentmodes = [
    "စုတ်သြန် နကဵု GooglePay",
    "ဒၞာဲစုတ်မဂၞန် Coupons"
  ];

  readpdf() {
    print("read pdf book");

    Navigator.pushNamed(context, AppPdfViewer.routeName,
        arguments: ScreenArguements(
          position: 0,
          items: widget.books,
        ));
  }

  readEpub() {
    Navigator.pushNamed(context, EpubReader.routeName,
        arguments: ScreenArguements(
          position: 0,
          items: widget.books,
        ));
  }

  Future<void> _fetchBookChapters() async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.GET_BOOK_CHAPTERS),
        body: jsonEncode({
          "data": {"book_id": widget.books.id}
        }),
      );

      final res = jsonDecode(response.body);

      if (!mounted) return;

      if (res["status"] == "success") {
        setState(() {
          _chapters = res["data"];
          _hasAudio = _chapters.isNotEmpty;
          _loadingChapters = false;
        });
      } else {
        setState(() {
          _hasAudio = false;
          _loadingChapters = false;
        });
      }
    } catch (e) {
      print("Error loading chapters: $e");

      if (!mounted) return;

      setState(() {
        _hasAudio = false;
        _loadingChapters = false;
      });
    }
  }

  Future<void> rateBook() async {
    try {
      Userdata? userdata = await SQLiteDbProvider.db.getUserData();
      var data = {
        "bookid": widget.books.id,
        "rate": ratevalue.toString(),
        "email": userdata == null ? "null" : userdata.email,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.ratebook),
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

  Future<void> updatetotalviews() async {
    try {
      var data = {
        "bookid": widget.books.id,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.update_total_views),
          body: jsonEncode({"data": data}));
      print(response.body);
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    ratevalue = widget.books.hasrate!;
    Future.delayed(const Duration(seconds: 20), () {
      updatetotalviews();
    });
    Future.delayed(const Duration(seconds: 0), () {
      _fetchBookChapters();
    });
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateManager>(context);
    final player = Provider.of<AudioPlayerModel>(context);
    userdata = appState.userdata;
    isPurchased =
        Provider.of<AppStateManager>(context).isBookPurchased(widget.books.id!);
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
        ),
        body: Container(
          margin: MediaQuery.of(context).size.width > 1200
              ? EdgeInsets.only(left: 250, right: 250)
              : EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Expanded(
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverToBoxAdapter(child: header(appState)),
                      SliverToBoxAdapter(
                          child: TabBar(
                        controller: _tabController,
                        /*indicator: ShapeDecoration(
                        shape: StadiumBorder(),
                        color: MyColors.mainC0lor,
                      ),*/
                        //labelColor: Colors.white,
                        labelStyle: TextStyles.display5(context).copyWith(
                            fontSize: 18, //fontFamily: 'Style1'
                            fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(
                            text: t.overview,
                          ),
                          Tab(text: t.information),
                          Tab(text: t.reviews),
                        ],
                      )),
                    ];
                  },
                  body: Container(
                    //height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        EbookOverView(widget.books),
                        EbooksInfo(widget.books),
                        EbookReviews(widget.books),
                      ],
                    ),
                  ),
                ),
              ),
              if (player.isBookAudio &&
                  player.currentBook != null &&
                  player.currentBook!.id == widget.books.id)
                Container(
                    margin: MediaQuery.of(context).size.width > 1200
                        ? EdgeInsets.only(left: 250, right: 250)
                        : EdgeInsets.only(left: 50, right: 50),
                    child: BookMiniPlayer())
            ],
          ),
        ),
      ),
    );
  }

  Widget header(AppStateManager? appstate) {
    return Stack(
      children: <Widget>[
        Container(
          height: 420,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.books.coverphoto!),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          height: 420,
          width: double.infinity,
          color: Colors.black45,
        ),
        Positioned(
          left: 0,
          top: 130,
          child: Container(
            height: 200,
            width: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                image: DecorationImage(
                    image: NetworkImage(widget.books.thumbnail!),
                    fit: BoxFit.cover)),
            margin: EdgeInsets.only(left: 16.0),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(0.0, 340.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: appstate!.isDarkModeOn
                  ? const Color.fromARGB(255, 13, 24, 45)
                  : const Color.fromARGB(255, 241, 240, 241),
              //borderRadius: BorderRadius.circular(30.0)),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0)),
            ),
            child: Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 22,
                bottom: 20,
              ),
              margin: EdgeInsets.only(top: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    //color: Colors.red,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                MarqueeWidget(
                                  child: Text(widget.books.title!,
                                      maxLines: 1,
                                      style: TextStyles.display1(context)
                                          .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  widget.books.author!,
                                  style: TextStyles.display1(context).copyWith(
                                    fontSize: 17,
                                  ),
                                ),
                                Container(
                                  width: 10,
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      //width: 70,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            LineAwesomeIcons.coins_solid,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          Text(
                                            widget.books.amount.toString(),
                                            style: TextStyles.display1(context)
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              fontFamily: "",
                                              color: MyColors.mainC0lor,
                                            ),
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        widget.isDownloads
                            ? Container()
                            : Consumer<BookmarksModel>(
                                builder: (context, bookmarksModel, child) {
                                  bool isBookmarked = bookmarksModel
                                      .isBookBookmarked(widget.books);
                                  return Container(
                                    //color: Colors.yellow,
                                    child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        visualDensity: VisualDensity.compact,
                                        icon: Icon(
                                          isBookmarked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isBookmarked
                                              ? Colors.red
                                              : appstate.isDarkModeOn
                                                  ? Colors.white
                                                  : Colors.black,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          if (isBookmarked)
                                            bookmarksModel
                                                .unBookmarkBook(widget.books);
                                          else
                                            bookmarksModel
                                                .bookmarkBook(widget.books);
                                        }),
                                  );
                                },
                              ),
                        /* Consumer<DownloadedBooksModel>(
                          builder: (context, downloadedAudioBibleModel, child) {
                            bool isDownloaded = downloadedAudioBibleModel
                                .isBookDownloaded(widget.books);
                            return widget.isDownloads
                                ? Container(
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          //size: 22,
                                        ),
                                        onPressed: () async {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible:
                                                false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(t.deletemedia),
                                                content: SingleChildScrollView(
                                                  child:
                                                      Text(t.deletemediahint),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text(
                                                      t.cancel,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(t.ok),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      print(widget.books.book);
                                                      downloadedAudioBibleModel
                                                          .deleteBook(
                                                              widget.books);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                  )
                                : isDownloaded
                                    ? Container()
                                    : Visibility(
                                        visible: !isPending,
                                        child: Container(
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.download,
                                                size: 22,
                                              ),
                                              onPressed: () async {
                                                if (widget.books.amount != 0 &&
                                                    !isPurchased) {
                                                  Alerts.showPaymentDialog(
                                                      context, widget.books);
                                                  return;
                                                }

                                                if (widget.books.epub == "") {
                                                  print("downloadpdf");
                                                  downloadedAudioBibleModel
                                                      .downloadBook(context,
                                                          widget.books, 1);
                                                  return;
                                                }
                                                Books? _books =
                                                    await SQLiteDbProvider.db
                                                        .getDownloadedBook(
                                                            widget.books);
                                                if (_books != null) {
                                                  if (_books.pdfhttp == 0) {
                                                    downloadedAudioBibleModel
                                                        .downloadBook(context,
                                                            widget.books, 1);
                                                    return;
                                                  }
                                                }
                                                await showDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // user must tap button!
                                                    builder: (BuildContext
                                                        _context) {
                                                      return DownloadOptionDialog(
                                                          title:
                                                              t.deleteoptions,
                                                          onclick:
                                                              (_index) async {
                                                            downloadedAudioBibleModel
                                                                .downloadBook(
                                                                    context,
                                                                    widget
                                                                        .books,
                                                                    _index);
                                                          });
                                                    });
                                              }),
                                        ),
                                      );
                          },
                        ),*/
                        IconButton(
                            padding: EdgeInsets.all(0),
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.share,
                              size: 24,
                            ),
                            onPressed: () {
                              //ShareFile.share(widget.books);
                              Utility.sharebook(context, widget.books);
                            }),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: Row(
                      children: [
                        RatingStars(
                          value: double.parse(widget.books.rating!),
                          onValueChanged: (v) {},
                          starBuilder: (index, color) => Icon(
                            Icons.star,
                            color: color,
                            size: 20,
                          ),
                          starCount: 5,
                          starSize: 20,
                          valueLabelColor: const Color(0xff9b9b9b),
                          valueLabelTextStyle: TextStyles.display1(context)
                              .copyWith(
                                  color: Color.fromARGB(255, 241, 240, 240),
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
                        Container(
                          width: 5,
                        ),
                        (widget.books.rating! == "" ||
                                widget.books.rating == null)
                            ? Container()
                            : Text("(" +
                                double.parse(widget.books.rating!)
                                    .toStringAsFixed(1) +
                                ")"),
                        Spacer(),
                        if (widget.books.hasAudio! &&
                            ((widget.books.amount == 0 || isPurchased)))
                          InkWell(
                            onTap: () async {
                              if (isPending) return;

                              if (widget.books.amount != 0 && !isPurchased) {
                                Alerts.showPaymentDialog(context, widget.books);
                                return;
                              }

                              if (_chapters.isEmpty) {
                                Alerts.showToast(
                                    context, "No audio chapters found");
                                return;
                              }

                              final model = Provider.of<AudioPlayerModel>(
                                  context,
                                  listen: false);

                              await model.playBookAudio(
                                widget.books,
                                _chapters,
                                0,
                                preserveCurrentIfSameBook: true,
                              );

                              if (!mounted) return;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const UnifiedAudioPlayerPage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: MyColors.mainC0lor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                t.listen,
                                style: TextStyles.display1(context).copyWith(
                                    color: const Color.fromARGB(
                                        255, 245, 243, 243),
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        InkWell(
                          onTap: () async {
                            if (isPending) return;
                            if (widget.books.amount != 0 && !isPurchased) {
                              Alerts.showPaymentDialog(context, widget.books);
                              return;
                            }
                            if (widget.books.epub == "" &&
                                widget.books.book != "") {
                              readpdf();
                              return;
                            }
                            if (widget.books.book == "" &&
                                widget.books.epub != "") {
                              readEpub();
                              return;
                            }
                            await showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return Container(
                                    margin: MediaQuery.of(context).size.width >
                                            1200
                                        ? EdgeInsets.only(left: 500, right: 500)
                                        : MediaQuery.of(context).size.width >
                                                800
                                            ? EdgeInsets.only(
                                                left: 350, right: 350)
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    500
                                                ? EdgeInsets.only(
                                                    left: 150, right: 150)
                                                : EdgeInsets.only(
                                                    left: 50, right: 50),
                                    child: SearchOptionDialog(
                                        title: t.readoptions,
                                        onclick: (_index) async {
                                          if (_index == 0) {
                                            readpdf();
                                          } else {
                                            readEpub();
                                          }
                                        }),
                                  );
                                });
                          },
                          child: Container(
                              //height: 25,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                shape: BoxShape.rectangle,
                                color: MyColors.mainC0lor,
                              ),
                              child: Text(
                                isPending
                                    ? t.pending
                                    : (widget.books.amount != 0 && !isPurchased)
                                        ? t.buy
                                        : t.read,
                                style: TextStyles.display1(context).copyWith(
                                    color: const Color.fromARGB(
                                        255, 245, 243, 243),
                                    fontSize: 20),
                              )),
                        ),
                        Container(
                          width: 0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //color: Colors.red,
                    child: Row(
                      children: [
                        Text(
                          widget.books.views.toString() + " " + t.views,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 16.0,
                            //fontFamily: "",
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                        Visibility(
                          visible: widget.books.amount! != 0,
                          child: Container(
                            width: 2,
                            height: 5,
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            color: MyColors.mainC0lor,
                          ),
                        ),
                        Visibility(
                          visible: widget.books.amount! != 0,
                          child: Text(
                            widget.books.sales.toString() + " " + t.sales,
                            style: TextStyles.display1(context).copyWith(
                              fontSize: 16.0,
                              //fontFamily: "",
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class SearchOptionDialog extends StatefulWidget {
  final String? title;
  final Function? onclick;
  SearchOptionDialog({Key? key, this.title, this.onclick}) : super(key: key);

  @override
  _ReportRadioDialogState createState() => _ReportRadioDialogState();
}

class _ReportRadioDialogState extends State<SearchOptionDialog> {
  List<String> reportOptions = t.viewoptions;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return AlertDialog(
      title: Text(
        widget.title! + ": ",
        style: TextStyles.subhead(context)
            .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        Container(
          height: 40,
          color: const Color.fromARGB(35, 128, 125, 128),
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(_context).pop();
                },
                child: Text(
                  t.cancel,
                  style: TextStyles.display5(context).copyWith(
                    fontSize: 18.0,
                    //color: MyColors.white,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(_context).pop();
                  widget.onclick!(_selected)!;

                  print(_selected);
                },
                child: Text(
                  t.openbook,
                  style: TextStyles.display5(context).copyWith(
                    fontSize: 18.0,
                    //color: MyColors.white,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        )

        // TextButton(
        //   child: Text(t.cancel),
        //   onPressed: () {
        //     Navigator.of(_context).pop();
        //   },
        // ),
        // TextButton(
        //   child: Text(t.ok),
        //   onPressed: () {
        //     Navigator.of(_context).pop();
        //     widget.onclick!(_selected)!;

        //     //print(_selected);
        //   },
        // ),
      ],
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: reportOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile(
                        title: Text(reportOptions[index]),
                        value: index,
                        groupValue: _selected,
                        onChanged: (value) {
                          setState(() {
                            _selected = value as int;
                          });
                        });
                  },
                  separatorBuilder: (context, position) {
                    return Container(child: Container());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadOptionDialog extends StatefulWidget {
  final String? title;
  final Function? onclick;
  DownloadOptionDialog({Key? key, this.title, this.onclick}) : super(key: key);

  @override
  _DownloadOptionDialog createState() => _DownloadOptionDialog();
}

class _DownloadOptionDialog extends State<DownloadOptionDialog> {
  List<String> reportOptions = t.viewoptions;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return AlertDialog(
      title: Text(
        widget.title! + ": ",
        style: TextStyles.subhead(context),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        TextButton(
          child: Text(t.cancel),
          onPressed: () {
            Navigator.of(_context).pop();
          },
        ),
        TextButton(
          child: Text(t.ok),
          onPressed: () {
            Navigator.of(_context).pop();
            widget.onclick!(_selected);

            //print(_selected);
          },
        ),
      ],
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: reportOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile(
                        title: Text(reportOptions[index]),
                        value: index,
                        groupValue: _selected,
                        onChanged: (value) {
                          setState(() {
                            _selected = value as int;
                          });
                        });
                  },
                  separatorBuilder: (context, position) {
                    return Container(child: Container());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

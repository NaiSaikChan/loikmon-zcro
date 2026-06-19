import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:http/http.dart' as http;

import '../models/Books.dart';
import '../utils/TextStyles.dart';

class RelatedBooksListView extends StatefulWidget {
  RelatedBooksListView(this.books);
  final Books books;

  @override
  State<RelatedBooksListView> createState() => _RelatedBooksListViewState();
}

class _RelatedBooksListViewState extends State<RelatedBooksListView> {
  bool isError = false;
  bool isLoading = false;
  List<Books> bookslist = [];

  Future<void> fetchItems() async {
    try {
      Userdata? userdata = await SQLiteDbProvider.db.getUserData();
      var data = {
        "bookid": widget.books.id,
        //"category": widget.books.categoryid,
        "email": userdata == null ? "null" : userdata.email,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.relatedbooks),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        List<Books> mediaList = await compute(parseSliderMedia, response.body);
        setItems(mediaList);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  void setItems(List<Books> item) {
    bookslist.clear();
    bookslist = item;
    isError = false;
    isLoading = false;
    setState(() {});
  }

  static List<Books> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["relatedbooks"].cast<Map<String, dynamic>>();
    return parsed.map<Books>((json) => Books.fromJson(json)).toList();
  }

  setFetchError() {
    setState(() {
      isError = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      fetchItems();
    });
  }

  Widget _buildItems(BuildContext context, int index) {
    var media = bookslist[index];
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: InkWell(
        child: Container(
          height: 350.0,
          width: 180.0,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            color: Colors.black12,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 250,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: media.thumbnail!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Center(
                        child: Icon(
                      Icons.error,
                      //color: Colors.grey,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            media.title!,
                            style: TextStyles.display1(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              //fontFamily: 'style1',
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            media.author!,
                            style: TextStyles.display1(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              // fontFamily: 'style1',
                              //color: Colors.blueGrey[300],
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //MediaPopupMenu(media),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, EbooksViewerScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: media,
                check: false,
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 65,
          width: double.infinity,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 0,
              ),
              Container(
                width: 2,
                height: double.infinity,
                color: MyColors.primary,
              ),
              Expanded(
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: ListTile(
                    title: Text(
                      t.relatedbooks,
                      textAlign: TextAlign.left,
                      style: TextStyles.headline(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        //fontFamily: 'style1',
                      ),
                    ),
                    subtitle: Text(t.booksyoumaylike),
                  ),
                ),
              ),
            ],
          ),
        ),
        (isError == true || bookslist.length == 0)
            ? Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(t.noitemstodisplay,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(context).copyWith(
                          //fontFamily: 'style1'
                          )),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 15.0, left: 10.0),
                height: 350.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: bookslist.length,
                  itemBuilder: _buildItems,
                ),
              ),
      ],
    );
  }
}

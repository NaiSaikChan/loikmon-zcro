import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/screens/HomePage.dart';
import 'package:loikmon/screens/NoitemScreen.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/my_colors.dart';

class ViewItem extends StatefulWidget {
  final String? id;
  final String? type;

  ViewItem({Key? key, this.id, this.type}) : super(key: key);

  @override
  _ArticleViewerScreenState createState() => _ArticleViewerScreenState();
}

class _ArticleViewerScreenState extends State<ViewItem> {
  bool isloading = true;
  bool iserror = false;

  setLoading() {
    setState(() {
      isloading = true;
      iserror = false;
    });
  }

  setError() {
    setState(() {
      isloading = false;
      iserror = true;
    });
  }

  setLoadied() {
    setState(() {
      isloading = false;
      iserror = false;
    });
  }

  processDeepLink(String id, String type) async {
    setLoading();
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    Alerts.showProgressDialog(context, "Processing, please wait ...");
    try {
      var data = {
        "type": type,
        "id": id, //path.pathSegments[1].toString(),
        "email": userdata == null ? "null" : userdata.email,
      };

      final response = await http.post(
        Uri.parse(ApiUrl.getitem),
        body: jsonEncode({"data": data}),
      );
      print("response for deeplink");
      print(response.body);
      print("...response for deeplink");
      Navigator.of(context).pop();
      final res = jsonDecode(response.body);
      if (res['status'] == "ok") {
        if (type == "book") {
          Books book = Books.fromJson(res["book"]);
          Navigator.of(context).pushNamedAndRemoveUntil(
              EbooksViewerScreen.routeName,
              (Route route) => route.settings.name == HomePage.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: book,
                check: false,
                option: "true",
              ));
        }
        if (type == "article") {
          Articles articles = Articles.fromJson(res["article"]);
          print("received = " + articles.title!);
          List<Articles> items = [];
          items.add(articles);
          Navigator.of(context).pushNamedAndRemoveUntil(
              ArticleViewerScreen.routeName,
              (Route route) => route.settings.name == HomePage.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: articles,
                itemsList: items,
                option: "true",
              ));
        }
      } else {
        setError();
      }
    } catch (exception) {
      // I get no exception here
      print("...response for deeplink");
      print(exception.toString());
      print("...response for deeplink");
      Navigator.of(context).pop();
      setError();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      processDeepLink(widget.id!, widget.type!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: isloading
            ? CupertinoActivityIndicator(
                radius: 12,
                color: MyColors.mainC0lor,
              )
            : NoitemScreen(
                title: t.error,
                message: t.data_load_error,
                onClick: () {
                  processDeepLink(widget.id!, widget.type!);
                }),
      ),
    ));
  }
}

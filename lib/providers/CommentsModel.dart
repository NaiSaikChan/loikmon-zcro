import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/Reviews.dart';
import '../models/Userdata.dart';
import '../utils/Alerts.dart';
import '../utils/ApiUrl.dart';
import '../utils/Utility.dart';

class CommentsModel with ChangeNotifier {
  List<Reviews> items = [];
  bool isError = false;
  int itmid = 0;
  bool isLoading = false;
  BuildContext? _context;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  int type = 0;
  bool isuserreviewed = true;

  CommentsModel(BuildContext context, int itmid, int type, bool shouldload) {
    _context = context;
    this.type = type;
    this.itmid = itmid;
    if (shouldload) {
      loadComments();
    }
  }

  bool isUser(Userdata? userdata, String email) {
    if (userdata == null) return false;
    return email == userdata.email;
  }

  loadComments() {
    isLoading = true;
    notifyListeners();
    fetchComments();
  }

  setCommentPostDetails() {}

  void setComments(List<Reviews> item) {
    items.clear();
    items = item;
    if (item.length == 0)
      isError = true;
    else
      isError = false;
    isLoading = false;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    items.clear();
    //notifyListeners();
  }

  Future<void> fetchComments() async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    try {
      final response = await http.post(Uri.parse(ApiUrl.loadrecentreviews),
          body: jsonEncode({
            "data": {
              "id": 0,
              "itmid": itmid,
              "type": type,
              "email": userdata == null ? "" : userdata.email,
            }
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        Map<String, dynamic> res = json.decode(response.body);
        isuserreviewed = int.parse(res['userreview'].toString()) == 0;
        List<Reviews> comments = await compute(parseComments, response.body);
        setComments(comments);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setCommentsFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setCommentsFetchError();
    }
  }

  setCommentsFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }

  Future<void> constructComment(
      BuildContext context, String content, double rate) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    try {
      var data = {
        "content": Utility.getBase64EncodedString(content),
        "email": userdata?.email,
        "itmid": itmid,
        "type": type,
        "rating": rate
      };
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.submitreview),
          body: jsonEncode({"data": data}));
      print("comments = " + response.body);
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        items.insert(0, Reviews.fromJson(res['review']));
        isuserreviewed = true;
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      Navigator.of(context).pop();
      Alerts.showToast(context, t.cannotreviewerror);
    }
  }

  Future<void> showDeleteCommentAlert(int commentId, int position) async {
    return showDialog(
        context: _context!,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(
                t.delete_comment_alert,
                style: TextStyles.display1(context)
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: new Text(
                t.delete_comment_alert_text,
                style: TextStyles.display1(context).copyWith(fontSize: 16),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.okay,
                      style: TextStyles.display1(context).copyWith(
                          color: const Color.fromARGB(255, 241, 45, 215),
                          //fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteComment(commentId, position);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel,
                      style: TextStyles.display1(context).copyWith(
                          color: const Color.fromARGB(255, 241, 45, 215),
                          //fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> deleteComment(int commentId, int position) async {
    Alerts.showProgressDialog(_context!, t.deleting_comment);
    try {
      ;
      var data = {
        "id": commentId,
        "itmid": itmid,
        "type": type,
      };
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.deletereview),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String _status = res["status"];
        if (_status == "ok") {
          Navigator.of(_context!).pop();
          items.removeAt(position);
          notifyListeners();
        } else {
          processingErrorMessage(t.error_deleting_comments);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.error_deleting_comments);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.error_deleting_comments);
    }
  }

  static List<Reviews> parseComments(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["reviews"].cast<Map<String, dynamic>>();
    return parsed.map<Reviews>((json) => Reviews.fromJson(json)).toList();
  }

  Future<void> showEditCommentAlert(int commentId, int position) async {
    // editComment(commentId, text, position);
  }

  Future<void> editComment(BuildContext context, String content, double rating,
      int id, int position) async {
    Alerts.showProgressDialog(_context!, t.editing_comment);
    try {
      var encoded = Utility.getBase64EncodedString(content);
      var data = {
        "content": encoded,
        "id": id,
        "rating": rating,
      };
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.editreview),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String _status = res["status"];
        if (_status == "ok") {
          Navigator.of(_context!).pop();
          items[position].content = encoded;
          items[position].rating = rating.toString();
          notifyListeners();
        } else {
          processingErrorMessage(t.error_editing_comments);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.error_editing_comments);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.error_editing_comments);
    }
  }

  processingErrorMessage(String msg) {
    Navigator.of(_context!).pop();
    Alerts.showCupertinoAlert(_context, t.error, msg);
  }

  //others
  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Reviews> item) {
    items.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Reviews> item) {
    items.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      var data = {
        "page": page.toString(),
        "type": type,
        "itmid": itmid,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.loadreviews),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        List<Reviews> mediaList =
            await compute(parseSliderMedia, response.body);
        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList);
        }
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

  static List<Reviews> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["reviews"].cast<Map<String, dynamic>>();
    return parsed.map<Reviews>((json) => Reviews.fromJson(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      isError = true;
      refreshController.refreshFailed();
      notifyListeners();
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}

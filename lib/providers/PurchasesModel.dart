import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PurchasesModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  bool isLoading = false;
  List<Books> booksList = [];
  String type = "ebook";
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  PurchasesModel(String type) {
    this.type = type;
    //loadItems();
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Books> item) {
    booksList.clear();
    booksList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Books> item) {
    booksList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    Userdata? user = await SQLiteDbProvider.db.getUserData();
    try {
      var data = {
        "type": type,
        "page": page.toString(),
        "email": user == null ? "null" : user.email
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCHUSERPURCHASES),
          body: jsonEncode({"data": data}));
      print(response.body);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<Books> mediaList = await compute(parseSliderMedia, response.body);
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

  static List<Books> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["books"].cast<Map<String, dynamic>>();
    return parsed.map<Books>((json) => Books.fromJson(json)).toList();
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

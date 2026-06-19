import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/ApiUrl.dart';

class LeaguesModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  List<Authors> items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  int? type;
  String query = "";

  LeaguesModel(int type) {
    this.type = type;
    this.items = [];
  }

  loadItems(String query) {
    this.query = query;
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Authors> item) {
    items.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Authors> item) {
    items.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      Userdata? userdata = await SQLiteDbProvider.db.getUserData();
      var data = {
        "type": type == 0 ? "book" : "article",
        "page": page.toString(),
        "query": query,
        "email": userdata == null ? "envisio" : userdata.email,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_LEAGUES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        List<Authors> mediaList =
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
      if (exception is DioError) {
        print(exception.error);
        print(exception.message);
        print(exception.response);
      }
      setFetchError();
    }
  }

  static List<Authors> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["authors"].cast<Map<String, dynamic>>();
    return parsed.map<Authors>((json) => Authors.fromJson(json)).toList();
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

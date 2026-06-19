import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/ApiUrl.dart';

class OtherbooksModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  bool isLoading = false;
  List<Books> booksList = [];
  int type = 0;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  List<Categories> categories = [];
  String query = "";
  Categories? cats;

  OtherbooksModel(int type) {
    this.type = type;
  }

  selectCategory(Categories cats) {
    this.cats = cats;
    booksList = [];
    loadItems(query);
    notifyListeners();
  }

  bool isSelected(Categories cats) {
    if (this.cats == null) {
      return false;
    }
    return this.cats!.id! == cats.id;
  }

  loadItems(String query) {
    this.query = query;
    refreshController.requestRefresh();
    page = 0;
    if (categories.length == 0) {
      fetchcategories();
    }
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
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    try {
      var data = {
        "email": userdata == null ? "null" : userdata.email,
        "type": type.toString(),
        "page": page.toString(),
        "query": query,
        "category": cats == null ? 0 : cats!.id,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_OTHER_BOOKS),
          body: jsonEncode({"data": data}));
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
      if (exception is DioError) {
        print(exception.error);
        print(exception.message);
      }
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

  Future<void> fetchcategories() async {
    try {
      var data = {
        "type": "book",
        "page": 0,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_CATEGORIES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        categories = await compute(parseCategories, response.body);
        categories.insert(
            0,
            Categories(
              id: 0,
              title: t.allitems,
            ));
        cats = categories[0];
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  static List<Categories> parseCategories(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["categories"].cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }
}

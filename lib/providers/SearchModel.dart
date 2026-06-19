import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/ApiUrl.dart';

class SearchModel with ChangeNotifier {
  List<Object> _items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isError = false;
  bool isLoading = false;
  bool isIdle = true;
  static bool isFirstLoad = false;
  String query = "";
  int currentIndex = 0;

  SearchModel();

  List<Object> get items {
    return _items;
  }

  setCurrentIndex(int index) {
    currentIndex = index;
    _items = [];
    notifyListeners();
  }

  void cancelSearch() {
    isError = false;
    isLoading = false;
    isIdle = true;
    notifyListeners();
  }

  void setSearchResult(List<Object> item) {
    _items = item;
    refreshController.refreshCompleted();
    isError = false;
    isLoading = false;
    notifyListeners();
  }

  Future<void> searchArticles(String query) async {
    try {
      this.query = query;
      isIdle = false;
      isFirstLoad = true;
      isLoading = true;
      _items = [];
      notifyListeners();
      final response = await http.post(Uri.parse(ApiUrl.SEARCH),
          body: jsonEncode({
            "data": {
              "offset": 0,
              "type": currentIndex,
              "query": query,
            }
          }));
      if (response.statusCode == 200) {
        print(response.body);
        if (currentIndex == 0) {
          List<Books> books = await compute(parseBooks, response.body);
          setSearchResult(books);
        } else {
          List<Articles> articles = await compute(parseArticles, response.body);
          setSearchResult(articles);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(response.body);
        print("there is an error somwehere");
        setArticleFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setArticleFetchError();
    }
  }

  setArticleFetchError() {
    _items = [];
    refreshController.refreshFailed();
    isError = true;
    isLoading = false;
    notifyListeners();
  }

  static List<Books> parseBooks(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["search"].cast<Map<String, dynamic>>();
    return parsed.map<Books>((json) => Books.fromJson(json)).toList();
  }

  static List<Articles> parseArticles(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["search"].cast<Map<String, dynamic>>();
    return parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
  }
}

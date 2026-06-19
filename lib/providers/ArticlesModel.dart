import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/Articles.dart';
import '../models/ScreenArguements.dart';
import '../screens/ArticleViewerScreen.dart';
import '../utils/ApiUrl.dart';

class ArticlesModel with ChangeNotifier {
  List<Articles>? _items = [];
  List<Categories> categories = [];
  String query = "";
  Categories? cats;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollController = new ScrollController();
  bool isError = false;
  int page = 0;
  int type = 0;

  ArticlesModel();

  selectCategory(Categories cats) {
    this.cats = cats;
    _items = [];
    fetch(type, query);
    notifyListeners();
  }

  bool isSelected(Categories cats) {
    if (this.cats == null) {
      return false;
    }
    return this.cats!.id! == cats.id;
  }

  loadArticleViewer(BuildContext context, int position) async {
    await Navigator.pushNamed(
      context,
      ArticleViewerScreen.routeName,
      arguments: ScreenArguements(position: position, items: _items),
    );
  }

  fetch(int type, String query) async {
    this.type = type;
    this.query = query;
    _items = [];
    page = 0;
    notifyListeners();
    refreshController.requestRefresh();
    if (categories.length == 0) {
      fetchcategories();
    }
    fetchArticles();
  }

  fetchMore(int type) async {
    this.type = type;
    page++;
    refreshController.requestLoading();
    fetchArticles();
  }

  List<Articles>? get items {
    return _items;
  }

  void setArticles(List<Articles>? item) {
    _items!.clear();
    _items = item;
    // SQLiteDbProvider.db.deleteAllArticles();
    // SQLiteDbProvider.db.insertBatchArticles(item);
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreArticles(List<Articles> item) {
    _items!.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items!.clear();
    //notifyListeners();
  }

  Future<void> fetchArticles() async {
    var data = {
      "page": page,
      "type": type,
      "query": query,
      "category": cats == null ? 0 : cats!.id,
    };
    print(data);
    try {
      final response = await http.post(Uri.parse(ApiUrl.ARTICLES),
          body: jsonEncode({"data": data}));
      print(response.body);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        // print(response.body);
        final res = jsonDecode(response.body);
        final parsed = res["articles"].cast<Map<String, dynamic>>();
        List<Articles> articles =
            parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
        if (page == 0) {
          setArticles(articles);
        } else {
          setMoreArticles(articles);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setArticleFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setArticleFetchError();
    }
  }

  setArticleFetchError() {
    if (page == 0) {
      refreshController.refreshFailed();
      isError = true;
    } else {
      refreshController.loadFailed();
    }
    notifyListeners();
  }

  Future<void> fetchcategories() async {
    try {
      var data = {
        "type": "article",
        "page": 0,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_CATEGORIES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        categories = await compute(parseSliderMedia, response.body);
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

  static List<Categories> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["categories"].cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }
}

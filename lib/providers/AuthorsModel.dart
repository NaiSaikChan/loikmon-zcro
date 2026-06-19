import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/ApiUrl.dart';

class AuthorsModel with ChangeNotifier {
  bool isError = false;
  List<Authors> items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  int? type;
  String query = "";

  AuthorsModel(int type) {
    this.type = type;
    items = [];
  }

  void _sortAuthors() {
    items.sort((a, b) {
      final totalCompare = b.totalContents.compareTo(a.totalContents);
      if (totalCompare != 0) return totalCompare;

      final articleCompare =
          (b.articlescount ?? 0).compareTo(a.articlescount ?? 0);
      if (articleCompare != 0) return articleCompare;

      return (b.bookscount ?? 0).compareTo(a.bookscount ?? 0);
    });
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
    items = item;
    _sortAuthors();
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Authors> item) {
    items.addAll(item);
    _sortAuthors();
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
        "email": userdata == null ? "" : userdata.email,
      };

      print(data);

      final response = await http.post(
        Uri.parse(ApiUrl.FETCH_AUTHORS),
        body: jsonEncode({"data": data}),
      );

      if (response.statusCode == 200) {
        List<Authors> mediaList =
            await compute(parseSliderMedia, response.body);

        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList);
        }
      } else {
        setFetchError();
      }
    } catch (exception) {
      print(exception);
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

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/models/Categories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/ApiUrl.dart';

class CategoriesModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  List<Categories> items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  int? type;

  CategoriesModel(int type) {
    this.type = type;
    this.items = [];
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

  void setItems(List<Categories> item) {
    items.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Categories> item) {
    items.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      var data = {
        "type": type == 0 ? "book" : "article",
        "page": page.toString(),
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_CATEGORIES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        List<Categories> mediaList =
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

  static List<Categories> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["categories"].cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
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

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/ApiUrl.dart';

class ArticlesListModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  bool isLoading = false;
  List<Articles> booksList = [];
  Itms? itms;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  List<Categories> subCategoriesList = [];
  int selectedSubCategory = 0;
  //
  List<Categories> categories = [];
  Categories? cats;

  ArticlesListModel(Itms itms) {
    this.itms = itms;
    categories = [];
    subCategoriesList = [];
    //loadItems();
  }

  selectCategory(Categories cats) {
    this.cats = cats;
    loadItems();
    notifyListeners();
  }

  bool isSelected(Categories cats) {
    if (this.cats == null) {
      return false;
    }
    return this.cats!.id! == cats.id;
  }

  loadItems() {
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

  void setItems(List<Articles> item) {
    booksList.clear();
    booksList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Articles> item) {
    booksList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    try {
      var data = {
        "email": userdata == null ? "null" : userdata.email,
        "itm": itms!.id.toString(),
        "type": 0,
        "itmtype": itms!.type,
        "page": page.toString(),
        "sub": selectedSubCategory.toString(),
        "category": cats == null ? 0 : cats!.id,
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.ARTICLES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);

        List<Articles> mediaList =
            await compute(parseSliderMedia, response.body);
        if (page == 0) {
          if (subCategoriesList.length == 0 && itms!.type != 1) {
            subCategoriesList = await compute(parseCategories, response.body);
            addTopItem();
            notifyListeners();
          }
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

  static List<Articles> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["articles"].cast<Map<String, dynamic>>();
    return parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
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

  //
  bool isSubcategorySelected(int index) {
    Categories categories = subCategoriesList[index];
    return categories.id == selectedSubCategory;
  }

  refreshPageOnCategorySelected(int id) {
    if (id != selectedSubCategory) {
      selectedSubCategory = id;
      booksList = [];
      notifyListeners();
      loadItems();
    }
  }

  addTopItem() {
    Categories cats = new Categories(
        id: 0,
        title: t.allitems,
        bookscount: 0,
        articlescount: 0,
        thumbnailUrl: "");
    subCategoriesList.insert(0, cats);
  }

  static List<Categories> parseCategories(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["subcategories"].cast<Map<String, dynamic>>();
    return parsed
        .map<Categories>((json) => Categories.fromSubCategory(json))
        .toList();
  }

  Future<void> fetchcategories() async {
    try {
      var data = {
        "author": itms!.id,
        "type": "article",
        "page": 0,
      };
      print(data);
      final response = await http.post(
          Uri.parse(ApiUrl.FETCH_AUTHOR_CATEGORIES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        categories = await compute(parsCategories, response.body);
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

  static List<Categories> parsCategories(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["categories"].cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }
}

/*import 'package:flutter/foundation.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/Userdata.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;

class ArticlesListModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  bool isLoading = false;
  List<Articles> booksList = [];
  Itms? itms;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  List<Categories> subCategoriesList = [];
  int selectedSubCategory = 0;

  ArticlesListModel(Itms itms) {
    this.itms = itms;
    subCategoriesList = [];
    //loadItems();
  }

  loadItems() {
    print("loading articles");
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Articles> item) {
    booksList.clear();
    booksList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Articles> item) {
    booksList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    try {
      var data = {
        "email": userdata == null ? "null" : userdata.email,
        "itm": itms!.id.toString(),
        "type": 0,
        "itmtype": itms!.type,
        "page": page.toString(),
        "sub": selectedSubCategory.toString(),
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.ARTICLES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);

        List<Articles> mediaList =
            await compute(parseSliderMedia, response.body);
        if (page == 0) {
          if (subCategoriesList.length == 0 && itms!.type != 1) {
            subCategoriesList = await compute(parseCategories, response.body);
            addTopItem();
            notifyListeners();
          }
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

  static List<Articles> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["articles"].cast<Map<String, dynamic>>();
    return parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
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

  //
  bool isSubcategorySelected(int index) {
    Categories categories = subCategoriesList[index];
    return categories.id == selectedSubCategory;
  }

  refreshPageOnCategorySelected(int id) {
    if (id != selectedSubCategory) {
      selectedSubCategory = id;
      booksList = [];
      notifyListeners();
      loadItems();
    }
  }

  addTopItem() {
    Categories cats = new Categories(
        id: 0,
        title: t.allitems,
        bookscount: 0,
        articlescount: 0,
        thumbnailUrl: "");
    subCategoriesList.insert(0, cats);
  }

  static List<Categories> parseCategories(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["subcategories"].cast<Map<String, dynamic>>();
    return parsed
        .map<Categories>((json) => Categories.fromSubCategory(json))
        .toList();
  }
}*/

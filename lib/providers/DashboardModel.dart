import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Collections.dart';
import 'package:loikmon/models/Sliders.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Categories.dart';
import '../models/Userdata.dart';
import '../utils/ApiUrl.dart';

class DashboardModel with ChangeNotifier {
  //List<Comments> _items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isError = false;
  Userdata? userdata;
  bool isLoading = true;
  List<Categories>? categories = [];
  List<Sliders>? sliders = [];
  List<Authors>? leagues = [];
  List<Books>? newbooks = [];
  List<Books>? popularbooks = [];
  List<Books>? recommended = [];
  List<Articles>? newarticles = [];
  List<Articles>? freearticles = [];
  List<Articles>? populararticles = [];
  List<Authors>? bookAuthors = [];
  List<Articles>? audioarticles = [];
  List<Collections>? collections = [];
  late BuildContext context;
  String notificationcount = "";
  String pending_bank_requests = "";
  //
  List<Books>? authorbooks = [];
  List<Books>? booksyoumaylike = [];
  bool isloadingoverview = true;
  bool isoverviewError = false;

  DashboardModel() {
    init();
  }

  setContext(BuildContext context) {
    this.context = context;
  }

  setPendingBankRequests(int _pending_bank_requests) {
    if (_pending_bank_requests == 0) {
      pending_bank_requests = "";
    } else if (_pending_bank_requests <= 9) {
      pending_bank_requests = _pending_bank_requests.toString();
    } else {
      pending_bank_requests = "9+";
    }
    notifyListeners();
  }

  unsetNotificationcount() {
    notificationcount = "";
    notifyListeners();
  }

  init() async {
    await getUserData();
    loadItems();
  }

  loadItems() {
    isLoading = true;
    notifyListeners();
    fetchItems();
  }

  fetch(int type) async {
    refreshController.requestRefresh();
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      SharedPreferences? _prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse(ApiUrl.DISCOVER),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "data": {
            "email": userdata == null ? "null" : userdata!.email,
            "lastseeninbox": _prefs.getInt("lastseenartistinbox") == null
                ? 0
                : _prefs.getInt("lastseenartistinbox"),
          }
        }),
      );
      //print("dashboardres = " + response.body.toString());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        isLoading = false;
        isError = false;

        dynamic res = json.decode(json.encode(json.decode(response.body)));
        sliders = parseSliders(res);
        categories = parseCategories(res);
        bookAuthors = parseAuthors(res);
        bookAuthors!.sort((a, b) {
          return b.articlescount!.compareTo(a.articlescount!);
        });
        leagues = parseLeagues(res);
        newbooks = parseBooks(res, "newbooks");
        popularbooks = parseBooks(res, "popular");
        recommended = parseBooks(res, "recommended");
        freearticles = parseArticles(res, "freearticles");
        newarticles = parseArticles(res, "newarticles");
        populararticles = parseArticles(res, "populararticles");
        audioarticles = parseArticles(res, "audioarticles");
        collections = parseCollections(res);
        int _notificationcount =
            int.parse(res['notification_count'].toString());
        if (_notificationcount == 0) {
          notificationcount = "";
        } else if (_notificationcount <= 9) {
          notificationcount = _notificationcount.toString();
        } else {
          notificationcount = "9+";
        }
        int _pending_bank_requests =
            int.parse(res['pending_bank_requests'].toString());
        if (_pending_bank_requests == 0) {
          pending_bank_requests = "";
        } else if (_pending_bank_requests <= 9) {
          pending_bank_requests = _pending_bank_requests.toString();
        } else {
          pending_bank_requests = "9+";
        }
        refreshController.refreshCompleted();
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(response.body);
        refreshController.refreshCompleted();
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      refreshController.refreshCompleted();
      print(exception.toString());
      if (exception is DioError) {
        print(exception.error);
        print(exception.message);
        print(exception.response);
      }
      setFetchError();
    }
  }

  static List<Sliders>? parseSliders(dynamic res) {
    final parsed = res["sliders"].cast<Map<String, dynamic>>();
    return parsed.map<Sliders>((json) => Sliders.fromJson(json)).toList();
  }

  static List<Categories>? parseCategories(dynamic res) {
    final parsed = res["categories"].cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }

  static List<Authors>? parseAuthors(dynamic res) {
    final parsed = res["authors"].cast<Map<String, dynamic>>();
    return parsed.map<Authors>((json) => Authors.fromJson(json)).toList();
  }

  static List<Authors>? parseLeagues(dynamic res) {
    final parsed = res["leagues"].cast<Map<String, dynamic>>();
    return parsed.map<Authors>((json) => Authors.fromJson(json)).toList();
  }

  static List<Books>? parseBooks(dynamic res, String itm) {
    print("booksitems = " + res[itm].toString());
    final parsed = res[itm].cast<Map<String, dynamic>>();
    return parsed.map<Books>((json) => Books.fromJson(json)).toList();
  }

  static List<Articles>? parseArticles(dynamic res, String itm) {
    final parsed = res[itm].cast<Map<String, dynamic>>();
    return parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
  }

  setFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }

//
  loadreviewItems(Books? books) {
    isloadingoverview = true;
    isoverviewError = false;
    authorbooks = [];
    booksyoumaylike = [];
    notifyListeners();
    fetchoverviewItems(books);
  }

  setReviewFetchError() {
    isoverviewError = true;
    isloadingoverview = false;
    notifyListeners();
  }

  Future<void> fetchoverviewItems(Books? books) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.OVERVIEW),
        body: jsonEncode({
          "data": {
            "email": userdata == null ? "null" : userdata!.email,
            "author": books!.authorid,
            "bookid": books.id,
          }
        }),
      );
      print(response.body);
      isloadingoverview = false;
      isoverviewError = false;

      dynamic res = jsonDecode(response.body);
      authorbooks = parseAuthorBooks(res);
      booksyoumaylike = parseBooksYouLike(res);
      notifyListeners();
    } catch (exception) {
      // I get no exception here
      print(exception);

      setReviewFetchError();
    }
  }

  static List<Books>? parseAuthorBooks(dynamic res) {
    final parsed = res["authorbooks"].cast<Map<String, dynamic>>();
    return parsed.map<Books>((json) => Books.fromJson(json)).toList();
  }

  static List<Books>? parseBooksYouLike(dynamic res) {
    final parsed = res["booksyoulike"].cast<Map<String, dynamic>>();
    return parsed.map<Books>((json) => Books.fromJson(json)).toList();
  }

  static List<Collections>? parseCollections(dynamic res) {
    final parsed = res["collections"].cast<Map<String, dynamic>>();
    return parsed
        .map<Collections>((json) => Collections.fromJson(json))
        .toList();
  }
}

import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/my_colors.dart';
import 'dart:math';

class Firebase {
  late Function navigateBook;
  late Function navigateArticle;
  static String appState = "idle";

  Firebase(
    Function navigateBook,
    Function navigateArticle,
  ) {
    this.navigateBook = navigateBook;
    this.navigateArticle = navigateArticle;
  }

  void init() async {}
}

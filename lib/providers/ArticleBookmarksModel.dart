import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/Articles.dart';
import '../database/SQLiteDbProvider.dart';

class ArticleBookmarksModel with ChangeNotifier {
  List<Articles> pinnedArticles = [];

  ArticleBookmarksModel() {
    getPinnedData();
  }

  bool isArticleBookMarked(int? id) {
    Articles? itm = pinnedArticles.firstWhereOrNull((itm) => itm.id == id);
    return itm != null;
  }

  bookmarkArticle(Articles article) {
    SQLiteDbProvider.db.bookmarkArticle(article);
    getPinnedData();
    notifyListeners();
  }

  unBookmarkArticle(int? id) {
    Articles? itm = pinnedArticles.firstWhereOrNull((itm) => itm.id == id);
    SQLiteDbProvider.db.deleteArticleBookmark(itm);
    getPinnedData();
    notifyListeners();
  }

  getPinnedData() async {
    pinnedArticles = await SQLiteDbProvider.db.getAllBookmarkedArticles();
    print("pinnedArticles = " + pinnedArticles.length.toString());
    pinnedArticles.reversed.toList();
    notifyListeners();
  }
}

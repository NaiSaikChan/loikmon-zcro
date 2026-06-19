import 'package:flutter/foundation.dart';
import '../models/Userdata.dart';
import '../models/Books.dart';
import '../database/SQLiteDbProvider.dart';
import 'package:collection/collection.dart' show IterableExtension;

class BookmarksModel with ChangeNotifier {
  Userdata? userdata;
  List<Books> bookmarksList = [];
  List<Books> books = [];
  List<Books> magazines = [];

  BookmarksModel() {
    getBookmarks();
  }

  getBookmarks() async {
    books = [];
    magazines = [];
    bookmarksList = await SQLiteDbProvider.db.getAllBooks();
    bookmarksList.forEach((element) {
      books.add(element);
    });
    bookmarksList.reversed.toList();
    notifyListeners();
    print(bookmarksList.length.toString());
  }

  bookmarkBook(Books books) async {
    await SQLiteDbProvider.db.bookMarkBook(books);
    getBookmarks();
  }

  unBookmarkBook(Books books) async {
    await SQLiteDbProvider.db.deleteBookmarkedBooks(books);
    getBookmarks();
  }

  bool isBookBookmarked(Books? books) {
    Books? itm = bookmarksList.firstWhereOrNull((itm) => (itm.id == books!.id));
    return itm != null;
  }
}

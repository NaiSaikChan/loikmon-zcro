import 'dart:async';

import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/Categories.dart';
import '../models/Userdata.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var databaseFactory = databaseFactoryFfiWeb;
    //var db = await databaseFactory.openDatabase('my_db.db');
    return await databaseFactory.openDatabase('monybookss2.db',
        options: OpenDatabaseOptions(
            version: 2,
            onOpen: (db) {},
            onUpgrade: (db, oldVersion, newVersion) async {
              if (newVersion == 3) {
                await db.execute(
                    "ALTER TABLE  ${Articles.BOOKMARKS} ADD COLUMN description TEXT");
              }
            },
            onCreate: (Database db, int version) async {
              await db.execute("CREATE TABLE ${Userdata.TABLE} ("
                  "email TEXT,"
                  "name TEXT,"
                  "coins INTEGER,"
                  "seller INTEGER"
                  ")");
              await db.execute("CREATE TABLE ${Itms.TABLE} ("
                  "id INTEGER PRIMARY KEY,"
                  "title TEXT"
                  ")");
              await db.execute("CREATE TABLE ${Articles.BOOKMARKS} ("
                  "id INTEGER PRIMARY KEY,"
                  "title TEXT,"
                  "content TEXT,"
                  "thumbnail TEXT,"
                  "thumbnail2 TEXT,"
                  "thumbnail3 TEXT,"
                  "thumbnail4 TEXT,"
                  "thumbnail5 TEXT,"
                  "author TEXT,"
                  "description TEXT,"
                  "category TEXT,"
                  "date TEXT,"
                  "link TEXT,"
                  "views INTEGER,"
                  "rates REAL,"
                  "amount INTEGER,"
                  "rating TEXT,"
                  "streamUrl TEXT,"
                  "hasrate REAL"
                  ")");

              await db.execute("CREATE TABLE ${Books.BOOKMARKS} ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "bookid INTEGER,"
                  "seller TEXT,"
                  "authorid INTEGER,"
                  "title TEXT,"
                  "thumbnail TEXT,"
                  "coverphoto TEXT,"
                  "book TEXT,"
                  "epub TEXT,"
                  "publisher TEXT,"
                  "author TEXT,"
                  "description TEXT,"
                  "pages TEXT,"
                  "categoryname TEXT,"
                  "type TEXT,"
                  "product TEXT,"
                  "datepublished TEXT,"
                  "messenger TEXT,"
                  "phone1 TEXT,"
                  "phone2 TEXT,"
                  "amount REAL,"
                  "pdfhttp INTEGER,"
                  "epubhttp INTEGER,"
                  "sales INTEGER,"
                  "rates REAL,"
                  "views INTEGER,"
                  "rating TEXT,"
                  "hasAudio INTEGER DEFAULT 0,"
                  "audioduration TEXT,"
                  "hasrate REAL"
                  ")");

              await db.execute("CREATE TABLE ${Books.DOWNLOADS} ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "bookid INTEGER,"
                  "authorid INTEGER,"
                  "seller TEXT,"
                  "title TEXT,"
                  "thumbnail TEXT,"
                  "coverphoto TEXT,"
                  "book TEXT,"
                  "epub TEXT,"
                  "publisher TEXT,"
                  "author TEXT,"
                  "description TEXT,"
                  "pages TEXT,"
                  "categoryname TEXT,"
                  "type TEXT,"
                  "product TEXT,"
                  "datepublished TEXT,"
                  "messenger TEXT,"
                  "phone1 TEXT,"
                  "phone2 TEXT,"
                  "amount REAL,"
                  "pdfhttp INTEGER,"
                  "epubhttp INTEGER,"
                  "sales INTEGER,"
                  "rates REAL,"
                  "views INTEGER,"
                  "rating TEXT,"
                  "hasAudio INTEGER DEFAULT 0,"
                  "audioduration TEXT,"
                  "hasrate REAL"
                  ")");
            }));
  }

  //userdata crud
  Future<Userdata?> getUserData() async {
    final db = await database;
    List<Map> results = await db!.query(
      "${Userdata.TABLE}",
      columns: Userdata.columns,
    );
    print(results.toString());
    List<Userdata> userdatalist = [];
    results.forEach((result) {
      Userdata userdata = Userdata.fromMap(result as Map<String, dynamic>);
      userdatalist.add(userdata);
    });
    //print(categories.length);
    return userdatalist.length > 0 ? userdatalist[0] : null;
  }

  insertUser(Userdata? userdata) async {
    final db = await database;
    var result = await db!.rawInsert(
        "INSERT Into ${Userdata.TABLE} (email, name, seller, coins)"
        " VALUES ( ?, ?, ?, ?)",
        [
          userdata!.email,
          userdata.name,
          userdata.seller,
          userdata.coins,
        ]);
    return result;
  }

  deleteUserData() async {
    final db = await database;
    db!.rawDelete("DELETE FROM ${Userdata.TABLE}");
  }

  //categories crud
  Future<List<Categories>> getAllCategories() async {
    final db = await database;
    List<Map> results = await db!.query("${Categories.TABLE}",
        columns: Categories.columns, orderBy: "id ASC");
    List<Categories> categories = [];
    results.forEach((result) {
      //Categories category = Categories.fromMap(result);
      //categories.add(category);
    });
    //print(categories.length);
    return categories;
  }

  insertCategory(Categories categories) async {
    final db = await database;
    var result = await db!.rawInsert(
        "INSERT OR REPLACE Into ${Categories.TABLE} (id, title, thumbnailUrl)"
        " VALUES (?, ?, ?)",
        [categories.id, categories.title, categories.thumbnailUrl]);
    return result;
  }

  deleteCategory(int id) async {
    final db = await database;
    db!.delete("${Categories.TABLE}", where: "bookid = ?", whereArgs: [id]);
  }

  //
  Future<List<Books>> getAllBooks() async {
    final db = await database;
    List<Map> results =
        await db!.query("${Books.BOOKMARKS}", columns: Books.columns);
    List<Books> medialist = [];
    results.forEach((result) {
      Books media = Books.fromMap(result as Map<String, dynamic>);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  bookMarkBook(Books? books) async {
    final db = await database;
    Batch batch = db!.batch();
    batch.insert(Books.BOOKMARKS, books!.toMap());
    await batch.commit(noResult: true);
  }

  //userdata crud
  Future<bool> isBookBookmarked(Books? books) async {
    final db = await database;
    List<Map> results = await db!.query("${Books.BOOKMARKS}",
        columns: Books.columns, where: "bookid = ?", whereArgs: [books!.id]);
    return results.length > 0;
  }

  deleteBookmarkedBooks(Books? books) async {
    final db = await database;
    db!.delete("${Books.BOOKMARKS}",
        where: "bookid = ?", whereArgs: [books!.id]);
  }

  //downloaded christian books
  Future<List<Books>> getAllDownloadedBooks() async {
    final db = await database;
    List<Map> results =
        await db!.query("${Books.DOWNLOADS}", columns: Books.columns);
    List<Books> medialist = [];
    results.forEach((result) {
      Books media = Books.fromMap(result as Map<String, dynamic>);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

//downloaded books
  addDownloadedBook(Books? books) async {
    final db = await database;
    Batch batch = db!.batch();
    batch.insert(Books.DOWNLOADS, books!.toMap());
    await batch.commit(noResult: true);
  }

  //userdata crud
  Future<bool> isBookDownloaded(Books? books) async {
    final db = await database;
    List<Map> results = await db!.query("${Books.DOWNLOADS}",
        columns: Books.columns, where: "bookid = ?", whereArgs: [books!.id]);
    return results.length > 0;
  }

  Future<Books?> getDownloadedBook(Books? books) async {
    final db = await database;
    List<Map> results = await db!.query("${Books.DOWNLOADS}",
        columns: Books.columns, where: "bookid = ?", whereArgs: [books!.id]);
    List<Books> medialist = [];
    results.forEach((result) {
      Books media = Books.fromMap(result as Map<String, dynamic>);
      medialist.add(media);
    });
    return medialist.length > 0 ? medialist[0] : null;
  }

  deleteDownloadedBook(Books books) async {
    final db = await database;
    db!.delete("${Books.DOWNLOADS}",
        where: "bookid = ?", whereArgs: [books.id]);
  }

  Future<int> updateDownloadedBook(Books? books) async {
    var db = await this.database;
    var result = await db!.update(Books.DOWNLOADS, books!.toMap(),
        where: "bookid = ?", whereArgs: [books.id]);
    print(result);
    return result;
  }

  //countries
  addAllCountries(List<Itms>? items) async {
    final db = await database;
    Batch batch = db!.batch();
    items!.forEach((element) {
      batch.insert(Itms.TABLE, element.toMap());
    });
    await batch.commit(noResult: true);
  }

  deleteallcountries() async {
    final db = await database;
    db!.rawDelete("DELETE FROM ${Itms.TABLE}");
  }

  Future<List<Itms>> getallcountries() async {
    final db = await database;
    List<Map> results = await db!.query("${Itms.TABLE}", columns: Itms.columns);
    List<Itms> medialist = [];
    results.forEach((result) {
      Itms media = Itms.fromMap(result as Map<String, dynamic>);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  //bokmarked articles
  Future<List<Articles>> getAllBookmarkedArticles() async {
    final db = await database;
    List<Map> results =
        await db!.query("${Articles.BOOKMARKS}", columns: Articles.columns);
    List<Articles> medialist = [];
    results.forEach((result) {
      Articles media = Articles.fromMap(result as Map<String, dynamic>);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  bookmarkArticle(Articles? articles) async {
    final db = await database;
    Batch batch = db!.batch();
    batch.insert(Articles.BOOKMARKS, articles!.toMap());
    await batch.commit(noResult: true);
  }

  deleteArticleBookmark(Articles? articles) async {
    final db = await database;
    db!.delete("${Articles.BOOKMARKS}",
        where: "id = ?", whereArgs: [articles!.id]);
  }
}

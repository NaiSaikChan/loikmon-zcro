import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../database/SQLiteDbProvider.dart';

class DownloadedBooksModel with ChangeNotifier {
  List<Books> books = [];

  DownloadedBooksModel() {
    getAllItems();
  }

  getAllItems() async {
    books = [];
    books = await SQLiteDbProvider.db.getAllDownloadedBooks();
    //bookmarksList.reversed.toList();
    notifyListeners();
  }

  bool isBookDownloaded(Books? ebook) {
    Books? itm = books.firstWhereOrNull((itm) => ((itm.id == ebook!.id)));
    if (itm == null) return false;
    if ((itm.epubhttp == 0 && ebook!.epub == "") && itm.pdfhttp == 1)
      return true;
    print("01");
    if ((itm.pdfhttp == 0 && ebook!.book == "") && itm.epubhttp == 1)
      return true;
    print("02");
    if (itm.pdfhttp == 1 && itm.epubhttp == 1) return true;
    print("03");
    return false;
  }

  Future<Books> getPDFBookDownloaded(Books ebook) async {
    print("getbook");
    Books? itm = books.firstWhereOrNull(
        (itm) => ((itm.id == ebook.id && itm.type == ebook.type)));
    if (itm == null) {
      return ebook;
    }
    if (itm.pdfhttp == 1) {
      return itm;
    }
    return ebook;
  }

  Future<Books> getEPUBBookDownloaded(Books? ebook) async {
    Books? itm = books.firstWhereOrNull(
        (itm) => ((itm.id == ebook!.id && itm.type == ebook.type)));
    if (itm == null) {
      return ebook!;
    }
    if (itm.epubhttp == 1) {
      return itm;
    }
    return ebook!;
  }

  Books? getDownloadedMedia(Books? ebook) {
    return books.firstWhereOrNull((itm) => (itm.id == ebook!.id));
  }

  deleteBook(Books ebook) async {
    //Books? _books = await SQLiteDbProvider.db.getDownloadedBook(ebook);
    //if (_books != null) {
    //final directory = await getApplicationDocumentsDirectory();
    //final path = directory.path;
    //print('path ${path}');
    if (ebook.pdfhttp == 0) {
      File file = File(ebook.book!);
      try {
        await file.delete();
      } catch (e) {
        print(e.toString());
      }
    }
    if (ebook.epubhttp == 0) {
      File file2 = File(ebook.epub!);
      try {
        await file2.delete();
      } catch (e) {
        print(e.toString());
      }
    }

    await SQLiteDbProvider.db.deleteDownloadedBook(ebook);
    getAllItems();
    //}
  }

  downloadBook(BuildContext context, Books book, int option) {
    shouldDownloadBook(context, book, option);
  }

  Future shouldDownloadBook(
      BuildContext context, Books book, int option) async {
    final ProgressDialog pd = ProgressDialog(context,
        type: ProgressDialogType.download,
        isDismissible: false,
        showLogs: true);
    try {
      pd.style(
          message: ' Downloading ' + book.title!,
          borderRadius: 10.0,
          backgroundColor: const Color.fromARGB(255, 243, 241, 241),
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyles.display1(context).copyWith(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyles.display1(context).copyWith(
              color: Colors.black,
              fontSize: 19.0,
              fontWeight: FontWeight.w600));
      await pd.show();
      var directory = await (getExternalStorageDirectory());
      //String fullPath = tempDir.path + "/boo2.pdf'";
      var path = directory!.path;
      String savePath = "$path/" + book.title!.replaceAll(" ", "_") + ".pdf";
      if (option == 1) {
        savePath = "$path/" + book.title!.replaceAll(" ", "_") + ".epub";
      }
      print("save path = " + savePath);
      Dio dio = Dio();
      Response response = await dio.get(
        option == 0 ? book.book! : book.epub!,
        onReceiveProgress: (rec, total) async {
          double progress = double.parse(((rec / total)).toStringAsFixed(1));

          print(progress);
          int _progress = (((rec / total) * 100).toInt());
          if (_progress < 100) {
            pd.update(
              progress: progress * 100,
              message: "Please wait...",
              progressWidget: Container(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator()),
              maxProgress: 100.0,
              progressTextStyle: TextStyles.display1(context).copyWith(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400),
              messageTextStyle: TextStyles.display1(context).copyWith(
                  color: Colors.black,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600),
            );
          } else {
            await pd.hide();
            //Toast.show(book.title + " downloaded successfully.", context);
            Books? _books = await SQLiteDbProvider.db.getDownloadedBook(book);
            if (_books != null) {
              if (option == 0) {
                Books books = Books.fromBook(
                    _books, savePath, _books.epub!, 1, _books.epubhttp!);
                await SQLiteDbProvider.db.updateDownloadedBook(books);
              } else {
                Books books = Books.fromBook(
                    _books, _books.book!, savePath, _books.pdfhttp!, 1);
                await SQLiteDbProvider.db.updateDownloadedBook(books);
              }
            } else {
              if (option == 0) {
                Books books =
                    Books.fromBook(book, savePath, "", 1, book.epubhttp!);
                await SQLiteDbProvider.db.addDownloadedBook(books);
              } else {
                Books books = Books.fromBook(book, "", savePath, 0, 1);
                await SQLiteDbProvider.db.addDownloadedBook(books);
              }
            }

            getAllItems();
          }
        },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      //print(response.headers);

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
      await pd.hide();
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  removeDownloadedBook(BuildContext context, Books books) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.deletemedia),
              content: new Text(t.deletemediahint),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteBook(books);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}

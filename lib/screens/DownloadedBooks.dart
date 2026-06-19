import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/providers/DownloadedBooksModel.dart';
import 'package:loikmon/screens/EmptyListScreen.dart';
import 'package:loikmon/widgets/BooksTile.dart';
import 'package:provider/provider.dart';

class DownloadedBooks extends StatefulWidget {
  DownloadedBooks();

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<DownloadedBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DownloadedEbooksListScreenBody("books"),
    );
  }
}

class DownloadedEbooksListScreenBody extends StatelessWidget {
  DownloadedEbooksListScreenBody(this.type);
  final String type;
  @override
  Widget build(BuildContext context) {
    DownloadedBooksModel ebooksListModel =
        Provider.of<DownloadedBooksModel>(context);
    List<Books> items = ebooksListModel.books;
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: items.length == 0
          ? EmptyListScreen(message: t.noitemstodisplay)
          : LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 700 ? 4 : 2,
                      crossAxisSpacing: 0.0,
                      //childAspectRatio: 0.1,
                      mainAxisExtent: 330,
                      mainAxisSpacing: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return BooksTile(
                      false,
                      index: index,
                      books: items[index],
                    );
                  },
                );
              },
            ),
    );
  }
}

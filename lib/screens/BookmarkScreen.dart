import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/widgets/BooksTile.dart';
import 'package:provider/provider.dart';

import '../providers/BookmarksModel.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late BookmarksModel mediaScreensModel;
  late List<Books> items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<BookmarksModel>(context);
    items = mediaScreensModel.bookmarksList;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 60, right: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Appbar(),
            Expanded(
              child: (items.length == 0)
                  ? Center(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(t.noitemstodisplay,
                              textAlign: TextAlign.center,
                              style: TextStyles.display1(context)
                                  .copyWith(fontSize: 18)),
                        ),
                      ),
                    )
                  : AutoHeightGridView(
                      itemCount: items.length,
                      crossAxisCount: Utility.getBookItemCount(context),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 8.0,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      shrinkWrap: true,
                      builder: (context, index) {
                        return BooksTile(
                          false,
                          index: (items.length - index),
                          books: items[index],
                        );
                      },
                    ),
            ),
            // MiniPlayer(),
          ],
        ),
      ),
    );
  }
}

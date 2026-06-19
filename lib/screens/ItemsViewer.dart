import 'package:flutter/material.dart';
import 'package:loikmon/utils/TextStyles.dart';

class ItemsViewer extends StatefulWidget {
  static const routeName = "itemsViewer";
  ItemsViewer({this.title, this.content});
  final String? title;
  final String? content;

  @override
  State<ItemsViewer> createState() => _ArticleViewerState();
}

class _ArticleViewerState extends State<ItemsViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title!,
          style: TextStyles.display1(context).copyWith(
              //fontFamily: 'style2',
              fontSize: 17),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 12,
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          widget.content!,
          style: TextStyles.display1(context).copyWith(
            fontSize: 17,
            //fontFamily: 'style1',
          ),
        ),
      ),
    );
  }
}

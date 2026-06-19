import 'package:flutter/material.dart';
import 'package:loikmon/models/Books.dart';

class BooksViewerScreen extends StatefulWidget {
  static const routeName = "/BooksViewerScreen";
  final Books? books;
  BooksViewerScreen({this.books});

  @override
  State<BooksViewerScreen> createState() => _BooksViewerScreenState();
}

class _BooksViewerScreenState extends State<BooksViewerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

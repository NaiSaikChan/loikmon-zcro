import 'package:flutter/material.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/providers/DashboardModel.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:provider/provider.dart';

class EbooksInfo extends StatefulWidget {
  EbooksInfo(this.books);
  final Books? books;

  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<EbooksInfo> {
  late DashboardModel dashboardModel;
  bool isSubscribed = false;

  onRetryClick() {
    dashboardModel.loadItems();
  }

  @override
  void initState() {
    //Provider.of<DashboardModel>(context, listen: false).fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dashboardModel = Provider.of<DashboardModel>(context);

    return Container(
      //color: Colors.white,
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          header("Category"),
          body(widget.books!.categoryname!),
          _divide(),
          header("Author"),
          body(widget.books!.author!),
          _divide(),
          header("Publisher"),
          body(widget.books!.publisher!),
          _divide(),
          header("Date Published"),
          body(widget.books!.datepublished!),
          _divide(),
          header("No of Pages/Words"),
          body(widget.books!.pages!),
          _divide(),
          header("Available Formats"),
          body(getformats() + (widget.books!.hasAudio! ? ", Audio" : "")),
          _divide(),
          if (widget.books!.hasAudio!) header("Audio Duration"),
          if (widget.books!.hasAudio!) body(widget.books!.audioduration!),
          if (widget.books!.hasAudio!) _divide(),
        ],
      ),
    );
  }

  String getformats() {
    if (widget.books!.book != "" && widget.books!.epub != "") {
      return "PDF, EPUB";
    } else if (widget.books!.book != "") {
      return "PDF";
    } else {
      return "EPUB";
    }
  }

  Divider _divide() {
    return Divider(
      color: Colors.grey,
    );
  }

  Widget header(String title) {
    return Container(
      height: 20,
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyles.display1(context).copyWith(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget body(String title) {
    return Container(
      //height: 20,
      padding: const EdgeInsets.only(left: 10, right: 0, top: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyles.display1(context).copyWith(
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }
}

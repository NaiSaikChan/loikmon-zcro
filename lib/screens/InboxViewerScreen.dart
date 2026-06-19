import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/utils/network_image.dart';
import 'package:http/http.dart' as http;

import '../i18n/strings.g.dart';
import '../models/Inbox.dart';
import '../utils/TextStyles.dart';
import 'NoitemScreen.dart';

class InboxViewerScreen extends StatefulWidget {
  static const routeName = "/inboxviewer";
  const InboxViewerScreen({Key? key, this.inbox}) : super(key: key);
  final Inbox? inbox;

  @override
  _InboxViewerScreenState createState() => _InboxViewerScreenState();
}

class _InboxViewerScreenState extends State<InboxViewerScreen> {
  bool isLoading = false;
  bool isError = false;

  Future<void> approveuserrequest() async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      var data = {
        "id": widget.inbox!.id!,
      };
      final response = await http.post(Uri.parse(ApiUrl.approvebook),
          body: jsonEncode({"data": data}));
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Alerts.showToast(context, "You have approved this payment.");
        Navigator.of(context).pop();
      } else {
        Alerts.show(context, "", t.cannotprocess);
      }
    } catch (exception) {
      Navigator.of(context).pop();
      Alerts.show(context, "", exception.toString());
    }
  }

  Future<void> deleteuserrequest() async {
    Alerts.showProgressDialog(
      context,
      t.processingpleasewait,
    );
    try {
      var data = {
        "id": widget.inbox!.id!,
      };
      final response = await http.post(Uri.parse(ApiUrl.deleteproofrequest),
          body: jsonEncode({"data": data}));
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Alerts.showToast(context, "You have deleted this payment proof");
        Navigator.of(context).pop();
      } else {
        Alerts.show(context, "", t.cannotprocess);
      }
    } catch (exception) {
      Navigator.of(context).pop();
      Alerts.show(context, "", exception.toString());
    }
  }

  @override
  void initState() {
    /*Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        title: Text("Inbox"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: SingleChildScrollView(
          child: getEventsBody(),
        ),
      ),
    );
  }

  Widget getEventsBody() {
    if (isLoading) {
      return Container(
        height: 600,
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
      );
    } else if (isError || widget.inbox == null) {
      return Container(
        height: 600,
        child: Center(
          child: NoitemScreen(
              title: t.oops,
              message: t.dataloaderror,
              onClick: () {
                //loadItems();
              }),
        ),
      );
    } else
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Payment from " + widget.inbox!.email!,
                  textAlign: TextAlign.start,
                  style: TextStyles.headline(context)
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Container(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.inbox!.date!,
                  textAlign: TextAlign.justify,
                  style: TextStyles.subhead(context).copyWith(fontSize: 16)),
            ),
            Container(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10, top: 8),
              //width: 50,
              //height: 80,
              height: 500,
              child: PNetworkImage(
                widget.inbox!.thumbnail!,
                fit: BoxFit.fill,
                height: double.infinity,
              ),
            ),
            Container(height: 20),
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 40,
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextButton(
                      child: Text("Approve",
                          style: TextStyles.subhead(context).copyWith(
                              color: MyColors.white,
                              fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        backgroundColor: MyColors.mainC0lor,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: new Text("Approve payment"),
                                  content: new Text(
                                      "When you click ok, you confirm that the payment have been recieved by you and user should be granted the book he paid for."),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDefaultAction: false,
                                      child: Text(t.ok),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        approveuserrequest();
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
                      },
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextButton(
                      child: Text("Delete",
                          style: TextStyles.subhead(context).copyWith(
                              color: MyColors.white,
                              fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: new Text("Delete payment"),
                                  content: new Text(
                                      "When you click ok, this request will be deleted and user will not be granted the book he paid for."),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDefaultAction: false,
                                      child: Text(t.ok),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteuserrequest();
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
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 20),
          ],
        ),
      );
  }
}

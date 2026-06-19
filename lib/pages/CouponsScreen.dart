import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Coins.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponsScreen extends StatefulWidget {
  CouponsScreen(this.coins);
  final Coins? coins;

  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  Itms? itms;
  bool isError = false;
  bool isLoading = false;
  TextEditingController? textEditingController = TextEditingController();

  Future<void> redeemCode(String coupon) async {
    Alerts.showProgressDialog(
      context,
      t.processingpleasewait,
    );
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    try {
      var data = {
        "code": coupon,
        "coinsid": widget.coins!.id!,
        "value": widget.coins!.value,
        "amount": widget.coins!.amount,
        "email": userdata == null ? "Test User" : userdata.email,
      };
      print(data);
      final response = await http.post(
        Uri.parse(ApiUrl.subscribeCoupon),
        body: jsonEncode({"data": data}),
      );
      Navigator.of(context).pop();
      final res = jsonDecode(response.body);
      if (res['status'] == "ok") {
        Provider.of<AppStateManager>(context, listen: false).getUserCoins();
        Alerts.showwithcallback(context, "", res['msg'], () {
          Navigator.of(context).pop();
        });
      } else {
        Alerts.show(context, "", res['msg']);
      }
    } catch (exception) {
      // I get no exception here
      print("code error = " + exception.toString());
      Alerts.show(context, t.error, exception.toString());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              //Navigator.pop(_context);
              Utility.readme(
                  context, t.couponcodereadmetitle, t.couponcodereadmecontent);
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.grey_40.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(left: 30, right: 20, top: 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  t.couponcodereadmecontent1,
                  textAlign: TextAlign.center,
                  style: TextStyles.display1(context).copyWith(
                      //color: Colors.black,
                      //decoration: TextDecoration.underline,
                      //decorationColor: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 16),
                ),
              ),
            ),
          ),
          // Visibility(
          //   visible: true,
          //   child: Container(
          //     margin: EdgeInsets.only(
          //       left: 20,
          //       right: 20,
          //       top: 0,
          //     ),
          //     width: double.infinity,
          //     child: Text(
          //       t.couponcode,
          //       style: TextStyles.display1(context).copyWith(
          //         fontSize: 18,
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.text,
                      cursorColor: const Color.fromARGB(255, 255, 64, 223),
                      decoration: InputDecoration(
                        hintText: t.entercouponcode,
                      ),
                      style: TextStyle(fontSize: 16)),
                ),
                IconButton(
                    onPressed: () async {
                      Userdata? userdata =
                          await SQLiteDbProvider.db.getUserData();
                      if (userdata == null) {
                        Alerts.subscriptionloginrequiredhint(context);
                      } else if (textEditingController!.text == "") {
                        Alerts.showToast(context, t.entercopounalert);
                      } else {
                        redeemCode(textEditingController!.text);
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: MyColors.mainC0lor,
                    ))
              ],
            ),
          ),
          Container(height: 50),
          InkWell(
            onTap: () async {
              if (!await launchUrl(
                Uri.parse("https://m.me/116324818154323"),
                mode: LaunchMode.externalApplication,
              )) {
                //throw Exception('Could not launch link');
                Alerts.showToast(context, 'Could not launch link');
              }
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColors.mainC0lor,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              // margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.facebookMessenger,
                    color: MyColors.mainC0lor,
                    size: 40,
                  ),
                  Container(
                    width: 30,
                  ),
                  Text(
                    t.getcoupononmessegner,
                    style: TextStyles.display1(context)
                        .copyWith(color: MyColors.mainC0lor, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          /*   Visibility(
            visible: true,
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.books!.phone1! != "",
            child: InkWell(
              onTap: () async {
                //Navigator.pop(_context);
                Uri phoneno = Uri.parse(widget.books!.phone1!);
                if (!await launchUrl(
                  (phoneno),
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch link');
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.mainC0lor, width: 1),
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.only(left: 80, right: 80, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 5,
                    ),
                    Icon(
                      LineAwesomeIcons.phone,
                      color: MyColors.mainC0lor,
                    ),
                    Text(
                      widget.books!.phone1!,
                      style: TextStyle(
                        color: MyColors.mainC0lor,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),*/
          /*Visibility(
            visible: widget.books!.phone2! != "",
            child: InkWell(
              onTap: () async {
                //Navigator.pop(_context);
                Uri phoneno = Uri.parse(widget.books!.phone2!);
                if (!await launchUrl(
                  (phoneno),
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch link');
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.mainC0lor, width: 1),
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.only(left: 80, right: 80, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 5,
                    ),
                    Icon(
                      LineAwesomeIcons.phone,
                      color: MyColors.mainC0lor,
                    ),
                    Text(
                      widget.books!.phone2!,
                      style: TextStyle(
                        color: MyColors.mainC0lor,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),*/
          Container(
            height: 50,
          )
        ],
      ),
    );
  }
}

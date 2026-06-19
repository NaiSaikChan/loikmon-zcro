import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Banks.dart';
import 'package:loikmon/models/Coins.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/pages/CouponsScreen.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/SubscriptionModel.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/utils/network_image.dart';
import 'package:provider/provider.dart';

class BuyBook extends StatefulWidget {
  static const routeName = "/BuyBook";
  BuyBook(this.coins);
  final Coins? coins;

  @override
  _EbookReviewsState createState() => _EbookReviewsState();
}

class _EbookReviewsState extends State<BuyBook> {
  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    SubscriptionModel subscriptionModel =
        Provider.of<SubscriptionModel>(context);
    ProductDetails? _productDetails = subscriptionModel
        .getProductFromPurchaseDetails(widget.coins!.productid!);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            t.paymentdetails,
            style: TextStyles.display0(context).copyWith(fontSize: 20),
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Container(
            margin: MediaQuery.of(context).size.width > 1200
                ? EdgeInsets.only(left: 450, right: 450)
                : EdgeInsets.only(left: 200, right: 200),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 10),
                  height: 130,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Positioned(
                        left: 80,
                        right: 0,
                        top: 10,
                        bottom: 0,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            //color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 40),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 12,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.coins!.name!,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyles.display1(context).copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.coins!.value!.toString() + " Coins ",
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyles.display1(context).copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _productDetails == null
                                      ? "\฿" + widget.coins!.amount.toString()
                                      : _productDetails.price,
                                  style: TextStyles.display1(context).copyWith(
                                    fontSize: 17,
                                    fontFamily: "",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, top: 15),
                          width: 80,
                          height: 100,
                          child: Icon(
                            LineAwesomeIcons.coins_solid,
                            color: Colors.orange,
                            size: 50,
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0, left: 0, right: 0, child: Divider()),
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  margin: EdgeInsets.fromLTRB(6, 10, 16, 0),
                  padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.mainC0lor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: const Color.fromARGB(66, 254, 58, 225),
                    ),
                    //labelColor: const Color.fromARGB(255, 245, 243, 243),
                    //indicatorPadding: EdgeInsets.all(10),

                    labelStyle: TextStyles.display1(context).copyWith(
                      fontSize: 17,
                    ),
                    tabs: [
                      Tab(text: t.paywithcoupon),
                      Tab(text: t.mobilebanking),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: [
                        CouponsScreen(widget.coins!),
                        BankScreen(widget.coins!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class BankScreen extends StatefulWidget {
  BankScreen(this.coins, {Key? key}) : super(key: key);
  final Coins? coins;

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  Itms? itms;
  bool isError = false;
  bool isLoading = false;
  List<Banks> banks = [];
  FilePickerResult? file;

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
              Utility.readme(context, t.couponcodereadmetitle2,
                  t.couponcodereadmecontent2);
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(left: 30, right: 20, top: 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  t.couponcodereadmecontent3,
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
          Container(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            child: Text(
              t.choosecountry,
              style: TextStyles.display1(context).copyWith(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(width: 0.6, color: const Color(0xFF999999))),
            // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: DropdownButton(
              isExpanded: true,
              dropdownColor: appStateManager.isDarkModeOn
                  ? MyColors.headerdark
                  : MyColors.white,

              hint: Text(
                t.nocountryselected,
                style: TextStyles.display1(context).copyWith(
                  fontSize: 17,
                  color: appStateManager.isDarkModeOn
                      ? const Color.fromARGB(255, 238, 235, 235)
                      : MyColors.headerdark,
                ),
              ),

              value: itms, //implement initial value or selected value
              onChanged: (value) {
                itms = value as Itms;
                setState(() {});
                loadbanks(widget.coins, itms!.id!);
              },
              items: appStateManager.countries.map((facility) {
                return DropdownMenuItem(
                    value: facility, child: Text(facility.title!));
              }).toList(),
            ),
          ),
          Visibility(
            visible: banks.length != 0,
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              width: double.infinity,
              child: Text(
                t.paymentmethods,
                style: TextStyles.display1(context).copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          isLoading
              ? Container(
                  height: 35,
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoActivityIndicator(),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      Text(
                        t.loadingbanks,
                        style: TextStyles.display1(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : Container(),
          isError
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(t.unabletoloadbanks,
                          textAlign: TextAlign.center,
                          style: TextStyles.medium(context).copyWith(
                              //color: MyColors.primary
                              fontSize: 18)),
                    ),
                    Container(height: 5),
                    Container(
                      width: 180,
                      height: 40,
                      child: TextButton(
                        child: Text(t.retry,
                            style: TextStyles.display1(context).copyWith(
                                color:
                                    const Color.fromARGB(255, 242, 240, 240))),
                        style: TextButton.styleFrom(
                          backgroundColor: MyColors.mainC0lor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          loadbanks(widget.coins, itms!.id!);
                        },
                      ),
                    )
                  ],
                )
              : Container(),
          (banks.length == 0 && !isLoading && !isError && itms != null)
              ? Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        t.nobanksforcountry,
                        style: TextStyles.display1(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                Banks? _bank = banks[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)
                      //color: Colors.grey,
                      ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 1),
                      childrenPadding: EdgeInsets.zero,
                      iconColor: Theme.of(context).iconTheme.color,
                      collapsedIconColor: Theme.of(context).iconTheme.color,
                      title: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 40,
                            margin: const EdgeInsets.only(right: 5, left: 3),
                            padding: EdgeInsets.all(0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              child: PNetworkImage(
                                _bank.thumbnail!,
                                fit: BoxFit.contain,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _bank.accountname!,
                              style: TextStyles.display1(context).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 12,
                            bottom: 12,
                          ),
                          child: HtmlWidget(
                            _bank.details!,
                            textStyle: TextStyles.display1(context).copyWith(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4, bottom: 4),
                          child: const Divider(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: banks.length != 5,
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              width: double.infinity,
              child: Text(
                t.attachproofofpayment,
                style: TextStyles.display1(context).copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Visibility(
            visible: banks.length != 5,
            child: InkWell(
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    file = result;
                  });
                }
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.only(left: 30, right: 30, top: 7),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Row(
                  children: [
                    Container(
                        width: 120,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Center(
                            child: Text(
                          t.selectafile,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ))),
                    Container(
                        width: 160,
                        padding: EdgeInsets.only(
                            left: 3, right: 3, top: 3, bottom: 3),
                        child: Center(
                            child: Text(
                          file == null
                              ? t.nofilechoosen
                              : file!.files.first.name,
                          maxLines: 2,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 12,
                          ),
                        ))),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: banks.length != 5,
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  Userdata? userdata = await SQLiteDbProvider.db.getUserData();
                  if (userdata == null) {
                    Alerts.subscriptionloginrequiredhint(context);
                  } else if (file == null) {
                    Alerts.showToast(context, t.pleaseselectafiletoupload);
                  } else {
                    submitPosttoServer(userdata.email!);
                  }
                },
                child: Text(
                  t.submitpaymentproof,
                  style: TextStyle(
                    fontFamily: "style1",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    iconColor: MyColors.mainC0lor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  loadbanks(Coins? coins, int country) {
    isLoading = true;
    isError = false;
    setState(() {});
    fetchbanksserver(coins, country);
  }

  setReviewFetchError() {
    isLoading = false;
    isError = true;
    setState(() {});
  }

  Future<void> fetchbanksserver(Coins? coins, int country) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.loadbanks),
        body: jsonEncode({
          "data": {
            "country": country,
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        isLoading = false;
        isError = false;

        dynamic res = jsonDecode(response.body);
        banks = parsebanks(res);
        setState(() {});
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setReviewFetchError();
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      setReviewFetchError();
    }
  }

  static List<Banks> parsebanks(dynamic res) {
    final parsed = res["banks"].cast<Map<String, dynamic>>();
    return parsed.map<Banks>((json) => Banks.fromJson(json)).toList();
  }

  submitPosttoServer(String email) async {
    Alerts.showProgressDialog(
      context,
      t.processingpleasewait,
    );

    try {
      Map<String, String> formData = {
        "coinsid": widget.coins!.id!.toString(),
        "value": widget.coins!.value.toString(),
        "amount": widget.coins!.amount.toString(),
        "email": email,
      };
      var request =
          new http.MultipartRequest("POST", Uri.parse(ApiUrl.proofofpayment));
      request.fields.addAll(formData);
      request.files.add(http.MultipartFile.fromBytes(
          "file", file!.files.first.bytes!,
          filename: "file.png"));
      request.send().then((response) {
        if (response.statusCode == 200) {
          // Navigator.pop(context);
          // If the server did return a 200 OK response,
          // then parse the JSON.
          Navigator.of(context).pop();
          Alerts.show(context, t.success, t.paymentofproofsuccess);
          //Alerts.show(context, t.success, t.paymentofproofsuccess);
        } else {
          Alerts.show(context, t.error, t.paymentofprooferror);
        }
        Provider.of<AppStateManager>(context, listen: false)
            .getUserpendingpurchases();
      });
    } catch (e) {
      Navigator.of(context).pop();
      Alerts.show(context, t.error, e.toString());
    }
  }

  Widget getItem(String title, String content, bool isbold) {
    return Container(
        height: 40,
        margin: EdgeInsets.only(left: 20, right: 20, top: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: 10,
          ),
          Text(
            title,
            style: TextStyles.display1(context).copyWith(
              fontSize: 17,
              // fontWeight: isbold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Spacer(),
          Text(
            content,
            style: TextStyles.display1(context).copyWith(
              fontSize: 17,
              // fontWeight: isbold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ]));
  }
}

class BankScreenOLD extends StatefulWidget {
  BankScreenOLD(this.coins, {Key? key}) : super(key: key);
  final Coins? coins;

  @override
  State<BankScreenOLD> createState() => _BankScreenStateOLD();
}

class _BankScreenStateOLD extends State<BankScreenOLD> {
  Itms? itms;
  bool isError = false;
  bool isLoading = false;
  List<Banks> banks = [];
  FilePickerResult? file;

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
              Utility.readme(context, t.couponcodereadmetitle2,
                  t.couponcodereadmecontent2);
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(left: 30, right: 20, top: 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  t.learnmore,
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
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            child: Text(
              t.choosecountry,
              style: TextStyles.display1(context).copyWith(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(width: 0.6, color: const Color(0xFF999999))),
            // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: DropdownButton(
              isExpanded: true,
              dropdownColor: appStateManager.isDarkModeOn
                  ? MyColors.headerdark
                  : MyColors.white,
              hint: Text(
                t.nocountryselected,
                style: TextStyles.display1(context).copyWith(
                  color: appStateManager.isDarkModeOn
                      ? Colors.white
                      : MyColors.headerdark,
                ),
              ),
              value: itms, //implement initial value or selected value
              onChanged: (value) {
                itms = value as Itms;
                setState(() {});
                loadbanks(widget.coins, itms!.id!);
              },
              items: appStateManager.countries.map((facility) {
                return DropdownMenuItem(
                    value: facility, child: Text(facility.title!));
              }).toList(),
            ),
          ),
          Visibility(
            visible: banks.length != 0,
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              width: double.infinity,
              child: Text(
                t.paymentmethods,
                style: TextStyles.display1(context).copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          isLoading
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoActivityIndicator(),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      Text(
                        t.loadingbanks,
                        style: TextStyles.display1(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : Container(),
          isError
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(t.unabletoloadbanks,
                          textAlign: TextAlign.center,
                          style: TextStyles.medium(context).copyWith(
                              //color: MyColors.primary
                              fontSize: 18)),
                    ),
                    Container(height: 5),
                    Container(
                      width: 180,
                      height: 40,
                      child: TextButton(
                        child: Text(t.retry,
                            style: TextStyles.display1(context).copyWith(
                                color:
                                    const Color.fromARGB(255, 243, 241, 241))),
                        style: TextButton.styleFrom(
                          backgroundColor: MyColors.mainC0lor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          loadbanks(widget.coins, itms!.id!);
                        },
                      ),
                    )
                  ],
                )
              : Container(),
          (banks.length == 0 && !isLoading && !isError && itms != null)
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ColoredBox(color: const Color.fromARGB(255, 181, 22, 22)),
                      Text(
                        t.nobanksforcountry,
                        style: TextStyles.display1(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                Banks? _bank = banks[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)
                      //color: Colors.grey,
                      ),
                  /* child: SimpleAccordion(
                    children: [
                      AccordionHeaderItem(
                        child: Container(
                          height: 40,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 15),
                                width: 100,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: PNetworkImage(
                                    _bank.thumbnail!,
                                    fit: BoxFit.fill,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              Text(
                                _bank.accountname!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          AccordionItem(
                            child: Container(
                                margin: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 12,
                                  bottom: 12,
                                ),
                                child: HtmlWidget(
                                  _bank.details!,
                                  textStyle: TextStyle(
                                    fontSize: 17,
                                    // fontWeight: isbold ? FontWeight.bold : FontWeight.normal,
                                  ),
                                )),
                          ),
                          AccordionItem(
                              child: Container(
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                            child: Divider(),
                          )),
                        ],
                      ),
                    ],
                  ),*/
                );
              },
            ),
          ),
          Visibility(
            visible: banks.length != 0,
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              width: double.infinity,
              child: Text(
                t.attachproofofpayment,
                style: TextStyles.display1(context).copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Visibility(
            visible: banks.length != 0,
            child: InkWell(
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    file = result;
                  });
                }
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.only(left: 30, right: 30, top: 7),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Row(
                  children: [
                    Container(
                        width: 120,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Center(
                            child: Text(
                          t.selectafile,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 243, 240, 240),
                          ),
                        ))),
                    Container(
                        width: 160,
                        padding: EdgeInsets.only(
                            left: 3, right: 3, top: 3, bottom: 3),
                        child: Center(
                            child: Text(
                          file == null
                              ? t.nofilechoosen
                              : file!.files.first.name,
                          maxLines: 2,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 16,
                          ),
                        ))),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: banks.length != 0,
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  Userdata? userdata = await SQLiteDbProvider.db.getUserData();
                  if (userdata == null) {
                    Alerts.subscriptionloginrequiredhint(context);
                  } else if (file == null) {
                    Alerts.showToast(context, t.pleaseselectafiletoupload);
                  } else {
                    submitPosttoServer(userdata.email!);
                  }
                },
                child: Text(
                  t.submitpaymentproof,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      backgroundColor: MyColors.mainC0lor,
                      // color: Colors.white,
                      color: MyColors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.mainC0lor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  loadbanks(Coins? coins, int country) {
    isLoading = true;
    isError = false;
    setState(() {});
    fetchbanksserver(coins, country);
  }

  setReviewFetchError() {
    isLoading = false;
    isError = true;
    setState(() {});
  }

  Future<void> fetchbanksserver(Coins? coins, int country) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.loadbanks),
        body: jsonEncode({
          "data": {
            "country": country,
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        isLoading = false;
        isError = false;

        dynamic res = jsonDecode(response.body);
        banks = parsebanks(res);
        setState(() {});
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setReviewFetchError();
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      setReviewFetchError();
    }
  }

  static List<Banks> parsebanks(dynamic res) {
    final parsed = res["banks"].cast<Map<String, dynamic>>();
    return parsed.map<Banks>((json) => Banks.fromJson(json)).toList();
  }

  submitPosttoServer(String email) async {
    Alerts.showProgressDialog(
      context,
      t.processingpleasewait,
    );

    try {
      Map<String, String> formData = {
        "coinsid": widget.coins!.id!.toString(),
        "value": widget.coins!.value.toString(),
        "amount": widget.coins!.amount.toString(),
        "email": email,
      };

      var request =
          http.MultipartRequest("POST", Uri.parse(ApiUrl.proofofpayment));

      request.fields.addAll(formData);
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          file!.files.first.bytes!,
          filename: file!.files.first.name,
        ),
      );

      final response = await request.send();

      if (!mounted) return;

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        setState(() {
          itms = null;
          banks = [];
          file = null;
          isLoading = false;
          isError = false;
        });

        Alerts.show(context, t.success, t.paymentofproofsuccess);
      } else {
        Alerts.show(context, t.error, t.paymentofprooferror);
      }

      Provider.of<AppStateManager>(context, listen: false)
          .getUserpendingpurchases();
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      Alerts.show(context, t.error, e.toString());
    }
  }

  submitPosttoServer2(String email) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);

    try {
      Map<String, String> formData = {
        "coinsid": widget.coins!.id!.toString(),
        "value": widget.coins!.value.toString(),
        "amount": widget.coins!.amount.toString(),
        "email": email,
      };
      var request =
          new http.MultipartRequest("POST", Uri.parse(ApiUrl.proofofpayment));
      request.fields.addAll(formData);
      request.files.add(http.MultipartFile.fromBytes(
          "file", file!.files.first.bytes!,
          filename: "file.png"));
      request.send().then((response) {
        if (response.statusCode == 200) {
          // Navigator.pop(context);
          // If the server did return a 200 OK response,
          // then parse the JSON.
          Navigator.of(context).pop();

          Alerts.show(context, t.success, t.paymentofproofsuccess);
          file = null;
          setState(() {});
        } else {
          Alerts.show(context, t.error, t.paymentofprooferror);
        }
        Provider.of<AppStateManager>(context, listen: false)
            .getUserpendingpurchases();
      });
    } catch (e) {
      Navigator.of(context).pop();
      Alerts.show(context, t.error, e.toString());
    }
  }

  Widget getItem(String title, String content, bool isbold) {
    return Container(
        height: 40,
        margin: EdgeInsets.only(left: 20, right: 20, top: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              // fontWeight: isbold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Spacer(),
          Text(
            content,
            style: TextStyle(
              fontSize: 17,
              // fontWeight: isbold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ]));
  }
}

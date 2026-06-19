import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/UserEvents.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/events.dart';
import 'package:loikmon/screens/AuthPage.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:increment_decrement_form_field/increment_decrement_form_field.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Alerts {
  static void showToast(BuildContext context, String message) {
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return FlashBar(
            controller: controller,
            behavior: FlashBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              side: BorderSide(
                color: Colors.black,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            margin: const EdgeInsets.all(32.0),
            clipBehavior: Clip.antiAlias,
            indicatorColor: Colors.black,
            icon: Icon(Icons.tips_and_updates_outlined),
            //title: Text('Flash Title'),
            content: Text(message),
          );
        });
  }

  static Future<void> show(context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                t.ok,
                style: TextStyle(fontFamily: 'style1'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showwithcallback(
      context, title, message, Function callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: 'style1')),
          content: SingleChildScrollView(
            child: Text(message, style: TextStyle(fontFamily: 'style1')),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(t.ok),
              onPressed: () {
                Navigator.of(context).pop();
                callback();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showpayalertwithcallback(
      context, title, message, Function callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text(message,
                style: TextStyles.display1(context).copyWith(fontSize: 19)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyles.display1(context).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 213, 42, 42),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                //callback();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MyColors.mainC0lor,
              ),
              child: Text(
                t.buycoins,
                style: TextStyles.display1(context).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 244, 242, 242),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                callback();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showCupertinoAlert(context, title, message) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(title, style: TextStyle(fontFamily: 'style1')),
              content:
                  new Text(message, style: TextStyle(fontFamily: 'style1')),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(t.ok, style: TextStyle(fontFamily: 'style1')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'style1'),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  static subscriptionloginrequiredhint(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.loginrequired),
          content: Text(t.loginrequiredhint),
          actions: <Widget>[
            TextButton(
              child: Text(t.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(t.login.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AuthPage.routeName);
              },
            )
          ],
        );
      },
    );
  }

  static showPaymentDialog(BuildContext _context, Books media) async {
    final bool isdarkmode =
        Provider.of<AppStateManager>(_context, listen: false).isDarkModeOn;

    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      subscriptionloginrequiredhint(_context);
      return;
    }

    int _amount = 0;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: _context,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setstate) {
            Future<void> _showCouponDialog() async {
              final TextEditingController couponController =
                  TextEditingController();

              final String? couponCode = await showDialog<String>(
                context: _context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text(
                      "Purchase with your coupon",
                      style: TextStyle(fontFamily: 'style1'),
                    ),
                    content: TextField(
                      controller: couponController,
                      decoration: const InputDecoration(
                        hintText: "Enter coupon code",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          t.cancel,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext)
                              .pop(couponController.text.trim());
                        },
                        child: const Text("Apply"),
                      ),
                    ],
                  );
                },
              );

              if (couponCode == null || couponCode.isEmpty) {
                return;
              }

              if (Navigator.of(bottomSheetContext).canPop()) {
                Navigator.of(bottomSheetContext).pop();
              }

              final appManager =
                  Provider.of<AppStateManager>(_context, listen: false);
              await appManager.purchaseBookWithCoupon(media, couponCode);
            }

            return Container(
              decoration: BoxDecoration(
                  color: isdarkmode ? MyColors.headerdark : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              // color: isdarkmode ? MyColors.headerdark : Colors.white,
              margin: MediaQuery.of(context).size.width > 1200
                  ? const EdgeInsets.only(left: 450, right: 450)
                  : MediaQuery.of(context).size.width > 800
                      ? const EdgeInsets.only(left: 300, right: 300)
                      : MediaQuery.of(context).size.width > 500
                          ? const EdgeInsets.only(left: 100, right: 100)
                          : const EdgeInsets.only(left: 50, right: 50),
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 6,
                  left: 0,
                  right: 0,
                  bottom: 0,
                ),
                child: Wrap(
                  children: [
                    const SizedBox(height: 23),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: _showCouponDialog,
                        child: const Text(
                          "Have a coupon? Redeem here",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.grey[400], height: 20),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: Center(
                        child: Text(
                          t.youhave +
                              '(' +
                              userdata.coins.toString() +
                              ')' +
                              t.coins,
                          textAlign: TextAlign.center,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(40, 0, 40, 12),
                      child: Center(
                        child: Text(
                          t.selectnormalprice,
                          textAlign: TextAlign.center,
                          style: TextStyles.display1(context)
                              .copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    LineAwesomeIcons.coins_solid,
                                    color: Colors.orange,
                                    size: 25,
                                  ),
                                  Text(
                                    media.amount.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      fontFamily: "",
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const Text(
                                "Normal Price",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  fontFamily: "",
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                          ),
                          child: IncrementDecrementFormField<int>(
                            initialValue: _amount,
                            incrementIconButtonConfig: IconButtonConfig(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            decrementIconButtonConfig: IconButtonConfig(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                            displayBuilder: (value, field) {
                              return Text(
                                value == null ? "0" : value.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              );
                            },
                            onDecrement: (currentValue) {
                              if (currentValue! > 0) {
                                setstate(() {
                                  _amount = _amount - 1;
                                });
                                return currentValue - 1;
                              }
                              return 0;
                            },
                            onIncrement: (currentValue) {
                              setstate(() {
                                _amount = _amount + 1;
                              });
                              return currentValue! + 1;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      color: MyColors.mainC0lor,
                      height: 60,
                      margin: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(_context).pop();
                            },
                            child: Text(
                              t.cancel,
                              style: TextStyles.display0(context).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: "",
                                color: const Color.fromARGB(255, 244, 243, 243),
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Books _article = Books.fromMap(
                                media.toMap2(media.amount! + _amount),
                              );
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: _context,
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50))),
                                builder: (context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setstate) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: isdarkmode
                                              ? MyColors.headerdark
                                              : const Color.fromARGB(
                                                  255, 243, 241, 241),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      margin: MediaQuery.of(context)
                                                  .size
                                                  .width >
                                              1200
                                          ? EdgeInsets.only(
                                              left: 450, right: 450)
                                          : MediaQuery.of(context).size.width >
                                                  800
                                              ? EdgeInsets.only(
                                                  left: 300, right: 300)
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      500
                                                  ? EdgeInsets.only(
                                                      left: 100, right: 100)
                                                  : EdgeInsets.only(
                                                      left: 50, right: 50),
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20))),
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            top: 6,
                                            left: 0,
                                            right: 0,
                                            bottom: 0),
                                        child: Wrap(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                LineAwesomeIcons
                                                    .cart_plus_solid,
                                                size: 60,
                                                color: const Color.fromARGB(
                                                    255, 214, 46, 206),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  20, 10, 20, 0),
                                              child: Center(
                                                child: Text(
                                                  t.forcoin +
                                                      " " +
                                                      "(" +
                                                      _article.amount
                                                          .toString() +
                                                      ")" +
                                                      " " +
                                                      t.makepurchasehint,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    //color: Color(0xFF4B4B4B),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 0,
                                            ),
                                            Container(
                                              color: MyColors.mainC0lor,
                                              height: 60,
                                              margin: EdgeInsets.only(top: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(_context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      t.cancel,
                                                      style:
                                                          TextStyles.display0(
                                                                  context)
                                                              .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                        fontFamily: "",
                                                        color: MyColors.white,
                                                      ),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(_context)
                                                          .pop();
                                                      eventBus.fire(
                                                          OnRequestPayment(
                                                              media));
                                                    },
                                                    child: Text(
                                                      t.proceed,
                                                      style:
                                                          TextStyles.display0(
                                                                  context)
                                                              .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0,
                                                        fontFamily: "",
                                                        color: MyColors.white,
                                                      ),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                              // SweetSheet().show(
                              //   context: _context,
                              //   description: Text(
                              //     "${_article.amount} ${t.makepurchasehint}",
                              //     style: const TextStyle(
                              //       color: Color(0xff2D3748),
                              //       fontFamily: 'style1',
                              //       fontSize: 16,
                              //     ),
                              //   ),
                              //   color: CustomSheetColor(
                              //     main: Colors.white,
                              //     accent: MyColors.mainC0lor,
                              //     icon: MyColors.accent,
                              //   ),
                              //   icon: FontAwesomeIcons.cartPlus,
                              //   positive: SweetSheetAction(
                              //     onPressed: () {
                              //       Navigator.of(_context).pop();
                              //       eventBus.fire(OnRequestPayment(_article));
                              //     },
                              //     title: t.proceed,
                              //   ),
                              //   negative: SweetSheetAction(
                              //     onPressed: () {
                              //       Navigator.of(_context).pop();
                              //     },
                              //     title: t.cancel,
                              //   ),
                              // );
                            },
                            child: Text(
                              t.confirm,
                              style: TextStyles.display0(context).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: const Color.fromARGB(255, 245, 244, 244),
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static showPaymentDialogOLD(BuildContext _context, Books media) async {
    bool isdarkmode =
        Provider.of<AppStateManager>(_context, listen: false).isDarkModeOn;
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      subscriptionloginrequiredhint(_context);
      return;
    }
    int _amount = 0;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: _context,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setstate) {
          return Container(
            color: isdarkmode ? MyColors.headerdark : Colors.white,
            margin: MediaQuery.of(context).size.width > 1200
                ? EdgeInsets.only(left: 450, right: 450)
                : MediaQuery.of(context).size.width > 800
                    ? EdgeInsets.only(left: 300, right: 300)
                    : MediaQuery.of(context).size.width > 500
                        ? EdgeInsets.only(left: 100, right: 100)
                        : EdgeInsets.only(left: 50, right: 50),
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 6, left: 0, right: 0, bottom: 0),
              child: Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: Text(
                      t.youhave +
                          '(' +
                          userdata.coins.toString() +
                          ')' +
                          t.coins,
                      textAlign: TextAlign.center,
                      style: TextStyles.display0(context).copyWith(
                        fontSize: 20,
                        fontFamily: 'style2',
                        fontWeight: FontWeight.w300,
                        //color: Color(0xFF4B4B4B),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(40, 0, 40, 12),
                    child: Center(
                      child: Text(
                        t.selectnormalprice,
                        textAlign: TextAlign.center,
                        style: TextStyles.display1(context).copyWith(
                          fontSize: 18,
                          //color: Color(0xFF4B4B4B),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        //width: 60,
                        decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  LineAwesomeIcons.coins_solid,
                                  color: Colors.orange,
                                  size: 25,
                                ),
                                Text(
                                  media.amount.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    fontFamily: "",
                                    color: MyColors.white,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Text(
                              t.normalprice,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                fontFamily: "style1",
                                color: MyColors.grey_10,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.all(6),
                        height: 50,
                        //width: 60,
                        decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: IncrementDecrementFormField<int>(
                          // an initial value
                          initialValue: _amount,
                          incrementIconButtonConfig: IconButtonConfig(
                              icon: Icon(
                            Icons.add,
                            color: const Color.fromARGB(255, 246, 244, 244),
                          )),
                          decrementIconButtonConfig: IconButtonConfig(
                              icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                          )),
                          // return the widget you wish to hold the value, in this case Text
                          // if no value set 0, otherwise display the value as a string
                          displayBuilder: (value, field) {
                            return Text(
                              value == null ? "0" : value.toString(),
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 243, 241, 241),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            );
                          },

                          // run when the left button is pressed (decrement)
                          // the current value is passed as a parameter
                          // return what you want to update the display value to
                          // when decrement is pressed. In this case if null 0,
                          // otherwise current value -1
                          onDecrement: (currentValue) {
                            if (currentValue! > 0) {
                              setstate(
                                () {
                                  _amount = _amount - 1;
                                },
                              );
                              return currentValue - 1;
                            } else {
                              return 0;
                            }
                          },

                          // run when the right button is pressed (increment)
                          // the current value is passed as a parameter
                          // return what you want to update the display value to
                          // when increment is pressed. In this case if null 0,
                          // otherwise current value +1
                          onIncrement: (currentValue) {
                            setstate(
                              () {
                                _amount = _amount + 1;
                              },
                            );

                            return currentValue! + 1;
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Color.fromARGB(255, 158, 43, 154),
                    height: 60,
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(_context).pop();
                          },
                          child: Text(
                            t.cancel,
                            style: TextStyles.display0(context).copyWith(
                              fontSize: 20.0,
                              color: MyColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Articles _article = Articles.fromMap(
                              media.toMap2(media.amount! + _amount),
                            );
                            final bottomInset = MediaQuery.of(
                              _context,
                            ).padding.bottom;

                            Alerts.showPurchaseConfirmBottomSheet(
                              context: _context,
                              message:
                                  "${_article.amount} ${t.makepurchasehint}",
                              onConfirm: () {
                                eventBus.fire(
                                  OnRequestArticlePayment(_article),
                                );
                              },
                            );
                          },
                          child: Text(
                            t.confirm,
                            style: TextStyles.display0(context).copyWith(
                              fontSize: 20.0,
                              color: MyColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static Future<void> showPurchaseConfirmBottomSheet({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final isDarkMode = Provider.of<AppStateManager>(
      context,
      listen: false,
    ).isDarkModeOn;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: isDarkMode
          ? MyColors.headerdark
          : const Color.fromARGB(255, 243, 229, 242),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final mq = MediaQuery.of(sheetContext);

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: mq.viewInsets.bottom + mq.padding.bottom + 16,
          ),
          child: SafeArea(
            top: false,
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 46,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 235, 235),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(
                      FontAwesomeIcons.cartPlus,
                      color: MyColors.mainC0lor,
                      size: 26,
                    ),
                  ),
                ),

                // const SizedBox(height: 18),
                // Center(
                //   child: Text(
                //     t.confirm.toCapitalized(),
                //     style: const TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w700,
                //       fontFamily: 'style2',
                //     ),
                //   ),
                // ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyles.display0(context).copyWith(
                    color: Color(0xff2D3748),
                    fontFamily: 'style2',
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                Container(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: BorderSide(color: MyColors.mainC0lor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          t.cancel,
                          style: TextStyles.display0(context).copyWith(
                            color: MyColors.mainC0lor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.mainC0lor,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          t.confirm,
                          style: TextStyles.display0(context).copyWith(
                            color: Color.fromARGB(255, 239, 238, 238),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showArticlePaymentDialog(BuildContext context, Articles media) {
    /* */
    showpaymentbottomsheet(context, media);
  }

  static void showpaymentbottomsheet(
      BuildContext _context, Articles media) async {
    bool isdarkmode =
        Provider.of<AppStateManager>(_context, listen: false).isDarkModeOn;
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      subscriptionloginrequiredhint(_context);
      return;
    }
    int _amount = 0;
    showModalBottomSheet(
      context: _context,
      backgroundColor: Colors.transparent,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setstate) {
          return Container(
            decoration: BoxDecoration(
                color: isdarkmode ? MyColors.headerdark : Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            margin: MediaQuery.of(context).size.width > 1200
                ? EdgeInsets.only(left: 450, right: 450)
                : MediaQuery.of(context).size.width > 800
                    ? EdgeInsets.only(left: 300, right: 300)
                    : MediaQuery.of(context).size.width > 500
                        ? EdgeInsets.only(left: 100, right: 100)
                        : EdgeInsets.only(left: 50, right: 50),
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 6, left: 0, right: 0, bottom: 0),
              child: Wrap(
                children: [
                  Align(
                    // style: ElevatedButton.styleFrom(
                    //     // backgroundColor: MyColors.mainC0lor,
                    //     ),
                    child: Text(
                      t.youhave +
                          '(' +
                          userdata.coins.toString() +
                          ')' +
                          t.coins,
                      textAlign: TextAlign.center,
                      style: TextStyles.display1(context).copyWith(
                        fontSize: 20,

                        fontWeight: FontWeight.w300,
                        //color: Color(0xFF4B4B4B),
                      ),
                    ),
                  ),
                  Container(height: 10),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: Center(
                      child: Text(
                        t.selectnormalprice,
                        textAlign: TextAlign.center,
                        style: TextStyles.display1(context).copyWith(
                          fontSize: 18,
                          //color: Color(0xFF4B4B4B),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.fromLTRB(40, 0, 40, 12),
                  //   child: Center(
                  //     child: Text(
                  //       "Select normal price or select more coins to encourage the author.\nClick confirm to make the purchase",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 17,
                  //         //color: Color(0xFF4B4B4B),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        //width: 60,
                        decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  LineAwesomeIcons.coins_solid,
                                  color: Colors.orange,
                                  size: 25,
                                ),
                                Text(
                                  media.amount.toString(),
                                  style: TextStyles.display0(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    fontFamily: "",
                                    color: MyColors.white,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Text(
                              t.normalprice,
                              style: TextStyles.display1(context).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                fontFamily: "",
                                color: MyColors.white,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.all(6),
                        height: 50,
                        //width: 60,
                        decoration: BoxDecoration(
                            color: MyColors.mainC0lor,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: IncrementDecrementFormField<int>(
                          // an initial value
                          initialValue: _amount,
                          incrementIconButtonConfig: IconButtonConfig(
                              icon: Icon(
                            Icons.add,
                            color: const Color.fromARGB(255, 245, 244, 244),
                          )),
                          decrementIconButtonConfig: IconButtonConfig(
                              icon: Icon(
                            Icons.remove,
                            color: const Color.fromARGB(255, 244, 242, 242),
                          )),
                          // return the widget you wish to hold the value, in this case Text
                          // if no value set 0, otherwise display the value as a string
                          displayBuilder: (value, field) {
                            return Text(
                              value == null ? "0" : value.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            );
                          },

                          // run when the left button is pressed (decrement)
                          // the current value is passed as a parameter
                          // return what you want to update the display value to
                          // when decrement is pressed. In this case if null 0,
                          // otherwise current value -1
                          onDecrement: (currentValue) {
                            if (currentValue! > 0) {
                              setstate(
                                () {
                                  _amount = _amount - 1;
                                },
                              );
                              return currentValue - 1;
                            } else {
                              return 0;
                            }
                          },

                          // run when the right button is pressed (increment)
                          // the current value is passed as a parameter
                          // return what you want to update the display value to
                          // when increment is pressed. In this case if null 0,
                          // otherwise current value +1
                          onIncrement: (currentValue) {
                            setstate(
                              () {
                                _amount = _amount + 1;
                              },
                            );

                            return currentValue! + 1;
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: MyColors.mainC0lor,
                    height: 60,
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(_context).pop();
                          },
                          child: Text(
                            t.cancel,
                            style: TextStyles.display0(context).copyWith(
                              fontFamily: 'style2',
                              fontSize: 20.0,
                              color: MyColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Articles _article = Articles.fromMap(
                                media.toMap2(media.amount! + _amount));

                            startPaymentDialog(_context, _article);
                          },
                          child: Text(
                            t.confirm,
                            style: TextStyles.display0(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: MyColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static startPaymentDialog(BuildContext _context, Articles _article) async {
    bool isdarkmode =
        Provider.of<AppStateManager>(_context, listen: false).isDarkModeOn;
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      subscriptionloginrequiredhint(_context);
      return;
    }
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: _context,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setstate) {
          return Container(
            decoration: BoxDecoration(
                color: isdarkmode
                    ? MyColors.headerdark
                    : const Color.fromARGB(255, 243, 241, 241),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            margin: MediaQuery.of(context).size.width > 1200
                ? EdgeInsets.only(left: 450, right: 450)
                : MediaQuery.of(context).size.width > 800
                    ? EdgeInsets.only(left: 300, right: 300)
                    : MediaQuery.of(context).size.width > 500
                        ? EdgeInsets.only(left: 100, right: 100)
                        : EdgeInsets.only(left: 50, right: 50),
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              width: double.infinity,
              padding: EdgeInsets.only(top: 6, left: 0, right: 0, bottom: 0),
              child: Wrap(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      LineAwesomeIcons.cart_plus_solid,
                      size: 60,
                      color: const Color.fromARGB(255, 214, 46, 206),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Center(
                      child: Text(
                        t.forcoin +
                            " " +
                            "(" +
                            _article.amount.toString() +
                            ")" +
                            " " +
                            t.makepurchasehint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          //color: Color(0xFF4B4B4B),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 0,
                  ),
                  Container(
                    color: MyColors.mainC0lor,
                    height: 60,
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(_context).pop();
                          },
                          child: Text(
                            t.cancel,
                            style: TextStyles.display0(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              fontFamily: "",
                              color: MyColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(_context).pop();
                            eventBus.fire(OnRequestArticlePayment(_article));
                          },
                          child: Text(
                            t.proceed,
                            style: TextStyles.display0(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              fontFamily: "",
                              color: MyColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

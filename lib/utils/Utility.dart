import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Coins.dart';
import 'package:loikmon/models/Contacts.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/pages/BuyBook.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/screens/ItemsViewer.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:music_player/music_player.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
  clientId:
      String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: ''),
);
// Note: Store OAuth secrets in environment variables for security

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class Utility {
  static readme(BuildContext context, String title, String content) {
    Map data = {"title": title.toString(), "content": content};
    print("map data =" + data.toString());
    Navigator.pushNamed(context, ItemsViewer.routeName, arguments: data);
  }

  static openBrowserTab(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Unable to open URL link');
    }
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static String getBase64EncodedString(String text) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(text.trim());
  }

  static String getBase64DecodedString(String text) {
    //print(text);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(text.trim());
  }

  static String getFileExtension(String link) {
    String ext = "mp4";
    if (link.contains(".")) {
      ext = link.substring(link.lastIndexOf("."));
    }
    return ext.replaceAll(".", "");
  }

  static showCoinsDialog(
      BuildContext context, List<Coins> coins, int currentcoins) {
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: appStateManager.isDarkModeOn
                    ? Color.fromARGB(255, 14, 25, 49)
                    : Color.fromARGB(255, 235, 239, 239),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                border: Border.all(
                  color: const Color.fromARGB(255, 131, 130, 131),
                  width: 1,
                )),
            margin: MediaQuery.of(context).size.width > 1200
                ? EdgeInsets.only(left: 450, right: 450)
                : MediaQuery.of(context).size.width > 800
                    ? EdgeInsets.only(left: 300, right: 300)
                    : MediaQuery.of(context).size.width > 500
                        ? EdgeInsets.only(left: 100, right: 100)
                        : EdgeInsets.only(left: 50, right: 50),

            //height: 1000,
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  height: 60,
                  child: ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.cancel)),
                    title: new Text(
                      t.topupcoins,
                      style: TextStyles.display0(context).copyWith(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: new Text(t.youhave + " $currentcoins " + t.coins),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Container(
                //   //height: 30,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //       border: Border.all(color: Colors.grey, width: 0.2)),
                //   padding: EdgeInsets.all(4),

                //   margin:
                //       EdgeInsets.only(top: 8, right: 10, left: 10, bottom: 4),
                //   child: ListTile(
                //     contentPadding: EdgeInsets.zero,
                //     isThreeLine: false,
                //     dense: false,
                //     trailing: IconButton(
                //         onPressed: () async {
                //           String messengerlink = ""; //TODO
                //           if (await canLaunchUrl(Uri.parse(messengerlink))) {
                //             await launchUrl(Uri.parse(messengerlink));
                //           } else {
                //             print('Unable to open URL link');
                //           }
                //           Navigator.of(context).pop();
                //         },
                //         icon: Icon(
                //           Icons.messenger,
                //           color: Colors.blue[700],
                //         )),
                //     title: new Text("Messenger"),
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //   ),
                // ),
                Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: coins.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // print(_productDetails);
                    return Container(
                      height: 60,
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 5,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        //color: Colors.blue,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.only(left: 3, right: 3, bottom: 5),
                        leading: new Icon(
                          LineAwesomeIcons.coins_solid,
                          size: 40,
                          color: Colors.orange,
                        ),
                        trailing: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 210, 49, 216),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          height: 40,
                          width: 70,
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: Center(
                              child: Text(
                                "\฿" + coins[index].amount!.toString(),
                                style: TextStyles.display1(context).copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        title: new Text(
                            t.forcoins +
                                ' ' +
                                '(' +
                                coins[index].value!.toString() +
                                ')' +
                                ' ' +
                                t.coins,
                            style: TextStyles.display0(context).copyWith(
                              fontSize: 17,
                            )),
                        subtitle: new Text(coins[index].name!),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed(BuyBook.routeName,
                              arguments: ScreenArguements(items: coins[index]));
                        },
                      ),
                      // child: ListTile(
                      //   //contentPadding: EdgeInsets.zero,
                      //   leading: new Icon(
                      //     LineAwesomeIcons.coins_solid,
                      //     color: Colors.orange,
                      //   ),
                      //   trailing: Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.orange,
                      //       borderRadius: BorderRadius.all(
                      //         Radius.circular(15.0),
                      //       ),
                      //     ),
                      //     height: 35,
                      //     width: 100,
                      //     child: Center(
                      //       child: Text(
                      //         "\฿" + coins[index].amount!.toString(),
                      //         style: TextStyles.display1(context).copyWith(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ),
                      //   title: new Text(coins[index].name!),
                      //   subtitle:
                      //       new Text(coins[index].value!.toString() + " Coins"),
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //     Navigator.of(context).pushNamed(BuyBook.routeName,
                      //         arguments: ScreenArguements(items: coins[index]));
                      //   },
                      // ),
                    );
                  },
                ),
                Container(
                  height: 20,
                ),
              ]),
            ),
          );
        });
  }

  static showContactusDialog(BuildContext context, Contacts contacts) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: <Widget>[
                  Container(width: 6),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      contacts.contacttitle!,
                      maxLines: 2,
                      style: TextStyles.subhead(context).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(height: 5),
                  Row(
                    children: <Widget>[
                      Container(width: 6),
                      Text(contacts.contactdescription!,
                          style: TextStyles.subhead(context)
                              .copyWith(fontSize: 16))
                    ],
                  ),
                  Container(height: 20),
                  InkWell(
                    onTap: () async {
                      if (!await launchUrl(
                        Uri.parse("tel:" + contacts.contactusphone1!),
                        mode: LaunchMode.externalApplication,
                      )) {
                        //throw Exception('Could not launch link');
                        Alerts.showToast(context, 'Could not launch link');
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                            child: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryFixed
                              .withAlpha(80),
                          width: 50.0,
                          height: 50.0,
                          child: IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            onPressed: () {},
                            icon: Icon(
                              Icons.phone,
                            ),
                          ),
                        )),
                        Container(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(contacts.contactusphone1!,
                                style: TextStyles.subhead(context).copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Container(height: 20),
                  InkWell(
                    onTap: () async {
                      if (!await launchUrl(
                        Uri.parse("tel:" + contacts.contactusphone2!),
                        mode: LaunchMode.externalApplication,
                      )) {
                        //throw Exception('Could not launch link');
                        Alerts.showToast(context, 'Could not launch link');
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                            child: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withAlpha(80),
                          width: 50.0,
                          height: 50.0,
                          child: IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            onPressed: () {},
                            icon: Icon(
                              Icons.phone,
                            ),
                          ),
                        )),
                        Container(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(contacts.contactusphone2!,
                                style: TextStyles.subhead(context).copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Container(height: 10),
                  Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      right: 20,
                      bottom: 10,
                    ),
                    // color:
                    //     Theme.of(context).colorScheme.secondary.withAlpha(30),
                    child: InkWell(
                      onTap: () async {
                        if (!await launchUrl(
                          Uri.parse(contacts.contactusmessenger!),
                          mode: LaunchMode.externalApplication,
                        )) {
                          //throw Exception('Could not launch link');
                          Alerts.showToast(context, 'Could not launch link');
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          ClipOval(
                              child: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withAlpha(50),
                            width: 50.0,
                            height: 50.0,
                            child: IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onPressed: () {},
                              icon: Icon(
                                LineAwesomeIcons.facebook_messenger,
                                color: Color.fromARGB(255, 14, 193, 233),
                                size: 35,
                              ),
                            ),
                          )),
                          Container(width: 15),
                          Flexible(
                            child: Text("Messenger",
                                overflow: TextOverflow.clip,
                                style: TextStyles.subhead(context).copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(t.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static sharebook(BuildContext context, Books? book) async {
    String link = "https://loikmon.org/#/viewbook/" + book!.id.toString();
    /*await Share.share(
      t.share_file_title + book!.title! + " On Loik Mon" + " \n\n" + link!,
      subject: t.share_file_title + book!.title! + " On Loik Mon ",
    );*/
    FlutterClipboard.copy(
      link,
    ).then((value) {
      Alerts.show(
          context,
          "",
          book.title! +
              " copied for sharing, you can paste where you want to share.");
    });
  }

  static sharearticle(BuildContext context, Articles? articles) async {
    String link =
        "https://loikmon.org/#/viewarticle/" + articles!.id.toString();
    /* await Share.share(
      t.share_file_title + articles!.title! + " On Loik Mon" + " \n\n" + link!,
      subject: t.share_file_title + articles.title! + " On Loik Mon",
    );
    */

    FlutterClipboard.copy(link).then((value) {
      Alerts.show(
          context,
          "",
          articles.title! +
              " copied for sharing, you can paste where you want to share.");
    });
  }

  static int getItemCount(BuildContext context) {
    /* if (MediaQuery.of(context).size.width < 600) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 650) {
      return 2;
    }
    if (MediaQuery.of(context).size.width < 1000) {
      return 3;
    }
    return 4;
    */
    if (MediaQuery.of(context).size.width < 600) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 650) {
      return 2;
    }
    if (MediaQuery.of(context).size.width < 1200) {
      return 3;
    }
    if (MediaQuery.of(context).size.width < 1300) {
      return 4;
    }
    return 5;
  }

  static double getItemchildAspectRatio(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      return 1.6;
    }
    if (MediaQuery.of(context).size.width < 605) {
      return 0.85;
    }
    if (MediaQuery.of(context).size.width < 650) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 670) {
      return 0.65;
    }
    if (MediaQuery.of(context).size.width < 710) {
      return 0.7;
    }
    if (MediaQuery.of(context).size.width < 745) {
      return 0.75;
    }
    if (MediaQuery.of(context).size.width < 800) {
      return 0.8;
    }
    if (MediaQuery.of(context).size.width < 880) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 900) {
      return 0.75;
    }
    if (MediaQuery.of(context).size.width < 940) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 1010) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 1070) {
      return 1.1;
    }
    /* if (MediaQuery.of(context).size.width < 720) {
      return 0.6;
    }
    if (MediaQuery.of(context).size.width < 750) {
      return 0.7;
    }
    if (MediaQuery.of(context).size.width < 820) {
      return 0.8;
    }*/
    if (MediaQuery.of(context).size.width < 1200) {
      return 1.2;
    }
    if (MediaQuery.of(context).size.width < 1300) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 1600) {
      return 1.2;
    }
    if (MediaQuery.of(context).size.width < 1800) {
      return 1.5;
    }
    return 1;
    /*print(MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width < 400) {
      return 2;
    }
    if (MediaQuery.of(context).size.width < 450) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 500) {
      return 1.2;
    }
    if (MediaQuery.of(context).size.width < 550) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 600) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 650) {
      return 0.75;
    }
    if (MediaQuery.of(context).size.width < 720) {
      return 0.6;
    }
    if (MediaQuery.of(context).size.width < 750) {
      return 0.7;
    }
    if (MediaQuery.of(context).size.width < 820) {
      return 0.8;
    }
    if (MediaQuery.of(context).size.width < 1080) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 1300) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 1600) {
      return 1.2;
    }
    if (MediaQuery.of(context).size.width < 1800) {
      return 1.5;
    }
    return 1;
    */
  }

  static double getBookAspectRatio(BuildContext context) {
    if (MediaQuery.of(context).size.width < 550) {
      return 0.68;
    }
    if (MediaQuery.of(context).size.width < 650) {
      return 0.8;
    }
    if (MediaQuery.of(context).size.width < 600) {
      return 1.6;
    }
    if (MediaQuery.of(context).size.width < 670) {
      return 0.65;
    }
    if (MediaQuery.of(context).size.width < 710) {
      return 0.7;
    }
    if (MediaQuery.of(context).size.width < 745) {
      return 0.75;
    }
    if (MediaQuery.of(context).size.width < 800) {
      return 0.8;
    }
    if (MediaQuery.of(context).size.width < 880) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 900) {
      return 0.75;
    }
    if (MediaQuery.of(context).size.width < 940) {
      return 0.9;
    }
    if (MediaQuery.of(context).size.width < 1010) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 1070) {
      return 1.1;
    }
    if (MediaQuery.of(context).size.width < 1200) {
      return 1.2;
    }
    if (MediaQuery.of(context).size.width < 1300) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 1600) {
      return 1.2;
    }
    if (MediaQuery.of(context).size.width < 1800) {
      return 1.5;
    }
    return 1;
  }

  static int getBookItemCount(BuildContext context) {
    if (MediaQuery.of(context).size.width < 200) {
      return 1;
    }
    if (MediaQuery.of(context).size.width < 500) {
      return 2;
    }
    if (MediaQuery.of(context).size.width < 650) {
      return 2;
    }
    if (MediaQuery.of(context).size.width < 800) {
      return 3;
    }
    if (MediaQuery.of(context).size.width < 1000) {
      return 4;
    }
    return 5;
  }

  static Future<void> followunfollowauthor(
      int author, bool action, String email) async {
    try {
      final dio = Dio();
      print({
        "email": email,
        "author": author,
        "action": action,
      });

      final response = await dio.post(
        ApiUrl.FOLLOW_UNFOLLOW_AUTHOR,
        data: jsonEncode({
          "data": {
            "email": email,
            "author": author,
            "action": action ? "follow" : "unfollow",
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        print(response.data);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(response.data);
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      if (exception is DioError) {
        print(exception.message);
        print(exception.response);
        print(exception.error);
      }
    }
  }
}

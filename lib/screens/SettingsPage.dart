import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/screens/AuthPage.dart';
import 'package:loikmon/screens/FaqsScreen.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/langs.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/Userdata.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppStateManager appManager;
  final InAppReview inAppReview = InAppReview.instance;
  Userdata? userdata;
  final TextStyle headerStyle = TextStyle(
    //color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  Future<void> showLogoutAlert() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.logoutfromapp),
              content: new Text(t.logoutfromapphint),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    googleSignIn.signOut();
                    appManager.unsetUserData();
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
  }

  Future<void> showDeleteAccountAlert() async {
    return showDialog(
        barrierColor: MyColors.primaryLight,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.deleteaccount),
              content: new Text(t.deleteaccounthint),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  textStyle: TextStyle(
                      backgroundColor: MyColors.mainC0lor,
                      color: MyColors.primaryLight),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAccountServer(userdata!.email!);
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
  }

  Future<void> deleteAccountServer(String email) async {
    Alerts.showProgressDialog(
      context,
      t.processingpleasewait,
    );
    try {
      var data = {
        "email": email,
      };
      final response = await http.post(Uri.parse(ApiUrl.DELETE_ACCOUNT),
          body: jsonEncode({"data": data}));
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Alerts.show(context, "", t.deleteaccountsuccess);
        appManager.unsetUserData();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appManager = Provider.of<AppStateManager>(context);
    userdata = appManager.userdata;
    String language = appLanguageData[
        AppLanguage.values[appManager.preferredLanguage]]!['name']!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              t.account,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            userdata == null
                ? Card(
                    elevation: 0.5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 0,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              LineAwesomeIcons.user,
                              size: 30,
                              color: const Color.fromARGB(255, 146, 22, 162),
                            ),
                          ),
                          title: Text(
                            t.guestuser,
                            style: TextStyles.display1(context)
                                .copyWith(fontSize: 18),
                          ),
                          subtitle: Text(
                            t.createanaccounthint,
                            style: TextStyles.display1(context)
                                .copyWith(fontSize: 18),
                          ),
                          trailing: Icon(
                            Icons.navigate_next,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AuthPage.routeName, arguments: true);
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            LineAwesomeIcons.coins_solid,
                            size: 30,
                            color: Colors.orange,
                          ),
                          title: Text(
                            t.buycoins,
                            style: TextStyles.display1(context)
                                .copyWith(fontSize: 18),
                          ),
                          subtitle: Text(
                            t.purchasecoinshint,
                            style: TextStyles.display1(context)
                                .copyWith(fontSize: 18),
                          ),
                          trailing: Icon(
                            Icons.navigate_next,
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AuthPage.routeName, arguments: true);
                          },
                        ),
                      ],
                    ),
                  )
                : Card(
                    elevation: 0.5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 0,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                              radius: 0,
                              child: Icon(
                                LineAwesomeIcons.user,
                                color: MyColors.mainC0lor,
                              )),
                          title: Text(userdata!.email!),
                          //subtitle: Text(userdata!.email!),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            LineAwesomeIcons.coins_solid,
                            color: Colors.orange,
                          ),
                          title:
                              Text(userdata!.coins.toString() + " " + t.coins),
                          subtitle: Text(
                            t.purchasecoins,
                          ),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            appManager.getCoins(context);
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            LineAwesomeIcons.sign_out_alt_solid,
                            color: const Color.fromARGB(255, 208, 46, 46),
                          ),
                          title: Text(t.logoutfromapp),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            showLogoutAlert();
                          },
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 10.0),
            Visibility(
              visible: false,
              child: Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 0,
                ),
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: false,
                      child: ListTile(
                        leading: Icon(
                          LineAwesomeIcons.language_solid,
                          color: const Color.fromARGB(255, 40, 31, 126),
                          size: 30,
                        ),
                        title: Text(
                          t.applanguage,
                          style: TextStyles.display1(context)
                              .copyWith(fontSize: 18),
                        ),
                        subtitle: Text(
                          language,
                          style: TextStyles.display1(context)
                              .copyWith(fontSize: 16),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          size: 30,
                        ),
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: SizedBox(
                                      width: 180,
                                      child: Text(
                                        t.chooseapplanguage,
                                        style: TextStyles.display1(context)
                                            .copyWith(
                                                //color: Colors.black,
                                                ),
                                      )),
                                  content: Container(
                                    height: 250.0,
                                    width: 400.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: appLanguageData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var selected = appLanguageData[
                                                AppLanguage
                                                    .values[index]]!['name'] ==
                                            language;
                                        return ListTile(
                                          trailing: selected
                                              ? Icon(Icons.check)
                                              : Container(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          title: Text(
                                            appLanguageData[AppLanguage
                                                .values[index]]!['name']!,
                                          ),
                                          onTap: () {
                                            appManager.setAppLanguage(index);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              t.Customize,
              style: TextStyles.display1(context).copyWith(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      LineAwesomeIcons.language_solid,
                      size: 28,
                    ),
                    title: Text(
                      t.applanguage,
                      style:
                          TextStyles.display1(context).copyWith(fontSize: 18),
                    ),
                    subtitle: Text(
                      language,
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      size: 28,
                    ),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: SizedBox(
                                  width: 180,
                                  child: Text(
                                    t.chooseapplanguage,
                                    style:
                                        TextStyles.display1(context).copyWith(
                                            //color: Colors.black,
                                            ),
                                  )),
                              content: Container(
                                height: 100.0,
                                width: 400.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: appLanguageData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var selected = appLanguageData[AppLanguage
                                            .values[index]]!['name'] ==
                                        language;
                                    return ListTile(
                                      trailing: selected
                                          ? Icon(Icons.check)
                                          : Container(
                                              height: 0,
                                              width: 0,
                                            ),
                                      title: Text(
                                        appLanguageData[AppLanguage
                                            .values[index]]!['name']!,
                                      ),
                                      onTap: () {
                                        appManager.setAppLanguage(index);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  _buildDivider(),
                  /* ListTile(
                    leading: Icon(
                      LineAwesomeIcons.font,
                    ),
                    title: Text(t.changeappfont),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: SizedBox(
                                  width: 180, child: Text(t.changeappfont)),
                              content: Container(
                                height: 250.0,
                                width: 400.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: t.fonts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var selected = appManager.preferredTheme;
                                    return ListTile(
                                      trailing: index == selected
                                          ? Icon(Icons.check)
                                          : Container(
                                              height: 0,
                                              width: 0,
                                            ),
                                      title: Text(
                                        t.fonts[index],
                                      ),
                                      onTap: () {
                                        appManager.setTheme(index);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  _buildDivider(),*/
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: const Color.fromARGB(255, 195, 54, 213),
                      size: 28,
                    ),
                    title: Text(
                      t.enabledarkmode,
                      style:
                          TextStyles.display1(context).copyWith(fontSize: 18),
                    ),
                    trailing: Switch(
                      value: appManager.isDarkModeOn,
                      onChanged: (value) {
                        appManager.setColor(!appManager.isDarkModeOn);
                      },
                      activeColor: MyColors.mainC0lor,
                      inactiveThumbColor: Colors.grey,
                    ),
                  ),
                  _buildDivider(),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(t.more,
                style: TextStyles.display1(context)
                    .copyWith(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      LineAwesomeIcons.tags_solid,
                      color: const Color.fromARGB(255, 59, 55, 60),
                      size: 28,
                    ),
                    title: Text(
                      t.terms,
                      style:
                          TextStyles.display1(context).copyWith(fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      size: 28,
                    ),
                    onTap: () {
                      Utility.openBrowserTab(ApiUrl.TERMS);
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      LineAwesomeIcons.th_list_solid,
                      color: const Color.fromARGB(255, 182, 194, 49),
                      size: 28,
                    ),
                    title: Text(
                      t.privacy,
                      style:
                          TextStyles.display1(context).copyWith(fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      size: 28,
                    ),
                    onTap: () {
                      Utility.openBrowserTab(ApiUrl.PRIVACY);
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      LineAwesomeIcons.question_circle,
                      color: const Color.fromARGB(255, 184, 54, 210),
                      size: 30,
                    ),
                    title: Text("FAQS"),
                    trailing: Icon(
                      Icons.navigate_next,
                      size: 28,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, FaqsScreen.routeName);
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      Icons.contact_support,
                      color: const Color.fromARGB(255, 38, 180, 188),
                      size: 28,
                    ),
                    title: Text(
                      t.contactus,
                      style:
                          TextStyles.display1(context).copyWith(fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      size: 28,
                    ),
                    onTap: () {
                      appManager.getContactUs(context);
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      LineAwesomeIcons.info_solid,
                      color: const Color.fromARGB(255, 227, 29, 194),
                      size: 28,
                    ),
                    title: Text(
                      t.about,
                      style:
                          TextStyles.display1(context).copyWith(fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      size: 28,
                    ),
                    onTap: () {
                      Utility.openBrowserTab(ApiUrl.ABOUT);
                    },
                  ),
                  /*_buildDivider(),
                  ListTile(
                    leading: Icon(
                      LineAwesomeIcons.app_store,
                    ),
                    title: Text(t.rateapp),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () async {
                      //LaunchReview.launch();

                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      }
                    },
                  ),*/
                  _buildDivider(),
                  Visibility(
                    visible: userdata != null,
                    child: ListTile(
                      leading: Icon(
                        LineAwesomeIcons.user_nurse_solid,
                        size: 28,
                        color: Colors.red,
                      ),
                      title: Text(
                        t.deletemyaccount,
                        style:
                            TextStyles.display1(context).copyWith(fontSize: 18),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        size: 28,
                      ),
                      onTap: () {
                        showDeleteAccountAlert();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}

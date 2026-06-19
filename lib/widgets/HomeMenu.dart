import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/screens/AuthPage.dart';
import 'package:loikmon/screens/FaqsScreen.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

class HomeMenu extends StatelessWidget {
  HomeMenu();

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        List<String> choices = [];

        choices
            .add(appStateManager.userdata == null ? t.login : t.logoutfromapp);
        if (appStateManager.isadminuser != 5 &&
            appStateManager.userdata != null) {
          choices.add("Admin Access");
        }
        choices.add(t.buycoins);
        choices.add("FAQS");

        // }
        return choices.map((itm) {
          return PopupMenuItem(
            value: itm,
            child: Text(itm),
          );
        }).toList();
      },
      //initialValue: 2,
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (dynamic value) {
        print(value);
        if (value == "Admin Access") {
          Utility.openBrowserTab(ApiUrl.BASEURL +
              "adminaccess/" +
              appStateManager.userdata!.email!);
        }
        if (value == t.login) {
          Navigator.of(context).pushNamed(AuthPage.routeName, arguments: true);
        }
        if (value == t.logoutfromapp) {
          showDialog(
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
                          appStateManager.unsetUserData();
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
        if (value == t.buycoins) {
          Provider.of<AppStateManager>(context, listen: false)
              .getCoins(context);
        }
        if (value == "FAQS") {
          Navigator.of(context)
              .pushNamed(FaqsScreen.routeName, arguments: true);
        }
      },
      icon: appStateManager.userdata == null
          ? Icon(
              Icons.account_circle_outlined,
              size: 30,
              //color: color!,
            )
          : Container(
              // height: 100,
              //width: 100,
              padding: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.mainC0lor,
                // borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                //padding: EdgeInsets.only(top: 10, right: 10),
                child: Text(
                  appStateManager.userdata!.email!
                      .substring(0, 1)
                      .toUpperCase(),
                  style: TextStyles.display1(context).copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 242, 240, 240),
                  ),
                ),
              ),
            ),
    );
  }
}

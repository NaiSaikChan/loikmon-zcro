import 'dart:async';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loikmon/audio_player/BookMiniPlayer.dart';
import 'package:loikmon/audio_player/miniPlayer.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/AudioPlayerModel.dart';
import 'package:loikmon/providers/DashboardModel.dart';
import 'package:loikmon/providers/SubscriptionModel.dart';
import 'package:loikmon/screens/AuthorsDashboard.dart';
import 'package:loikmon/screens/BookmarksLibrary.dart';
import 'package:loikmon/screens/CategoriesDashboard.dart';
import 'package:loikmon/screens/DashboardScreen.dart';
import 'package:loikmon/screens/InboxListScreen.dart';
import 'package:loikmon/screens/Library.dart';
import 'package:loikmon/screens/PendingBankPaymentsPage.dart';
import 'package:loikmon/screens/SettingsPage.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/img.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/widgets/HomeMenu.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static const routeName = "/homescreen";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<SubscriptionModel>(context, listen: false)
          .initInAppPurchases(context);
      Provider.of<AppStateManager>(context, listen: false).setContext(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomePageItem();
  }
}

class HomePageItem extends StatefulWidget {
  HomePageItem({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageItemState createState() => _HomePageItemState();
}

class _HomePageItemState extends State<HomePageItem>
    with SingleTickerProviderStateMixin {
  final _controller = SidebarXController(selectedIndex: 0, extended: false);
  final _key = GlobalKey<ScaffoldState>();
  //GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  String bookmarks = "";
  String downloads = "";
  late AppStateManager appStateManager;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<SubscriptionModel>(context, listen: false)
          .initInAppPurchases(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayerModel>(context);
    appStateManager = Provider.of<AppStateManager>(context);
    /* final bookmarksModel = Provider.of<BookmarksModel>(context);
    int bookmarkslen = bookmarksModel.bookmarksList.length;
    if (bookmarkslen != 0) {
      setState(() {
        bookmarks = bookmarkslen > 9 ? "9+" : bookmarkslen.toString();
      });
    } else {
      bookmarks = "";
      setState(() {});
    }
    final downloadsModel = Provider.of<DownloadedBooksModel>(context);
    int downloadslen = downloadsModel.books.length;
    if (downloadslen != 0) {
      setState(() {
        downloads = downloadslen > 9 ? "9+" : downloadslen.toString();
      });
    } else {
      downloads = "";
      setState(() {});
    }*/
    DashboardModel dashboardModel = Provider.of<DashboardModel>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        title: Text(
          t.appname,
          style: TextStyles.display1(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.white,
        toolbarHeight: 50,
        elevation: 1,
        leading: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 50, top: 0, bottom: 0),
            child: Image(
              // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => widget,
              image: AssetImage(Img.get("logo.png")),
              height: 100,
              width: 100,
            ),
          ),
        ),
        actions: [
          Container(
            //width: 90,
            margin: EdgeInsets.only(top: 0),
            child: IconButton(
              onPressed: () {
                appStateManager.setColor(!appStateManager.isDarkModeOn);
              },
              icon: Icon(
                Icons.color_lens,
                color: appStateManager.isDarkModeOn
                    ? const Color.fromARGB(255, 199, 22, 211)
                    : const Color.fromARGB(255, 185, 20, 193),
                size: 30,
              ),
            ),
          ),
          Container(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                appStateManager.getContactUsLink(context);
              },
              icon: Icon(
                LineAwesomeIcons.facebook_messenger,
                color: const Color.fromARGB(255, 50, 108, 180),
                size: 30,
              )),
          Container(
            width: 20,
          ),
          Visibility(
            visible: true,
            child: Container(
              padding: const EdgeInsets.only(right: 0),
              margin: EdgeInsets.only(right: 4),
              child: dashboardModel.notificationcount == ""
                  ? IconButton(
                      onPressed: () {
                        dashboardModel.unsetNotificationcount();
                        Navigator.of(context)
                            .pushNamed(InboxListScreenState.routeName);
                      },
                      icon: Icon(LineAwesomeIcons.bell))
                  : IconButton(
                      icon: badge.Badge(
                        badgeContent: Text(
                          dashboardModel.notificationcount,
                          style: TextStyles.display1(context).copyWith(
                              color: Color.fromARGB(255, 250, 246, 251),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        child: Icon(
                          LineAwesomeIcons.bell,
                          color: const Color.fromARGB(255, 234, 68, 39),
                          size: 30,
                        ),
                      ),
                      onPressed: (() {
                        dashboardModel.unsetNotificationcount();
                        Navigator.of(context)
                            .pushNamed(InboxListScreenState.routeName);
                      })),
            ),
          ),
          Container(
            width: 20,
          ),
          Visibility(
            visible: appStateManager.isadminuser == 0,
            child: Container(
              padding: const EdgeInsets.only(right: 0),
              margin: EdgeInsets.only(right: 4),
              child: dashboardModel.pending_bank_requests == ""
                  ? IconButton(
                      onPressed: () {
                        dashboardModel.unsetNotificationcount();
                        Navigator.of(context)
                            .pushNamed(PendingBankPaymentsPage.routeName);
                      },
                      icon: Icon(FontAwesomeIcons.buildingColumns),
                    )
                  : IconButton(
                      icon: badge.Badge(
                        badgeContent: Text(
                          dashboardModel.pending_bank_requests,
                          style: TextStyles.display1(context).copyWith(
                            color: Color.fromARGB(255, 250, 246, 251),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Icon(FontAwesomeIcons.buildingColumns),
                      ),
                      onPressed: (() {
                        Navigator.of(context)
                            .pushNamed(PendingBankPaymentsPage.routeName);
                      }),
                    ),
            ),
          ),
          Visibility(
              visible: appStateManager.isadminuser == 0,
              child: SizedBox(
                width: 10,
              )),
          HomeMenu(),
          /* IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                },
                icon: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                )), */
          Container(
            width: 20,
          )
        ],
      ),
      //drawer: ExampleSidebarX(controller: _controller),
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Row(
          children: [
            ExampleSidebarX(controller: _controller),
            // Your app screen body
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: _ScreensExample(
                        controller: _controller,
                      ),
                    ),
                    Container(
                      margin: MediaQuery.of(context).size.width > 1200
                          ? EdgeInsets.only(left: 250, right: 250)
                          : EdgeInsets.only(left: 50, right: 50),
                      child:
                          player.isBookAudio ? BookMiniPlayer() : MiniPlayer(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      /* Column(
          children: [
            Expanded(
              child: getBody(currentIndex),
            ),
          ],
        ),
        bottomNavigationBar: SnakeNavigationBar.color(
          backgroundColor: !appStateManager.isDarkModeOn
              ? Color.fromARGB(255, 240, 238, 238)
              : MyColors.headerdark,
          behaviour: SnakeBarBehaviour.pinned,
          snakeShape: SnakeShape.indicator,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          padding: const EdgeInsets.all(0),
          selectedLabelStyle: TextStyle(fontSize: 13, fontFamily: 'style2'),

          ///configuration for SnakeNavigationBar.color
          snakeViewColor: MyColors.mainC0lor,

          selectedItemColor: !appStateManager.isDarkModeOn
              ? const Color.fromARGB(255, 28, 27, 27)
              : const Color.fromARGB(255, 233, 232, 232),
          unselectedItemColor: !appStateManager.isDarkModeOn
              ? Colors.blueGrey
              : Color.fromARGB(255, 165, 163, 163),

          ///configuration for SnakeNavigationBar.gradient
          //snakeViewGradient: selectedGradient,
          //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
          //unselectedItemGradient: unselectedGradient,

          showUnselectedLabels: false,
          showSelectedLabels: true,

          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(iconList[0]), label: t.home),
            BottomNavigationBarItem(
                icon: Icon(iconList[2]), label: t.categories),
            BottomNavigationBarItem(icon: Icon(iconList[3]), label: t.authors),
            BottomNavigationBarItem(icon: Icon(iconList[4]), label: t.library),
            BottomNavigationBarItem(icon: Icon(iconList[5]), label: t.settings),
          ],
        ),*/
    );
  }

  Widget getBody(SidebarXController _controller) {
    print(_controller.selectedIndex);
    switch (_controller.selectedIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return CategoriesDashboard();
      case 2:
        return AuthorsDashboard();
      case 3:
        return Library();
      case 4:
        return SettingsPage();

      default:
        return DashboardScreen();
    }
  }
}

class Constants {
  static final Color primaryColor = Color.fromRGBO(86, 215, 188, 1);
  static final Color scaffoldBackgroundColor = Color.fromRGBO(245, 247, 249, 1);
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;
  //final AppStateManager appStateManager;

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    final iconList = <IconData>[
      LineAwesomeIcons.home_solid,
      LineAwesomeIcons.newspaper,
      LineAwesomeIcons.list_alt, //alternate_list
      LineAwesomeIcons.user_friends_solid,
      LineAwesomeIcons.bookmark,
      LineAwesomeIcons.wallet_solid,
      LineAwesomeIcons.tools_solid,
    ];

    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        // hoverColor: MyColors.mainC0lor,
        itemPadding: EdgeInsets.all(6),
        itemMargin: EdgeInsets.only(
          bottom: 20,
        ),
        iconTheme: IconThemeData(
          size: 28,
        ),
        selectedIconTheme: IconThemeData(
          color: MyColors.mainC0lor,
          size: 28,
        ),
        hoverIconTheme: IconThemeData(
          color: MyColors.mainC0lor,
          size: 28,
        ),
        decoration: BoxDecoration(
          // color: MyColors.mainC0lor,
          // borderRadius: BorderRadius.circular(20),
          color: appStateManager.isDarkModeOn
              ? const Color.fromARGB(255, 34, 42, 50)
              : const Color.fromARGB(255, 239, 241, 242),
        ),
        //padding: EdgeInsets.all(10),
        // textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        // selectedTextStyle: const TextStyle(color: Colors.white),
        /**/
        /*  hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          /* border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],*/
        ),
        iconTheme: IconThemeData(
          //color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          // color: Colors.white,
          size: 20,
        ),*/
      ),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 30,
          // child:
          //    Padding(padding: const EdgeInsets.all(16.0), child: Text("MB")),
        );
      },
      extendedTheme: SidebarXTheme(
        width: 220,
        iconTheme: IconThemeData(
          size: 28,
        ),
        //hoverColor: MyColors.mainC0lor,
        selectedIconTheme: IconThemeData(
          size: 28,
          color: MyColors.mainC0lor,
        ),
        selectedTextStyle: TextStyles.display1(context).copyWith(
          fontSize: 20,
          color: MyColors.mainC0lor,
        ),
        textStyle: TextStyles.display1(context).copyWith(
          fontSize: 20,
        ),
        hoverIconTheme: IconThemeData(
          size: 28,
          color: MyColors.mainC0lor,
        ),
        hoverTextStyle: TextStyles.display1(context).copyWith(
          fontSize: 20,
          color: MyColors.mainC0lor,
        ),
        itemTextPadding: EdgeInsets.only(
          right: 20,
          left: 20,
        ),
        selectedItemTextPadding: EdgeInsets.only(
          right: 20,
          left: 20,
        ),
      ),
      items: [
        SidebarXItem(
          icon: iconList[0],
          label: t.home,
        ),
        SidebarXItem(
          icon: iconList[2],
          label: t.categories,
        ),
        SidebarXItem(
          icon: iconList[3],
          label: t.authors,
        ),
        SidebarXItem(
          icon: iconList[4],
          label: t.bookmarks,
        ),
        SidebarXItem(
          icon: iconList[5],
          label: "My Purchases",
        ),
        SidebarXItem(
          icon: iconList[6],
          label: t.settings,
        ),
      ],
    );
  }

  void _showDisabledAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Item disabled for selecting',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return DashboardScreen();
          case 1:
            return CategoriesDashboard();
          case 2:
            return AuthorsDashboard();
          case 3:
            return BookmarksLibrary();
          case 4:
            return Library();
          case 5:
            return SettingsPage();

          default:
            return DashboardScreen();
        }
      },
    );
  }
}

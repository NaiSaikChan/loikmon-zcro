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
  static const routeName = '/homescreen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<SubscriptionModel>(context, listen: false)
          .initInAppPurchases(context);
      Provider.of<AppStateManager>(context, listen: false)
          .setContext(context);
    });
  }

  @override
  Widget build(BuildContext context) => HomePageItem();
}

// ─────────────────────────────────────────────────────────────────────────────
class HomePageItem extends StatefulWidget {
  HomePageItem({Key? key}) : super(key: key);

  @override
  _HomePageItemState createState() => _HomePageItemState();
}

class _HomePageItemState extends State<HomePageItem>
    with SingleTickerProviderStateMixin {
  final _controller =
      SidebarXController(selectedIndex: 0, extended: false);
  final _key = GlobalKey<ScaffoldState>();

  late AppStateManager appStateManager;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<SubscriptionModel>(context, listen: false)
          .initInAppPurchases(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayerModel>(context);
    appStateManager = Provider.of<AppStateManager>(context);
    final DashboardModel dashboardModel =
        Provider.of<DashboardModel>(context);
    final bool isDark = appStateManager.isDarkModeOn;

    return Scaffold(
      key: _key,
      // ── App Bar ──────────────────────────────────────────────
      appBar: AppBar(
        toolbarHeight: 56,
        // Logo as leading widget
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 6, bottom: 6),
          child: Image(
            image:  AssetImage(Img.get('logo.png')),
            height: 36,
            width:  36,
            fit:    BoxFit.contain,
          ),
        ),
        // App name centered
        title: Text(
          t.appname,
          style: TextStyles.display1(context).copyWith(
            fontWeight:    FontWeight.w800,
            fontSize:      22,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        // Action buttons
        actions: [
          // Theme toggle — modern color-lens replaced with sleek moon/sun
          IconButton(
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            onPressed: () {
              appStateManager.setColor(!isDark);
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: isDark
                  ? const Icon(Icons.wb_sunny_rounded,
                      key: ValueKey('sun'),
                      color: MyColors.warning,
                      size: 24)
                  : const Icon(Icons.nights_stay_rounded,
                      key: ValueKey('moon'),
                      color: MyColors.accentOnDark,
                      size: 24),
            ),
          ),
          // Messenger
          IconButton(
            tooltip:  'Contact us',
            onPressed: () =>
                appStateManager.getContactUsLink(context),
            icon: const Icon(
              LineAwesomeIcons.facebook_messenger,
              color: Color(0xFF3B7CE5),
              size:  22,
            ),
          ),
          // Notifications
          Visibility(
            visible: true,
            child: _NotificationButton(
              dashboardModel: dashboardModel,
            ),
          ),
          // Bank payments (admin only)
          Visibility(
            visible: appStateManager.isadminuser == 0,
            child: _BankButton(dashboardModel: dashboardModel),
          ),
          // Profile / menu
          HomeMenu(),
          const SizedBox(width: 8),
        ],
        // Hairline bottom border instead of shadow
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark
                ? MyColors.borderDark
                : MyColors.borderLight,
          ),
        ),
      ),

      // ── Body ─────────────────────────────────────────────────
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          children: [
            // Sidebar
            _AppSidebar(controller: _controller),
            // Main content + mini-player
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _ScreensExample(controller: _controller),
                  ),
                  // Mini player bar — centered with responsive margins
                  Container(
                    margin: MediaQuery.of(context).size.width > 1200
                        ? const EdgeInsets.symmetric(horizontal: 250)
                        : const EdgeInsets.symmetric(horizontal: 40),
                    child: player.isBookAudio
                        ? BookMiniPlayer()
                        : MiniPlayer(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Notification bell with badge
class _NotificationButton extends StatelessWidget {
  final DashboardModel dashboardModel;
  const _NotificationButton({required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    final bool hasNotif = dashboardModel.notificationcount != '';
    return IconButton(
      tooltip: 'Inbox',
      onPressed: () {
        dashboardModel.unsetNotificationcount();
        Navigator.of(context).pushNamed(InboxListScreenState.routeName);
      },
      icon: hasNotif
          ? badge.Badge(
              badgeContent: Text(
                dashboardModel.notificationcount,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              badgeStyle: const badge.BadgeStyle(
                  badgeColor: MyColors.error, padding: EdgeInsets.all(4)),
              child: const Icon(LineAwesomeIcons.bell, size: 22),
            )
          : const Icon(LineAwesomeIcons.bell, size: 22),
    );
  }
}

/// Bank pending-requests button
class _BankButton extends StatelessWidget {
  final DashboardModel dashboardModel;
  const _BankButton({required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    final bool hasPending = dashboardModel.pending_bank_requests != '';
    return IconButton(
      tooltip: 'Bank payments',
      onPressed: () {
        Navigator.of(context).pushNamed(PendingBankPaymentsPage.routeName);
      },
      icon: hasPending
          ? badge.Badge(
              badgeContent: Text(
                dashboardModel.pending_bank_requests,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              badgeStyle: const badge.BadgeStyle(
                  badgeColor: MyColors.warning, padding: EdgeInsets.all(4)),
              child: const Icon(FontAwesomeIcons.buildingColumns, size: 20),
            )
          : const Icon(FontAwesomeIcons.buildingColumns, size: 20),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Modernized SidebarX — pill-style selected item, accent icon highlight
class _AppSidebar extends StatelessWidget {
  final SidebarXController controller;
  const _AppSidebar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateManager>(context);
    final bool isDark = appState.isDarkModeOn;

    final Color sidebarBg =
        isDark ? MyColors.sidebarDark : MyColors.sidebarLight;
    final Color selectedBg = MyColors.accentGlow;
    final Color selectedFg = MyColors.accent;
    final Color unselectedFg = isDark
        ? MyColors.textSecondaryDark
        : MyColors.textSecondaryLight;

    final iconList = <IconData>[
      LineAwesomeIcons.home_solid,
      LineAwesomeIcons.list_alt,       // categories
      LineAwesomeIcons.user_friends_solid, // authors
      LineAwesomeIcons.bookmark,
      LineAwesomeIcons.wallet_solid,
      LineAwesomeIcons.tools_solid,
    ];

    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        margin:    const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding:   EdgeInsets.zero,
        decoration: BoxDecoration(
          color:        sidebarBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? MyColors.borderDark : MyColors.borderLight,
            width: 1,
          ),
        ),
        itemMargin:  const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        itemPadding: const EdgeInsets.all(10),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        selectedItemDecoration: BoxDecoration(
          color:        selectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: MyColors.accent.withOpacity(0.25),
            width: 1,
          ),
        ),
        iconTheme: IconThemeData(color: unselectedFg, size: 24),
        selectedIconTheme:
            IconThemeData(color: selectedFg, size: 24),
        hoverIconTheme:
            IconThemeData(color: selectedFg, size: 24),
      ),
      headerBuilder: (context, extended) =>
          const SizedBox(height: 16),
      extendedTheme: SidebarXTheme(
        width: 210,
        decoration: BoxDecoration(
          color:        sidebarBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? MyColors.borderDark : MyColors.borderLight,
            width: 1,
          ),
        ),
        itemMargin:  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        selectedItemDecoration: BoxDecoration(
          color:        selectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: MyColors.accent.withOpacity(0.25),
            width: 1,
          ),
        ),
        iconTheme: IconThemeData(color: unselectedFg, size: 24),
        selectedIconTheme:
            IconThemeData(color: selectedFg, size: 24),
        hoverIconTheme:
            IconThemeData(color: selectedFg, size: 24),
        textStyle: TextStyle(
          color:      unselectedFg,
          fontSize:   15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Style1',
        ),
        selectedTextStyle: TextStyle(
          color:      selectedFg,
          fontSize:   15,
          fontWeight: FontWeight.w700,
          fontFamily: 'Style1',
        ),
        hoverTextStyle: TextStyle(
          color:      selectedFg,
          fontSize:   15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Style1',
        ),
        itemTextPadding:         const EdgeInsets.only(left: 12),
        selectedItemTextPadding: const EdgeInsets.only(left: 12),
      ),
      items: [
        SidebarXItem(icon: iconList[0], label: t.home),
        SidebarXItem(icon: iconList[1], label: t.categories),
        SidebarXItem(icon: iconList[2], label: t.authors),
        SidebarXItem(icon: iconList[3], label: t.bookmarks),
        SidebarXItem(icon: iconList[4], label: 'My Purchases'),
        SidebarXItem(icon: iconList[5], label: t.settings),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Screen router
class _ScreensExample extends StatelessWidget {
  final SidebarXController controller;
  const _ScreensExample({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        switch (controller.selectedIndex) {
          case 0: return DashboardScreen();
          case 1: return CategoriesDashboard();
          case 2: return AuthorsDashboard();
          case 3: return BookmarksLibrary();
          case 4: return Library();
          case 5: return SettingsPage();
          default: return DashboardScreen();
        }
      },
    );
  }
}

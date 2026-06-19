import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Onboarder.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/screens/HomePage.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  static const routeName = "/onboarding";
  OnboardingPage();

  @override
  OnboarderPageState createState() => OnboarderPageState();
}

/*class _OnboarderPageState extends State<OnboardingPage> {
  //Create a list of PageModel to be set on the onBoarding Screens.
  final pageList = [
    PageModel(
      color: Colors.purple,
      heroImagePath: 'assets/images/preacher.png',
      title: Text('Messages',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
            'Experience the word of God and true intimacy with the Holy spirit as you listen to messages from teachers of the word all over the globe.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
      ),
      icon: Icon(
        Icons.stacked_bar_chart,
        color: Colors.purple,
      ),
    ),
    PageModel(
      color: MyColors.primary,
      heroImagePath: 'assets/images/bible.gif',
      title: Text('The Word',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
            'One of the best ways to stay strong in the faith is to saturate yourself in the Word of God continually. ' +
                'Read or listen to the word of God anytime, anywhere.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
      ),
      icon: Icon(
        Icons.stacked_bar_chart,
        color: MyColors.primary,
      ),
    ),
    PageModel(
      color: Colors.teal,
      heroImagePath: 'assets/images/logo.png',
      title: Text('Books',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
            'Our 1500+ christian books have been carefully selected from the works of established Christian writers all over the world.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
      ),
      icon: Icon(
        Icons.book,
        color: Colors.teal,
      ),
    ),
    // SVG Pages Example

    PageModel(
      color: Colors.deepOrange,
      heroImagePath: 'assets/svg/store.svg',
      title: Text('AND MORE!',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
            'And it gets more interesting, You can create playlists of your favorite messages, bible reading plans and reminders, playlists of your favorite bible passages and lots more. ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
      ),
      icon: Icon(
        Icons.playlist_add,
        color: Colors.deepOrange,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Pass pageList and the mainPage route.
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () => Navigator.of(context).pop(),
        onSkipButtonPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}*/

class OnboarderPageState extends State<OnboardingPage> {
  List<Onboarder> onboarderItem = Onboarder.getOnboardingItems(
      t.onboardingpagetitles, t.onboardingpagehints);
  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.purple,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.grey[100])),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    PageView(
                      onPageChanged: onPageViewChange,
                      controller: pageController,
                      children: buildPageViewItem(),
                    ),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: MyColors.white),
                          onPressed: () {
                            Provider.of<AppStateManager>(context, listen: false)
                                .setUserSeenOnboardingPage(true);
                            Navigator.of(context)
                                .pushReplacementNamed(HomePage.routeName);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: buildDots(context),
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 40,
                margin: EdgeInsets.only(bottom: 10),
                child: TextButton(
                  child: Text(isLast ? t.done : t.next,
                      style: TextStyles.subhead(context).copyWith(
                          color: MyColors.mainC0lor,
                          fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    backgroundColor: MyColors.white,
                  ),
                  onPressed: () {
                    if (isLast) {
                      Provider.of<AppStateManager>(context, listen: false)
                          .setUserSeenOnboardingPage(true);
                      Navigator.of(context)
                          .pushReplacementNamed(HomePage.routeName);
                      //Navigator.of(context).pop();
                      return;
                    }
                    pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  },
                ),
              )
            ]),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    isLast = _page == onboarderItem.length - 1;
    setState(() {});
  }

  List<Widget> buildPageViewItem() {
    List<Widget> widgets = [];
    for (Onboarder onboarder in onboarderItem) {
      Widget wg = Container(
        padding: EdgeInsets.all(35),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Wrap(
          children: <Widget>[
            Container(
                // color: Colors.green,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(onboarder.title,
                              style: TextStyles.medium(context).copyWith(
                                  color: MyColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25)),
                          Container(
                            width: 120,
                            height: 2,
                            // color: MyColors.primary,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 14, bottom: 14),
                            child: Lottie.asset(
                              onboarder.image,
                              //width: 250,
                              //height: 250,
                            ), //Image.asset(Img.get(onboarder.image),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: Text(onboarder.hint,
                                textAlign: TextAlign.center,
                                style: TextStyles.caption(context).copyWith(
                                    color: MyColors.white,
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic)),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      );
      widgets.add(wg);
    }
    return widgets;
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < onboarderItem.length; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor: page == i
              ? const Color.fromARGB(255, 239, 238, 238)
              : MyColors.grey_40,
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}

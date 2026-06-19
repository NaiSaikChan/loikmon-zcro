//import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loikmon/ScrollBehaviour.dart';
import 'package:loikmon/audio_player/BookAudioPlayerPage.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/Books.dart';
//import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/models/Coins.dart';
import 'package:loikmon/models/Inbox.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/pages/BuyBook.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/screens/AppPdfViewer.dart';
import 'package:loikmon/screens/ArticleAuthorsListScreen.dart';
import 'package:loikmon/screens/ArticlesCatsScreen.dart';
import 'package:loikmon/screens/ArticlesReviewsScreen.dart';
import 'package:loikmon/screens/ArticlesScreen.dart';
import 'package:loikmon/screens/AuthPage.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/screens/AuthorsScreen.dart';
import 'package:loikmon/screens/BooksScreen.dart';
import 'package:loikmon/screens/BooksViewerScreen.dart';
import 'package:loikmon/screens/CategoriesScreen.dart';
import 'package:loikmon/screens/CategoriesViewScreen.dart';
import 'package:loikmon/screens/CollectionDetailsScreen.dart';
import 'package:loikmon/screens/CollectionsScreen.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/screens/EpubReader.dart';
import 'package:loikmon/screens/FaqsScreen.dart';
import 'package:loikmon/screens/InboxListScreen.dart';
import 'package:loikmon/screens/InboxViewerScreen.dart';
import 'package:loikmon/screens/ItemsViewer.dart';
import 'package:loikmon/screens/LeaguesScreen.dart';
import 'package:loikmon/screens/OnboardingPage.dart';
import 'package:loikmon/screens/OthersBooksScreen.dart';
import 'package:loikmon/screens/PendingBankPaymentsPage.dart';
import 'package:loikmon/screens/ReviewsScreen.dart';
import 'package:loikmon/screens/SearchScreen.dart';
import 'package:loikmon/screens/ViewItems.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/ArticleViewerScreen.dart';
import './screens/HomePage.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required Widget defaultHome,
  })  : _defaultHome = defaultHome,
        super(key: key);
  final Widget _defaultHome;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //AppStateManager appStateManager;
  AppLifecycleState? state;
  bool isChatOpen = false;
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  navigateBooks(int id) {
    processDeepLink(id, "book");
  }

  navigateArticles(int id) {
    processDeepLink(id, "article");
  }

  processDeepLink(int id, String type) async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    Alerts.showProgressDialog(
        navigatorKey.currentState!.context, "Processing, please wait ...");
    try {
      var data = {
        "type": type,
        "id": id, //path.pathSegments[1].toString(),
        "email": userdata == null ? "null" : userdata.email,
      };

      final response = await http.post(
        Uri.parse(ApiUrl.getitem),
        body: jsonEncode({"data": data}),
      );
      print("response for deeplink");
      print(response.body);
      print("...response for deeplink");
      navigatorKey.currentState!.pop();
      final res = jsonDecode(response.body);
      if (res['status'] == "ok") {
        if (type == "book") {
          Books book = Books.fromJson(res["book"]);
          navigatorKey.currentState!.pushNamed(EbooksViewerScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: book,
                check: false,
              ));
        }
        if (type == "article") {
          Articles articles = Articles.fromJson(res["article"]);
          print("received = " + articles.title!);
          List<Articles> items = [];
          items.add(articles);
          navigatorKey.currentState!.pushNamed(ArticleViewerScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: articles,
                itemsList: items,
                check: false,
              ));
        }
      } else {
        Alerts.show(context, "", "There was an issue processing the request");
      }
    } catch (exception) {
      // I get no exception here
      print("...response for deeplink");
      print(exception.toString());
      print("...response for deeplink");
      navigatorKey.currentState!.pop();
      Alerts.show(context, "", "There was an issue processing the request");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print("widget is disposed");
    WidgetsBinding.instance.removeObserver(this);
    //Provider.of<AudioPlayerModel>(context, listen: false).cleanUpResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      //autoLoad: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          theme: appStateManager.themeData,
          navigatorKey: navigatorKey,
          title: 'Loik Mon',
          scrollBehavior: MyCustomScrollerBehavior(),
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [Locale("en"), Locale("mon")],
          locale: Locale("en"),
          home: SplashScreen(), //widget._defaultHome,
          debugShowCheckedModeBanner: false,
          initialRoute: "/homescreen",
          onGenerateRoute: (settings) {
            final routeName = settings.name;
            if (settings.name!.startsWith('/viewarticle/')) {
              List<String> pathComponents = settings.name!.split('/');
              print(pathComponents);
              print(pathComponents[2]);
              return MaterialPageRoute(
                builder: (context) {
                  return ViewItem(
                    id: pathComponents[2],
                    type: "article",
                  );
                },
              );
            }
            if (settings.name!.startsWith('/viewbook/')) {
              List<String> pathComponents = settings.name!.split('/');
              print(pathComponents[1]);
              return MaterialPageRoute(
                builder: (context) {
                  return ViewItem(
                    id: pathComponents[2],
                    type: "book",
                  );
                },
              );
            }
            if (settings.name == OnboardingPage.routeName) {
              //
              // Cast the arguments to the correct type: ScreenArguments.
              return MaterialPageRoute(
                builder: (context) {
                  return OnboardingPage();
                },
              );
            }

            if (settings.name == BooksScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return BooksScreen(
                    args.items as Itms,
                  );
                },
              );
            }

            if (settings.name == ArticlesCatsScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return ArticlesCatsScreen(
                    args.items as Itms,
                  );
                },
              );
            }

            if (settings.name == OthersBooksScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return OthersBooksScreen(
                    args.position as int,
                  );
                },
              );
            }

            if (settings.name == AuthorsScreen.routeName) {
              //envisionaps@gmail.com
              return MaterialPageRoute(
                builder: (context) {
                  return AuthorsScreen();
                },
              );
            }

            if (settings.name == SearchScreen.routeName) {
              //envisionaps@gmail.com
              return MaterialPageRoute(
                builder: (context) {
                  return SearchScreen();
                },
              );
            }

            if (settings.name == CategoriesScreen.routeName) {
              //envisionaps@gmail.com
              return MaterialPageRoute(
                builder: (context) {
                  return CategoriesScreen();
                },
              );
            }

            if (settings.name == CategoriesViewScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              //envisionaps@gmail.com
              return MaterialPageRoute(
                builder: (context) {
                  return CategoriesViewScreen(args.items as Itms);
                },
              );
            }

            if (settings.name == BooksViewerScreen.routeName) {
              //envisionaps@gmail.com
              return MaterialPageRoute(
                builder: (context) {
                  return BooksViewerScreen(books: settings.arguments as Books);
                },
              );
            }

            if (settings.name == AuthorsListScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return AuthorsListScreen(args.items as Authors, args.check!);
                },
              );
            }

            if (settings.name == LeaguesScreen.routeName) {
              //envisionaps@gmail.com
              return MaterialPageRoute(
                builder: (context) {
                  return LeaguesScreen();
                },
              );
            }

            if (settings.name == ArticleAuthorsListScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return ArticleAuthorsListScreen(args.items as Authors);
                },
              );
            }

            if (settings.name == EbooksViewerScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return EbooksViewerScreen(args.option == null ? false : true,
                      args.items as Books, args.check!);
                },
              );
            }

            if (settings.name == BuyBook.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return BuyBook(args.items as Coins);
                },
              );
            }
            //

            if (settings.name == ArticleViewerScreen.routeName) {
              final ScreenArguements? args =
                  settings.arguments as ScreenArguements?;
              return MaterialPageRoute(
                builder: (context) {
                  return ArticleViewerScreen(
                    check: args!.option == null ? false : true,
                    position: args.position,
                    article: args.items as Articles?,
                    items: args.itemsList as List<Articles>?,
                    isMiniBar: args.check == null ? false : args.check,
                  );
                },
              );
            }

            if (settings.name == CollectionsScreen.routeName) {
              //envisionaps@gmail.com
              return MaterialPageRoute(
                builder: (context) {
                  return CollectionsScreen();
                },
              );
            }

            if (settings.name == CollectionDetailsScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return CollectionDetailsScreen(
                    collectionId: args.position as int,
                  );
                },
              );
            }

            if (settings.name == PendingBankPaymentsPage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return PendingBankPaymentsPage();
                },
              );
            }

            if (settings.name == UnifiedAudioPlayerPage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return UnifiedAudioPlayerPage();
                },
              );
            }

            if (settings.name == AppPdfViewer.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return AppPdfViewer(books: args.items as Books);
                },
              );
            }

            if (settings.name == ItemsViewer.routeName) {
              Map items = (settings.arguments as Map);
              return MaterialPageRoute(
                builder: (context) {
                  return ItemsViewer(
                    title: items['title'],
                    content: items['content'],
                  );
                },
              );
            }

            if (settings.name == InboxListScreenState.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return InboxListScreenState();
                },
              );
            }

            if (settings.name == FaqsScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return FaqsScreen();
                },
              );
            }

            if (settings.name == InboxViewerScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements? args =
                  settings.arguments as ScreenArguements?;
              return MaterialPageRoute(
                builder: (context) {
                  return InboxViewerScreen(
                    inbox: args!.items as Inbox?,
                  );
                },
              );
            }

            if (settings.name == ArticlesScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return ArticlesScreen(
                    args.position as int,
                  );
                },
              );
            }

            if (settings.name == EpubReader.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return EpubReader(epub: args.items as Books);
                },
              );
            }

            if (settings.name == ReviewsScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return ReviewsScreen(args.items as Books);
                },
              );
            }

            if (settings.name == ArticlesReviewsScreen.routeName) {
              ScreenArguements args = settings.arguments as ScreenArguements;
              return MaterialPageRoute(
                builder: (context) {
                  return ArticlesReviewsScreen(args.items as Articles);
                },
              );
            }

            if (settings.name == AuthPage.routeName) {
              bool status = settings.arguments == null
                  ? false
                  : settings.arguments as bool;
              return MaterialPageRoute(
                builder: (context) {
                  return AuthPage(status);
                },
              );
            }

            return MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            );
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  getFirstScreen() async {
    if (html.window.location.href.contains("viewbook")) {
      String thePath = html.window.location.href;
      String lastItem = thePath.substring(thePath.lastIndexOf('/') + 1);
      // Alerts.show(context, "title", lastItem);
    } else if (html.window.location.href.contains("viewarticle")) {
      String thePath = html.window.location.href;
      String lastItem = thePath.substring(thePath.lastIndexOf('/') + 1);
      // Alerts.show(context, "title", lastItem);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("user_seen_onboarding_page") == null ||
          prefs.getBool("user_seen_onboarding_page") == false) {
        Navigator.of(context).pushReplacementNamed(OnboardingPage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    }
    /* */
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 0), () {
      getFirstScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        child: Container(
          width: double.infinity,
          height: 500,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 15,
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(Img.get("logo.png")),
                  //height: 30,
                  //width: 30,
                ),
              ),*/
              Container(height: 20),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: t.appname,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                          color: MyColors.mainC0lor,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

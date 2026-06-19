import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loikmon/providers/ArticleBookmarksModel.dart';
import 'package:loikmon/providers/ArticlesModel.dart';
import 'package:loikmon/providers/AudioPlayerModel.dart';
import 'package:loikmon/providers/BookmarksModel.dart';
import 'package:loikmon/providers/DashboardModel.dart';
import 'package:loikmon/providers/DownloadedBooksModel.dart';
import 'package:loikmon/providers/SubscriptionModel.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';
import 'providers/AppStateManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AppStateManager()),
      ChangeNotifierProvider(create: (_) => DashboardModel()),
      ChangeNotifierProvider(create: (_) => BookmarksModel()),
      ChangeNotifierProvider(create: (_) => SubscriptionModel()),
      ChangeNotifierProvider(create: (_) => ArticlesModel()),
      ChangeNotifierProvider(create: (_) => ArticleBookmarksModel()),
      ChangeNotifierProvider(create: (_) => DownloadedBooksModel()),
      ChangeNotifierProvider(create: (_) => AudioPlayerModel()),
    ], child: MyApp(defaultHome: Container())),
  );
}

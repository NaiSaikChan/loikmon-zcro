import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Coins.dart';
import 'package:loikmon/models/Contacts.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/UserEvents.dart';
import 'package:loikmon/providers/events.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/app_themes.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/SQLiteDbProvider.dart';
import '../i18n/strings.g.dart';
import '../models/Userdata.dart';
import '../utils/langs.dart';

class AppStateManager with ChangeNotifier {
  Userdata? userdata;
  int? isadminuser = 5;
  Contacts? contacts;
  List<Coins> appcoins = [];
  List<int> purchasedbooks = [];
  List<int> purchasedarticles = [];
  List<Coins> pendingpurchases = [];
  List<Itms> countries = [];
  bool? isUserSeenOnboardingPage = false;
  int DEFAULT_LANGUAGE = 0;
  int preferredLanguage = 0;
  int preferredTheme = 0;
  final _themePreference = "theme_preference";
  bool youversionbible = false;
  final _langPreference = "language_preference";
  String version = "";
  bool isDarkModeOn = false;
  ThemeData? _themeData;
  final _colorPreference = "color_preference";
  BuildContext? context;

  AppStateManager() {
    _loadAppSettings();
    getUserData();
    getUserCoins();
    getPackageInfo();
    getCountries();
    registerEvents();
  }

  getCountries() async {
    countries = await SQLiteDbProvider.db.getallcountries();
    print("countries = " + countries.length.toString());
    if (countries.length == 0) {
      loadcountries();
    }
  }

  registerEvents() {
    //logged in event
    eventBus.on<OnCoinsPurchase>().listen((event) async {
      getUserCoins();
      getUserpurchases();
    });
    eventBus.on<OnRequestPayment>().listen((event) {
      Books book = event.media;
      makeBookPayment(book);
    });
    eventBus.on<OnRequestArticlePayment>().listen((event) {
      Articles book = event.media;
      makeArticlePayment(book);
    });
  }

  setContext(BuildContext context) {
    this.context = context;
  }

  ThemeData? get themeData {
    if (_themeData == null) {
      if (isDarkModeOn) {
        _themeData = appThemeDataDark[AppThemeDark.Style1];
      } else {
        _themeData = appThemeDataLight[AppThemeLight.Style1];
      }
    }
    return _themeData;
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    notifyListeners();
  }

  //app theme manager
  void _loadAppSettings() {
    SharedPreferences.getInstance().then((prefs) {
      //bible

      try {
        //load app language
        isDarkModeOn = prefs.getBool(_colorPreference) ?? false;
        preferredLanguage = prefs.getInt(_langPreference) ?? DEFAULT_LANGUAGE;
        preferredTheme = prefs.getInt(_themePreference) ?? 0;
      } catch (e) {
        // quietly pass
      }
      if (isDarkModeOn) {
        _themeData = appThemeDataDark[AppThemeDark.values[preferredTheme]];
      } else {
        _themeData = appThemeDataLight[AppThemeLight.values[preferredTheme]];
      }
      switch (
          appLanguageData[AppLanguage.values[preferredLanguage]]!['value']) {
        case "en":
          LocaleSettings.setLocale(AppLocale.en);
          break;
        case "mon":
          LocaleSettings.setLocale(AppLocale.es);
          break;
      }
      notifyListeners();
    });
  }

  //app language setting
  setAppLanguage(int index) async {
    //AppLanguage _preferredLanguage = AppLanguage.values[index];
    preferredLanguage = index;
    switch (appLanguageData[AppLanguage.values[preferredLanguage]]!['value']) {
      case "en":
        LocaleSettings.setLocale(AppLocale.en);
        break;
      case "mon":
        LocaleSettings.setLocale(AppLocale.es);
        break;
    }
    // Here we notify listeners that theme changed
    // so UI have to be rebuild
    notifyListeners();
    // Save selected theme into SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(_langPreference, preferredLanguage);
  }

  /// Sets theme and notifies listeners about change.
  setTheme(int index) async {
    if (isDarkModeOn) {
      _themeData = appThemeDataDark[AppThemeDark.values[index]];
    } else {
      _themeData = appThemeDataLight[AppThemeLight.values[index]];
    }
    // Here we notify listeners that theme changed
    // so UI have to be rebuild

    // Save selected theme into SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    preferredTheme = index;
    prefs.setInt(_themePreference, preferredTheme);
    notifyListeners();
  }

  setColor(bool mode) async {
    // Here we notify listeners that theme changed
    // so UI have to be rebuild

    // Save selected theme into SharedPreferences
    isDarkModeOn = mode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(_colorPreference, isDarkModeOn);
    if (isDarkModeOn) {
      _themeData = appThemeDataDark[AppThemeDark.values[preferredTheme]];
    } else {
      _themeData = appThemeDataLight[AppThemeLight.values[preferredTheme]];
    }
    notifyListeners();
  }

  getUserSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("user_seen_onboarding_page") != null) {
      isUserSeenOnboardingPage = prefs.getBool("user_seen_onboarding_page");
    }
  }

  setUserSeenOnboardingPage(bool seen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("user_seen_onboarding_page", seen);
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
    if (userdata == null) return;
    eventBus.fire(UserLoggedInEvent(userdata!));
    if (userdata != null) {
      getUserpurchases();
      getUserCoins();
      getUserpendingpurchases();
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      if (prefs.getInt("isadminuserkey") != null) {
        this.isadminuser = prefs.getInt("isadminuserkey");
        notifyListeners();
      }
    }
  }

  setUserData(Userdata _userdata, int isadminuser) async {
    await SQLiteDbProvider.db.deleteUserData();
    await SQLiteDbProvider.db.insertUser(_userdata);
    this.userdata = _userdata;
    this.isadminuser = isadminuser;
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    prefs.setInt("isadminuserkey", isadminuser);
    eventBus.fire(UserLoggedInEvent(userdata!));
    if (userdata != null) {
      getUserpurchases();
      getUserpendingpurchases();
    }
    notifyListeners();
  }

  unsetUserData() async {
    await SQLiteDbProvider.db.deleteUserData();
    isadminuser = 5;
    this.userdata = null;
    eventBus.fire(AppEvents.LOGOUT);
    notifyListeners();
    purchasedbooks = [];
    purchasedarticles = [];
    pendingpurchases = [];
  }

  //utils
  Future<void> getUserpurchases() async {
    if (userdata == null) return;
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.FETCH_USER_PURCHASES),
        body: jsonEncode({
          "data": {"email": userdata!.email}
        }),
      );

      if (response.statusCode == 200) {
        dynamic res = jsonDecode(response.body);
        //userCoins = int.parse(res['coins'] as String);
        //setUserCoins(userCoins);
        purchasedbooks = [];
        for (var itm in res['books']) {
          purchasedbooks.add(int.parse(itm as String));
        }
        purchasedarticles = [];
        for (var itm in res['articles']) {
          purchasedarticles.add(int.parse(itm as String));
        }
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> recordbookpayment(Books media) async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      Alerts.subscriptionloginrequiredhint(context!);
      return;
    }
    Alerts.showProgressDialog(context!, t.processingpleasewait);
    try {
      var data = {
        "amount": media.amount,
        "email": userdata.email,
        "book": media.id,
      };
      final response = await http.post(
        Uri.parse(ApiUrl.PURCHASEMEDIA),
        body: jsonEncode({"data": data}),
      );
      Navigator.of(context!).pop();
      final res = jsonDecode(response.body);
      if (res['status'] == "ok") {
        eventBus.fire(OnCoinsPurchase());
        Alerts.show(context!, "", t.bookpurchasesuccess);
      } else {
        Alerts.show(context!, "", t.bookpurchaseerror);
      }
    } catch (exception) {
      print(exception.toString());
      // I get no exception here
      Navigator.of(context!).pop();
    }
  }

  isBookPurchased(int id) {
    if (isadminuser == 0) return true;
    if (purchasedbooks.length == 0) return false;
    int? books = purchasedbooks.firstWhereOrNull((element) => element == id);
    return books != null;
  }

  bool isArticlePurchased(Articles _article) {
    if (isadminuser == 0) return true;
    if (_article.amount == 0) return true;
    if (purchasedarticles.length == 0) return false;
    int? article =
        purchasedarticles.firstWhereOrNull((element) => element == _article.id);
    return article != null;
  }

  //get user pending purchases
  Future<void> getUserpendingpurchases() async {
    if (userdata == null) return;
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.FETCH_USER_PENDING_PURCHASES),
        body: jsonEncode({
          "data": {"email": userdata!.email}
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        //userCoins = int.parse(res['coins'] as String);
        //setUserCoins(userCoins);
        pendingpurchases = parsecoins(response.body);
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  //getcountries
  Future<void> loadcountries() async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.loadcountries),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        countries = parsecountries(response.body);
        await SQLiteDbProvider.db.addAllCountries(countries);
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  static List<Itms> parsecountries(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["countries"].cast<Map<String, dynamic>>();
    return parsed.map<Itms>((json) => Itms.fromJson(json)).toList();
  }

  Future<void> getCoins(BuildContext context) async {
    if (appcoins.length != 0) {
      Utility.showCoinsDialog(context, appcoins, userdata!.coins!);
      return;
    }
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.GET_COINS),
      );
      print(response.body);
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        //dynamic res = jsonDecode(response.data);

        appcoins = parsecoins(response.body);
        Utility.showCoinsDialog(
            context, appcoins, userdata == null ? 0 : userdata!.coins!);
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Alerts.showToast(context, "Unable to load app coins");
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      Navigator.of(context).pop();
      Alerts.showToast(context, "Unable to load app coins");
    }
  }

  static List<Coins> parsecoins(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["coins"].cast<Map<String, dynamic>>();
    return parsed.map<Coins>((json) => Coins.fromJson(json)).toList();
  }

  Future<void> getUserCoins() async {
    if (userdata == null) return;
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.getusercoins),
        body: jsonEncode({
          "data": {"email": userdata!.email}
        }),
      );
      final res = jsonDecode(response.body);
      Userdata _userdata = Userdata(
        coins: int.parse(res['coins'].toString()),
        seller: userdata!.seller,
        name: userdata!.name,
        firstname: userdata!.firstname,
        lastname: userdata!.lastname,
        email: userdata!.email,
      );
      await SQLiteDbProvider.db.deleteUserData();
      await SQLiteDbProvider.db.insertUser(_userdata);
      userdata = _userdata;
      notifyListeners();
    } catch (exception) {
      // I get no exception here
      print("usercoins issue = " + exception.toString());
    }
  }

  //
  Future<void> makeBookPayment(Books book) async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      Alerts.subscriptionloginrequiredhint(context!);
      return;
    }

    Alerts.showProgressDialog(context!, t.processingpleasewait);
    try {
      var data = {
        "amount": book.amount,
        "email": userdata.email,
        "bookid": book.id,
      };
      print(data);
      final response = await http.post(
        Uri.parse(ApiUrl.PURCHASEBOOK),
        body: jsonEncode({"data": data}),
      );
      Navigator.of(context!).pop();
      final res = jsonDecode(response.body);
      if (res['status'] == "ok") {
        eventBus.fire(OnCoinsPurchase());
        Alerts.show(context, "", t.purchasesuccess);
      } else {
        Alerts.showpayalertwithcallback(context, "", res['message'], () {
          getCoins(context!);
        });
      }
    } catch (exception) {
      print(exception.toString());
      // I get no exception here
      Navigator.of(context!).pop();
    }
  }

  Future<void> makeArticlePayment(Articles articles) async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      Alerts.subscriptionloginrequiredhint(context!);
      return;
    }

    Alerts.showProgressDialog(context!, t.processingpleasewait);
    try {
      var data = {
        "amount": articles.amount,
        "email": userdata.email,
        "articleid": articles.id,
      };

      final response = await http.post(
        Uri.parse(ApiUrl.PURCHASEARTICLE),
        body: jsonEncode({"data": data}),
      );
      Navigator.of(context!).pop();
      final res = jsonDecode(response.body);
      if (res['status'] == "ok") {
        eventBus.fire(OnCoinsPurchase());
        Alerts.show(context, "", t.purchasesuccess);
      } else {
        Alerts.showpayalertwithcallback(context, "", res['message'], () {
          getCoins(context!);
        });
      }
    } catch (exception) {
      print(exception.toString());
      // I get no exception here
      Navigator.of(context!).pop();
    }
  }

  Future<void> getContactUs(BuildContext context) async {
    if (contacts != null) {
      Utility.showContactusDialog(context, contacts!);
      return;
    }
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.fetchcontactus),
      );
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final res = jsonDecode(response.body);
        contacts = Contacts.fromJson(res['contactus']);
        Utility.showContactusDialog(context, contacts!);
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Alerts.showToast(context, "Unable to load app coins");
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);
      Navigator.of(context).pop();
      Alerts.showToast(context, exception.toString());
    }
  }

  Future<void> getContactUsLink(BuildContext context) async {
    if (contacts != null) {
      launchmessenger(context);
      return;
    }
    Alerts.showProgressDialog(
      context,
      t.processingpleasewait,
    );
    try {
      final response = await http.get(Uri.parse(
        ApiUrl.fetchcontactus,
      ));
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        final res = jsonDecode(response.body);
        contacts = Contacts.fromJson(res['contactus']);
        launchmessenger(context);
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(response.body);
        Alerts.showToast(context, "Unable to load app coins");
      }
    } catch (exception) {
      // I get no exception here
      //print(exception);

      Navigator.of(context).pop();
      Alerts.showToast(context, exception.toString());
    }
  }

  launchmessenger(BuildContext context) async {
    if (!await launchUrl(
      Uri.parse(contacts!.contactusmessenger!),
      mode: LaunchMode.externalApplication,
    )) {
      //throw Exception('Could not launch link');
      Alerts.showToast(context, 'Could not launch link');
    }
  }

  Future<void> purchaseBookWithCoupon(Books book, String couponCode) async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      Alerts.subscriptionloginrequiredhint(context!);
      return;
    }

    final String code = couponCode.trim();
    if (code.isEmpty) {
      Alerts.showToast(context!, "Please enter a coupon code");
      return;
    }

    Alerts.showProgressDialog(context!, t.processingpleasewait);

    try {
      final data = {
        "email": userdata.email,
        "code": code,
        "book_id": book.id,
      };

      final response = await http.post(
        Uri.parse(ApiUrl.REDEEM_BOOK_COUPON),
        body: jsonEncode({"data": data}),
      );

      Navigator.of(context!).pop();

      final res = jsonDecode(response.body);

      if (res["status"] == "ok") {
        await getUserpurchases();
        await getUserCoins();
        await getUserpendingpurchases();

        eventBus.fire(OnCoinsPurchase());

        Alerts.show(
          context!,
          "",
          res["msg"] ?? "Book purchased successfully using coupon",
        );
      } else {
        Alerts.show(
          context!,
          "",
          res["msg"] ?? "Unable to use this coupon",
        );
      }
    } catch (exception) {
      print("purchaseBookWithCoupon error = ${exception.toString()}");
      Navigator.of(context!).pop();
      Alerts.showToast(context!, exception.toString());
    }
  }
}

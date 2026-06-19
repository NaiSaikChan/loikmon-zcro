/*
 * Generated file. Do not edit.
 *
 * Locales: 2
 * Strings: 616 (308.0 per locale)
 *
 * Built on 2025-11-23 at 13:15 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale {
  en, // 'en' (base locale, fallback)
  es, // 'es'
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
  Translations._(); // no constructor

  static _StringsEn of(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
    if (inheritedWidget == null) {
      throw 'Please wrap your app with "TranslationProvider".';
    }
    return inheritedWidget.translations;
  }
}

class LocaleSettings {
  LocaleSettings._(); // no constructor

  /// Uses locale of the device, fallbacks to base locale.
  /// Returns the locale which has been set.
  static AppLocale useDeviceLocale() {
    final locale = AppLocaleUtils.findDeviceLocale();
    return setLocale(locale);
  }

  /// Sets locale
  /// Returns the locale which has been set.
  static AppLocale setLocale(AppLocale locale) {
    _currLocale = locale;
    _t = _currLocale.translations;

    // force rebuild if TranslationProvider is used
    _translationProviderKey.currentState?.setLocale(_currLocale);

    return _currLocale;
  }

  /// Sets locale using string tag (e.g. en_US, de-DE, fr)
  /// Fallbacks to base locale.
  /// Returns the locale which has been set.
  static AppLocale setLocaleRaw(String rawLocale) {
    final locale = AppLocaleUtils.parse(rawLocale);
    return setLocale(locale);
  }

  /// Gets current locale.
  static AppLocale get currentLocale {
    return _currLocale;
  }

  /// Gets base locale.
  static AppLocale get baseLocale {
    return _baseLocale;
  }

  /// Gets supported locales in string format.
  static List<String> get supportedLocalesRaw {
    return AppLocale.values.map((locale) => locale.languageTag).toList();
  }

  /// Gets supported locales (as Locale objects) with base locale sorted first.
  static List<Locale> get supportedLocales {
    return AppLocale.values.map((locale) => locale.flutterLocale).toList();
  }
}

/// Provides utility functions without any side effects.
class AppLocaleUtils {
  AppLocaleUtils._(); // no constructor

  /// Returns the locale of the device as the enum type.
  /// Fallbacks to base locale.
  static AppLocale findDeviceLocale() {
    final String? deviceLocale = WidgetsBinding.instance.window.locale
        .toLanguageTag();
    if (deviceLocale != null) {
      final typedLocale = _selectLocale(deviceLocale);
      if (typedLocale != null) {
        return typedLocale;
      }
    }
    return _baseLocale;
  }

  /// Returns the enum type of the raw locale.
  /// Fallbacks to base locale.
  static AppLocale parse(String rawLocale) {
    return _selectLocale(rawLocale) ?? _baseLocale;
  }
}

// context enums

// interfaces generated as mixins

// translation instances

late _StringsEn _translationsEn = _StringsEn.build();
late _StringsEs _translationsEs = _StringsEs.build();

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {
  /// Gets the translation instance managed by this library.
  /// [TranslationProvider] is using this instance.
  /// The plural resolvers are set via [LocaleSettings].
  _StringsEn get translations {
    switch (this) {
      case AppLocale.en:
        return _translationsEn;
      case AppLocale.es:
        return _translationsEs;
    }
  }

  /// Gets a new translation instance.
  /// [LocaleSettings] has no effect here.
  /// Suitable for dependency injection and unit tests.
  ///
  /// Usage:
  /// final t = AppLocale.en.build(); // build
  /// String a = t.my.path; // access
  _StringsEn build() {
    switch (this) {
      case AppLocale.en:
        return _StringsEn.build();
      case AppLocale.es:
        return _StringsEs.build();
    }
  }

  String get languageTag {
    switch (this) {
      case AppLocale.en:
        return 'en';
      case AppLocale.es:
        return 'es';
    }
  }

  Locale get flutterLocale {
    switch (this) {
      case AppLocale.en:
        return const Locale.fromSubtags(languageCode: 'en');
      case AppLocale.es:
        return const Locale.fromSubtags(languageCode: 'es');
    }
  }
}

extension StringAppLocaleExtensions on String {
  AppLocale? toAppLocale() {
    switch (this) {
      case 'en':
        return AppLocale.en;
      case 'es':
        return AppLocale.es;
      default:
        return null;
    }
  }
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey =
    GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
  TranslationProvider({required this.child})
    : super(key: _translationProviderKey);

  final Widget child;

  @override
  _TranslationProviderState createState() => _TranslationProviderState();

  static _InheritedLocaleData of(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
    if (inheritedWidget == null) {
      throw 'Please wrap your app with "TranslationProvider".';
    }
    return inheritedWidget;
  }
}

class _TranslationProviderState extends State<TranslationProvider> {
  AppLocale locale = _currLocale;

  void setLocale(AppLocale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLocaleData(locale: locale, child: widget.child);
  }
}

class _InheritedLocaleData extends InheritedWidget {
  final AppLocale locale;
  Locale get flutterLocale => locale.flutterLocale; // shortcut
  final _StringsEn translations; // store translations to avoid switch call

  _InheritedLocaleData({required this.locale, required Widget child})
    : translations = locale.translations,
      super(child: child);

  @override
  bool updateShouldNotify(_InheritedLocaleData oldWidget) {
    return oldWidget.locale != locale;
  }
}

// pluralization feature not used

// helpers

final _localeRegex = RegExp(
  r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$',
);
AppLocale? _selectLocale(String localeRaw) {
  final match = _localeRegex.firstMatch(localeRaw);
  AppLocale? selected;
  if (match != null) {
    final language = match.group(1);
    final country = match.group(5);

    // match exactly
    selected = AppLocale.values.cast<AppLocale?>().firstWhere(
      (supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'),
      orElse: () => null,
    );

    if (selected == null && language != null) {
      // match language
      selected = AppLocale.values.cast<AppLocale?>().firstWhere(
        (supported) => supported?.languageTag.startsWith(language) == true,
        orElse: () => null,
      );
    }

    if (selected == null && country != null) {
      // match country
      selected = AppLocale.values.cast<AppLocale?>().firstWhere(
        (supported) => supported?.languageTag.contains(country) == true,
        orElse: () => null,
      );
    }
  }
  return selected;
}

// translations

// Path: <root>
class _StringsEn {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  _StringsEn.build();

  /// Access flat map
  dynamic operator [](String key) => _flatMap[key];

  // Internal flat map initialized lazily
  late final Map<String, dynamic> _flatMap = _buildFlatMap();

  late final _StringsEn _root = this; // ignore: unused_field

  // Translations
  String get appname => 'Loik Mon';
  String get openbook => 'Open Book';
  String get book => 'Book';
  String get bookss => '';
  String get booksss => 'Book';
  String get article => 'Article';
  String get articless => 'Article';
  String get articlesss => '';
  String get initializingapp =>
      'Please wait while we setup a few things, it wont take long, we promise.';
  String get errorinitapp =>
      'Unfortunately, we could not complete setup at the moment, please check your internet connection, then click to retry';
  String get initappsucess =>
      'Congratulations, setup is now complete, you can now click to continue to app';
  String get retry => 'Try Again';
  String get continuetoapp => 'Continue to App';
  String get home => 'Home';
  String get bookmarks => 'Bookmarks';
  String get playlists => 'Playlists';
  String get havecoupon => 'Have A Coupon?';
  String get downloads => 'Downloaded book';
  String get website => ' Our Website';
  String get terms => 'Terms & Conditions';
  String get account => 'Profile';
  String get appsettings => 'App Settings';
  String get guestuser => 'Guest User';
  String get createanaccounthint => 'Create an account or login to app';
  String get logoutfromapp => 'Logout from App';
  String get deletemyaccount => 'Delete my account';
  String get delete => 'Delete';
  String get applanguage => 'App Language';
  String get chooseapplanguage => 'Select App Language';
  String get emailaddress => 'Email Address';
  String get confirmpassword => 'Confirm Password';
  String get passwordsdontmatch => 'Passwords dont match!';
  String get login => 'LOG IN';
  String get createaccount => 'Create Account';
  String get forgotpassword => 'Forgot Password?';
  String get resetpassword => 'Reset Password';
  String get resetpasswordhint =>
      'A reset password link will be sent to your email.';
  String get resetpasswordsuccess =>
      'If the email exists in our platform, you should recieve an instruction on how to reset your password.';
  String get goback => 'Go Back';
  String get ok => 'OK';
  String get cancel => 'Cancel';
  String get resendverifycode => 'Resend Verification Link';
  String get successregistermessage =>
      'You have successfully created an account, please check your email for a verification link and verify your email address.';
  String get successresendverifymessage =>
      'A verification link have been sent to your email.';
  String get resendverifylink =>
      'A verification link was sent to your email address, visit the link to verify your email. Did not get the email? click the link below to resend verification link.';
  String get processingpleasewait => 'Processing, please wait...';
  String get cannotprocess =>
      'The requested operation cannot be processed at the moment, please try again later.';
  String get oops => 'Ooops!';
  String get save => 'Save';
  String get error => 'Error';
  String get success => 'Success';
  String get downloadversion => 'Download';
  String get downloading => 'Downloading';
  String get failedtodownload => 'Failed to download';
  String get pleaseclicktoretry => 'Please click to retry.';
  String get of => 'Of';
  String get nobibleversionshint =>
      'There is no bible data to display, click on the button below to download atleast one bible version.';
  String get downloaded => 'Downloaded';
  String get enteremailaddresstoresetpassword =>
      'Enter your email to reset your password';
  String get backtologin => 'BACK TO LOGIN';
  String get signintocontinue => 'Sign in to continue';
  String get signin => 'S I G N  I N';
  String get signinforanaccount => 'SIGN UP FOR AN ACCOUNT?';
  String get alreadyhaveanaccount => 'Already have an account?';
  String get updateprofile => 'Update Profile';
  String get updateprofilehint =>
      'To get started, please update your profile page, this will help us in connecting you with other people';
  String get deleteselectedhint =>
      'This action will delete the selected messages.  Please note that this only deletes your side of the conversation, \n the messages will still show on your partners device.';
  String get deleteselected => 'Delete selected';
  String get unabletofetchconversation =>
      'Unable to Fetch \nyour conversation with \n';
  String get loadmoreconversation => 'Load more conversations';
  String get sendyourfirstmessage => 'Send your first message to \n';
  String get unblock => 'Unblock ';
  String get block => 'Block';
  String get writeyourmessage => 'Write your message...';
  String get clearconversation => 'Clear Conversation';
  String get clearconversationhintone =>
      'This action will clear all your conversation with ';
  String get clearconversationhinttwo =>
      '.\n  Please note that this only deletes your side of the conversation, the messages will still show on your partners chat.';
  String get logoutfromapphint =>
      'You wont be able to access some priviledges if you are not logged in.';
  String get deleteaccount => 'Delete my account';
  String get deleteaccounthint =>
      'This action will delete your account and remove all your data, once your data is deleted, it cannot be recovered.';
  String get deleteaccountsuccess => 'Account deletion was succesful';
  String get myprofile => 'My Profile';
  String get copiedtoclipboard => 'Copied to clipboard';
  String get biblebooks => 'Bible';
  String get searchhint => 'Search Audio & Video Messages';
  String get performingsearch => 'Searching Audios and Videos';
  String get nosearchresult => 'No results Found';
  String get nosearchresulthint => 'Try input more general keyword';
  String get dataloaderror =>
      'Could not load requested data at the moment, check your data connection and click to retry.';
  String get bookmark => 'Bookmark';
  String get unbookmark => 'UnBookmark';
  String get pulluploadmore => 'pull up load';
  String get loadfailedretry => 'Load Failed!Click retry!';
  String get releaseloadmore => 'release to load more';
  String get nomoredata => 'No more Data';
  String get notsupported => 'Not Supported';
  String get cleanupresources => 'Cleaning up resources';
  String get sharefiletitle => 'Watch or Listen to ';
  String get sharefilebody => 'Via MonEbook, Download now at ';
  String get sharetext =>
      'Enjoy Loik Mon, Share, bookmark and download offline';
  String get sharetexthint =>
      'Join the Loik Mon platform that lets you read thousands of Loik Mon. Download now at';
  String get next => 'Next';
  List<String> get onboardingpagetitles => [
    'Welcome to loikmon Platform',
    'Great Books Discovery',
    'Offline Books',
    'Bookmark Books',
  ];
  List<String> get onboardingpagehints => [
    'loikmon is a platform that lets you read thousands on Loik Mon.',
    'Discover thousands of Loik Mon, all at your disposal.',
    'Download Books and read offline anytime you want',
    'Bookmark and read later any book of your choice.',
  ];
  String get app_name => 'Loik Mon';
  String get walletbalance => 'Wallet Balance';
  String get loading_app => 'initializing app...';
  String get allitems => 'လိက်ဖအိုတ်';
  String get emptyplaylist => 'No Playlists';
  String get grantstoragepermission =>
      'Please grant accessing storage permission to continue';
  String get share_file_title => 'Discover  ';
  String get share_file_body => 'Via loikmon App, Download now at ';
  String get categories => 'Categories';
  String get category => 'Category';
  String get latest => 'Books';
  String get magazines => 'Magazines';
  String get author => 'Author';
  String get profile => 'Profile';
  String get settings => 'Settings';
  String get playlist => 'My Playlist';
  String get app_info => 'App Info';
  String get books => 'Books';
  String get soldbooks => 'Books on Sale';
  String get soldmagazines => 'Magazines on Sale';
  String get collection => 'Collections';
  List<String> get searchoptions => ['Books', 'Magazines'];
  List<String> get viewoptions => ['PDF', 'EPUB'];
  List<String> get fonts => [
    'Style 1',
    'Style 2',
    'Style 3',
    'Style 4',
    'Style 5',
  ];
  String get start_subscription => 'Unlock Premium Features';
  String get start_subscription_hint =>
      'Unlock premium features to start your journey to a never-ending media streaming experience';
  String get suggestedforyou => 'Suggested for you';
  String get tracks => 'Tracks';
  String get livetvchannels => 'Live Tv Channels';
  String get latestbooks => 'Latest Books';
  String get popularbooks => 'Popular Books';
  String get latestmagazines => 'Mon Magazines';
  String get authors => 'Authors';
  String get viewall => 'View All';
  String get bookmarksMedia => 'My Bookmarks';
  String get noitemstodisplay => 'No Items To Display';
  String get download => 'Downloads';
  String get addplaylist => 'Add to playlist';
  String get share => 'Share';
  String get deletemedia => 'Delete File';
  String get deletemediahint =>
      'Do you wish to delete this downloaded file? This action cannot be undone.';
  String get search_hint => 'Search Books and Magazines';
  String get performing_search => 'Searching Books and Magazines';
  String get no_search_result => 'No results Found';
  String get no_search_result_hint => 'Try input more general keyword';
  String get comments => 'Comments';
  String get replies => 'Replies';
  String get reply => 'Reply';
  String get login_to_add_comment => 'Login to add a comment';
  String get login_to_reply => 'Login to reply';
  String get write_a_message => 'Write a message...';
  String get no_comments => 'No Comments found \nclick to retry';
  String get error_making_comments =>
      'Cannot process commenting at the moment..';
  String get error_deleting_comments =>
      'Cannot delete this comment at the moment..';
  String get error_editing_comments =>
      'Cannot edit this comment at the moment..';
  String get error_loadingmore_comments =>
      'Cannot load more comments at the moment..';
  String get deleting_comment => 'Deleting review';
  String get editing_comment => 'Editing comment';
  String get delete_comment_alert => 'Delete Review';
  String get edit_comment_alert => 'Edit Comment';
  String get delete_comment_alert_text =>
      'Do you wish to delete this review? This action cannot be undone';
  String get load_more => 'load more';
  String get guest_user => 'Guest User';
  String get full_name => 'Full Name';
  String get email_address => 'Email Address';
  String get password => 'Password';
  String get repeat_password => 'Repeat Password';
  String get register => 'Register';
  String get logout => 'Logout';
  String get logout_from_app => 'Logout from app?';
  String get logout_from_app_hint =>
      'You wont be able to like or comment on articles and videos if you are not logged in.';
  String get go_to_login => 'Go to Login';
  String get reset_password => 'Reset Password';
  String get login_to_account => 'Already have an account? Login';
  String get empty_field_error_hint => 'You need to fill all the fields';
  String get invalid_email_error_hint =>
      'You need to enter a valid email address';
  String get passwords_dont_match => 'Passwords dont match';
  String get processing_please_wait => 'Processing, Please wait...';
  String get create_account => 'Create an account';
  String get forgot_password => 'Forgot Password?';
  String get more_options => 'More Options';
  String get about => 'About Us';
  String get privacy => 'Privacy Policy';
  String get rate => 'Rate App';
  String get version => 'Version';
  String get skip => 'Skip';
  String get skip_login => 'Skip Login';
  String get skip_register => 'Skip Registration';
  String get data_load_error =>
      'Could not load requested data at the moment, check your data connection and click to retry.';
  String get no_items => 'No Items to display at the moment.';
  String get loginrequired => 'Login Required';
  String get loginrequiredhint =>
      'To make payments on this platform, you need to be logged in. Create a free account now or log in to your existing account.';
  String get subscriptions => 'App Subscriptions';
  String get subscribe => 'SUBSCRIBE';
  String get subscribehint => 'Payment Required';
  String get previewsubscriptionrequiredhint =>
      'Payment is required to download or read this book. Purchase this book now for ';
  String get done => 'GET STARTED';
  String get paydescriptiontitle => 'Payment Descriptions';
  String get paydescriptioncontent =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  String get googlepayreadmecontent =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  String get couponcodereadmetitle => 'Coupon Codes';
  String get couponcodereadmecontent1 =>
      'The Coupon code you have got, please add it under here "Enter Coupon"';
  String get couponcodereadmecontent =>
      'The coupon code can be used to add digital coins to your E-Wallet account.To add digital coins to your E-Wallet account, please contact us via Messenger or by calling +82-10-6828-8163 to receive your coupon code. Once the coins are credited, you can use them to purchase books and articles.';
  String get couponcodereadmetitle2 => 'Banks Description';
  String get couponcodereadmecontent2 =>
      'For bank transfers, select your current country of residence, choose an available payment method, and pay the listed amount. After completing the payment, send us the proof and kindly wait for our confirmation. Once we receive it, we will review and confirm once approved.';
  String get couponcodereadmecontent3 =>
      'Select your country, choose a payment method, and pay the amount. Send proof, then wait for confirmation after review.';
  String get rateapp => 'Rate App';
  String get bookpurchasesuccess => 'Book Purchase was Successful.';
  String get bookpurchaseerror =>
      'There was an issue with the item purchase, please contact app admin.';
  String get cannotreviewerror => 'Cannot drop a review at the moment';
  String get paymentdetails => 'Payment Details';
  String get mobilebanking => 'Mobile Banking';
  String get paywithcoupon => 'Pay with Coupon';
  String get choosecountry => 'Choose Country:';
  String get nocountryselected => 'No Country Selected';
  String get paymentmethods => 'Payment Methods:';
  String get loadingbanks => 'loading banks..';
  String get unabletoloadbanks => 'Unable to load banks';
  String get nobanksforcountry => 'No banks for selected countries';
  String get attachproofofpayment => 'Attach proof of payment';
  String get selectafile => 'Select a file';
  String get nofilechoosen => 'No file chosen';
  String get pleaseselectafiletoupload =>
      'Please select a file to upload for proof of payment';
  String get submitpaymentproof => 'Submit payment proof';
  String get paymentofproofsuccess =>
      'Your proof of payment was submitted successfully. We will alert you once your payment has been approved by the seller.';
  String get paymentofprooferror =>
      'Sorry, we could not save this data at the moment. Please try again.';
  String get learnmore =>
      'Google itself does not charge extra fee for sending the money to your bank.';
  String get couponcode => 'Coupon code';
  String get entercouponcode => 'Enter Coupon';
  String get entercopounalert => 'Please enter a coupon code';
  String get getcoupononmessegner => 'Get coupon code here';
  String get phoneus => 'OR Phone Us';
  String get description => 'Description';
  String get failedtoloadoverview => 'Failed to load overview';
  String get authorbooks => 'Author Books';
  String get booksyoumaylike => 'Books you may like';
  String get ratebook => 'Rate';
  String get taptorate => 'Tap a star to set your rating';
  String get submit => 'Submit';
  String get addcomment => 'Add comment here';
  String get writeareview => 'Write a review';
  String get topreviews => 'Top Reviews';
  String get noreviews => 'No Reviews yet';
  String get accountsuccess => 'Account created successfully';
  String get topsearchbooks => 'Top Search Books';
  String get topsellbooks => 'Top Sell Books';
  String get recommended => 'Recommended Books';
  String get overview => 'Overview';
  String get information => 'Information';
  String get reviews => 'Reviews';
  String get deleteoptions => 'Download Options';
  String get readoptions => 'Read Options';
  String get pending => 'Pending';
  String get buy => 'Buy';
  String get read => 'Read';
  String get changeappfont => 'Change App Font';
  String get changefontsizespacing => 'Change Font Size & Spacing';
  String get fontsize => 'Font Size';
  String get linespace => 'Line Space';
  String get library => 'Library';
  String get relatedbooks => 'Related Books';
  String get booksearchhint => 'Type Book or Author name';
  String get articlesearchhint => 'Type Article or Author name';
  String get searching => 'Searching ...';
  String get Customize => 'Customize';
  String get enabledarkmode => 'Enable Dark Mode';
  String get more => 'More';
  String get newbooks => 'New Books';
  String get newbook => 'New Book';
  String get newarticles => 'New Articles';
  String get newarticle => 'New Article';
  String get populararticles => 'Popular Articles';
  String get articles => 'Articles';
  String get allbooks => 'All Books';
  String get makepurchasehint =>
      'units will be deducted from your wallet. Click proceed to make this purchase.';
  String get proceed => 'PROCEED';
  String get fewcoinwallethint =>
      'Sorry, you do not have enough coins in your wallet to make this purchase';
  String get purchasesuccess => 'Congrats, you purchase was successful';
  String get articlepurchasehint =>
      'You need to purchase this article before you can read it, click the button below to make this purchase.';
  String get bookbookmarks => 'Bookmarked Books';
  String get bookmarkedarticles => 'Bookmarked Articles';
  String get purchasedbooks => 'Purchased Books';
  String get purchasedarticles => 'Purchased Articles';
  String get sales => 'Sales';
  String get views => 'Views';
  String get coins => 'Units';
  String get purchasecoins => 'Purchase more coins for your E-wallet';
  String get buycoins => 'Buy Coins';
  String get purchasecoinshint => 'Purchase coins for your E-Wallet';
  String get contactus => 'Contact Us';
  String get topupcoins => 'Top up coins';
  String get youhave => 'You have';
  String get paymentfor => 'Payment for';
  String get pendingapproval => 'Pending Approval';
  String get paymentapproved => 'Payment Approved';
  String get epubsettings => 'Epub Settings';
  String get fontstyle => 'Font Style';
  String get background => 'Background';
  String get bookchapter => 'Book Chapters';
  String get downloadall => 'Download All';
  String get light => 'Light';
  String get dark => 'Dark';
  String get downloadedarticles => 'Downloaded Articles';
  String get closeapp => 'Close App';
  String get quitapp =>
      'Do you wish to close the app and return to your home screen';
  String get confirm => 'CONFIRM';
  String get normalprice => 'Normal Price';
  String get selectnormalprice =>
      'Select normal price or give more coins to supports authors and the platform';
  String get listen => 'Listen';
  String get audio => 'audio';
  String get forcoins => 'For';
  String get forcoin => '';
  String get freearticle => 'Free Articles';

  String get chapter_title => 'Book Chapter';
  String get searchauthors => 'Search Authors';
  String get searchleagues => 'Search Leagues';
  String get leagues => 'Leagues';
  String get okay => 'OK';
  String get searchArticles => 'Search Articles';
  String get fromauthor => 'From';
}

// Path: <root>
class _StringsEs implements _StringsEn {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  _StringsEs.build();

  /// Access flat map
  @override
  dynamic operator [](String key) => _flatMap[key];

  // Internal flat map initialized lazily
  @override
  late final Map<String, dynamic> _flatMap = _buildFlatMap();

  @override
  late final _StringsEs _root = this; // ignore: unused_field

  // Translations
  @override
  String get appname => 'Loik Mon';
  @override
  String get book => 'လိက်ကၞပ်';
  @override
  String get bookss => 'လိက်';
  @override
  String get booksss => 'ကၞပ်';
  @override
  String get article => 'လိက်ပရေၚ်';
  @override
  String get articless => 'ပိုဒ်';
  @override
  String get articlesss => 'လိက်ပရေၚ်';
  @override
  String get initializingapp =>
      'သ္ပဂုဏ်တုဲ စၟဳမၚ်ကဵုမွဲလစုတ်ညိ အဃောပိုယ်တအ် စုတ်ဒၟံၚ် အရာညိည, ကမၠောန်ဏအ်ဟွံကေတ်အခိၚ်ဗွဲမလအ်ရ';
  @override
  String get errorinitapp =>
      'ဗွဲကဆံၚ်ကံမပရေံ, ပ္ဍဲအခိၚ်လၟုဟ်ဝွံ ကမၠောန်ပိုယ်တအ်ကၠောန်သ္ပလၟုဟ် ဍိုက်ပေၚ်အာစိုပ်ဒတုဲဟွံမာန်ဏဳရ, please check your internet connection သ္ပဂုဏ်တုဲ ကလေၚ်စၟဳစၟတ် ဇြဟတ်လာၚ်လပှ်ကျာညိ, တုဲမ္ဂး ကလေၚ်ဍဵုဂစာန်မွဲဝါပၠန်ညိ';
  @override
  String get initappsucess =>
      'Congratulations, setup is now complete, you can now click to continue to app';
  @override
  String get retry => 'Try Again';
  @override
  String get continuetoapp => 'ဆက်ပံက်အာ';
  @override
  String get home => 'မုက်တမ်';
  @override
  String get bookmarks => 'ဂိုၚ်ဒေပ်';
  @override
  String get playlists => 'Playlists';
  @override
  String get downloads => 'လိက်တံၚ်ဂြဲလဝ်';
  @override
  String get website => 'ဝေပ်သာ်';
  @override
  String get terms => 'အပိုၚ်အခြာကာလသုၚ်စောဲ';
  @override
  String get account => 'အကံက်';
  @override
  String get appsettings => 'တၚ်ပလေဝ်';
  @override
  String get chapter_title => 'က္ဍိုပ်လိက်ဂမၠိုၚ်';
  @override
  String get guestuser => 'ညးလွပ်ကၟုဲ';
  @override
  String get createanaccounthint => 'ကၠောန်အကံက်တၟိ ဟွံသေၚ်မ္ဂး လံက်အေန်';
  @override
  String get logoutfromapp => 'လံက်အံက်';
  @override
  String get deletemyaccount => 'ဇိုတ်အကံက်မၞး';
  @override
  String get applanguage => 'အရေဝ်ဘာသာ';
  @override
  String get chooseapplanguage => 'အရေဝ်ဘာသာ';
  @override
  String get emailaddress => 'အဳမေလ်';
  @override
  String get confirmpassword => 'ဂၞန်ပၞုက်';
  @override
  String get passwordsdontmatch => 'ဂၞန်ပၞုက်မၞးဟွံတုပ်ညးသ္ကအ်!';
  @override
  String get login => 'လံက်အေန်';
  @override
  String get createaccount => 'ကၠောန်အကံက်တၟိ';
  @override
  String get forgotpassword => 'ဝိုတ်စဂၞန်ပၞုက်မၞးယျဟာ?';
  @override
  String get resetpassword => 'ကၠောန်ဂၞန်ပၞုက်တၟိ';
  @override
  String get resetpasswordhint =>
      'Linkသွက်ဂွံဆက်ကၠောန်အာဂၞန်ပၞုက်ဂှ် ပလံၚ်ဏာပ္ဍဲအဳမေလ်ရ.';
  @override
  String get resetpasswordsuccess =>
      'ယဝ်အဳမေလ်မၞးနွံမံၚ်ပ္ဍဲ appပိုဲတံရမ္ဂး နဲကဲဂွံကၠောန်ဂၞန်ပၞုက်တၟိဂှ် ကလိကေတ်တၚ်စၞောန်ညိ';
  @override
  String get goback => 'ကလေၚ်';
  @override
  String get havecoupon => 'Have A Coupon?';
  @override
  String get collection => 'လိက်ရုဲစှ်ဂမၠိုၚ်';
  @override
  String get ok => 'အိုခေလ်';
  @override
  String get okay => 'ယွံ';
  @override
  String get cancel => 'တးပါဲ';
  @override
  String get resendverifycode => 'ကလေၚ်ပလံၚ်လေန်(ၚ်)လိက်စၟဳစၟတ်မွဲဝါပၠန်ညိ';
  @override
  String get successregistermessage =>
      'အကံက်မၞးခၞံကၠောန်ဗဒှ်အာစိုပ်ဒတုဲယျ, သ္ပဂုဏ်တုဲ အာစၟဳစၟတ်စၟတ် အဳမေလ်မၞး သွက်လေန်သ္ပဒတန် ကေုာံ သ္ပဒတန် ဌာန်ဒတန်အဳမေလ်မၞးညိ';
  @override
  String get successresendverifymessage =>
      'လေန် သ္ပဒတန်ဂှ် ပလံၚ်ဏာ ပ္ဍဲ အဳမေမၞးတုဲယျ';
  @override
  String get resendverifylink =>
      'လေန် သ္ပဒတန်ဂှ် ပလံၚ်ဏာ ပ္ဍဲ အဳမေမၞးတုဲယျ, ဍဵုကေတ် လေန်ဏအ် သွက်သ္ပဒတန် အဳမေမၞး .  ဟွံကလိဂွံ အဳမေဟာ ? ဍဵုကေတ်လေန်သၟဝ်ဏအ် သွက်ဂွံကလေၚ်ပလံၚ်ကဵု လေန်သ္ပဒတန် ပၠန်';
  @override
  String get processingpleasewait => 'သ္ပဂုဏ်တုဲ မၚ်ကဵုမွဲလစုတ်ညိအဴ...';
  @override
  String get cannotprocess =>
      'အခိၚ်လၟုဟ် ပရေၚ်ကမၠောန်အာတ်မိက်ဂွံ ဆက်ကၠောန်အာဟွံဂွံ , သ္ပဂုဏ်တုဲ ဗွဲကြဴကလေၚ်ဍဵုကဵု Try Again မွဲဝါပၠန်ညိ.';
  @override
  String get oops => 'သြယာဲ!';
  @override
  String get save => 'ဂိုၚ်ဒေပ်';
  @override
  String get error => 'အေလ်ရာ';
  @override
  String get success => 'ပလံၚ်ဗစိုပ်တုဲဒှ်ရအဴ';
  @override
  String get delete => 'ဇိုတ်';
  @override
  String get downloadversion => 'တံၚ်ဂြဲ';
  @override
  String get downloading => 'တံၚ်ဂြဲဒၟံၚ်ရ';
  @override
  String get failedtodownload => 'တၚ်ဂြဲဟွံအံၚ်ဇၞးရ';
  @override
  String get pleaseclicktoretry => 'ဍဵုကဵု Try Again မွဲဝါပၠန်ညိ';
  @override
  String get of => 'Of';
  @override
  String get nobibleversionshint =>
      'ဒၞဲါဏအ် သွက်ဂွံထ္ၜးကဵုဂှ် တၚ်ဂၞၚ်တအ်ဟွံမွဲရ , ဍဵုကေတ် သၟဝ်ဏအ် အောန်အိုတ် သွက်သ္ဂောံ ဂြဴဖျေံကဵု ဗီုပြၚ်မွဲမွဲညိ';
  @override
  String get downloaded => 'တံၚ်ဂြဲလဝ်တုဲ';
  @override
  String get enteremailaddresstoresetpassword =>
      'စုတ်အဳမေလ်မၞး ကလိကေတ်ဂၞန်ပၞုက်တၟိညိ';
  @override
  String get backtologin => 'ကလေၚ်လံက်အေန်ညိ';
  @override
  String get signintocontinue => 'လံက်အေန်တုဲ ဆက်အာ';
  @override
  String get signin => 'လံက်အေန်';
  @override
  String get signinforanaccount => 'ကၠောန်အကံက်တၟိဟာ';
  @override
  String get alreadyhaveanaccount => 'အကံက်မၞးနွံတုဲမံၚ်ယျဟာ';
  @override
  String get updateprofile => 'ပလေဝ်ပရိုဝ်ဝှာၚ်';
  @override
  String get updateprofilehint =>
      'သွက်ဂွံစကမၠောန် , သ္ပဂုဏ်တုဲ သၠုၚ််ပတိုန်ကဆံၚ် မုက်လိက်မၞးညိ , ကဵုကၠုၚ်အာရီုဗၚ်ကုပိုယ် သွက်ဂွံကလေၚ်ဆက်စၠောံကဵု ညးတၞဟ်ဏောၚ်';
  @override
  String get deleteselectedhint =>
      'ပွလၟုဟ်ဂှ် ဇိုတ်ကၠေံထောံ မလိက်ပိုယ်မရုဲစှ်လဝ်ဏောၚ် . စွံသတိပသမ္တီညိ ပွမဇိုတ်လၟုဟ်ဂှ် ဒှ်တဴဇိုတ်ကၠေံထောံ လ္ပမၞးမွဲလ္ပာ်ဟေၚ်ညိကီု, ပိုဒ်လိက်တအ်ဂှ် ပ္ဍဲလ္ပာ်စက်ညးမွဲလ္ပာ်တေံ ထ္ၜးမံၚ်ဏီဖိုဟ်ဏီဂှ်.';
  @override
  String get deleteselected => 'စၟတ်လဝ်တအ် ဇိုတ်အာ';
  @override
  String get unabletofetchconversation =>
      'ကေတ်နၚ်ဟွံဂွံ \n ကေုာံ မၞးမသဳကၠဳလဝ် \n';
  @override
  String get loadmoreconversation => 'ထၟံက်ဟလိုၚ်ကဵု တၚ်သဳကၠဳတက်ကျာ';
  @override
  String get sendyourfirstmessage => 'ပြၚ်ဗစိုပ်လိက် အလန်ကၠာအိုတ်ညိ \n';
  @override
  String get unblock => 'ဟွံကၟာတ်';
  @override
  String get block => 'ကၟာတ်ထောံ';
  @override
  String get writeyourmessage => 'ချူကေတ်ပိုဒ်လိက်မၞးညိ...';
  @override
  String get clearconversation => 'သအးထောံ ဂလာန်တက်လဝ်ကျာ';
  @override
  String get clearconversationhintone =>
      'ဒှ်တဴကမၠောန် သွက်ဂွံသအးကၠေံ ဂလာန်သဳကၠဳမၞးဖအိုတ်ဏောၚ်';
  @override
  String get clearconversationhinttwo =>
      '.\n  သ္ပဂုဏ်တုဲသမ္တီကေတ်ညိ အရာဝွံဒှ်တဴသွက်ရဂွံဇိုတ်ထောံ တၚ်သဳကၠဳ လ္ပာ်မၞးဟေၚ်ရ,  ပိုဒ်ဂလာန်တအ်ဂှ် ဆက်သှ်ေထ္ၜးအာဒၟံၚ် ပ္ဍဲလ္ပာ်သ္ကအ်ရဲမၞးတေံဏီ';
  @override
  String get logoutfromapphint =>
      'ယဝ်ခါရ မၞးဟွံလံက်အေန်လဝ်မ္ဂး မၞးဟွံမွဲကဵု အခေါၚ်လုပ်အရာတၚ်တၟေၚ်တအ်ရ၊ တိတ်နူအကံက်ဏံရဟာ';
  @override
  String get deleteaccount => 'ဇိုတ်အကံက်မၞး';
  @override
  String get deleteaccounthint =>
      'ဒှ်အရာ မဇိုတ်ကၠေံအကံက်မၞး ကေုာံ တးပဲါထောံတၚ်ဂၞၚ်မၞးတအ်ဖအိုတ်, အခါမၞးမဇိုတ်ကေတ်ထောံတၚ်ဂၞၚ်တအ်တုဲ ,ကလေၚ်သ္ပကေတ်အတိုၚ်တြေံဟွံဂွံရ';
  @override
  String get deleteaccountsuccess => 'Account deletion was succesful';
  @override
  String get myprofile => 'ပရိုဝ်ဝှာၚ်မၞး';
  @override
  String get copiedtoclipboard => 'ကူဆာဲဏာ ဒၞဲါစၠောံတုဲရ';
  @override
  String get biblebooks => 'ပြကိုဟ်';
  @override
  String get searchhint => 'ဂၠာဲတဴ ပိုဒ်လိက် ဗွဲရမျာၚ် ကေုာံ ဗွဲရုပ်ထ္ၜး';
  @override
  String get performingsearch => 'ဂၠာဲကေတ်ဒၟံၚ် ရမျာၚ် ကေုာံ ရုပ်ထ္ၜး';
  @override
  String get nosearchresult => 'မုသွဟ်မွဲ ဟွံဆဵုကေတ်ရ';
  @override
  String get nosearchresulthint => 'ဂစာန်ချူစုတ် မအက္ခရ် ဗွဲဒဒှ်သာမညတအ်ညိ';
  @override
  String get dataloaderror =>
      'လၟုဟ် တံၚ်ဖျေံထ္ၜးကဵုတၚ်နၚ်အာတ်မိက်တအ် ဟွံဂွံဏီရ, စၟဳစၟတ်ကေတ် ဇြဟတ်လာၚ်လပှ်ကျာတုဲ ကလေၚ်ဍဵုကဵု Try Again မွဲဝါပၠန်ညိ';
  @override
  String get bookmark => 'စၟတ်သမ္တဳ';
  @override
  String get unbookmark => 'ပလှ်ပတိတ်နူစၟတ်သမ္တီ';
  @override
  String get pulluploadmore => 'ဂြဲဖျေံဂွံဆက်ညာတ်အာ';
  @override
  String get loadfailedretry => 'Load ဟွံအံၚ်ဇၞး!ဍဵုကဵုဂစာန်မွဲဝါပၠန်ညိ!';
  @override
  String get releaseloadmore => 'release to load more';
  @override
  String get nomoredata => 'ဒေတာဟွံမွဲရ';
  @override
  String get notsupported => 'ဟွံထံက်ပၚ် ကဵုအရီုဗၚ်ရ';
  @override
  String get cleanupresources => 'ဇိုတ်သ္အးထောံ တမ်ရိုဟ်တအ်ညိ';
  @override
  String get sharefiletitle => 'သွက် ဗဵု ဟွံသေၚ် ကလေၚ်  ';
  @override
  String get sharefilebody => 'Via လိက်ကၞပ်မန်, တၚ်ဂြဴကေတ်အဏအ်. ';
  @override
  String get sharetext =>
      'ကဵုမိပ်စိုတ်လ္တူ လိက်အဳဗာ်ပိုဲတံတုဲ , ပါ်ပရအ် , စၟတ်စွံ ကေုာံ တၚ်ဂြဴဖျေံ မသ္ကုလာၚ် ';
  @override
  String get sharetexthint =>
      'ပါလုပ် စၚ်ကြမ် လိက်ကၞပ်မန်ဂှ် ဗဒှ်ကဵုသွက်မၞး သ္ဂောံဗှ်ကေတ် လိက်ကၞပ်မန် ဂၠိုၚ်ကဵုလ္ၚီအုပ်ရ။ တံၚ်ဂြဲဖျေံဒၞာဲဏံ.';
  @override
  String get next => 'ဆက်အာ';
  @override
  List<String> get onboardingpagetitles => [
    'ဒုၚ်တၠုၚ်ရအဴ',
    'ဂၠိုက်ဂၠာဲလိက်မန် ebook ဌာန်ပိုဲညိအဴ',
    'လိက်အပ်လာၚ်',
    'လိက်စၟတ်သမ္တဳ',
  ];
  @override
  List<String> get onboardingpagehints => [
    'M-eBook လိက်ကၞပ်မန်ဝွံ ဒှ်တဴစၚ်ကြမ် အရာသွက်မၞးသ္ဂောံဗှ်ကေတ်လိက်ကၞပ် ဂၠိုၚ်ကဵုလ္ၚီအုပ် ပ္ဍဲဏအ်ရ',
    'ဂၠာဲကေတ်လိက်ကၞပ်မန်ဂမၠိုၚ် ပ္ဍဲကဵုဒၞဲါဏအ်.',
    ' တံၚ််ဂြဲ လိက်ကၞပ်ဂမၠိုၚ်တုဲ  ၜိုန်လပှ်ကျာဟွံမွဲကီုလေဝ် အခိၚ်မၞးဒးစိုတ်ဗှ်ကေတ်မာန် ',
    ' စၟတ်စွံလဝ်တုဲ ဗှ်ကေတ်ဗွဲကြဴ မုလိက်မၞးမရုဲစှ်လဝ်တအ်ဂှ်.',
  ];
  @override
  String get app_name => 'Loik Mon';
  @override
  String get walletbalance => 'ဗၞတ်သြန်နွံ ပ္ဍဲထိုၚ်သြန်';
  @override
  String get loading_app => 'Loading loikmon...';
  @override
  String get allitems => 'လိက်ဖအိုတ်';
  @override
  String get emptyplaylist => 'No Playlists';
  @override
  String get grantstoragepermission =>
      'သွက်သ္ဂောံဂိုၚ်ဒေပ်အာလိက်ဂမၠိုၚ်ပ္ဍဲစက်မၞးမာန်ဂှ် သ္ပဂုဏ်တုဲကဵုအခေါၚ်သွက်စက်ဖုန်မၞးညိ';
  @override
  String get share_file_title => 'ဂၠိုက်ဂၠာဲ  ';
  @override
  String get share_file_body => 'Via loikmon App, Download now at ';
  @override
  String get categories => 'ကဏ္ဍဂမၠိုၚ်';
  @override
  String get category => 'ကဏ္ဍ';
  @override
  String get latest => 'Books';
  @override
  String get audio => 'ရမျာၚ်ဗှ်လိက်';
  @override
  String get magazines => 'Magazines';
  @override
  String get author => 'အ္စာကၞေဟ်';
  @override
  String get profile => 'ပရိုဝ်ဝှာၚ်';
  @override
  String get freearticle => 'လိက်ပရေၚ်ဟွံသက္ကုၚုဟ်မး';
  @override
  String get settings => 'တၚ်ပလေဝ်';
  @override
  String get playlist => 'My Playlist';
  @override
  String get app_info => 'ပရူပရာ(loikmon)';
  @override
  String get books => 'လိက်ကၞပ်';
  @override
  String get bookchapter => 'က္ဍိုပ်လိက်ဂမၠိုၚ်';
  @override
  String get soldbooks => 'လိက်မသွံရာန်';
  @override
  String get soldmagazines => 'Magazines on Sale';
  @override
  List<String> get searchoptions => ['လိက်', 'မဂ္ဂဇျေန်'];
  @override
  List<String> get viewoptions => ['PDF', 'EPUB'];
  @override
  List<String> get fonts => [
    'Style 1',
    'Style 2',
    'Style 3',
    'Style 4',
    'Style 5',
  ];
  @override
  String get start_subscription => 'ပံက်ကေတ် တၚ်ကမၠောန် အခေါၚ်တၟေၚ်';
  @override
  String get start_subscription_hint =>
      'ပံက်ကေတ် ကမၠောန်အခေါၚ်တၟေၚ် သွက်သ္ဂောံ စအာတရဴမၞး မၞုံကဵုပရေၚ်ဆဵုဂဗး တၚ်နၚ်လပှ်ကျာ ဒေါံအိုတ်အာဟွံမာန်တအ်';
  @override
  String get suggestedforyou => 'ဘိုၚ်ကဵုကသပ် သွက်မၞး';
  @override
  String get tracks => 'Tracks';
  @override
  String get livetvchannels => 'Live Tv Channels';
  @override
  String get latestbooks => 'လိက်တိတ်လကြဴအိုတ်';
  @override
  String get popularbooks => 'လိက်ဒယှ်တှ်';
  @override
  String get latestmagazines => 'Mon Magazines';
  @override
  String get authors => 'အ္စာကၞေဟ်ဂမၠိုၚ်';
  @override
  String get viewall => 'ဗဵုဖအိုတ်';
  @override
  String get bookmarksMedia => 'လိက်စၟတ်သမ္တဳ';
  @override
  String get noitemstodisplay => 'လိက်ဟွံမွဲရ';
  @override
  String get download => 'လိက်တံၚ်ဂြဲလဝ်';
  @override
  String get downloadall => 'တံၚ်ဂြဲဖအိုတ်';
  @override
  String get addplaylist => 'Add to playlist';
  @override
  String get share => 'ပါ်ပရအ်';
  @override
  String get deletemedia => 'ဇိုတ်ဝှာၚ်';
  @override
  String get deletemediahint =>
      'စိုတ်မၞးနွံဟာ သ္ဂောံဇိုတ်ထောံ အရာမဂြဲဖျေံလဝ်ဏအ်? ကမၠောန်ဏအ် ကၠောန်တုဲ ကလေၚ်ပဠေဝ်ကေတ်ဟွံဂွံ';
  @override
  String get search_hint => 'Search Books and Magazines';
  @override
  String get performing_search => 'Searching Books and Magazines';
  @override
  String get no_search_result => 'မုရဴသွဟ်မွဲ ဟွံဆဵုကေတ်ရ';
  @override
  String get no_search_result_hint => 'ဂစာန်တက်စုတ် မအက္ခရ် မဒှ်ဗွဲသာမညတအ်ညိ';
  @override
  String get comments => 'တၚ်လညာတ်ပါ်ပါဲ';
  @override
  String get replies => 'လိက်ကလေၚ်';
  @override
  String get reply => 'ကလေၚ်လိက်';
  @override
  String get login_to_add_comment => 'သွက်ဂွံကဵုလညာတ်ဂှ် လံက်အေန်ကဵုမွဲဝါညိ';
  @override
  String get login_to_reply => 'သွက်ကလေၚ်လိက်ဂှ်လံက်အေန်ကဵုမွဲဝါညိ';
  @override
  String get write_a_message => 'ချူလညာတ်မၞး...';
  @override
  String get no_comments =>
      'တၚ်လညာတ်ပါ်ပါဲဟွံမွဲရ \nကလေၚ်ဍဵုကဵု Try Again မွဲဝါပၠန်ညိ';
  @override
  String get error_making_comments =>
      'သွက်ဂွံချူစုတ်ဂလာန်ဂှ် ကၠောန်သ္ပကဵုဟွံမာန်ဏဳ အခိၚ်လၟုဟ်ဏံ..';
  @override
  String get error_deleting_comments =>
      'သွက်ဂွံဇိုတ်ကေတ် ပိုဒ်ဂလာန်တအ်ဂှ် ပြဟ်ဟ်ဏံ ကၠောန်သ္ပကဵုဟွံမာန်ဏဳရ ..';
  @override
  String get error_editing_comments =>
      'သွက်ဂွံပဠေဝ်ဒါန် ပိုဒ်ဂလာန်ဏအ်ဂှ် ပြဟ်ဟ်ဏံ ကၠောန်သ္ပကဵုဟွံမာန််ဏီရ..';
  @override
  String get error_loadingmore_comments =>
      'ထမံက်ထ္ၜးကဵု ပိုဒ်ဂလာန်တၞဟ်ဟ်တအ် ပြဟ်ဟ်ဏံ ဟွံမာန်ဏီ..';
  @override
  String get deleting_comment => 'ဇိုတ်ဒၟံၚ် တၚ်သ္ၚီဂၠိပ်တအ်ရ';
  @override
  String get editing_comment => 'ပလေဝ်တၚ်ကဵုလညာတ်';
  @override
  String get delete_comment_alert => 'ဇိုတ်တၚ်ကဵုလညာတ်';
  @override
  String get edit_comment_alert => 'ပလေဝ်တၚ်ကဵုလညာတ်';
  @override
  String get delete_comment_alert_text => 'မၞးမိက်ဂွံဇိုတ်တၚ်ကဵုလညာတ်မၞးဟာ';
  @override
  String get load_more => 'ဆက်ဗဵု';
  @override
  String get guest_user => 'ညးလွပ်ကၟုဲ';
  @override
  String get full_name => 'ယၟုပေၚ်ၚ်';
  @override
  String get email_address => 'အဳမေလ်';
  @override
  String get password => 'ဂၞန်ပၞုက်';
  @override
  String get repeat_password => 'ကလေၚ်စုတ်ဂၞန်ပၞုက်';
  @override
  String get register => 'ကၠောန်အကံက်တၟိ';
  @override
  String get logout => 'တိတ်နူကဵုအကံက်';
  @override
  String get logout_from_app => 'တိတ်နူကဵုအကံက်မၞးဟာ';
  @override
  String get logout_from_app_hint =>
      'You wont be able to like or comment on articles and videos if you are not logged in.';
  @override
  String get go_to_login => 'ဆက်လံက်အေန်';
  @override
  String get reset_password => 'ကၠောန်ဂၞန်ပၞုက်တၟိ';
  @override
  String get login_to_account => 'အကံက်မၞးနွံတုဲမံၚ်ယျဟာ';
  @override
  String get empty_field_error_hint => 'မၞးဒးဗပေၚ် တၚ်နၚ်ဂမၠိုၚ်ကၠာရောၚ်';
  @override
  String get invalid_email_error_hint =>
      'မၞးမဒးစုတ် အဳမေလ်ဗွဲဗဗွဲကဵုအဳမေလ်ရောၚ် ';
  @override
  String get passwords_dont_match => 'ဂၞန်ပၞုက်ၜါဂှ် ဟွံကိတ်ညဳ';
  @override
  String get processing_please_wait =>
      'မကၠောန်တဴဒၟံၚ်, သ္ပဂုဏ်တုဲမၚ်မွဲလစုတ်ညိ...';
  @override
  String get create_account => 'ကၠောန်အကံက်တၟိ';
  @override
  String get forgot_password => 'ဝိုတ်စဂၞန်ပၞုက်ယျဟာ';
  @override
  String get more_options => 'တၚ်တၞဟ်ဟ်';
  @override
  String get about => 'ပရောပရာပိုဲ';
  @override
  String get privacy => 'မူဝါဒအခေါၚ်အရာ';
  @override
  String get rate => 'ကဵုစၟတ်ကဵုအေပ်ဏံ';
  @override
  String get version => 'Version';
  @override
  String get skip => 'ထၜက်';
  @override
  String get skip_login => 'ထၜက်လံက်အေန်';
  @override
  String get skip_register => 'ထကၠောန်အကံက်တၟိ';
  @override
  String get data_load_error =>
      'လိက်ဂမၠိုၚ် ထၟံက်ထ္ၜးကဵုဟွံမာန်ဏီရ, သ္ပဂုဏ်တုဲဍဵုကဵု Try Again မွဲဝါညိ၊ စၟဳစၟတ်ကဵုအေန်တာနေတ်မၞးတုဲ ကလေၚ်ပံက်မွဲဝါညိအဴ';
  @override
  String get no_items => 'လိက်ဟွံမွဲရ.';
  @override
  String get loginrequired => 'နွံပၟိက်လံက်အေန်';
  @override
  String get loginrequiredhint =>
      'သွက်ဂွံရာန်လိက်ပ္ဍဲအေပ်ပိုဲဏံဂှ် မၞးဒးလံက်အေန်ကၠာရောၚ်။ အကံက်မၞးဟွံမွဲဏီမ္ဂး ကၠောန်အကံက်တၟိတုဲ လံက်အေန်ကဵုမွဲဝါညိအဴ';
  @override
  String get subscriptions => 'App Subscriptions';
  @override
  String get subscribe => 'SUBSCRIBE';
  @override
  String get subscribehint => 'Payment Required';
  @override
  String get previewsubscriptionrequiredhint =>
      'Payment is required to download or read this book. Purchase this book now for ';
  @override
  String get done => 'GET STARTED';
  @override
  String get paydescriptiontitle => 'တၞးသမ္တီ သၞောတ်ကဵုသြန်';
  @override
  String get paydescriptioncontent =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  @override
  String get googlepayreadmecontent =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  @override
  String get couponcodereadmetitle => 'ပရောပရာ';
  @override
  String get couponcodereadmecontent1 =>
      'ဂၞန်ခူဗန်မၞးကလိဂွံလဝ်ဂှ် စုတ်ဒၞာဲစုတ်ဂၞန်ခူဗန်သၟဝ်ဏံတုဲ ကလိကေတ်မသြန်ဗွဲမပြဟ်မာန်ရ။ ဂၞန်ခူဗန်ဟွံမွဲမ္ဂး သွက်ဂွံကလိကေတ်ဂၞန်ခူဗန်ဂှ် ဆက်စၠောံကဵုပိုဲ ဂၞန်ဖုန်၊ ပ္ဍဲmessengerဏံညိအဴ';
  String get couponcodereadmecontent =>
      'ဂၞန်ခူဗန်ပိုဲတံဂှ် သုၚ်စောဲအာနဒဒှ် မသြန်ဒေတ်ဂျေတ်ဒေဝ် သွက်ဂွံစုတ် ပ္ဍဲE-Walletမၞးရ။ သွက်ဂွံစုတ်မသြန်ဒေတ်ဂျေတ်ဒေဝ် ပ္ဍဲE-Walletမၞးဂှ် ကေတ်အဆက်ပ္ဍဲ Messengerသၟဝ်ဏံတုဲ ဟွံသေၚ်မ္ဂး ကေတ်နၚ်အဆက်နကဵုဂၞန်ဖုန် - +66955070956 ညိအဴ။ မသြန်မၞးကလိဂွံတုဲမ္ဂး လိက်မၞးဒးစိုတ်ရာန်ကေတ်မာန်ရအဴ။ ';
  @override
  String get couponcodereadmetitle2 => 'ပရောပရာ';
  @override
  String get couponcodereadmecontent2 =>
      'ဍုၚ်မၞးနွံဂှ် ရုဲစှ်ကေတ်တုဲ နကဵုPaymentမွဲမွဲထပ်ရုဲစှ်ပၠန်တုဲ အတိုၚ်ၚုဟ်မး Packageဂှ် ပြၚ်စုတ်သြန်ညိ။ ပြၚ်သြန်တုဲမ္ဂး ဗွဲမပြဟ်ပိုဲတံစၟဳစၟတ်တုဲ သ္ပဒတန်ရောၚ်။';
  String get couponcodereadmecontent3 =>
      'ဍုၚ်မၞးနွံဂှ် ရုဲစှ်ကေတ်တုဲ နကဵုPaymentမွဲမွဲထပ်ရုဲစှ်ပၠန်တုဲ အတိုၚ်ၚုဟ်မး Packageဂှ် ပြၚ်စုတ်သြန်ညိ။ ပြၚ်သြန်တုဲမ္ဂး ဗွဲမပြဟ်ပိုဲတံစၟဳစၟတ်တုဲ သ္ပဒတန်ရောၚ်။';
  @override
  String get rateapp => 'သ္ပသမ္တီ Loik Mon';
  @override
  String get bookpurchasesuccess => 'မၞးရာန်လိက်အံၚ်ဇၞးရအဴ.';
  @override
  String get bookpurchaseerror => 'ပြဿနာရာန်လိက်နွံမ္ဂး ဆက်စၠောံကဵုပိုဲညိအဴ';
  @override
  String get cannotreviewerror => 'Cannot drop a review at the moment';
  @override
  String get paymentdetails => 'ပရောပရောရာန်လိက်';
  @override
  String get mobilebanking => 'ဘာဏ်ကေန်(ၚ်)';
  @override
  String get paywithcoupon => 'ရာန်နကဵုခူဗန်';
  @override
  String get choosecountry => 'ရုဲစှ်ဍုၚ်:';
  @override
  String get nocountryselected => 'ဟွံဂွံရုဲစှ်လဝ်ဍုၚ်ဏီ';
  @override
  String get paymentmethods => 'တၚ်ရုဲစှ်ပလံၚ်သြန်ဂမၠိုၚ်';
  @override
  String get loadingbanks => 'loading banks..';
  @override
  String get unabletoloadbanks => 'Unable to load banks';
  @override
  String get nobanksforcountry => 'ဍုၚ်မၞးဂှ် ဘာဏ်ဟွံမွဲရ';
  @override
  String get attachproofofpayment => 'စုတ်လိက်တၞးချာဲတၚ်တုပ်စိုတ်သြန်';
  @override
  String get selectafile => 'ရုဲစုတ်လိက်တၞးချာဲမၞး';
  @override
  String get nofilechoosen => 'ဟွံဂွံရုဲစုတ်လဝ်လိက်တၞးချာဲဏီ';
  @override
  String get pleaseselectafiletoupload =>
      'သ္ပဂုဏ်တုဲစုတ်ကဵုလိက်တၚ်တုပ်စိုတ်(လိက်တၞးချာဲတၚ်တုပ်စိုတ်သြန်မၞးညိ)';
  @override
  String get submitpaymentproof => 'ပလံၚ်ဗစိုပ်လိက်တၚ်တုပ်စိုတ်';
  @override
  String get paymentofproofsuccess =>
      'မၞးပလံၚ်လိက်ဒကုတ်(Voucher) တုဲဒှ်ရအဴ၊ ဗွဲမတာပ်အခိၚ် ပိုဲစၟတ်စၟတ်တုဲ စုတ်ကဵုဗွဲမပြဟ်ရောၚ်၊ အဝ်...မၚ်ကဵုမွဲအံၚ်ညိအဴ၊ (တၚ်သမ္တီ - ယဝ်နွံပၟိက်ဗွဲမပြဟ်မ္ဂး ကေတ်အဆက်ပ္ဍဲ(FB-Page)တိုက်ရိုက်ညိအဴ။';
  @override
  String get paymentofprooferror =>
      'သၠးအခေါၚ်ညိ ဂိုၚ်ဟွံဒေပ်ဟွံအံၚ်ဇၞးရ. သ္ပဂုဏ်တုဲထပ် Try Again ကဵုမွဲဝါပၠန်ညိ.';
  @override
  String get learnmore =>
      'Google itself does not charge extra fee for sending the money to your bank.';
  @override
  String get couponcode => 'ဂၞန်ခူဗန်';
  @override
  String get entercouponcode => 'စုတ်ဂၞန်ခူဗန်ဒၞာဲဏံ';
  @override
  String get entercopounalert => 'သ္ပဂုဏ်တုဲစုတ်ကဵုဂၞန်ခူဗန်မၞးညိ';
  @override
  String get getcoupononmessegner => 'ကလိကေတ်ခူဗန် ဒၞာဲဏံညိ';
  @override
  String get phoneus => 'ဆက်စၠောံနကဵုဂၞန်ဖုန်';
  @override
  String get description => 'ပရောပရာ';
  @override
  String get failedtoloadoverview => 'ထၟံက်ထ္ၜးပရောအရာ ဟွံအံၚ်ဇၞးရ';
  @override
  String get authorbooks => 'လိက်အ္စာကၞေဟ်';
  @override
  String get booksyoumaylike => 'လိက်မၞးဒးစိုတ်';
  @override
  String get ratebook => 'ကဵုစၟတ်လိက်ဏံ';
  @override
  String get taptorate => 'ရုဲစှ်သၞံၚ်သွက်ကဵုစၟတ်လိက်ဏံ';
  @override
  String get submit => 'ပတိုန်ဏာ';
  @override
  String get addcomment => 'ချူလိက်ထံက်ထ္ၜးဒၞာဲဏံညိ';
  @override
  String get writeareview => 'ချူလိက်ထံက်ထ္ၜး';
  @override
  String get topreviews => 'လိက်ထံက်ထ္ၜးကဆံၚ်လ္တူ';
  @override
  String get noreviews => 'လိက်ထံက်ထ္ၜး ဟွံမွဲဏီရ';
  @override
  String get accountsuccess => 'အကံက်မၞး ကၠောန်သ္ပအံၚ်ဇၞးရ';
  @override
  String get topsearchbooks => 'လိက်မၞးဂၠိုက်ဂၠာဲ';
  @override
  String get searchauthors => 'သ္ၚဳအ္စာကၞေဟ်';
  @override
  String get leagues => 'ဂကောံအ္စာကၞေဟ်';
  @override
  String get searchleagues => 'သ္ၚဳဂကောံ';
  @override
  String get searchArticles => 'သ္ၚဳဂၠာဲလိက်ပရေၚ်';
  @override
  String get topsellbooks => 'လိက်သွံတၟေၚ်';
  @override
  String get recommended => 'လိက်ထံက်ဂလာန်';
  @override
  String get overview => 'ပရောပရာ';
  @override
  String get information => 'တၚ်နၚ်ဂမၠိုၚ်';
  @override
  String get reviews => 'တၚ်ထံက်ထ္ၜး';
  @override
  String get deleteoptions => 'ရုဲစှ်လိက်တံၚ်ဂြဲ';
  @override
  String get readoptions => 'ရုဲစှ်လိက်ဗွဟ်';
  @override
  String get pending => 'အခိၚ်စၟဳဗှ်';
  @override
  String get buy => 'ရာန်';
  @override
  String get read => 'ပံက်ဗှ်';
  @override
  String get changeappfont => 'သၠာဲဗီုပြၚ်မလိက်';
  @override
  String get changefontsizespacing => 'ပြံၚ်အယဲမလိက်ကေုာံသၠဲပၞောန်လိက်';
  @override
  String get fontsize => 'အယဲမလိက်';
  @override
  String get linespace => 'ပၞောန်လိက်';
  @override
  String get library => 'ဌာန်ရံၚ်လိက်';
  @override
  String get relatedbooks => 'လိက်မဆက်စပ်';
  @override
  String get booksearchhint => 'ဂၠာဲလိက်';
  @override
  String get searching => 'ဂၠာဲဒၟံၚ် ...';
  @override
  String get Customize => 'ပြံၚ်သၠာဲ';
  @override
  String get enabledarkmode => 'သၠာဲအရံၚ်';
  @override
  String get more => 'တၞဟ်ဟ်';
  @override
  String get newbooks => 'လိက်ကၞပ်တၟိ';
  @override
  String get newarticles => 'လိက်ပရေၚ်တၟိ';
  @override
  String get newbook => 'လိက်ကၞပ်တၟိ';
  @override
  String get newarticle => 'လိက်ပရေၚ်တၟိ';
  @override
  String get populararticles => 'လိက်ပရေၚ်ဒယှ်တှ်';
  @override
  String get articles => 'လိက်ပရေၚ်';
  @override
  String get allbooks => 'လိက်ဖအိုတ်';
  @override
  String get makepurchasehint =>
      'ယူနေတ်ဏံဝွံ ကံက်နုက်အာနူ E-Walletမၞးရောၚ်၊ စှ်ေစိုတ်မ္ဂး ဆက်ဍဵုအာ"သ္ပဒ္တန်"ညိအဴ';
  @override
  String get proceed => 'သ္ပဒ္တန်';
  @override
  String get fewcoinwallethint =>
      'Sorry, you do not have enough coins in your wallet to make this purchase';
  @override
  String get purchasesuccess => 'Congrats, you purchase was successful';
  @override
  String get articlepurchasehint =>
      'သွက်ရဂွံဗှ်/ကလၚ်အာလိက်ပရေၚ်ဏံဝွံ နွံပၟိက်ကဵုဒးရာန်ရောၚ်';
  @override
  String get bookbookmarks => 'လိက်စၟတ်';
  @override
  String get bookmarkedarticles => 'လိက်ပရေၚ်စၟတ်';
  @override
  String get purchasedbooks => 'လိက်ရာန်လဝ်';
  @override
  String get purchasedarticles => 'လိက်ပရေၚ်ရာန်လဝ်';
  @override
  String get sales => 'Sales';
  @override
  String get views => 'Views';
  @override
  String get coins => 'ယူနေတ်';
  @override
  String get forcoins => 'မသြန်အကွက်';
  @override
  String get forcoin => 'မသြန်';
  @override
  String get purchasecoins => 'ထပ်ရာန်ပကောံစွံမသြန်သွက်E-Wallet';
  @override
  String get buycoins => 'ရာန်မသြန်';
  @override
  String get purchasecoinshint =>
      'သွက်ရာန်လိက်ကၞပ်၊ လိက်ပရေၚ် ပ္ဍဲAppဏံဂှ် ရာန်ပကောံစွံလဝ်မသြန်ဒၞာဲဏံညိအဴ';
  @override
  String get contactus => 'ကေတ်အဆက်';
  @override
  String get topupcoins => 'ဗပေၚ်မသြန်';
  @override
  String get youhave => 'မသြန်မၞးနွံဒၟံၚ်';
  @override
  String get paymentfor => 'Payment for';
  @override
  String get pendingapproval => 'Pending Approval';
  @override
  String get paymentapproved => 'Payment Approved';
  @override
  String get articlesearchhint => 'Type Article or Author name';
  @override
  String get epubsettings => 'Epub Settings';
  @override
  String get fontstyle => 'Font Style';
  @override
  String get background => 'Background';
  @override
  String get light => 'Light';
  @override
  String get dark => 'Dark';
  @override
  String get downloadedarticles => 'လိက်ပရေၚ်တံၚ်ဂြဲလဝ်';
  @override
  String get closeapp => 'တိတ်နူအေပ်ဏံရဟာ';
  @override
  String get quitapp => 'သ္ပဒ္တန်တိတ်နူအေပ်ဏံရဟာ';
  @override
  String get confirm => 'သ္ပဒ္တန်';
  @override
  String get normalprice => 'ၚုဟ်မးပကတိ';
  @override
  String get selectnormalprice =>
      'ရုဲစှ်ကေတ်ၚုဟ်မးပကတိ ဟွံသေၚ်မ္ဂး သွက်အ္စာကၞေဟ်တံဂွံဒှ်ဇြဟတ်စိုတ် ထပ်ပပဵုကဵုၚုဟ်မးမာန်မံၚ်ရအဴ!';
  @override
  String get openbook => 'ပံက်ဗှ်';
  @override
  String get listen => 'ပံက်ကလၚ်';
  @override
  String get fromauthor => 'နူကဵုအ္စာကၞေဟ်';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _StringsEn {
  Map<String, dynamic> _buildFlatMap() {
    return <String, dynamic>{
      'appname': 'Mon Ebook',
      'initializingapp':
          'Please wait while we setup a few things, it wont take long, we promise.',
      'errorinitapp':
          'Unfortunately, we could not complete setup at the moment, please check your internet connection, then click to retry',
      'initappsucess':
          'Congratulations, setup is now complete, you can now click to continue to app',
      'retry': 'Try Again',
      'continuetoapp': 'Continue to App',
      'home': 'Home',
      'bookmarks': 'Bookmarks',
      'playlists': 'Playlists',
      'downloads': 'Downloads',
      'website': ' Our Website',
      'terms': 'Terms & Conditions',
      'account': 'Profile',
      'appsettings': 'App Settings',
      'guestuser': 'Guest User',
      'createanaccounthint': 'Create an account or login to app',
      'logoutfromapp': 'Logout from App',
      'deletemyaccount': 'Delete my account',
      'applanguage': 'App Language',
      'chooseapplanguage': 'Select App Language',
      'emailaddress': 'Email Address',
      'confirmpassword': 'Confirm Password',
      'passwordsdontmatch': 'Passwords dont match!',
      'login': 'LOG IN',
      'createaccount': 'Create Account',
      'forgotpassword': 'Forgot Password?',
      'resetpassword': 'Reset Password',
      'resetpasswordhint': 'A reset password link will be sent to your email.',
      'resetpasswordsuccess':
          'If the email exists in our platform, you should recieve an instruction on how to reset your password.',
      'goback': 'Go Back',
      'ok': 'OK',
      'cancel': 'CANCEL',
      'resendverifycode': 'Resend Verification Link',
      'successregistermessage':
          'You have successfully created an account, please check your email for a verification link and verify your email address.',
      'successresendverifymessage':
          'A verification link have been sent to your email.',
      'resendverifylink':
          'A verification link was sent to your email address, visit the link to verify your email. Did not get the email? click the link below to resend verification link.',
      'processingpleasewait': 'Processing, please wait...',
      'cannotprocess':
          'The requested operation cannot be processed at the moment, please try again later.',
      'oops': 'Ooops!',
      'save': 'Save',
      'error': 'Error',
      'success': 'Success',
      'downloadversion': 'Download',
      'downloading': 'Downloading',
      'failedtodownload': 'Failed to download',
      'pleaseclicktoretry': 'Please click to retry.',
      'of': 'Of',
      'nobibleversionshint':
          'There is no bible data to display, click on the button below to download atleast one bible version.',
      'downloaded': 'Downloaded',
      'enteremailaddresstoresetpassword':
          'Enter your email to reset your password',
      'backtologin': 'BACK TO LOGIN',
      'signintocontinue': 'Sign in to continue',
      'signin': 'S I G N  I N',
      'signinforanaccount': 'SIGN UP FOR AN ACCOUNT?',
      'alreadyhaveanaccount': 'Already have an account?',
      'updateprofile': 'Update Profile',
      'updateprofilehint':
          'To get started, please update your profile page, this will help us in connecting you with other people',
      'deleteselectedhint':
          'This action will delete the selected messages.  Please note that this only deletes your side of the conversation, \n the messages will still show on your partners device.',
      'deleteselected': 'Delete selected',
      'unabletofetchconversation':
          'Unable to Fetch \nyour conversation with \n',
      'loadmoreconversation': 'Load more conversations',
      'sendyourfirstmessage': 'Send your first message to \n',
      'unblock': 'Unblock ',
      'block': 'Block',
      'writeyourmessage': 'Write your message...',
      'clearconversation': 'Clear Conversation',
      'clearconversationhintone':
          'This action will clear all your conversation with ',
      'clearconversationhinttwo':
          '.\n  Please note that this only deletes your side of the conversation, the messages will still show on your partners chat.',
      'logoutfromapphint':
          'You wont be able to access some priviledges if you are not logged in.',
      'deleteaccount': 'Delete my account',
      'deleteaccounthint':
          'This action will delete your account and remove all your data, once your data is deleted, it cannot be recovered.',
      'deleteaccountsuccess': 'Account deletion was succesful',
      'myprofile': 'My Profile',
      'copiedtoclipboard': 'Copied to clipboard',
      'biblebooks': 'Bible',
      'searchhint': 'Search Audio & Video Messages',
      'performingsearch': 'Searching Audios and Videos',
      'nosearchresult': 'No results Found',
      'nosearchresulthint': 'Try input more general keyword',
      'dataloaderror':
          'Could not load requested data at the moment, check your data connection and click to retry.',
      'bookmark': 'Bookmark',
      'unbookmark': 'UnBookmark',
      'pulluploadmore': 'pull up load',
      'loadfailedretry': 'Load Failed!Click retry!',
      'releaseloadmore': 'release to load more',
      'nomoredata': 'No more Data',
      'notsupported': 'Not Supported',
      'cleanupresources': 'Cleaning up resources',
      'sharefiletitle': 'Watch or Listen to ',
      'sharefilebody': 'Via MonEbook, Download now at ',
      'sharetext': 'Enjoy Loik Mon, Share, bookmark and download offline',
      'sharetexthint':
          'Join the Loik Mon platform that lets you read thousands of Loik Mon. Download now at',
      'next': 'Next',
      'onboardingpagetitles.0': 'Welcome to Loik Mon',
      'onboardingpagetitles.1': 'Great Books Discovery',
      'onboardingpagetitles.2': 'Offline Books',
      'onboardingpagetitles.3': 'Bookmark Books',
      'onboardingpagehints.0':
          'Mon Ebook is a platform that lets you read thousands on Loik Mon.',
      'onboardingpagehints.1':
          'Discover thousands of Loik Mon, all at your disposal.',
      'onboardingpagehints.2':
          'Download Books and read offline anytime you want',
      'onboardingpagehints.3':
          'Bookmark and read later any book of your choice.',
      'app_name ': 'Mon Ebook',
      'walletbalance ': 'Wallet Balance',
      'loading_app ': 'initializing app...',
      'allitems ': 'All Items',
      'emptyplaylist ': 'No Playlists',
      'grantstoragepermission ':
          'Please grant accessing storage permission to continue',
      'share_file_title ': 'Discover  ',
      'share_file_body ': 'Via loikmon App, Download now at ',
      'categories ': 'Categories',
      'category ': 'Category',
      'latest ': 'Books',
      'magazines ': 'Magazines',
      'author ': 'Author',
      'profile ': 'Profile',
      'settings ': 'Settings',
      'playlist ': 'My Playlist',
      'app_info ': 'App Info',
      'books ': 'Books',
      'soldbooks ': 'Books on Sale',
      'soldmagazines ': 'Magazines on Sale',
      'searchoptions .0': 'Books',
      'searchoptions .1': 'Magazines',
      'viewoptions .0': 'PDF',
      'viewoptions .1': 'EPUB',
      'fonts.0': 'Style 1',
      'fonts.1': 'Style 2',
      'fonts.2': 'Style 3',
      'fonts.3': 'Style 4',
      'fonts.4': 'Style 5',
      'start_subscription ': 'Unlock Premium Features',
      'start_subscription_hint ':
          'Unlock premium features to start your journey to a never-ending media streaming experience',
      'suggestedforyou ': 'Suggested for you',
      'tracks ': 'Tracks',
      'livetvchannels ': 'Live Tv Channels',
      'latestbooks ': 'Latest Books',
      'popularbooks ': 'Popular Books',
      'latestmagazines ': 'Mon Magazines',
      'authors ': 'Authors',
      'viewall ': 'View All',
      'bookmarksMedia ': 'My Bookmarks',
      'noitemstodisplay ': 'No Items To Display',
      'download ': 'Downloads',
      'addplaylist ': 'Add to playlist',
      'share ': 'Share',
      'deletemedia ': 'Delete File',
      'deletemediahint ':
          'Do you wish to delete this downloaded file? This action cannot be undone.',
      'search_hint ': 'Search Books and Magazines',
      'performing_search ': 'Searching Books and Magazines',
      'no_search_result ': 'No results Found',
      'no_search_result_hint ': 'Try input more general keyword',
      'comments ': 'Comments',
      'replies ': 'Replies',
      'reply ': 'Reply',
      'login_to_add_comment ': 'Login to add a comment',
      'login_to_reply ': 'Login to reply',
      'write_a_message ': 'Write a message...',
      'no_comments ': 'No Comments found \nclick to retry',
      'error_making_comments ': 'Cannot process commenting at the moment..',
      'error_deleting_comments ': 'Cannot delete this comment at the moment..',
      'error_editing_comments ': 'Cannot edit this comment at the moment..',
      'error_loadingmore_comments ':
          'Cannot load more comments at the moment..',
      'deleting_comment ': 'Deleting review',
      'editing_comment ': 'Editing comment',
      'delete_comment_alert ': 'Delete Review',
      'edit_comment_alert ': 'Edit Comment',
      'delete_comment_alert_text ':
          'Do you wish to delete this review? This action cannot be undone',
      'load_more ': 'load more',
      'guest_user ': 'Guest User',
      'full_name ': 'Full Name',
      'email_address ': 'Email Address',
      'password ': 'Password',
      'repeat_password ': 'Repeat Password',
      'register ': 'Register',
      'logout ': 'Logout',
      'logout_from_app ': 'Logout from app?',
      'logout_from_app_hint ':
          'You wont be able to like or comment on articles and videos if you are not logged in.',
      'go_to_login ': 'Go to Login',
      'reset_password ': 'Reset Password',
      'login_to_account ': 'Already have an account? Login',
      'empty_field_error_hint ': 'You need to fill all the fields',
      'invalid_email_error_hint ': 'You need to enter a valid email address',
      'passwords_dont_match ': 'Passwords dont match',
      'processing_please_wait ': 'Processing, Please wait...',
      'create_account ': 'Create an account',
      'forgot_password ': 'Forgot Password?',
      'more_options ': 'More Options',
      'about ': 'About Us',
      'privacy ': 'Privacy Policy',
      'rate ': 'Rate App',
      'version ': 'Version',
      'skip ': 'Skip',
      'skip_login ': 'Skip Login',
      'skip_register ': 'Skip Registration',
      'data_load_error ':
          'Could not load requested data at the moment, check your data connection and click to retry.',
      'no_items ': 'No Items to display at the moment.',
      'loginrequired ': 'Login Required',
      'loginrequiredhint ':
          'To make payments on this platform, you need to be logged in. Create a free account now or log in to your existing account.',
      'subscriptions ': 'App Subscriptions',
      'subscribe ': 'SUBSCRIBE',
      'subscribehint ': 'Payment Required',
      'previewsubscriptionrequiredhint ':
          'Payment is required to download or read this book. Purchase this book now for ',
      'done ': 'GET STARTED',
      'paydescriptiontitle ': 'Payment Descriptions',
      'paydescriptioncontent ':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'googlepayreadmecontent ':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'couponcodereadmetitle': 'Coupon Codes',
      'couponcodereadmecontent':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'couponcodereadmetitle2': 'Banks Description',
      'couponcodereadmecontent2':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'rateapp': 'Rate App',
      'bookpurchasesuccess': 'Book Purchase was Successful.',
      'bookpurchaseerror':
          'There was an issue with the item purchase, please contact app admin.',
      'cannotreviewerror': 'Cannot drop a review at the moment',
      'paymentdetails': 'Payment Details',
      'mobilebanking': 'Mobile Banking',
      'paywithcoupon': 'Pay with Coupon',
      'choosecountry': 'Choose Country:',
      'nocountryselected': 'No Country Selected',
      'paymentmethods': 'Payment Methods:',
      'loadingbanks': 'loading banks..',
      'unabletoloadbanks': 'Unable to load banks',
      'nobanksforcountry': 'No banks for selected countries',
      'attachproofofpayment': 'Attach proof of payment',
      'selectafile': 'Select a file',
      'nofilechoosen': 'No file chosen',
      'pleaseselectafiletoupload':
          'Please select a file to upload for proof of payment',
      'submitpaymentproof': 'Submit payment proof',
      'paymentofproofsuccess':
          'Your proof of payment was submitted successfully. We will alert you once your payment has been approved by the seller.',
      'paymentofprooferror':
          'Sorry, we could not save this data at the moment. Please try again.',
      'learnmore':
          'Google itself does not charge extra fee for sending the money to your bank.',
      'couponcode': 'Coupon code',
      'entercouponcode': 'Enter Coupon',
      'entercopounalert': 'Please enter a coupon code',
      'getcoupononmessegner': 'Get coupon code on Messenger',
      'phoneus': 'OR Phone Us',
      'description': 'Description',
      'failedtoloadoverview': 'Failed to load overview',
      'authorbooks': 'Author Books',
      'booksyoumaylike': 'Books you may like',
      'ratebook': 'Rate',
      'taptorate': 'Tap a star to set your rating',
      'submit': 'Submit',
      'addcomment': 'Add Comment',
      'writeareview': 'Write a review',
      'topreviews': 'Top Reviews',
      'noreviews': 'No Reviews yet',
      'accountsuccess': 'Account created successfully',
      'topsearchbooks': 'Top Search Books',
      'topsellbooks': 'Top Sell Books',
      'recommended': 'Recommended Books',
      'overview': 'Overview',
      'information': 'Information',
      'reviews': 'Reviews',
      'deleteoptions': 'Download Options',
      'readoptions': 'Read Options',
      'pending': 'Pending',
      'buy': 'Buy',
      'read': 'Read',
      'changeappfont': 'Change App Font',
      'changefontsizespacing': 'Change Font Size & Spacing',
      'fontsize': 'Font Size',
      'linespace': 'Line Space',
      'library': 'Library',
      'relatedbooks': 'Related Books',
      'booksearchhint': 'Type Book or Author name',
      'articlesearchhint': 'Type Article or Author name',
      'searching': 'Searching ...',
      'Customize': 'Customize',
      'enabledarkmode': 'Enable Dark Mode',
      'more': 'More',
      'newbooks': 'New Books',
      'newarticles': 'New Articles',
      'populararticles': 'Popular Articles',
      'articles': 'Articles',
      'allbooks': 'All Books',
      'makepurchasehint':
          'units will be deducted from your wallet. Click proceed to make this purchase.',
      'proceed': 'Proceed',
      'fewcoinwallethint':
          'Sorry, you do not have enough coins in your wallet to make this purchase',
      'purchasesuccess': 'Congrats, you purchase was successful',
      'articlepurchasehint':
          'You need to purchase this article before you can read it, click the button below to make this purchase.',
      'bookbookmarks': 'Bookmarked Books',
      'bookmarkedarticles': 'Bookmarked Articles',
      'purchasedbooks': 'Purchased Books',
      'purchasedarticles': 'Purchased Articles',
      'sales': 'Sales',
      'views': 'Views',
      'coins': 'Coins',
      'purchasecoins': 'Purchase more coins for purchases',
      'buycoins': 'Buy Coins',
      'purchasecoinshint': 'Purchase coins for purchase',
      'contactus': 'Contact us',
      'topupcoins': 'Top up coins',
      'youhave': 'You have',
      'paymentfor': 'Payment for',
      'pendingapproval': 'Pending Approval',
      'paymentapproved': 'Payment Approved',
      'epubsettings': 'Epub Settings',
      'fontstyle': 'Font Style',
      'background': 'Background',
      'light': 'Light',
      'dark': 'Dark',
      'downloadedarticles': 'Downloaded Articles',
      'closeapp': 'Close App',
      'quitapp': 'Do you wish to close the app and return to your home screen',
      'confirm': 'Confirm',
      'normalprice': 'Normal Price',
      'selectnormalprice': 'Select Normal Price',
    };
  }
}

extension on _StringsEs {
  Map<String, dynamic> _buildFlatMap() {
    return <String, dynamic>{
      'appname': 'အာံအဳဗော်',
      'initializingapp':
          'Please wait while we setup a few things, it wont take long, we promise.',
      'errorinitapp':
          'Unfortunately, we could not complete setup at the moment, please check your internet connection, then click to retry',
      'initappsucess':
          'Congratulations, setup is now complete, you can now click to continue to app',
      'retry': 'ဂစာန်မွဲဝါပၠန်',
      'continuetoapp': 'ဆက်ပံက်အာ',
      'home': 'မုက်တမ်',
      'bookmarks': 'ဂိုၚ်ဒေပ်',
      'playlists': 'Playlists',
      'downloads': 'တံၚ်ဂြဲလဝ်',
      'website': 'ဝေပ်သာ်',
      'terms': 'အပိုၚ်အခြာကာလသုၚ်စောဲ',
      'account': 'အကံက်',
      'appsettings': 'တၚ်ပလေဝ်',
      'guestuser': 'Guest User',
      'createanaccounthint': 'ကၠောန်အကံက်တၟိ ဟွံသေၚ်မ္ဂး လံက်အေန်',
      'logoutfromapp': 'လံက်အံက်',
      'deletemyaccount': 'ဇိုတ်အကံက်မၞး',
      'applanguage': 'အရေဝ်ဘာသာ',
      'chooseapplanguage': 'ရုဲစှ်အရေဝ်ဘာသာ',
      'emailaddress': 'အဳမေလ်',
      'confirmpassword': 'ဂၞန်ပၞုက်',
      'passwordsdontmatch': 'ဂၞန်ပၞုက်မၞးဟွံတုပ်ညးသ္ကအ်!',
      'login': 'လံက်အေန်',
      'createaccount': 'ကၠောန်အကံက်တၟိ',
      'forgotpassword': 'ဝိုတ်စဂၞန်ပၞုက်မၞးယျဟာ?',
      'resetpassword': 'ကၠောန်ဂၞန်ပၞုက်တၟိ',
      'resetpasswordhint':
          'လေန်(ၚ်)သွက်ဂွံဆက်ကၠောန်အာဂၞန်ပၞုက်ဂှ် ပလံၚ်ဏာပ္ဍဲအဳမေလ်ရ.',
      'resetpasswordsuccess':
          'ယဝ်အဳမေလ်မၞးနွံမံၚ်ပ္ဍဲ appပိုဲတံရမ္ဂး နဲကဲဂွံကၠောန်ဂၞန်ပၞုက်တၟိဂှ် ကလိကေတ်တၚ်စၞောန်ညိ',
      'goback': 'ကလေၚ်',
      'ok': 'အိုခေလ်',
      'cancel': 'တိတ်',
      'resendverifycode': 'ကလေၚ်ပလံၚ်လေန်(ၚ်)လိက်စၟဳစၟတ်မွဲဝါပၠန်ညိ',
      'successregistermessage':
          'You have successfully created an account, please check your email for a verification link and verify your email address.',
      'successresendverifymessage':
          'A verification link have been sent to your email.',
      'resendverifylink':
          'A verification link was sent to your email address, visit the link to verify your email. Did not get the email? click the link below to resend verification link.',
      'processingpleasewait': 'Processing, please wait...',
      'cannotprocess':
          'The requested operation cannot be processed at the moment, please try again later.',
      'oops': 'သြယာဲ!',
      'save': 'ဂိုၚ်ဒေပ်',
      'error': 'အေလ်ရာ',
      'success': 'အံၚ်ဇၞး',
      'downloadversion': 'တံၚ်ဂြဲ',
      'downloading': 'Downloading',
      'failedtodownload': 'တၚ်ဂြဲဟွံအံၚ်ဇၞးရ',
      'pleaseclicktoretry': 'ဍဵုကဵုဂစာန်မွဲဝါပၠန်ညိ',
      'of': 'Of',
      'nobibleversionshint':
          'There is no bible data to display, click on the button below to download atleast one bible version.',
      'downloaded': 'Downloaded',
      'enteremailaddresstoresetpassword': 'စုတ်အဳမေလ်မၞး ကလိကေတ်ဂၞန်ပၞုက်တၟိညိ',
      'backtologin': 'ကလေၚ်လံက်အေန်ညိ',
      'signintocontinue': 'လံက်အေန်တုဲ ဆက်အာ',
      'signin': 'လံက်အေန်',
      'signinforanaccount': 'ကၠောန်အကံက်တၟိဟာ',
      'alreadyhaveanaccount': 'အကံက်မၞးနွံတုဲမံၚ်ယျဟာ',
      'updateprofile': 'ပလေဝ်ပရိုဝ်ဝှာၚ်',
      'updateprofilehint':
          'To get started, please update your profile page, this will help us in connecting you with other people',
      'deleteselectedhint':
          'This action will delete the selected messages.  Please note that this only deletes your side of the conversation, \n the messages will still show on your partners device.',
      'deleteselected': 'Delete selected',
      'unabletofetchconversation':
          'Unable to Fetch \nyour conversation with \n',
      'loadmoreconversation': 'Load more conversations',
      'sendyourfirstmessage': 'Send your first message to \n',
      'unblock': 'Unblock ',
      'block': 'Block',
      'writeyourmessage': 'Write your message...',
      'clearconversation': 'Clear Conversation',
      'clearconversationhintone':
          'This action will clear all your conversation with ',
      'clearconversationhinttwo':
          '.\n  Please note that this only deletes your side of the conversation, the messages will still show on your partners chat.',
      'logoutfromapphint':
          'You wont be able to access some priviledges if you are not logged in.',
      'deleteaccount': 'Delete my account',
      'deleteaccounthint':
          'This action will delete your account and remove all your data, once your data is deleted, it cannot be recovered.',
      'deleteaccountsuccess': 'Account deletion was succesful',
      'myprofile': 'ပရိုဝ်ဝှာၚ်မၞး',
      'copiedtoclipboard': 'Copied to clipboard',
      'biblebooks': 'Bible',
      'searchhint': 'Search Audio & Video Messages',
      'performingsearch': 'Searching Audios and Videos',
      'nosearchresult': 'No results Found',
      'nosearchresulthint': 'Try input more general keyword',
      'dataloaderror':
          'Could not load requested data at the moment, check your data connection and click to retry.',
      'bookmark': 'စၟတ်သမ္တဳ',
      'unbookmark': 'ပလှ်ပတိတ်နူစၟတ်သမ္တီ',
      'pulluploadmore': 'ဂြဲဖျေံဂွံဆက်ညာတ်အာ',
      'loadfailedretry': 'Load ဟွံအံၚ်ဇၞး!ဍဵုကဵုဂစာန်မွဲဝါပၠန်ညိ!',
      'releaseloadmore': 'release to load more',
      'nomoredata': 'ဒေတာဟွံမွဲရ',
      'notsupported': 'Not Supported',
      'cleanupresources': 'Cleaning up resources',
      'sharefiletitle': 'Watch or Listen to ',
      'sharefilebody': 'Via MonEbook, Download now at ',
      'sharetext': 'Enjoy Loik Mon, Share, bookmark and download offline',
      'sharetexthint':
          'Join the Loik Mon platform that lets you read thousands of Loik Mon. Download now at',
      'next': 'ဆက်',
      'onboardingpagetitles.0': 'ဒုၚ်တၠုၚ်ရအဴ',
      'onboardingpagetitles.1': 'ဂၠိုက်ဂၠာဲလိက်မန် အဳဗေါက် ဌာန်ပိုဲညိအဴ',
      'onboardingpagetitles.2': 'လိက်အပ်လာၚ်',
      'onboardingpagetitles.3': 'လိက်စၟတ်သမ္တဳ',
      'onboardingpagehints.0':
          'Mon Ebook is a platform that lets you read thousands on Loik Mon.',
      'onboardingpagehints.1':
          'Discover thousands of Loik Mon, all at your disposal.',
      'onboardingpagehints.2':
          'Download Books and read offline anytime you want',
      'onboardingpagehints.3':
          'Bookmark and read later any book of your choice.',
      'app_name ': 'အာံအဳဗော်',
      'walletbalance ': 'Wallet Balance',
      'loading_app ': 'စပ္တန်အဳဗော်မန်...',
      'allitems ': 'လိက်ဖအိုတ်',
      'emptyplaylist ': 'No Playlists',
      'grantstoragepermission ':
          'Please grant accessing storage permission to continue',
      'share_file_title ': 'ဂၠိုက်ဂၠာဲ  ',
      'share_file_body ': 'Via loikmon App, Download now at ',
      'categories ': 'ကဏ္ဍဂမၠိုၚ်',
      'category ': 'ကဏ္ဍ',
      'latest ': 'Books',
      'magazines ': 'Magazines',
      'author ': 'အ္စာကၞေဟ်',
      'profile ': 'ပရိုဝ်ဝှာၚ်',
      'settings ': 'တၚ်ပလေဝ်',
      'playlist ': 'My Playlist',
      'app_info ': 'ပရူပရာအဳဗော်မာန်',
      'books ': 'လိက်ဂမၠိုၚ်',
      'soldbooks ': 'လိက်မသွံရာန်',
      'soldmagazines ': 'Magazines on Sale',
      'searchoptions .0': 'လိက်',
      'searchoptions .1': 'မဂ္ဂဇျေန်',
      'viewoptions .0': 'PDF',
      'viewoptions .1': 'EPUB',
      'fonts.0': 'Style 1',
      'fonts.1': 'Style 2',
      'fonts.2': 'Style 3',
      'fonts.3': 'Style 4',
      'fonts.4': 'Style 5',
      'start_subscription ': 'Unlock Premium Features',
      'start_subscription_hint ':
          'Unlock premium features to start your journey to a never-ending media streaming experience',
      'suggestedforyou ': 'Suggested for you',
      'tracks ': 'Tracks',
      'livetvchannels ': 'Live Tv Channels',
      'latestbooks ': 'လိက်တိတ်လကြဴအိုတ်',
      'popularbooks ': 'လိက်ဒယှ်တှ်',
      'latestmagazines ': 'Mon Magazines',
      'authors ': 'အ္စာကၞေဟ်ဂမၠိုၚ်',
      'viewall ': 'ဗဵုဖအိုတ်',
      'bookmarksMedia ': 'လိက်စၟတ်သမ္တဳ',
      'noitemstodisplay ': 'လိက်ဟွံမွဲ',
      'download ': 'လိက်တံၚ်ဂြဲ',
      'addplaylist ': 'Add to playlist',
      'share ': 'ပါ်ပရအ်',
      'deletemedia ': 'ဇိုတ်ဝှာၚ်',
      'deletemediahint ':
          'Do you wish to delete this downloaded file? This action cannot be undone.',
      'search_hint ': 'Search Books and Magazines',
      'performing_search ': 'Searching Books and Magazines',
      'no_search_result ': 'No results Found',
      'no_search_result_hint ': 'Try input more general keyword',
      'comments ': 'တၚ်လညာတ်ပါ်ပါဲ',
      'replies ': 'လိက်ကလေၚ်',
      'reply ': 'ကလေၚ်လိက်',
      'login_to_add_comment ': 'သွက်ဂွံကဵုလညာတ်ဂှ် လံက်အေန်ကဵုမွဲဝါညိ',
      'login_to_reply ': 'သွက်ကလေၚ်လိက်ဂှ်လံက်အေန်ကဵုမွဲဝါညိ',
      'write_a_message ': 'ချူလညာတ်မၞး...',
      'no_comments ': 'တၚ်လညာတ်ပါ်ပါဲဟွံမွဲရ \nကလေၚ်ဍဵုကဵု ဂစာန်မွဲဝါပၠန်',
      'error_making_comments ': 'Cannot process commenting at the moment..',
      'error_deleting_comments ': 'Cannot delete this comment at the moment..',
      'error_editing_comments ': 'Cannot edit this comment at the moment..',
      'error_loadingmore_comments ':
          'Cannot load more comments at the moment..',
      'deleting_comment ': 'Deleting review',
      'editing_comment ': 'ပလေဝ်တၚ်ကဵုလညာတ်',
      'delete_comment_alert ': 'ဇိုတ်တၚ်ကဵုလညာတ်',
      'edit_comment_alert ': 'ပလေဝ်တၚ်ကဵုလညာတ်',
      'delete_comment_alert_text ': 'မၞးမိက်ဂွံဇိုတ်တၚ်ကဵုလညာတ်မၞးဟာ',
      'load_more ': 'ဆက်ဗဵု',
      'guest_user ': 'Guest User',
      'full_name ': 'ယၟုပေၚ်ၚ်',
      'email_address ': 'အဳမေလ်',
      'password ': 'ဂၞန်ပၞုက်',
      'repeat_password ': 'ကလေၚ်စုတ်ဂၞန်ပၞုက်',
      'register ': 'ကၠောန်အကံက်တၟိ',
      'logout ': 'တိတ်နူကဵုအကံက်',
      'logout_from_app ': 'တိတ်နူကဵုအကံက်မၞးဟာ',
      'logout_from_app_hint ':
          'You wont be able to like or comment on articles and videos if you are not logged in.',
      'go_to_login ': 'ဆက်လံက်အေန်',
      'reset_password ': 'ကၠောန်ဂၞန်ပၞုက်တၟိ',
      'login_to_account ': 'အကံက်မၞးနွံတုဲမံၚ်ယျဟာ',
      'empty_field_error_hint ': 'You need to fill all the fields',
      'invalid_email_error_hint ': 'မၞးမဒးစုတ် အဳမေလ်ဗွဲဗဗွဲကဵုအဳမေလ်ရောၚ် ',
      'passwords_dont_match ': 'ဂၞန်ပၞုက်ၜါဂှ် ဟွံကိတ်ညဳ',
      'processing_please_wait ': 'မကၠောန်တဴဒၟံၚ်, သ္ပဂုဏ်တုဲမၚ်မွဲလစုတ်ညိ...',
      'create_account ': 'ကၠောန်အကံက်တၟိ',
      'forgot_password ': 'ဝိုတ်စဂၞန်ပၞုက်ယျဟာ',
      'more_options ': 'တၚ်တၞဟ်ဟ်',
      'about ': 'ပရောပရာပိုဲ',
      'privacy ': 'မူဝါဒအခေါၚ်အရာ',
      'rate ': 'ကဵုစၟတ်ကဵုအေပ်ဏံ',
      'version ': 'Version',
      'skip ': 'ထ္ၜက်',
      'skip_login ': 'ထ္ၜက်လံက်အေန်',
      'skip_register ': 'ထ္ၜက်ကၠောန်အကံက်တၟိ',
      'data_load_error ':
          'လိက်ဂမၠိုၚ် ထၟံက်ထ္ၜးကဵုဟွံမာန်ဏီရ, သ္ပဂုဏ်တုဲဍဵုကဵု ဂစာန်မွဲဝါညိ၊ စၟဳစၟတ်ကဵုအေန်တာနေတ်မၞးတုဲ ကလေၚ်ပံက်မွဲဝါညိအဴ',
      'no_items ': 'လိက်ဟွံမွဲရ.',
      'loginrequired ': 'နွံပၟိက်လံက်အေန်',
      'loginrequiredhint ':
          'သွက်ဂွံရာန်လိက်ပ္ဍဲအေပ်ပိုဲဏံဂှ် မၞးဒးလံက်အေန်ကၠာရောၚ်။ အကံက်မၞးဟွံမွဲဏီမ္ဂး ကၠောန်အကံက်တၟိတုဲ လံက်အေန်ကဵုမွဲဝါညိအဴ',
      'subscriptions ': 'App Subscriptions',
      'subscribe ': 'SUBSCRIBE',
      'subscribehint ': 'Payment Required',
      'previewsubscriptionrequiredhint ':
          'Payment is required to download or read this book. Purchase this book now for ',
      'done ': 'GET STARTED',
      'paydescriptiontitle ': 'Payment Descriptions',
      'paydescriptioncontent ':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'googlepayreadmecontent ':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'couponcodereadmetitle ': 'ပရောပရာ',
      'couponcodereadmecontent ':
          'သွက်ဂွံကလိဂွံကောပ်ဗါန်ဂှ် ဒးဆက်စၠောံကဵုညးမသွံလိက်နကဵု messengerရအဴ',
      'couponcodereadmetitle2': 'Banks Description',
      'couponcodereadmecontent2':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'rateapp': 'သ္ပသမ္တီ အေပ်အဳဗော်မန်',
      'bookpurchasesuccess': 'မၞးရာန်လိက်အံၚ်ဇၞးရအဴ.',
      'bookpurchaseerror': 'ပြဿနာရာန်လိက်မၞးနွံမ္ဂး ဆက်စၠောံကဵုပိုဲညိအဴ',
      'cannotreviewerror': 'Cannot drop a review at the moment',
      'paymentdetails': 'ပရောပရောရာန်လိက်',
      'mobilebanking': 'မိုဝ်ဗာဲ ဘာဏ်ကေန်(ၚ်)',
      'paywithcoupon': 'ရာန်နကဵုကောပ်ဗါန်',
      'choosecountry': 'ရုဲစှ်ဍုၚ်:',
      'nocountryselected': 'ဟွံဂွံရုဲစှ်လဝ်ဍုၚ်ဏီ',
      'paymentmethods': 'တၚ်ရုဲစှ်ပလံၚ်သြန်ဂမၠိုၚ်',
      'loadingbanks': 'loading banks..',
      'unabletoloadbanks': 'Unable to load banks',
      'nobanksforcountry': 'ဍုၚ်မၞးဂှ် ဘာဏ်ဟွံမွဲရ',
      'attachproofofpayment': 'စုတ်လိက်တၞးချာဲတၚ်တုပ်စိုတ်သြန်',
      'selectafile': 'ရုဲစုတ်လိက်တၞးချာဲမၞး',
      'nofilechoosen': 'ဟွံဂွံရုဲစုတ်လဝ်လိက်တၞးချာဲဏီ',
      'pleaseselectafiletoupload':
          'သ္ပဂုဏ်တုဲစုတ်ကဵုလိက်တၚ်တုပ်စိုတ်(လိက်တၞးချာဲတၚ်တုပ်စိုတ်သြန်မၞးညိ)',
      'submitpaymentproof': 'ပလံၚ်ဗစိုပ်လိက်တၚ်တုပ်စိုတ်',
      'paymentofproofsuccess':
          'မၞးပလံၚ်လိက်တၚ်တုပ်စိုတ် အံၚ်ဇၞးရအဴ၊ ဗွဲမတာပ်အခိၚ် ပိုဲစၟတ်လိက်တၚ်တုပ်စိုတ်တုဲ ကဵုအခေါၚ်ဗှ်လိက်ဏံရ၊ အဝ်...မၚ်စၟဳကဵုမွဲဝါညိအဴ၊ (တၚ်သမ္တီ - အခိၚ်စၟဳစၟတ်အကြာ၂၄နာဍဳ)',
      'paymentofprooferror':
          'သၠးအခေါၚ်ညိ ဂိုၚ်ဟွံဒေပ်ဟွံအံၚ်ဇၞးရ. သ္ပဂုဏ်တုဲထပ်ဂစာန််ကဵုမွဲဝါပၠန်ညိ.',
      'learnmore': 'နဲကဲသုၚ်စောဲ',
      'couponcode': 'ဂၞန်ကောပ်ဗါန်',
      'entercouponcode': 'စုတ်ဂၞန်ကောပ်ဗါန်',
      'entercopounalert': 'သ္ပဂုဏ်တုဲစုတ်ကဵုဂၞန်ကောပ်ဗါန်မၞးညိ',
      'getcoupononmessegner': 'ကလိကေတ်ဂၞန်ကောပ်ဗါန် ပ္ဍဲmessengerဏံညိ',
      'phoneus': 'ဆက်စၠောံနကဵုဂၞန်ဖုန်',
      'description': 'ပရောပရာ',
      'failedtoloadoverview': 'ထၟံက်ထ္ၜးပရောအရာ ဟွံအံၚ်ဇၞးရ',
      'authorbooks': 'လိက်အ္စာကၞေဟ်',
      'booksyoumaylike': 'လိက်မၞးဒးစိုတ်',
      'ratebook': 'ကဵုစၟတ်လိက်ဏံ',
      'taptorate': 'ရုဲစှ်သၞံၚ်သွက်ကဵုစၟတ်လိက်ဏံ',
      'submit': 'ပတိုန်ဏာ',
      'addcomment': 'ချူလိက်ထံက်ထ္ၜး',
      'writeareview': 'ချူလိက်ထံက်ထ္ၜး',
      'topreviews': 'လိက်ထံက်ထ္ၜးကဆံၚ်လ္တူ',
      'noreviews': 'လိက်ထံက်ထ္ၜး ဟွံမွဲဏီရ',
      'accountsuccess': 'အကံက်မၞး ကၠောန်သ္ပအံၚ်ဇၞးရ',
      'topsearchbooks': 'လိက်မၞးဂၠိုက်ဂၠာဲ',
      'topsellbooks': 'လိက်သွံတၟေၚ်',
      'recommended': 'လိက်ထံက်ဂလာန်',
      'overview': 'ပရောပရာ',
      'information': 'တၚ်နၚ်ဂမၠိုၚ်',
      'reviews': 'တၚ်ထံက်ထ္ၜး',
      'deleteoptions': 'ရုဲစှ်လိက်တံၚ်ဂြဲ',
      'readoptions': 'ရုဲစှ်လိက်ဗွဟ်',
      'pending': 'အခိၚ်စၟဳဗှ်',
      'buy': 'ရာန်',
      'read': 'ဗှ်လိက်',
      'changeappfont': 'သၠာဲဗီုပြၚ်မလိက်',
      'changefontsizespacing': 'ပြံၚ်အယဲမလိက်ကေုာံသၠဲပၞောန်လိက်',
      'fontsize': 'အယဲမလိက်',
      'linespace': 'ပၞောန်လိက်',
      'library': 'ဌာန်ရံၚ်လိက်',
      'relatedbooks': 'လိက်မဆက်စပ်',
      'booksearchhint': 'ဂၠာဲလိက်',
      'searching': 'ဂၠာဲဒၟံၚ် ...',
      'Customize': 'ပြံၚ်သၠာဲ',
      'enabledarkmode': 'သၠာဲအရံၚ်',
      'more': 'တၞဟ်ဟ်',
      'newbooks': 'New Books',
      'newarticles': 'New Articles',
      'populararticles': 'Popular Articles',
      'articles': 'Articles',
      'allbooks': 'All Books',
      'makepurchasehint':
          'units will be deducted from your wallet. Click proceed to make this purchase.',
      'proceed': 'Proceed',
      'fewcoinwallethint':
          'Sorry, you do not have enough coins in your wallet to make this purchase',
      'purchasesuccess': 'Congrats, you purchase was successful',
      'articlepurchasehint':
          'You need to purchase this article before you can read it, click the button below to make this purchase.',
      'bookbookmarks': 'Bookmarked Books',
      'bookmarkedarticles': 'Bookmarked Articles',
      'purchasedbooks ': 'လိက်ရာန်',
      'purchasedarticles': 'Purchased Articles',
      'sales': 'Sales',
      'views': 'Views',
      'coins': 'Coins',
      'purchasecoins': 'Purchase more coins for purchases',
      'buycoins': 'Buy Coins',
      'purchasecoinshint': 'Purchase coins for purchase',
      'contactus': 'Contact us',
      'topupcoins': 'Top up coins',
      'youhave': 'You have',
      'paymentfor': 'Payment for',
      'pendingapproval': 'Pending Approval',
      'paymentapproved': 'Payment Approved',
      'articlesearchhint': 'Type Article or Author name',
      'epubsettings': 'Epub Settings',
      'fontstyle': 'Font Style',
      'background': 'Background',
      'light': 'Light',
      'dark': 'Dark',
      'downloadedarticles': 'Downloaded Articles',
      'closeapp': 'Close App',
      'quitapp': 'Do you wish to close the app and return to your home screen',
      'confirm': 'Confirm',
      'normalprice': 'Normal Price',
      'selectnormalprice': 'Select Normal Price',
    };
  }
}

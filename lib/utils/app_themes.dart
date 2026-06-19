import 'package:flutter/material.dart';

import '../utils/my_colors.dart';

enum AppThemeLight {
  Style1,
}

enum AppThemeDark {
  Style1,
}

/// Returns enum value name without enum class name.
String enumNameLight(AppThemeLight anyEnum) {
  return anyEnum.toString().split('.')[1];
}

String enumNameDark(AppThemeDark anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeDataLight = {
  AppThemeLight.Style1: ThemeData(
    useMaterial3: false,
    fontFamily: 'Style1',

    scaffoldBackgroundColor: const Color.fromARGB(255, 242, 243, 244),

    ///ADD THIS
    dialogTheme: DialogThemeData(
      backgroundColor: const Color.fromARGB(255, 246, 249, 250),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 14,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Color.fromARGB(255, 0, 0, 0),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black, // text color
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primary,
        foregroundColor: const Color.fromARGB(255, 240, 239, 239),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),

    ///IMPORTANT FOR MODAL / BOTTOM SHEETS
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    ///MATERIAL COLORS (VERY IMPORTANT)
    colorScheme: ColorScheme.light(
      primary: MyColors.primary,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 248, 246, 248),
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    cardTheme: const CardThemeData(
      color: Color.fromARGB(255, 241, 240, 240),
    ),

    iconTheme: const IconThemeData(color: Colors.black),
  ),
  /*AppThemeLight.keng: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'keng',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: MyColors.primary,
      titleTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.black, unselectedLabelColor: Colors.grey),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontFamily: 'keng',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        fontFamily: 'keng',
      ),
      subtitle2: TextStyle(
        fontFamily: 'keng',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        fontFamily: 'keng',
      ),
      headline3: TextStyle(
        fontFamily: 'keng',
      ),
      headline2: TextStyle(
        fontFamily: 'keng',
      ),
      headline1: TextStyle(
        fontFamily: 'keng',
      ),
      subtitle1: TextStyle(
        fontFamily: 'keng',
      ),
      bodyText2: TextStyle(
        fontFamily: 'keng',
      ),
      bodyText1: TextStyle(
        fontFamily: 'keng',
      ),
      overline: TextStyle(
        fontFamily: 'keng',
      ),
      caption: TextStyle(
        fontFamily: 'keng',
      ),
    ),
  ),
  AppThemeLight.hsi: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'hsi',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: MyColors.primary,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.black, unselectedLabelColor: Colors.grey),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontFamily: 'hsi',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        fontFamily: 'hsi',
      ),
      subtitle2: TextStyle(
        fontFamily: 'hsi',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        fontFamily: 'hsi',
      ),
      headline3: TextStyle(
        fontFamily: 'hsi',
      ),
      headline2: TextStyle(
        fontFamily: 'hsi',
      ),
      headline1: TextStyle(
        fontFamily: 'hsi',
      ),
      subtitle1: TextStyle(
        fontFamily: 'hsi',
      ),
      bodyText2: TextStyle(
        fontFamily: 'hsi',
      ),
      bodyText1: TextStyle(
        fontFamily: 'hsi',
      ),
      overline: TextStyle(
        fontFamily: 'hsi',
      ),
      caption: TextStyle(
        fontFamily: 'hsi',
      ),
    ),
  ),
  AppThemeLight.hopong: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    fontFamily: 'hopong',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: MyColors.primary,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.black, unselectedLabelColor: Colors.grey),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontFamily: 'hopong',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        fontFamily: 'hopong',
      ),
      subtitle2: TextStyle(
        fontFamily: 'hopong',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        fontFamily: 'hopong',
      ),
      headline3: TextStyle(
        fontFamily: 'hopong',
      ),
      headline2: TextStyle(
        fontFamily: 'hopong',
      ),
      headline1: TextStyle(
        fontFamily: 'hopong',
      ),
      subtitle1: TextStyle(
        fontFamily: 'hopong',
      ),
      bodyText2: TextStyle(
        fontFamily: 'hopong',
      ),
      bodyText1: TextStyle(
        fontFamily: 'hopong',
      ),
      overline: TextStyle(
        fontFamily: 'hopong',
      ),
      caption: TextStyle(
        fontFamily: 'hopong',
      ),
    ),
  ),
  AppThemeLight.beautifulword: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'beautifulword',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: MyColors.primary,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.black, unselectedLabelColor: Colors.grey),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontFamily: 'beautifulword',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        fontFamily: 'beautifulword',
      ),
      subtitle2: TextStyle(
        fontFamily: 'beautifulword',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        fontFamily: 'beautifulword',
      ),
      headline3: TextStyle(
        fontFamily: 'beautifulword',
      ),
      headline2: TextStyle(
        fontFamily: 'beautifulword',
      ),
      headline1: TextStyle(
        fontFamily: 'beautifulword',
      ),
      subtitle1: TextStyle(
        fontFamily: 'beautifulword',
      ),
      bodyText2: TextStyle(
        fontFamily: 'beautifulword',
      ),
      bodyText1: TextStyle(
        fontFamily: 'beautifulword',
      ),
      overline: TextStyle(
        fontFamily: 'beautifulword',
      ),
      caption: TextStyle(
        fontFamily: 'beautifulword',
      ),
    ),
  ),*/
};

final appThemeDataDark = {
  AppThemeDark.Style1: ThemeData(
    useMaterial3: false,
    fontFamily: 'Style1',

    scaffoldBackgroundColor: const Color.fromARGB(255, 10, 18, 35),

    ///IMPROVED DIALOG THEME
    dialogTheme: DialogThemeData(
      backgroundColor: const Color.fromARGB(251, 19, 33, 37),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        color: Color.fromARGB(255, 239, 241, 242),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: Color.fromARGB(255, 198, 199, 200),
        fontSize: 14,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Color.fromARGB(255, 239, 241, 242),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Color.fromARGB(255, 239, 241, 242),
      indicatorSize: TabBarIndicatorSize.label,
    ),

    ///BOTTOM SHEET
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 27, 31, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 239, 241, 242),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primary,
        foregroundColor: const Color.fromARGB(255, 239, 241, 242),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          Color.fromARGB(255, 237, 241, 244),
        ),
      ),
    ),

    ///COLOR SCHEME (VERY IMPORTANT)
    colorScheme: ColorScheme.dark(
      primary: MyColors.primary,
      onPrimary: const Color.fromARGB(255, 239, 241, 242),
      surface: Color.fromARGB(255, 27, 31, 50),
      onSurface: const Color.fromARGB(255, 239, 241, 242),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      color: MyColors.headerdark,
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 237, 241, 244),
      ),
    ),

    cardTheme: const CardThemeData(
      color: Color.fromARGB(255, 27, 31, 50),
    ),

    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 237, 241, 244),
    ),
  ),
  /* AppThemeDark.keng: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'keng',
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      color: MyColors.headerdark,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    dialogBackgroundColor: Colors.grey[900],
    cardTheme: CardTheme(
      color: Colors.grey[900],
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.grey[900],
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      headline1: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      overline: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
      caption: TextStyle(
        color: Colors.white,
        fontFamily: 'keng',
      ),
    ),
  ),
  AppThemeDark.hsi: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'hsi',
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      color: MyColors.headerdark,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    dialogBackgroundColor: Colors.grey[900],
    cardTheme: CardTheme(
      color: Colors.grey[900],
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.grey[900],
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      headline1: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      overline: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
      caption: TextStyle(
        color: Colors.white,
        fontFamily: 'hsi',
      ),
    ),
  ),
  AppThemeDark.hopong: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'hopong',
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      color: MyColors.headerdark,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    dialogBackgroundColor: Colors.grey[900],
    cardTheme: CardTheme(
      color: Colors.grey[900],
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.grey[900],
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      headline1: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      overline: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
      caption: TextStyle(
        color: Colors.white,
        fontFamily: 'hopong',
      ),
    ),
  ),
  AppThemeDark.beautifulword: ThemeData(
    //primarySwatch: Colors.blue,
    // brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: 'beautifulword',
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      color: MyColors.headerdark,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    dialogBackgroundColor: Colors.grey[900],
    cardTheme: CardTheme(
      color: Colors.grey[900],
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.grey[900],
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
        fontSize: 20.0,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      headline1: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      overline: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
      caption: TextStyle(
        color: Colors.white,
        fontFamily: 'beautifulword',
      ),
    ),
  ),*/
};

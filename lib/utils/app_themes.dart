import 'package:flutter/material.dart';
import '../utils/my_colors.dart';

enum AppThemeLight { Style1 }
enum AppThemeDark  { Style1 }

/// Returns enum value name without enum class name.
String enumNameLight(AppThemeLight anyEnum) =>
    anyEnum.toString().split('.')[1];

String enumNameDark(AppThemeDark anyEnum) =>
    anyEnum.toString().split('.')[1];

// ────────────────────────────────────────────────────────────
//  LIGHT THEME  —  Zcro Modern Minimalist 2025
// ────────────────────────────────────────────────────────────
final appThemeDataLight = {
  AppThemeLight.Style1: ThemeData(
    useMaterial3: false,
    fontFamily: 'Style1',

    // Background — pure near-white with slight blue tint
    scaffoldBackgroundColor: MyColors.surfaceLight,

    // ── Color Scheme ──────────────────────────────────────
    colorScheme: ColorScheme.light(
      primary:   MyColors.accent,
      onPrimary: Colors.white,
      secondary: MyColors.accentSoft,
      surface:   MyColors.cardLight,
      onSurface: MyColors.textPrimaryLight,
      error:     MyColors.error,
    ),

    // ── AppBar ────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: MyColors.headerLight,
      elevation:       0,
      scrolledUnderElevation: 0,
      centerTitle:     true,
      titleTextStyle: TextStyle(
        color:       MyColors.textPrimaryLight,
        fontSize:    22,
        fontWeight:  FontWeight.w700,
        letterSpacing: 0.2,
      ),
      iconTheme: IconThemeData(color: MyColors.textPrimaryLight),
    ),

    // ── Cards ─────────────────────────────────────────────
    cardTheme: CardThemeData(
      color:        MyColors.cardLight,
      elevation:    0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: MyColors.borderLight, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── Elevated Button ───────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.accent,
        foregroundColor: Colors.white,
        elevation:       0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    // ── Text Button ───────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MyColors.accent,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // ── Icon Button ───────────────────────────────────────
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(MyColors.textPrimaryLight),
      ),
    ),

    // ── Tab Bar ───────────────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor:           MyColors.accent,
      unselectedLabelColor: MyColors.textSecondaryLight,
      indicatorColor:       MyColors.accent,
      indicatorSize:        TabBarIndicatorSize.label,
      labelStyle:   TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
    ),

    // ── Bottom Sheet ──────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MyColors.cardLight,
      elevation:       0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // ── Dialog ────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: MyColors.cardLight,
      elevation:       0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: const TextStyle(
        color: MyColors.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: const TextStyle(
        color: MyColors.textSecondaryLight,
        fontSize: 14,
        height: 1.5,
      ),
    ),

    // ── Divider ───────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color:     MyColors.borderLight,
      thickness: 1,
      space:     1,
    ),

    // ── Icon ─────────────────────────────────────────────
    iconTheme: const IconThemeData(color: MyColors.textPrimaryLight),

    // ── Input (search bars etc.) ──────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled:      true,
      fillColor:   const Color(0xFFF1F3F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:   BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  ),
};

// ────────────────────────────────────────────────────────────
//  DARK THEME  —  Zcro Modern Minimalist 2025
// ────────────────────────────────────────────────────────────
final appThemeDataDark = {
  AppThemeDark.Style1: ThemeData(
    useMaterial3: false,
    fontFamily: 'Style1',

    // Background — very deep navy
    scaffoldBackgroundColor: MyColors.surfaceDark,

    // ── Color Scheme ──────────────────────────────────────
    colorScheme: ColorScheme.dark(
      primary:   MyColors.accentOnDark,
      onPrimary: Colors.white,
      secondary: MyColors.accentSoft,
      surface:   MyColors.cardDark,
      onSurface: MyColors.textPrimaryDark,
      error:     MyColors.error,
    ),

    // ── AppBar ────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: MyColors.headerdark,
      elevation:       0,
      scrolledUnderElevation: 0,
      centerTitle:     true,
      titleTextStyle: const TextStyle(
        color:       MyColors.textPrimaryDark,
        fontSize:    22,
        fontWeight:  FontWeight.w700,
        letterSpacing: 0.2,
      ),
      iconTheme: const IconThemeData(color: MyColors.textPrimaryDark),
    ),

    // ── Cards ─────────────────────────────────────────────
    cardTheme: CardThemeData(
      color:     MyColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: MyColors.borderDark, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── Elevated Button ───────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.accentOnDark,
        foregroundColor: Colors.white,
        elevation:       0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    // ── Text Button ───────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MyColors.accentOnDark,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // ── Icon Button ───────────────────────────────────────
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(MyColors.textPrimaryDark),
      ),
    ),

    // ── Tab Bar ───────────────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor:           MyColors.accentOnDark,
      unselectedLabelColor: MyColors.textSecondaryDark,
      indicatorColor:       MyColors.accentOnDark,
      indicatorSize:        TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
    ),

    // ── Bottom Sheet ──────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1A2035),
      elevation:       0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // ── Dialog ────────────────────────────────────────────
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF1A2035),
      elevation:       0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      titleTextStyle: TextStyle(
        color: MyColors.textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: TextStyle(
        color: MyColors.textSecondaryDark,
        fontSize: 14,
        height: 1.5,
      ),
    ),

    // ── Divider ───────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color:     MyColors.borderDark,
      thickness: 1,
      space:     1,
    ),

    // ── Icon ─────────────────────────────────────────────
    iconTheme: const IconThemeData(color: MyColors.textPrimaryDark),

    // ── Input ─────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled:    true,
      fillColor: const Color(0xFF1E2840),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:   BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  ),
};

import 'package:flutter/material.dart';

class MyColors {
  // === LEGACY RANDOM COLORS (kept for backward-compat) ===
  static List<Color?> randomcolors = [
    Colors.amber[900],
    Colors.lime[700],
    Colors.purple,
    Colors.teal,
    Colors.indigo[900],
    Colors.blueGrey[700],
    Colors.pink,
  ];

  // === BRAND / ACCENT (kept — note the intentional "0" in name) ===
  // ⚠️  mainC0lor uses zero "0", NOT letter "o" — preserving spelling exactly.
  static Color mainC0lor = const Color(0xFFC014BA); // vivid magenta-purple

  // === MODERN DESIGN TOKENS ===

  // Surface / Background
  static const Color surfaceLight    = Color(0xFFF6F7FB); // very light off-white
  static const Color surfaceDark     = Color(0xFF0D1121); // deep dark navy
  static const Color cardLight       = Color(0xFFFFFFFF);
  static const Color cardDark        = Color(0xFF161B2E); // mid navy card
  static const Color sidebarLight    = Color(0xFFF0F2F7);
  static const Color sidebarDark     = Color(0xFF131827);

  // Accent palette  (magenta-violet family)
  static const Color accent          = Color(0xFFC014BA); // primary brand
  static const Color accentSoft      = Color(0xFFE040FB); // lighter pop
  static const Color accentMuted     = Color(0xFFAD1AAA); // pressed / hover
  static const Color accentOnDark    = Color(0xFFD946EF); // on-dark variant
  static const Color accentGlow      = Color(0x29C014BA); // 16% opacity glow fill

  // Semantic
  static const Color success         = Color(0xFF22C55E);
  static const Color warning         = Color(0xFFEAB308);
  static const Color error           = Color(0xFFEF4444);
  static const Color info            = Color(0xFF3B82F6);
  static const Color coins           = Color(0xFFF59E0B); // amber coins icon

  // Text
  static const Color textPrimaryLight   = Color(0xFF0F172A); // slate-900
  static const Color textSecondaryLight = Color(0xFF64748B); // slate-500
  static const Color textPrimaryDark    = Color(0xFFF1F5F9); // slate-100
  static const Color textSecondaryDark  = Color(0xFF94A3B8); // slate-400

  // Divider / border
  static const Color borderLight     = Color(0x1A000000); // black 10%
  static const Color borderDark      = Color(0x1AFFFFFF); // white 10%

  // Header (AppBar / sidebar top-bar)
  static const Color headerLight     = Color(0xFFFFFFFF);
  static Color       headerdark      = const Color(0xFF0B1120);

  // Gradient stops for glass overlay on images
  static const Color glassBottom     = Color(0xC2000000); // 76% black
  static const Color glassTop        = Color(0x00000000); // transparent

  // === LEGACY ALIASES (kept to avoid breaking unchanged widgets) ===
  static Color kTextColor            = const Color(0xFF0D1333);
  static Color kBlueColor            = const Color(0xFF6E8AFA);
  static Color kBestSellerColor      = const Color(0xFFFFD073);
  static Color kGreenColor           = const Color(0xFF49CC96);
  static Color primary               = const Color(0xFFF6F7FB);
  static Color primaryDark           = const Color(0xFF161B2E);
  static Color? primaryLight         = Colors.pink[300];
  static Color? primaryVeryLight     = Colors.pink[100];
  static const Color accentDark      = Color(0xFFF50057);
  static const Color accentLight     = Color(0xFFFF80AB);
  static Color backgroundColor       = const Color(0xFFF6F7FB);

  static const Color grey_3          = Color(0xFFECECEC);
  static const Color grey_5          = Color(0xFFEBEAEA);
  static const Color grey_10         = Color(0xFFE6E6E6);
  static const Color grey_20         = Color(0xFFCCCCCC);
  static const Color grey_40         = Color(0xFF999999);
  static const Color grey_60         = Color(0xFF666666);
  static const Color grey_80         = Color(0xFF37474F);
  static const Color grey_90         = Color(0xFF263238);
  static const Color grey_95         = Color(0xFF1A1A1A);
  static const Color grey_100_       = Color(0xFF0D0D0D);

  static const Color notWhite        = Color(0xFFEDF0F2);
  static const Color nearlyWhite     = Color(0xFFF0EFEF);
  static const Color white           = Color(0xFFECEAEA);
  static const Color nearlyBlack     = Color(0xFF213333);
  static const Color grey            = Color(0xFF3A5160);
  static const Color dark_grey       = Color(0xFF313A44);
  static const Color darkText        = Color(0xFF253840);
  static const Color darkerText      = Color(0xFF17262A);
  static const Color lightText       = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground  = Color(0xFFEEF1F3);
  static const Color spacer          = Color(0xFFEEEDED);
  static const String fontName       = 'WorkSans';
}

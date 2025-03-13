import 'package:flutter/material.dart';

class AppColors {
  // Primary Theme Colors
  static const Color kPrimaryColor = Color(0xFF925BFE);
  static const Color kSecondaryColor = Color(0xFF756EF3);
  static const Color kBackgroundColor = Color(0xFFF0F5F5);
  static const Color kScaffoldColor = Color(0xFFF0F5F5);

  // Text Colors
  static const Color kTitleColor = Color(0xFF002055);
  static const Color kTextColor = Color(0xFF00091F);
  static const Color kStrokeColor = Color(0xFF868D95);

  // Semantic Colors
  static const Color kErrorColor = Color(0xFFF9637C); // Red
  static const Color kSuccessColor = Color(0xFF26C586); // Light Green
  static const Color kWarningColor = Color(0xFFFBB453); // Orange
  static const Color kInfoColor = Color(0xFF185BFF); // Blue

  // Additional Colors
  static const Color kLightGreyColor = Color(0xFF828282);
  static const Color kDarkGreyColor = Color(0xFF333333);
  static const Color kLightGreenColor = Color(0xFF26C586);
  static const Color kDarkGreenColor = Color(0xFF229064);
  static const Color kOrangeColor = Color(0xFFFBB453);
  static const Color kYellowColor = Color(0xFFF0B704);
  static const Color kPurpleColor = Color(0xFF925BFE);
  static const Color kDarkPurpleColor = Color(0xFF756EF3);
  static const Color kIconColor = Color(0xFF000000);
  static const Color kShadowColor = Color(0xFF000000);
  static const Color kBlackColor = Color(0xFF000000);
  static const Color kWhiteColor = Color(0xFFFFFFFF);

  // Dark Mode Support
  static var dark = _DarkColors();
  static var light = _LightColors();

  // Material Color Palette for Primary Color
  static const MaterialColor kPrimarySwatch = MaterialColor(
    0xFF925BFE,
    <int, Color>{
      50: Color(0xFFEDE3FF),
      100: Color(0xFFD1BFFF),
      200: Color(0xFFB499FF),
      300: Color(0xFF976FFF),
      400: Color(0xFF864FFF),
      500: Color(0xFF7530FE),
      600: Color(0xFF6B2AFD),
      700: Color(0xFF5F22FD),
      800: Color(0xFF531AFD),
      900: Color(0xFF3F0DFD),
    },
  );
}

// Dark Mode Colors
class _DarkColors {
  final Color background = Color(0xFF0A1931);
  final Color text = Color(0xFFF0F5F5);
  final Color primary = Color(0xFF756EF3);
  final Color secondary = Color(0xFF925BFE);
  final Color error = Color(0xFFF9637C);
  final Color success = Color(0xFF26C586);
}

// Light Mode Colors
class _LightColors {
  final Color background = Color(0xFFF0F5F5);
  final Color text = Color(0xFF00091F);
  final Color primary = Color(0xFF925BFE);
  final Color secondary = Color(0xFF756EF3);
  final Color error = Color(0xFFF9637C);
  final Color success = Color(0xFF26C586);
}

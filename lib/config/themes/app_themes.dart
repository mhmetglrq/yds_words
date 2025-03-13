import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yds_words/config/extensions/context_extension.dart';

import '../items/colors/app_colors.dart';

/// A utility class to provide consistent light and dark themes.
///
/// The `lightTheme` and `darkTheme` methods receive a [BuildContext]
/// so they can leverage extension methods (e.g., responsiveTextSize) for
/// responsive font sizing.
class AppTheme {
  const AppTheme._();

  /// Creates the light theme for the application.
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.kTextColor,
      scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kTitleColor),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
          color: AppColors.kTitleColor,
        ),
        foregroundColor: AppColors.kWhiteColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      fontFamily: 'Inter',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(6.0), // ~0.034 * height
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.3), // ~0.03 * height
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6), // ~0.026 * height
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(6.0), // ~0.034 * height
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4), // ~0.025 * height
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6), // ~0.026 * height
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.6), // ~0.032 * height
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4), // ~0.025 * height
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.5), // ~0.02 * height
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(4.2), // ~0.024 * height
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.8), // ~0.022 * height
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.5), // ~0.02 * height
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.8), // ~0.022 * height
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.5), // ~0.02 * height
        ),
        labelSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.0), // ~0.017 * height
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kTextColor),
    );
  }

  /// Creates the dark theme for the application.
  ///
  /// It also receives a [BuildContext] so we can customize text sizes or
  /// other properties if desired.
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: context.textTheme.displayLarge?.copyWith(
          color: Colors.white,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(6.0),
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.3),
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6),
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(6.0),
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4),
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6),
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.6),
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4),
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.5),
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(4.2),
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.8),
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.5),
          color: Colors.white,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.blueAccent,
        brightness: Brightness.dark,
      ),
    );
  }
}

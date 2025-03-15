import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yds_words/config/extensions/context_extension.dart';

import '../items/colors/app_colors.dart';

/// A utility class to provide consistent light and dark themes.
class AppTheme {
  const AppTheme._();

  /// Creates the light theme for the application.
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.kPrimaryColor,
      scaffoldBackgroundColor: AppColors.kBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.kWhiteColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kTitleColor),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
          color: AppColors.kTitleColor,
        ),
        foregroundColor: AppColors.kPrimaryColor,
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
          fontSize: context.responsiveTextSize(6.0),
          color: AppColors.kTextColor,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.3),
          color: AppColors.kTextColor,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6),
          color: AppColors.kTextColor,
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(6.0),
          color: AppColors.kTitleColor,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4),
          color: AppColors.kTitleColor,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6),
          color: AppColors.kTitleColor,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.6),
          color: AppColors.kTitleColor,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4),
          color: AppColors.kTextColor,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.5),
          color: AppColors.kTextColor,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(4.2),
          color: AppColors.kDarkGreyColor,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.8),
          color: AppColors.kDarkGreyColor,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.5),
          color: AppColors.kDarkGreyColor,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.8),
          color: AppColors.kTextColor,
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.5),
          color: AppColors.kTextColor,
        ),
        labelSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.0),
          color: AppColors.kTextColor,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.kPrimaryColor,
        primary: AppColors.kPrimaryColor,
        secondary: AppColors.kSecondaryColor,
        error: AppColors.kErrorColor,
        brightness: Brightness.light,
      ),
    );
  }

  /// Creates the dark theme for the application.
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.dark.primary,
      scaffoldBackgroundColor: AppColors.dark.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.dark.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: context.textTheme.displayLarge?.copyWith(
          color: AppColors.dark.text,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.dark.background,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(6.0),
          color: AppColors.dark.text,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.3),
          color: AppColors.dark.text,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6),
          color: AppColors.dark.text,
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(6.0),
          color: AppColors.dark.text,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4),
          color: AppColors.dark.text,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(4.6),
          color: AppColors.dark.text,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveTextSize(5.6),
          color: AppColors.dark.text,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(4.4),
          color: AppColors.dark.text,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveTextSize(3.5),
          color: AppColors.dark.text,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(4.2),
          color: AppColors.dark.text,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.8),
          color: AppColors.dark.text,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.responsiveTextSize(3.5),
          color: AppColors.dark.text,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.dark.primary,
        secondary: AppColors.dark.secondary,
        brightness: Brightness.dark,
        surface: AppColors.dark.background,
      ),
    );
  }
}

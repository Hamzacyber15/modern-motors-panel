// import 'package:connectivity_plus/connectivity_plus.dart';
// ignore_for_file: deprecated_member_use

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class AppTheme {
  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color raisinColor = const Color(0xFF272727);
  static Color greyColor = const Color(0xFFEEEEEE);
  static Color blackColor = const Color(0xFF000000);
  static const Color toOrdersTextColor = Color(0xFF646b72);
  static String fontName = 'Raleway';
  static Color lightGreen = const Color(0xFFF7FFF2);
  static Color greyishBlue = const Color(0xFF84B2B0);
  static final Color backgroundGreyColor = Color(0xffF2F2F2);
  static final Color pageHeaderTitleColor = Color(0xff212b36);
  static const Color bgColor = Color(0xFFF5F7FA);
  //static Color primaryColor = const Color.fromARGB(255, 8, 34, 164);
  static Color primaryColor = const Color(
    0xFF0F172A,
  ); //const Color.fromARGB(255, 2, 21, 118);
  static Color darkprimaryColor = const Color.fromARGB(255, 9, 36, 172);
  static Color lightBlueColor = const Color.fromARGB(255, 80, 101, 205);
  static const Color blackColorShade1 = Color(0xFF1A1A1A);
  static Color orangeColor = const Color.fromRGBO(250, 92, 0, 1);
  static Color black50 = const Color(0xFF000000).withValues(alpha: 0.5);
  static Color grey = const Color(0xAAAAAAAA);
  static Color redColor = const Color(0xFFA00000);
  static Color transparentColor = const Color(0x00FFFFFF);
  static Color greenColor = const Color.fromARGB(255, 15, 112, 15);
  static Color lightGreenColor = const Color.fromARGB(255, 89, 236, 89);
  static Color yellowColor = const Color(0xFFFDD128);
  static final Color pageHeaderSubTitleColor = Color(0xff646b72);
  static final Color borderColor = Color(0xffe6eaed);
  static ThemeData getCurrentTheme(
    bool isDark,
    ConnectivityResult connectionStatus,
  ) {
    Color inverseBlackOrWhite = isDark ? whiteColor : blackColor;
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: fontName,
      primarySwatch: generateMaterialColor(primaryColor),
      scaffoldBackgroundColor: isDark ? blackColor : greyColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: connectionStatus == ConnectivityResult.none
            ? Colors.red
            : isDark
            ? raisinColor
            : greyColor,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontFamily: fontName,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: primaryColor),
        actionsIconTheme: IconThemeData(color: primaryColor),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? raisinColor : whiteColor,
        indicatorColor: primaryColor,
        elevation: 0,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: isDark ? raisinColor : whiteColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? raisinColor : whiteColor,
        elevation: 0,
      ),
      datePickerTheme: const DatePickerThemeData(),
      cardTheme: CardThemeData(
        color: isDark ? raisinColor : whiteColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: fontName, color: blackColor),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: pageHeaderTitleColor,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          fontFamily: fontName,
          color: pageHeaderSubTitleColor,
        ),
        headlineLarge: TextStyle(fontFamily: fontName, color: blackColor),
        headlineMedium: TextStyle(fontFamily: fontName, color: blackColor),
        headlineSmall: TextStyle(fontFamily: fontName, color: blackColor),
        labelLarge: TextStyle(fontFamily: fontName, color: blackColor),
        labelMedium: TextStyle(fontFamily: fontName, color: blackColor),
        labelSmall: TextStyle(fontFamily: fontName, color: blackColor),
        titleLarge: TextStyle(fontFamily: fontName, color: blackColor),
        titleMedium: TextStyle(fontFamily: fontName, color: blackColor),
        titleSmall: TextStyle(fontFamily: fontName, color: blackColor),
        bodySmall: TextStyle(color: blackColor),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: pageHeaderSubTitleColor,
        ),
        bodyLarge: TextStyle(color: blackColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: inverseBlackOrWhite,
        suffixIconColor: inverseBlackOrWhite,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //       color: AppTheme.primaryColor), // Border color when not focused
        // ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
          ), // Border color when focused
        ),
        labelStyle: TextStyle(
          color: isDark ? greyColor : raisinColor.withOpacity(0.5),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        selectedColor: primaryColor,
        iconTheme: IconThemeData(color: inverseBlackOrWhite),
        checkmarkColor: whiteColor,
        labelStyle: TextStyle(color: inverseBlackOrWhite),
        secondaryLabelStyle: TextStyle(color: whiteColor),
        backgroundColor: isDark ? blackColor : greyColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
      ),
      iconTheme: IconThemeData(color: inverseBlackOrWhite),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        surfaceTintColor: whiteColor,
        backgroundColor: whiteColor,
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        titleTextStyle: TextStyle(
          color: AppTheme.blackColor,
          fontFamily: fontName,
        ),
        iconColor: inverseBlackOrWhite,
        visualDensity: VisualDensity.compact,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        // tilePadding: const EdgeInsets.symmetric(
        //   horizontal: 12,
        // ),
        // shape: Border.all(
        //   width: 0,
        //   color: whiteColor,
        // ),
        // collapsedShape: Border.all(
        //   width: 0,
        //   color: whiteColor,
        // ),
        iconColor: Colors.blue[200],
        collapsedIconColor: AppTheme.grey,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (!states.contains(WidgetState.selected)) {
            return isDark ? whiteColor : grey;
          }
          return primaryColor;
        }),
        thumbColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (!states.contains(WidgetState.selected)) {
            return isDark ? whiteColor : whiteColor;
          }
          return whiteColor;
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? raisinColor : whiteColor,
        titleTextStyle: TextStyle(
          color: inverseBlackOrWhite,
          fontFamily: fontName,
        ),
        contentTextStyle: TextStyle(
          color: inverseBlackOrWhite,
          fontFamily: fontName,
          decorationColor: Colors.white,
        ),
        surfaceTintColor: isDark ? whiteColor : raisinColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(color: primaryColor, fontFamily: fontName),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F3F3)),
        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      math.max(0, math.min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1,
  );

  static int shadeValue(int value, double factor) =>
      math.max(0, math.min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1,
  );
}

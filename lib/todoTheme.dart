import 'package:flutter/material.dart';
import 'package:todoapp/color_for_the_app.dart';

class Todotheme {
  static ThemeData lightThmem = ThemeData(
    useMaterial3: true,
    // colorScheme: ColorScheme.fromSeed(seedColor: ColorForTheApp.whiteColor),
    colorScheme: const ColorScheme.light(
      primary: ColorForTheApp.whiteColor,
      onPrimary: ColorForTheApp.blackColor,
      secondary: ColorForTheApp.whiteColor,
      onSecondary: ColorForTheApp.whiteColor,
      surface: ColorForTheApp.whiteColor,
      onSurface: ColorForTheApp.blackColor,
    ),

    timePickerTheme: TimePickerThemeData(
      dialBackgroundColor: ColorForTheApp.blackColor,
      dialTextColor: ColorForTheApp.whiteColor,
      hourMinuteColor: ColorForTheApp.blackColor,
      hourMinuteTextColor: ColorForTheApp.whiteColor,
      dayPeriodColor: ColorForTheApp.blackColor,
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorForTheApp.whiteColor;
        }
        return ColorForTheApp.blackColor;
      }),

      // dialTextStyle: TextStyle(
      //   backgroundColor: ColorForTheApp.greycolorlightshade,
      //   color: ColorForTheApp.whiteColor,
      // ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(ColorForTheApp.blackColor),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(ColorForTheApp.blackColor),
      ),
      dialHandColor: ColorForTheApp.greycolor.withAlpha(90),
    ),

    // scaffoldBackgroundColor: ColorForTheApp.whiteColor,
    // appBarTheme: AppBarTheme(
    //   backgroundColor: ColorForTheApp.greycolor.shade300,
    //   foregroundColor: ColorForTheApp.blackColor,
    //   elevation: 20,
    // ),

    // progressIndicatorTheme: ProgressIndicatorThemeData(
    //   color: ColorForTheApp.whiteColor,
    // ),
    // inputDecorationTheme: InputDecorationTheme(
    //   focusedBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: ColorForTheApp.blackColor),
    //   ),
    //   labelStyle: TextStyle(color: ColorForTheApp.blackColor),
    // ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorForTheApp.blackColor,
      selectionColor: ColorForTheApp.whiteColor54,
      selectionHandleColor: ColorForTheApp.blackColor,
    ),

    datePickerTheme: DatePickerThemeData(
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(ColorForTheApp.blackColor),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(ColorForTheApp.blackColor),
      ),
      todayBackgroundColor: WidgetStateProperty.all(ColorForTheApp.greycolor),
      todayForegroundColor: WidgetStateProperty.all(ColorForTheApp.whiteColor),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? ColorForTheApp.greycolor
            : null;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? ColorForTheApp.whiteColor
            : null;
      }),
    ),

    cardTheme: CardThemeData(color: ColorForTheApp.whiteColor, elevation: 2),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorForTheApp.greycolor.shade300,
      foregroundColor: ColorForTheApp.blackColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: ColorForTheApp.greycolor.shade300,
      selectedItemColor: ColorForTheApp.blackColor,
      unselectedItemColor: ColorForTheApp.greycolor.shade800,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      elevation: 5,
    ),
    // brightness: Brightness.light,
    // textTheme: TextTheme(
    //   bodyMedium: TextStyle(color: ColorForTheApp.blackColor),
    // ),
    // iconTheme: IconThemeData(color: ColorForTheApp.blackColor),
  );

  static ThemeData darktheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: ColorForTheApp.blackColor,
      onPrimary: ColorForTheApp.whiteColor,
      secondary: ColorForTheApp.greycolor,
      onSecondary: ColorForTheApp.greycolorlightshade,
      surface: ColorForTheApp.blackColor,
      onSurface: ColorForTheApp.whiteColor,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorForTheApp.whiteColor,
      selectionColor: ColorForTheApp.greycolor,
      selectionHandleColor: ColorForTheApp.whiteColor,
    ),

    // scaffoldBackgroundColor: ColorForTheApp.blackColor,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorForTheApp.greycolorlightshade,
      foregroundColor: ColorForTheApp.whiteColor,
      elevation: 20,
    ),

    // progressIndicatorTheme: ProgressIndicatorThemeData(
    //   refreshBackgroundColor: ColorForTheApp.blackColor,
    //   color: ColorForTheApp.whiteColor,
    // ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: ColorForTheApp.whiteColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorForTheApp.whiteColor),
      ),
      labelStyle: TextStyle(color: ColorForTheApp.whiteColor),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorForTheApp.greycolor,
      foregroundColor: ColorForTheApp.blackColor,
    ),

    timePickerTheme: TimePickerThemeData(
      backgroundColor: ColorForTheApp.greycolorlightshade,
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(ColorForTheApp.whiteColor),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(ColorForTheApp.whiteColor),
      ),
      dialHandColor: ColorForTheApp.greycolor.withAlpha(90),
      dayPeriodColor: ColorForTheApp.blackColor,
      dayPeriodTextColor: ColorForTheApp.whiteColor,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: ColorForTheApp.greycolorlightshade,
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(ColorForTheApp.whiteColor),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(ColorForTheApp.whiteColor),
      ),
      todayBorder: BorderSide(style: BorderStyle.none),
      todayBackgroundColor: WidgetStateProperty.all(ColorForTheApp.blackColor),
      todayForegroundColor: WidgetStateProperty.all(ColorForTheApp.whiteColor),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? ColorForTheApp.blackColor
            : null;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? ColorForTheApp.whiteColor
            : null;
      }),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: ColorForTheApp.blackColor,
      selectedItemColor: ColorForTheApp.whiteColor,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      elevation: 5,
    ),
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: ColorForTheApp.whiteColor),
    ),
    iconTheme: IconThemeData(color: ColorForTheApp.whiteColor),
  );
}

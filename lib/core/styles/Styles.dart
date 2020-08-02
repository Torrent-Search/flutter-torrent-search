import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primaryColor = Colors.deepPurpleAccent;
const Color accentColor = Colors.deepPurpleAccent;

final ThemeData dark = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  accentColor: accentColor,
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  buttonTheme: ThemeData.dark().buttonTheme.copyWith(
        colorScheme: const ColorScheme.dark(),
        buttonColor: primaryColor,
      ),
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
    color: Colors.black,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'OpenSans',
      ),
  primaryTextTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'OpenSans',
      ),
  accentTextTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'OpenSans',
      ),
  tabBarTheme: const TabBarTheme(
    unselectedLabelColor: Colors.white,
    labelPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      color: Colors.white,
    ),
  ),
  scaffoldBackgroundColor: Colors.black,
  textSelectionHandleColor: Colors.white,
);

final ThemeData light = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  accentColor: accentColor,
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  buttonTheme: ThemeData.dark().buttonTheme.copyWith(
        colorScheme: const ColorScheme.light(),
        buttonColor: primaryColor,
      ),
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
    color: Colors.white,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'OpenSans',
      ),
  primaryTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'OpenSans',
      ),
  accentTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'OpenSans',
      ),
  tabBarTheme: const TabBarTheme(
    unselectedLabelColor: Colors.white,
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    indicator: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      color: Colors.white,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  textSelectionHandleColor: Colors.black,
);

abstract class Styles {
  static ThemeData themeData({bool darkMode, int color}) {
    if (darkMode) {
      return dark.copyWith(
          accentColor: Color(color), primaryColor: Color(color));
    }
    return light.copyWith(
        accentColor: Color(color), primaryColor: Color(color));
  }
}

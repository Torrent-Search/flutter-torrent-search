import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/utils/Preferences.dart';

Color primaryColor = Colors.deepPurpleAccent;
Color accentColor = Colors.deepPurpleAccent;

TextStyle defaultTextStyle(Brightness brightness){
  return TextStyle(
    color: brightness == Brightness.dark ? Colors.white : Colors.black,
    fontSize: 13
  );
}
TextStyle defaultTextStyleBold(Brightness brightness){
  return defaultTextStyle(brightness).copyWith(
    fontWeight: FontWeight.bold,
  );
}

final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    accentColor: accentColor,
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    buttonTheme: ThemeData.dark().buttonTheme.copyWith(
      colorScheme: ColorScheme.dark(),
      buttonColor: primaryColor,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: ThemeData.dark().primaryColor,
      brightness: Brightness.dark,
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
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.grey),
    ));

final ThemeData light = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    accentColor: accentColor,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    buttonTheme: ThemeData.dark().buttonTheme.copyWith(
      colorScheme: ColorScheme.light(),
      buttonColor: primaryColor,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: primaryColor,
      brightness: Brightness.light,
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
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
    ));


abstract class Themes {
  static Preferences prefernces = Preferences();
  static ThemeData themeData(bool isDarkTheme, BuildContext context,{int color = 0 })  {
    if(color == 0){
      color = Colors.deepPurpleAccent.value;
    }
    Color accent = Color(color);
    if (isDarkTheme) {
      return dark.copyWith(
        accentColor: accent,
        primaryColor: accent
      );
    }
    return light.copyWith(
        accentColor: accent,
        primaryColor: accent
    );
  }
}


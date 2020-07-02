/*
 *     Copyright (C) 2020 by Tejas Patil <tejasvp25@gmail.com>
 *
 *     torrentsearch is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     torrentsearch is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with torrentsearch.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/utils/Preferences.dart';

Color primaryColor = Colors.deepPurpleAccent;
Color accentColor = Colors.deepPurpleAccent;

TextStyle defaultTextStyle(Brightness brightness) {
  return TextStyle(
    color: brightness == Brightness.dark ? Colors.white : Colors.black,
    fontSize: 13,
    fontFamily: "OpenSans",
  );
}

TextStyle defaultTextStyleBold(Brightness brightness) {
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
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.white,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white),
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
          colorScheme: ColorScheme.light(),
          buttonColor: primaryColor,
        ),
    appBarTheme: AppBarTheme(
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
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
    ),
    scaffoldBackgroundColor: Colors.white,
    textSelectionHandleColor: Colors.black);

abstract class Themes {
  static Preferences prefernces = Preferences();
  static ThemeData themeData(bool isDarkTheme, BuildContext context,
      {int color = 0}) {
    if (color == 0) {
      color = Colors.deepPurpleAccent.value;
    }
    Color accent = Color(color);
    if (isDarkTheme) {
      return dark.copyWith(accentColor: accent, primaryColor: accent);
    }
    return light.copyWith(accentColor: accent, primaryColor: accent);
  }
}

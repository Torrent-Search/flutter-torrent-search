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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String THEME_STATUS = "THEMESTATUS";
  static const String ISTOKENSAVED = "ISTOKENSAVED";
  static const String ACCENT = "ACCENT";
  static const String INDEXERS = "INDEXERS";
  static const String SYSTEMACCENT = "SYSTEMACCENT";
  static const String TACACCPTED = "TACACCPTED";
  static const String FIRSTOPEN = "FIRSTOPEN";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }

  setIsTokenSaved(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(ISTOKENSAVED, value);
  }

  Future<bool> getIsTokenSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }

  Future<int> getAccent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(ACCENT) ?? Colors.deepPurpleAccent.value;
  }

  setAccent(int accent) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(ACCENT, accent);
  }

  Future<bool> getIndexers(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }

  setIndexers(String indexer, bool enable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(indexer, enable);
  }

  setSystemAccent(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SYSTEMACCENT, value);
  }

  Future<bool> UseSystemAccent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SYSTEMACCENT) ?? false;
  }

  setTacAccepted(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(TACACCPTED, value);
  }

  Future<bool> getTacAccepted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(TACACCPTED) ?? false;
  }

  setFirstOpen(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(FIRSTOPEN, value);
  }

  Future<bool> getFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FIRSTOPEN) ?? true;
  }
}

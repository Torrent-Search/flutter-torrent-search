import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String THEME_STATUS = "THEMESTATUS";
  static const String ISTOKENSAVED = "ISTOKENSAVED";
  static const String ACCENT = "ACCENT";
  static const String INDEXERS = "INDEXERS";
  static const String SYSTEMACCENT = "SYSTEMACCENT";
  static const String TACACCPTED = "TACACCPTED";

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
}

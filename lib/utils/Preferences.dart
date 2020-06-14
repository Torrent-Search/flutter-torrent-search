
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const THEME_STATUS = "THEMESTATUS";
  static const ISTOKENSAVED = "ISTOKENSAVED";
  static const ACCENT = "ACCENT";
  static const INDEXERS = "INDEXERS";
  static const SYSTEMACCENT = "SYSTEMACCENT";

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

  Future<bool> getIndexers(String key)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ??  true;
  }
  setIndexers(String indexer,bool enable)async{
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
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/utils/Preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  Preferences preferences = Preferences();

  bool _darkTheme = false;
  int _accent = Colors.deepPurpleAccent.value;
  bool _useSystemAccent = false;
  int _systemaccent = Colors.deepPurpleAccent.value;

  bool get darkTheme => _darkTheme;
  set darkTheme(bool value) {
    _darkTheme = value;
    preferences.setDarkTheme(value);
    notifyListeners();
  }

  int get accent => _accent;
  set accent(int value) {
    _accent = value;
    preferences.setAccent(value);
    notifyListeners();
  }

  bool get useSystemAccent => _useSystemAccent;
  set useSystemAccent(bool value) {
    _useSystemAccent = value;
    notifyListeners();
  }

  int get systemaccent => _systemaccent;
  set systemaccent(int value) {
    _systemaccent = value;
    notifyListeners();
  }
}

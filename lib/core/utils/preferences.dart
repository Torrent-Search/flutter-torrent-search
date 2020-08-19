import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torrentsearch/injector.dart';

// ignore_for_file: constant_identifier_names

class Preferences {
  // Key For Dark Mode Preference
  static const String DARK_MODE_KEY = "DARK_MODE";
  // Key For Accent Preference
  static const String ACCENT_KEY = "ACCENT";

  // Key For TAC Preference
  //  TAC : Terms and Conditions
  static const String TAC_KEY = "TAC";

  ///*  Returns [bool] depending on [DARK_MODE_KEY] Preference
  ///*  Returns [false] if [DARK_MODE_KEY] Preference is not Set
  static bool nightMode() {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.getBool(DARK_MODE_KEY) ?? false;
  }

  ///*  Sets [DARK_MODE_KEY] Preference
  static Future<void> setNightMode({@required bool nightMode}) async {
    final SharedPreferences pref = sl<SharedPreferences>();
    pref.setBool(DARK_MODE_KEY, nightMode);
  }

  ///*  Returns [int] depending on [ACCENT_KEY] Preference
  ///*  Returns [4286336511] if [ACCENT_KEY] Preference is not Set
  ///?  4286336511 is int Color code for DeepPurpleAccent
  static int accentCode() {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.getInt(ACCENT_KEY) ?? 4286336511;
  }

  ///*  Sets [ACCENT_KEY] Preference
  static Future<void> setAccentCode(int colorCode) {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.setInt(ACCENT_KEY, colorCode);
  }

  ///*  Returns [bool] depending on [TAC_KEY] Preference
  ///*  Returns [false] if [TAC_KEY] Preference is not Set
  static bool tacStatus() {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.getBool(TAC_KEY) ?? false;
  }

  ///*  Sets [TAC_KEY] Preference
  static Future<void> setTacStatus(bool tac) {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.setBool(TAC_KEY, tac);
  }
}

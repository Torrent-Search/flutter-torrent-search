import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torrentsearch/injector.dart';

class Preferences {
  static const String DARK_MODE_KEY = "DARK_MODE";
  static const String ACCENT_KEY = "ACCENT";

  //  TAC : Terms and Conditions
  static const String TAC_KEY = "TAC";

  static bool nightMode() {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.getBool(DARK_MODE_KEY) ?? false;
  }

  static Future<void> setNightMode({@required bool nightMode}) async {
    final SharedPreferences pref = sl<SharedPreferences>();
    pref.setBool(DARK_MODE_KEY, nightMode);
  }

  static int accentCode() {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.getInt(ACCENT_KEY) ?? 4286336511;
  }

  static Future<void> setAccentCode(int colorCode) {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.setInt(ACCENT_KEY, colorCode);
  }

  static bool tacStatus() {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.getBool(TAC_KEY) ?? false;
  }

  static Future<void> setTacStatus(bool tac) {
    final SharedPreferences pref = sl<SharedPreferences>();
    return pref.setBool(TAC_KEY, tac);
  }
}

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

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/utils/Preferences.dart';

class PreferenceProvider with ChangeNotifier {
  final Preferences preferences = Preferences();

  bool _darkTheme = false;
  int _accent = Colors.deepPurpleAccent.value;
  bool _useSystemAccent = false;
  int _systemaccent = Colors.deepPurpleAccent.value;
  bool _tacaccepted = false;
  RemoteConfig _remoteConfig = null;
  String _base_url = "https://torr-scraper.herokuapp.com/";

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

  bool get tacaccepted => _tacaccepted;
  set tacaccepted(bool value) {
    _tacaccepted = value;
    preferences.setTacAccepted(_tacaccepted);
    notifyListeners();
  }

  String get baseUrl => _base_url;

  RemoteConfig get remoteconfig => _remoteConfig;
  set remoteconfig(RemoteConfig config) {
    _remoteConfig = config;
    _base_url = _remoteConfig.getString("baseUrl");
  }
}

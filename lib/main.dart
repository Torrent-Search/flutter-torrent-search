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

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/pages/About.dart';
import 'package:torrentsearch/pages/AlbumInformation.dart';
import 'package:torrentsearch/pages/AllMusic.dart';
import 'package:torrentsearch/pages/AllRecents.dart';
import 'package:torrentsearch/pages/DownloadInfo.dart';
import 'package:torrentsearch/pages/FavouriteTorrents.dart';
import 'package:torrentsearch/pages/Home.dart';
import 'package:torrentsearch/pages/MusicInformation.dart';
import 'package:torrentsearch/pages/MusicResult.dart';
import 'package:torrentsearch/pages/PlaylistInformation.dart';
import 'package:torrentsearch/pages/RecentInformation.dart';
import 'package:torrentsearch/pages/SearchHistory.dart';
import 'package:torrentsearch/pages/Settings.dart';
import 'package:torrentsearch/pages/SplashScreen.dart';
import 'package:torrentsearch/pages/TermsandConditions.dart';
import 'package:torrentsearch/pages/TorrentResult.dart';
import 'package:torrentsearch/utils/DownloadService.dart';
import 'package:torrentsearch/utils/FadeRouteBuilder.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/utils/Preferences.dart';
import 'package:torrentsearch/utils/Themes.dart';
import 'package:url_launcher/url_launcher.dart';

import 'database/DatabaseHelper.dart';

void main() async {
  await FlutterDownloader.initialize(debug: false);
  runApp(MyApp());
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  return Future<void>.value();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PreferenceProvider preferenceProvider = PreferenceProvider();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Preferences _preferences = Preferences();
  RemoteConfig _remoteConfig;

  final DatabaseHelper dbhelper = DatabaseHelper();
  static const platform = const MethodChannel('flutter.native/helper');
  bool _permissionReady;
  int accent;
  ReceivePort _port = ReceivePort();

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          openTgChannel(message['data']['tg']);
        },
        onLaunch: (Map<String, dynamic> message) async {
          openTgChannel(message['data']['tg']);
        },
        onResume: (Map<String, dynamic> message) async {
          openTgChannel(message['data']['tg']);
        },
        onBackgroundMessage: myBackgroundMessageHandler);
    _saveDeviceToken();
    _initializeRemoteConfig();
    _bindBackgroundIsolate();
    _permissionReady = false;
    _init();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => preferenceProvider,
      child: Consumer<PreferenceProvider>(
        builder:
            (BuildContext context, PreferenceProvider value, Widget child) {
          return MaterialApp(
            home: SplashScreen(),
            onGenerateRoute: (RouteSettings settings) {
              dynamic args = settings.arguments;
              switch (settings.name) {
                case '/home':
                  return FadeRouteBuilder(page: Home());
                  break;
                case '/result':
                  return FadeRouteBuilder(page: TorrentResult(args));
                  break;
                case '/recentinfo':
                  return FadeRouteBuilder(page: RecentInformation(args));
                  break;
                case '/allrecents':
                  return FadeRouteBuilder(page: AllRecents(args));
                  break;
                case '/settings':
                  return FadeRouteBuilder(page: Settings());
                  break;
                case '/favourite':
                  return FadeRouteBuilder(page: FavouriteTorrents(type: args));
                  break;
                case '/history':
                  return FadeRouteBuilder(page: SearchHistory(type: args));
                  break;
                case '/tac':
                  return FadeRouteBuilder(page: TermsandConditions());
                  break;
                case '/about':
                  return FadeRouteBuilder(page: About());
                  break;
                case '/musicinfo':
                  if (args.runtimeType == String) {
                    return FadeRouteBuilder(
                        page: MusicInformation(
                      pid: args,
                    ));
                  }
                  return FadeRouteBuilder(
                      page: MusicInformation(
                    songdata: args,
                  ));
                  break;
                case '/albuminfo':
                  return FadeRouteBuilder(
                      page: AlbumInformation(
                    id: args,
                  ));
                  break;
                case '/playlistinfo':
                  return FadeRouteBuilder(
                      page: PlaylistInformation(
                    id: args,
                  ));
                  break;
                case '/allmusic':
                  return FadeRouteBuilder(
                      page: AllMusic(args['list'], args['type']));
                  break;
                case '/musicresult':
                  return FadeRouteBuilder(page: MusicResult(args));
                  break;
                case '/downloads':
                  return FadeRouteBuilder(page: DownloadInfo());
                  break;
              }
            },
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics)
            ],
            debugShowCheckedModeBanner: false,
            theme: Themes.themeData(preferenceProvider.darkTheme, context,
                color: preferenceProvider.useSystemAccent
                    ? preferenceProvider.systemaccent
                    : preferenceProvider.accent),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    dbhelper.close();
    _unbindBackgroundIsolate();
    DownloadService.dispose();
    super.dispose();
  }

  void _saveDeviceToken() async {
    final AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;

    String uid = info.androidId;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      if (!await _preferences.getIsTokenSaved()) {
        var tokens = _db
            .collection('users')
            .document(uid)
            .collection('tokens')
            .document(fcmToken);

        await tokens
            .setData({
              'uid': uid,
              'token': fcmToken,
              'createdAt': FieldValue.serverTimestamp(), // optional
              'platform': Platform.operatingSystem // optional
            })
            .then((value) => _preferences.setIsTokenSaved(true))
            .catchError((err) {
              _preferences.setIsTokenSaved(false);
            });
      }
    }
  }

  void _initializeRemoteConfig() async {
    _remoteConfig = await RemoteConfig.instance;
    try {
      _remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
      _remoteConfig.setDefaults(<String, dynamic>{
        'baseUrl': 'https://torr-scraper.herokuapp.com/',
      });
      _remoteConfig.fetch(expiration: Duration(hours: 12));
      _remoteConfig.activateFetched();
      preferenceProvider.remoteconfig = _remoteConfig;
    } on FetchThrottledException catch (_) {}
  }

  Future<bool> _checkPermission() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.storage.request();
      if (permission.isGranted == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void openTgChannel(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      DownloadService.updateData(id, status, progress);
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void getCurrentAppTheme() async {
    preferenceProvider.tacaccepted =
        await preferenceProvider.preferences.getTacAccepted();
    preferenceProvider.darkTheme =
        await preferenceProvider.preferences.getTheme();
    preferenceProvider.useSystemAccent =
        await preferenceProvider.preferences.UseSystemAccent();
    Color fromChannel = Color(await platform.invokeMethod("getSystemAccent"));
    Color compatilbleToFlutter = Color.fromRGBO(
        fromChannel.red, fromChannel.green, fromChannel.blue, 1.0);
    preferenceProvider.systemaccent = compatilbleToFlutter.value;
    preferenceProvider.accent =
        await preferenceProvider.preferences.getAccent();
  }

  Future<void> _init() async {
    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      DownloadService.localPath =
          await platform.invokeMethod("getDownloadDirectory");
    } else {
      _permissionReady = await _checkPermission();
    }
  }
}

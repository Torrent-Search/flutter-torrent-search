import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/pages/AllRecents.dart';
import 'package:torrentsearch/pages/Home.dart';
import 'package:torrentsearch/pages/RecentInformation.dart';
import 'package:torrentsearch/pages/Settings.dart';
import 'package:torrentsearch/pages/TorrentResult.dart';
import 'package:torrentsearch/utils/DarkThemeProvider.dart';
import 'package:torrentsearch/utils/Preferences.dart';
import 'package:torrentsearch/utils/Themes.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
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
  final DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Preferences _preferences = Preferences();
  static const platform = const MethodChannel('flutter.native/helper');

  int accent;
  @override
  void initState() {
    super.initState();
//    openTgChannel();
    getCurrentAppTheme();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: ${message['data']['click_action']}");
          openTgChannel(message['data']['tg']);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          openTgChannel(message['data']['tg']);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          openTgChannel(message['data']['tg']);
        },
        onBackgroundMessage: myBackgroundMessageHandler);
    _saveDeviceToken();
  }

  void openTgChannel(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.preferences.getTheme();
    themeChangeProvider.useSystemAccent =
        await themeChangeProvider.preferences.UseSystemAccent();
    Color fromChannel = Color(await platform.invokeMethod("getSystemAccent"));
    print(fromChannel.red.toString() +
        " " +
        fromChannel.green.toString() +
        " " +
        fromChannel.blue.toString());
    Color compatilbleToFlutter = Color.fromRGBO(
        fromChannel.red, fromChannel.green, fromChannel.blue, 1.0);
    themeChangeProvider.systemaccent = compatilbleToFlutter.value;
    themeChangeProvider.accent =
        await themeChangeProvider.preferences.getAccent();
    print(themeChangeProvider.useSystemAccent);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
//            initialRoute: '/',
            home: Home(),
            routes: {
//              '/': (context) => Home(),
              "/result": (context) => TorrentResult(),
              "/recentinfo": (context) => RecentInformation(),
              "/allrecents": (context) => AllRecents(),
              "/settings": (context) => Settings(),
            },
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics)
            ],
            debugShowCheckedModeBanner: false,
            theme: Themes.themeData(themeChangeProvider.darkTheme, context,
                color: themeChangeProvider.useSystemAccent
                    ? themeChangeProvider.systemaccent
                    : themeChangeProvider.accent),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
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
}

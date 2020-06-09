import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/pages/Home.dart';

import 'package:torrentsearch/pages/TorrentResult.dart';
import 'package:torrentsearch/utils/DarkThemeProvider.dart';
import 'package:torrentsearch/utils/Preferences.dart';
import 'package:torrentsearch/utils/Themes.dart';


void main() async {
  runApp(MyApp());

}
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(message);
  return Future<void>.value();
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Preferences _preferences = Preferences();
  int accent;
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
        onBackgroundMessage: myBackgroundMessageHandler
    );
    _saveDeviceToken();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.preferences.getTheme();
    themeChangeProvider.accent = await themeChangeProvider.preferences.getAccent();
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
             home : Home(),
            routes: {
//              '/': (context) => Home(),
              "/result": (context) => TorrentResult(),
            },
            navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
            debugShowCheckedModeBanner: false,
            theme: Themes.themeData(themeChangeProvider.darkTheme, context,color: themeChangeProvider.accent),
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
    AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
    String uid = info.androidId;


    // Get the token for this device to Send Push Notifications
    String fcmToken = await _fcm.getToken();
    // Save it to Firestore
    if (fcmToken != null  ) {
      if(!await _preferences.getIsTokenSaved()){
        var tokens = _db
            .collection('users')
            .document(uid)
            .collection('tokens')
            .document(fcmToken);

        await tokens.setData({
          'uid' : uid,
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        }).then((value) => _preferences.setIsTokenSaved(true)).catchError((err){
          _preferences.setIsTokenSaved(false);
        });
      }
    }
  }
}


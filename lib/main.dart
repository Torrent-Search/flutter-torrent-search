import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torrentsearch/core/bloc/styles_bloc.dart';
import 'package:torrentsearch/core/pages/splash_screen.dart';
import 'package:torrentsearch/core/routes/routes.gr.dart';
import 'package:torrentsearch/core/utils/method_channel_utils.dart';
import 'package:torrentsearch/core/utils/preferences.dart';
import 'package:torrentsearch/features/torrent/data/database/database_helper.dart';
import 'package:torrentsearch/features/torrent/data/datasources/torrent_api_source.dart';
import 'package:torrentsearch/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjector();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();
  static String appVersion;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final StylesBloc _stylesBloc = StylesBloc();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  bool nightMode = false;
  @override
  void initState() {
    super.initState();
    _initPrefs();
    _initRemoteConfig();
    _initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StylesBloc>(
      create: (context) => _stylesBloc,
      child: BlocBuilder<StylesBloc, StylesState>(
        bloc: _stylesBloc,
        builder: (BuildContext context, StylesState state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            home: const SplashScreen(),
            builder: ExtendedNavigator.builder(
              router: Router(),
              initialRoute: "/",
              builder: (_, extendedNav) {
                return Theme(
                  data: state.themeData,
                  child: extendedNav,
                );
              },
            ),
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics)
            ],
          );
        },
      ),
    );
  }

  Future<void> _initPrefs() async {
    _stylesBloc.add(
      StylesEvent(
          darkMode: Preferences.nightMode(),
          colorCode: Preferences.accentCode()),
    );
  }

  @override
  void dispose() {
    _stylesBloc.dispose();
    DatabaseHelper().close();
    super.dispose();
  }

  Future<void> _initRemoteConfig() async {
    MyApp.appVersion = await MethodChannelUtils.getVersion();
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults({
      'baseUrl': "https://torr-scraper.herokuapp.com/",
    });
    try {
      await remoteConfig.fetch(expiration: const Duration(hours: 6));
      await remoteConfig.activateFetched();
      sl<TorrentApiDataSource>().baseUrl = remoteConfig.getString("baseUrl");
    } on FetchThrottledException {}
  }

  void _initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: firebaseMessagingCallback,
      onLaunch: firebaseMessagingCallback,
      onResume: firebaseMessagingCallback,
      onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    return Future<void>.value();
  }

  static Future<dynamic> firebaseMessagingCallback(
      Map<String, dynamic> message) {
    MethodChannelUtils.openLink(message['data']['tg'] as String);
  }
}

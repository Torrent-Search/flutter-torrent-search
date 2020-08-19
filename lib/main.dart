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

  ///* Inject Dependancies
  await initInjector();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();

  ///*  [appVersion] holds the Current App Version
  static String appVersion;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final StylesBloc _stylesBloc = StylesBloc();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    /// Initializae Preferences
    _initPrefs();

    /// Configure Remote Config
    _initRemoteConfig();

    /// Configure Firebase Messaging
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

  /// Initialize Preferences and Queue StylesEvent According to Shared Preferences
  Future<void> _initPrefs() async {
    _stylesBloc.add(
      StylesEvent(
          darkMode: Preferences.nightMode(),
          colorCode: Preferences.accentCode()),
    );
  }

  @override
  void dispose() {
    /// Dispose Styles Bloc
    _stylesBloc.dispose();

    /// Dispose Styles Bloc
    DatabaseHelper().close();
    super.dispose();
  }

  /// Configure Firebase Remote Config Modeule
  Future<void> _initRemoteConfig() async {
    /// [App Version] sets current app version
    /// [MethodChannelUtils.getVersion()] return the Current App Version
    MyApp.appVersion = await MethodChannelUtils.getVersion();

    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    /// Set Remote Config Defaults
    remoteConfig.setDefaults({
      'baseUrl': "https://torr-scraper.herokuapp.com/",
    });
    try {
      /// Fetch and Activate Remote Configs
      await remoteConfig.fetch(expiration: const Duration(hours: 6));
      await remoteConfig.activateFetched();

      ///* Set base url in TorrentApiSource
      sl<TorrentApiDataSource>().setBaseUrl(remoteConfig.getString("baseUrl"));
      // ignore: empty_catches
    } on FetchThrottledException {}
  }

  /// Configure Firebase Messaging Modeule
  void _initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: firebaseMessagingCallback,
      onLaunch: firebaseMessagingCallback,
      onResume: firebaseMessagingCallback,
      onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  /// Background Callback handler for Firebase Messaging
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    return Future<void>.value();
  }

  /// Callback handler for Firebase Messaging
  static Future<dynamic> firebaseMessagingCallback(
      Map<String, dynamic> message) {
    /// Open Tg Channel on Notification
    MethodChannelUtils.openLink(message['data']['tg'] as String);
    return Future<void>.value();
  }
}

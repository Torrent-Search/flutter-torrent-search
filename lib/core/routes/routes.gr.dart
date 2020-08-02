// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/core/pages/about.dart';
import 'package:torrentsearch/core/pages/settings.dart';
import 'package:torrentsearch/core/pages/splash_screen.dart';
import 'package:torrentsearch/core/pages/terms_and_conditions.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/favourite.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/home.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/search_history.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/torrent_result.dart';

class Routes {
  static const String splashScreen = '/';
  static const String home = '/home';
  static const String torrentResult = '/result';
  static const String settings = '/settings';
  static const String favourite = '/favourite';
  static const String searchHistory = '/history';
  static const String termsandConditions = '/tac';
  static const String about = '/about';
  static const all = <String>{
    splashScreen,
    home,
    torrentResult,
    settings,
    favourite,
    searchHistory,
    termsandConditions,
    about,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashScreen, page: SplashScreen),
    RouteDef(Routes.home, page: Home),
    RouteDef(Routes.torrentResult, page: TorrentResult),
    RouteDef(Routes.settings, page: Settings),
    RouteDef(Routes.favourite, page: Favourite),
    RouteDef(Routes.searchHistory, page: SearchHistory),
    RouteDef(Routes.termsandConditions, page: TermsandConditions),
    RouteDef(Routes.about, page: About),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashScreen: (data) {
      return PageRouteBuilder<SplashScreen>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SplashScreen(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
    Home: (data) {
      return PageRouteBuilder<Home>(
        pageBuilder: (context, animation, secondaryAnimation) => const Home(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
    TorrentResult: (data) {
      final args = data.getArgs<TorrentResultArguments>(nullOk: false);
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TorrentResult(query: args.query),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
    Settings: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Settings(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
    Favourite: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Favourite(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
    SearchHistory: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchHistory(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
    TermsandConditions: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TermsandConditions(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
    About: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => About(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// TorrentResult arguments holder class
class TorrentResultArguments {
  final String query;
  TorrentResultArguments({@required this.query});
}

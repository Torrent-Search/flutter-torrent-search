import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:torrentsearch/core/pages/about.dart';
import 'package:torrentsearch/core/pages/settings.dart';
import 'package:torrentsearch/core/pages/splash_screen.dart';
import 'package:torrentsearch/core/pages/terms_and_conditions.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/favourite.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/home.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/search_history.dart';
import 'package:torrentsearch/features/torrent/presentation/pages/torrent_result.dart';

@CustomAutoRouter(
  preferRelativeImports: false,
  transitionsBuilder: TransitionsBuilders.fadeIn,
  durationInMilliseconds: 500,
  routes: <AutoRoute>[
    // initial route is named "/"
    AutoRoute<SplashScreen>(
      page: SplashScreen,
      initial: true,
    ),
    AutoRoute<Home>(
      page: Home,
      path: "/home",
    ),
    AutoRoute(
      page: TorrentResult,
      path: "/result",
    ),
//    AutoRoute(
//      page: RecentInfo,
//      path: "/recent",
//    ),
    AutoRoute(
      page: Settings,
      path: "/settings",
    ),
//    AutoRoute(
//      page: AllRecents,
//      path: "/allrecent",
//    ),
    AutoRoute(
      page: Favourite,
      path: "/favourite",
    ),
    AutoRoute(
      page: SearchHistory,
      path: "/history",
    ),
    AutoRoute(
      page: TermsandConditions,
      path: "/tac",
    ),
    AutoRoute(
      page: About,
      path: "/about",
    ),
  ],
)
class $Router {}

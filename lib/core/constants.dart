import 'package:flutter/services.dart';

class Constants {
  // ignore_for_file: constant_identifier_names

  static const String CHANNEL = "com.tejas.torrentsearch";

  static const String ENDPOINT_1337x = "api/1337x";
  static const String ENDPOINT_MG_1337x = "api/1337x_mg";
  static const String SKYTORRENT_ENDPOINT = "api/skytorrents";
  static const String HORRIBLESUBS_ENDPOINT = "api/horriblesubs";
  static const String NYAA_ENDPOINT = "api/nyaa";
  static const String KICKASS_ENDPOINT = "api/kickass";
  static const String KICKASS_MG_ENDPOINT = "api/kickass_mg";
  static const String LIMETORRENTS_ENDPOINT = "api/limetorrents";
  static const String LIMETORRENTS_ENDPOINT_MG = "api/limetorrents_mg";
  static const String TPB_ENDPOINT = "api/thepiratebay";
  static const String TORRENTDOWNLOADS_ENDPOINT = "api/torrentdownloads";
  static const String TGX_ENDPOINT = "api/tgx";
  static const String YTS_ENDPOINT = "api/yts";
  static const String EZTV_TORRENT = "api/eztv";
  static const String NOTIFICATION = "api/notification";
  static const String ZOOQLE = "api/zooqle";
  static const String JIOSAAVNRAW = "api/jiosaavnraw";
  static const String JIOSAAVSONG = "api/jiosaavnsong";
  static const String JIOSAAVALBUM = "api/jiosaavnalbum";
  static const String JIOSAAVPLAYLIST = "api/jiosaavnplaylist";
  static const String JIOSAAVHOME = "api/jiosaavnhome";
  static const String RECENTS = "api/recent";
  static const String RECENT_MOVIES = "api/tgxmov";
  static const String RECENT_SHOWS = "api/tgxseries";

  static const String IMDB = "api/imdb";

  static const List<String> INDEXERS = [
    "1337x",
    "Eztv",
    "Kickass",
    "Limetorrents",
    "Skytorrents",
    "Pirate Bay",
    "Torrent Downloads",
    "Torrent Galaxy",
    "Yts",
    "Zooqle",
    "Nyaa",
    "Horriblesubs"
  ];

  static const MethodChannel METHOD_CHANNEL = MethodChannel(CHANNEL);

  static const String METHOD_CLIPBOARD = "copyToClipboard";
  static const String METHOD_SYSTEM_ACCENT = "getSystemAccent";
  static const String METHOD_SHARE = "share";
  static const String METHOD_OPEN_LINK = "openLink";
  static const String METHOD_SDK_INT = "getSdkInt";
  static const String METHOD_APP_VERSION = "getVersion";
}

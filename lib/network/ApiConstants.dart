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

class ApiConstants {
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

  static const List INDEXERS = [
    "1337x",
    "Eztv",
    "Kickass",
    "Limetorrents",
    "Skytorrents",
    "Pirate Bay",
    "Torrent Downloads",
    "Torrent Galaxy",
    "Yts",
    "Nyaa",
    "Horriblesubs"
  ];
}

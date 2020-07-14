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

import 'dart:convert';

class RecentResponse {
  RecentResponse({
    this.movies,
    this.shows,
  });

  final List<RecentInfo> movies;
  final List<RecentInfo> shows;

  factory RecentResponse.fromRawJson(String str) =>
      RecentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecentResponse.fromJson(Map<String, dynamic> json) => RecentResponse(
        movies: List<RecentInfo>.from(
            json["movies"].map((x) => RecentInfo.fromJson(x))),
        shows: List<RecentInfo>.from(
            json["shows"].map((x) => RecentInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "movies": List<dynamic>.from(movies.map((x) => x.toJson())),
        "shows": List<dynamic>.from(shows.map((x) => x.toJson())),
      };
}

class RecentInfo {
  RecentInfo({
    this.name,
    this.torrentUrl,
    this.imgUrl,
    this.imdbcode,
  });

  String name;
  String torrentUrl;
  String imgUrl;
  String imdbcode;

  factory RecentInfo.fromJson(Map<String, dynamic> json) => RecentInfo(
        name: json["name"],
        torrentUrl: json["torrent_url"],
        imgUrl: json["img_url"],
        imdbcode: json["imdbcode"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "torrent_url": torrentUrl,
        "img_url": imgUrl,
        "imdbcode": imdbcode,
      };
}

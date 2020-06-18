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

RecentResponse RecentResponseFromJson(String str) =>
    RecentResponse.fromJson(json.decode(str));

String RecentResponseToJson(RecentResponse data) => json.encode(data.toJson());

class RecentResponse {
  RecentResponse({
    this.data,
  });

  List<RecentInfo> data;

  factory RecentResponse.fromJson(Map<String, dynamic> json) => RecentResponse(
        data: List<RecentInfo>.from(
            json["Data"].map((x) => RecentInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
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

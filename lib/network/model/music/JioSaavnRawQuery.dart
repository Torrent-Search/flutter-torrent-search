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

import 'package:torrentsearch/network/model/music/Albums.dart';
import 'package:torrentsearch/network/model/music/Songs.dart';

class JioSaavnRawQuery {
  JioSaavnRawQuery({
    this.albums,
    this.songs,
  });

  final Albums albums;
  final Songs songs;

  factory JioSaavnRawQuery.fromRawJson(String str) =>
      JioSaavnRawQuery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JioSaavnRawQuery.fromJson(Map<String, dynamic> json) =>
      JioSaavnRawQuery(
        albums: Albums.fromJson(json["albums"]),
        songs: Songs.fromJson(json["songs"]),
      );

  Map<String, dynamic> toJson() => {
        "albums": albums.toJson(),
        "songs": songs.toJson(),
      };
}

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

import 'package:torrentsearch/network/model/music/Songs.dart';

class Playlist {
  Playlist({
    this.id,
    this.name,
    this.image,
    this.songs,
  });

  final String name;
  final String image;
  final String id;
  final List<SongdataWithUrl> songs;

  factory Playlist.fromRawJson(String str) =>
      Playlist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["listid"],
        name: json["listname"],
        image: json["image"],
        songs: List<SongdataWithUrl>.from(
            json["songs"].map((x) => SongdataWithUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "listid": id,
        "listname": name,
        "image": image,
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
      };
}

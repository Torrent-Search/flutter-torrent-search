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

class Albums {
  Albums({
    this.data,
    this.position,
  });

  final List<AlbumsData> data;
  final int position;

  factory Albums.fromRawJson(String str) => Albums.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        data: List<AlbumsData>.from(
            json["data"].map((x) => AlbumsData.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "position": position,
      };
}

class AlbumsData {
  AlbumsData({
    this.id,
    this.title,
    this.image,
    this.music,
    this.url,
    this.type,
    this.description,
    this.ctr,
    this.position,
    this.moreInfo,
  });

  final String id;
  final String title;
  final String image;
  final String music;
  final String url;
  final String type;
  final String description;
  final int ctr;
  final int position;
  final AlbumMoreInfo moreInfo;

  factory AlbumsData.fromRawJson(String str) =>
      AlbumsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlbumsData.fromJson(Map<String, dynamic> json) => AlbumsData(
        id: json["id"],
        title: json["title"],
        image: json["image"].toString().replaceAll("50x50", "500x500"),
        music: json["music"],
        url: json["url"],
        type: json["type"],
        description: json["description"],
        ctr: json["ctr"],
        position: json["position"],
        moreInfo: json["more_info"] != null
            ? AlbumMoreInfo.fromJson(json["more_info"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "music": music,
        "url": url,
        "type": type,
        "description": description,
        "ctr": ctr,
        "position": position,
        "more_info": moreInfo.toJson(),
      };
}

class AlbumMoreInfo {
  AlbumMoreInfo({
    this.year,
    this.isMovie,
    this.language,
    this.songPids,
  });

  final String year;
  final String isMovie;
  final String language;
  final String songPids;

  factory AlbumMoreInfo.fromRawJson(String str) =>
      AlbumMoreInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlbumMoreInfo.fromJson(Map<String, dynamic> json) => AlbumMoreInfo(
        year: json["year"],
        isMovie: json["is_movie"],
        language: json["language"],
        songPids: json["song_pids"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "is_movie": isMovie,
        "language": language,
        "song_pids": songPids,
      };
}

class AlbumWithUrl {
  AlbumWithUrl({
    this.title,
    this.name,
    this.year,
    this.releaseDate,
    this.primaryArtists,
    this.primaryArtistsId,
    this.albumid,
    this.permaUrl,
    this.image,
    this.songs,
  });

  final String title;
  final String name;
  final String year;
  final String releaseDate;
  final String primaryArtists;
  final String primaryArtistsId;
  final String albumid;
  final String permaUrl;
  final String image;
  final List<SongdataWithUrl> songs;

  factory AlbumWithUrl.fromRawJson(String str) =>
      AlbumWithUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlbumWithUrl.fromJson(Map<String, dynamic> json) => AlbumWithUrl(
        title: json["title"],
        name: json["name"],
        year: json["year"],
        releaseDate: json["release_date"],
        primaryArtists: json["primary_artists"],
        primaryArtistsId: json["primary_artists_id"],
        albumid: json["albumid"],
        permaUrl: json["perma_url"],
        image: json["image"],
        songs: List<SongdataWithUrl>.from(
            json["songs"].map((x) => SongdataWithUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "name": name,
        "year": year,
        "release_date": releaseDate,
        "primary_artists": primaryArtists,
        "primary_artists_id": primaryArtistsId,
        "albumid": albumid,
        "perma_url": permaUrl,
        "image": image,
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
      };
}

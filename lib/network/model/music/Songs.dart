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

class Songs {
  Songs({
    this.data,
    this.position,
  });

  final List<SongData> data;
  final int position;

  factory Songs.fromRawJson(String str) => Songs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Songs.fromJson(Map<String, dynamic> json) => Songs(
        data:
            List<SongData>.from(json["data"].map((x) => SongData.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "position": position,
      };
}

class SongData {
  SongData({
    this.id,
    this.title,
    this.image,
    this.album,
    this.url,
    this.type,
    this.ctr,
    this.moreInfo,
  });

  final String id;
  final String title;
  final String image;
  final String album;
  final String url;
  final String type;
  final int ctr;
  final SongMoreInfo moreInfo;

  factory SongData.fromRawJson(String str) =>
      SongData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongData.fromJson(Map<String, dynamic> json) => SongData(
        id: json["id"],
        title: json["title"],
        image: json["image"].toString().replaceAll("50x50", "500x500"),
        album: json["album"],
        url: json["url"],
        type: json["type"],
        ctr: json["ctr"],
        moreInfo: SongMoreInfo.fromJson(json["more_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "album": album,
        "url": url,
        "type": type,
        "ctr": ctr,
        "more_info": moreInfo.toJson(),
      };
}

class SongMoreInfo {
  SongMoreInfo({
    this.primaryArtists,
    this.singers,
  });

  final String primaryArtists;
  final String singers;

  factory SongMoreInfo.fromRawJson(String str) =>
      SongMoreInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongMoreInfo.fromJson(Map<String, dynamic> json) => SongMoreInfo(
        primaryArtists: json["primary_artists"],
        singers: json["singers"],
      );

  Map<String, dynamic> toJson() => {
        "primary_artists": primaryArtists,
        "singers": singers,
      };
}

class SongdataWithUrl {
  SongdataWithUrl({
    this.id,
    this.song,
    this.image,
    this.album,
    this.albumid,
    this.encryptedMediaUrl,
    this.year,
    this.duration,
    this.singers,
  });

  final String id;
  final String song;
  final String image;
  final String album;
  final String albumid;
  final String encryptedMediaUrl;
  final String year;
  String duration;
  final String singers;

  factory SongdataWithUrl.fromRawJson(String str) =>
      SongdataWithUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongdataWithUrl.fromJson(Map<String, dynamic> json) =>
      SongdataWithUrl(
        id: json["id"],
        song: json["song"].toString().replaceAll("&quot;", ""),
        image: json["image"],
        album: json["album"],
        albumid: json["albumid"],
        encryptedMediaUrl: json["encrypted_media_url"],
        year: json["year"],
        duration: json["duration"],
        singers: json["singers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "song": song,
        "image": image,
        "album": album,
        "albumid": albumid,
        "encrypted_media_url": encryptedMediaUrl,
        "year": year,
        "duration": duration,
        "singers": singers,
      };

  factory SongdataWithUrl.fromMap(Map<String, dynamic> json) => SongdataWithUrl(
        id: json["id"],
        song: json["song"].toString().replaceAll("&quot;", ""),
        image: json["image"],
        album: json["album"],
        albumid: json["albumid"],
        encryptedMediaUrl: json["encrypted_media_url"],
        year: json["year"],
        duration: json["duration"],
        singers: json["singers"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "song": song,
        "image": image,
        "album": album,
        "albumid": albumid,
        "encrypted_media_url": encryptedMediaUrl,
        "year": year,
        "duration": duration,
        "singers": singers,
      };
}

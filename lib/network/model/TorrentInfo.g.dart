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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TorrentInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TorrentInfo _$TorrentInfoFromJson(Map<String, dynamic> json) {
  return TorrentInfo(
    json['name'] as String,
    json['torrent_url'] as String,
    json['seeders'] as String,
    json['leechers'] as String,
    json['upload_date'] as String,
    json['size'] as String,
    json['magnet'] as String,
    json['website'] as String,
  )
    ..uploader = json['uploader'] as String
    ..torrentFile = json['torrentFile'] as String;
}

Map<String, dynamic> _$TorrentInfoToJson(TorrentInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'torrent_url': instance.url,
      'seeders': instance.seeders,
      'leechers': instance.leechers,
      'upload_date': instance.upload_date,
      'size': instance.size,
      'uploader': instance.uploader,
      'magnet': instance.magnet,
      'website': instance.website,
      'torrentFile': instance.torrentFile,
    };

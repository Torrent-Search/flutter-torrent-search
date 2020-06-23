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

part of 'TorrentRepo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TorrentRepo _$TorrentRepoFromJson(Map<String, dynamic> json) {
  return TorrentRepo(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : TorrentInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TorrentRepoToJson(TorrentRepo instance) =>
    <String, dynamic>{
      'data': instance.torrentInfo,
    };

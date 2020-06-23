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

part of 'Magnet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Magnet _$MagnetFromJson(Map<String, dynamic> json) {
  return Magnet(
    json['magnet'] as String,
  )..torrentFile = json['torrentFile'] as String;
}

Map<String, dynamic> _$MagnetToJson(Magnet instance) => <String, dynamic>{
      'magnet': instance.magnet,
      'torrentFile': instance.torrentFile,
    };

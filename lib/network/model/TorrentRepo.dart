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

import 'package:json_annotation/json_annotation.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';

part 'TorrentRepo.g.dart';

@JsonSerializable()
class TorrentRepo {
  @JsonKey(name: "data")
  List<TorrentInfo> torrentInfo;

  TorrentRepo(this.torrentInfo);

  factory TorrentRepo.fromJSON(Map<String, dynamic> json) =>
      _$TorrentRepoFromJson(json);
  Map<String, dynamic> toJson() => _$TorrentRepoToJson(this);
}

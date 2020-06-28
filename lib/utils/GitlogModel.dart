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

// To parse this JSON data, do
//
//     final gitlog = gitlogFromJson(jsonString);

import 'dart:convert';

List<Gitlog> gitlogFromJson(String str) =>
    List<Gitlog>.from(json.decode(str).map((x) => Gitlog.fromJson(x)));

String gitlogToJson(List<Gitlog> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Gitlog {
  Gitlog({
    this.message,
  });

  final String message;

  factory Gitlog.fromJson(Map<String, dynamic> json) => Gitlog(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

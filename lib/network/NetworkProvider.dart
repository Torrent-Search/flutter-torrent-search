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

import 'package:http/http.dart' as http;
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/Imdb.dart';
import 'package:torrentsearch/network/model/Magnet.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/network/model/TorrentRepo.dart';
import 'package:torrentsearch/network/model/Update.dart';
import 'package:torrentsearch/network/model/music/JioSaavnHome.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';

Future<List<TorrentInfo>> getApiResponse(
    String BASE_URL, String endpoint, String query) async {
  http.Response response = await http.get('$BASE_URL$endpoint?search=$query');
  if (response.statusCode == 200) {
    return TorrentRepo.fromJSON(json.decode(response.body)).torrentInfo;
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
  return null;
}

Future<String> getMagnetResponse(
    String BASE_URL, String endpoint, String url) async {
  var response = await http.get("$BASE_URL$endpoint?url=$url");
  if (response.statusCode == 200) {
    return Magnet.fromJson(json.decode(response.body)).magnet;
  } else if (response.statusCode == 204) {
    throw Exception('No Content Found');
  } else {
    throw Exception('Error Connecting to Server');
  }
}

Future<List<RecentInfo>> getRecentMovies(String BASE_URL,
    {bool longList = false}) async {
  String url = '${BASE_URL}api/tgxmov';
  if (longList) {
    url += "?list=long";
  }
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return List<RecentInfo>.from(
        json.decode(response.body)["Data"].map((x) => RecentInfo.fromJson(x)));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<List<RecentInfo>> getRecentSeries(String BASE_URL,
    {bool longList = false}) async {
  String url = '${BASE_URL}api/tgxseries';
  if (longList) {
    url += "?list=long";
  }
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return List<RecentInfo>.from(
        json.decode(response.body)["Data"].map((x) => RecentInfo.fromJson(x)));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<Imdb> getImdb(String BASE_URL, String id) async {
  var response;
  response = await http.get('${BASE_URL}api/imdb?id=$id');
  if (response.statusCode == 200) {
    return Imdb.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<Update> getAppVersion(
  String BASE_URL,
) async {
  http.Response response = await http.get('${BASE_URL}api/appversion');
  if (response.statusCode == 200) {
    return Update.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<JioSaavnRawQuery> getJioSaavnRawResponse(
    String BASE_URL, String query) async {
  http.Response response =
      await http.get('${BASE_URL}${ApiConstants.JIOSAAVNRAW}?search=$query');
  if (response.statusCode == 200) {
    return JioSaavnRawQuery.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<SongdataWithUrl> getJioSongdataWithUrl(
    String BASE_URL, String query) async {
  http.Response response =
      await http.get('${BASE_URL}${ApiConstants.JIOSAAVSONG}?search=$query');
  if (response.statusCode == 200) {
    return SongdataWithUrl.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<AlbumWithUrl> getJioAlbumWithUrl(String BASE_URL, String query) async {
  http.Response response =
      await http.get('${BASE_URL}${ApiConstants.JIOSAAVALBUM}?search=$query');
  if (response.statusCode == 200) {
    return AlbumWithUrl.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<JioSaavnHome> getJioSaavnHome(String BASE_URL) async {
  http.Response response =
      await http.get('${BASE_URL}${ApiConstants.JIOSAAVHOME}');
  if (response.statusCode == 200) {
    return JioSaavnHome.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<Playlist> getPlaylist(String BASE_URL, String query) async {
  http.Response response = await http
      .get('${BASE_URL}${ApiConstants.JIOSAAVPLAYLIST}?search=$query');
  if (response.statusCode == 200) {
    return Playlist.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<RecentResponse> getRecents(String BASE_URL) async {
  http.Response response = await http.get(BASE_URL + ApiConstants.RECENTS);
  if (response.statusCode == 200) {
    return RecentResponse.fromJson(json.decode(response.body));
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

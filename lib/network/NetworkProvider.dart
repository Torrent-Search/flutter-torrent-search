import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/Imdb.dart';
import 'package:torrentsearch/network/model/Magnet.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:http/http.dart' as http;
import 'package:torrentsearch/network/model/TorrentRepo.dart';

const String BASE_URL = "https://torr-scraper.herokuapp.com/";

Future<List<TorrentInfo>> getApiResponse(String endpoint, String query) async {
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

Future<String> getMagnetResponse(String endpoint, String url) async {
  var response = await http.get("$BASE_URL$endpoint?url=$url");
  if (response.statusCode == 200) {
    return Magnet.fromJson(json.decode(response.body)).magnet;
  } else if (response.statusCode == 204) {
    throw Exception('No Content Found');
  } else {
    throw Exception('Error Connecting to Server');
  }
}

Future<List<RecentInfo>> getRecentMovies({bool longList = false}) async {
  String url = '${BASE_URL}api/tgxmov';
  if (longList) {
    url += "?list=long";
  }
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return RecentResponse.fromJson(json.decode(response.body)).data;
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<List<RecentInfo>> getRecentSeries({bool longList = false}) async {
  List<RecentInfo> list;
  String url = '${BASE_URL}api/tgxseries';
  if (longList) {
    url += "?list=long";
  }
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    list = RecentResponse.fromJson(json.decode(response.body)).data;
    return list;
  } else if (response.statusCode == 204) {
    throw NoContentFoundException();
  } else if (response.statusCode == 500) {
    throw InternalServerError();
  }
}

Future<Imdb> getImdb(String id) async {
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

Future<String> getAppVersion()async{
  http.Response response = await http.get('${BASE_URL}api/appversion');
  if (response.statusCode == 200) {
    return response.body.toString();
  }
  return "";
}


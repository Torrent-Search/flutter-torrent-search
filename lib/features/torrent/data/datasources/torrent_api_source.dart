import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:torrentsearch/core/errors/internal_server_error.dart';
import 'package:torrentsearch/core/errors/no_content_found.dart';
import 'package:torrentsearch/features/torrent/data/models/torrent_info_model.dart';

//  ignore_for_file:argument_type_not_assignable

abstract class TorrentApiDataSource {
  Future<List<TorrentInfoModel>> getTorrent(String endpoint, String query);
//  Future<Recent> getRecent();
//  Future<List<RecentData>> getSpecificRecent({bool movie, bool longlist});
  Future<String> getMagnet(String endpoint, String url);
//  Future<RecentDataWithImdbModel> getRecentData(String imdbCode);
  String baseUrl;
}

class TorrentApiDataSourceImpl implements TorrentApiDataSource {
  final http.Client client;
  @override
  String baseUrl;

  TorrentApiDataSourceImpl(this.client) {
    baseUrl = 'https://torr-scraper.herokuapp.com/';
  }

  @override
  Future<List<TorrentInfoModel>> getTorrent(String endpoint, String query,
      {int pageNo = 0}) async {
    final http.Response res = await client.get(
        '$baseUrl$endpoint?search=$query&page=${pageNo == 0 ? "" : pageNo}');
    if (res.statusCode == 204) {
      throw NoContentFoundException();
    } else if (res.statusCode == 500) {
      throw InternalServerError();
    }
    return List<TorrentInfoModel>.from((json.decode(res.body)["data"])
        .map((x) => TorrentInfoModel.fromJson(x)));
  }

//  @override
//  Future<List<RecentData>> getSpecificRecent(
//      {bool movie, bool longlist}) async {
//    final http.Response res = await client.get(
//        '$baseUrl${movie ? Constants.RECENT_MOVIES : Constants.RECENT_SHOWS}?list=${longlist ? "long" : ""}');
//
//    if (res.statusCode == 204) {
//      throw NoContentFoundException();
//    } else if (res.statusCode == 500) {
//      throw InternalServerError();
//    }
//    return List<RecentData>.from(
//        (json.decode(res.body)["Data"]).map((x) => RecentData.fromJson(x)));
//  }
//
//  @override
//  Future<Recent> getRecent() async {
//    final http.Response res = await client.get('$baseUrl${Constants.RECENTS}');
//    if (res.statusCode == 204) {
//      throw NoContentFoundException();
//    } else if (res.statusCode == 500) {
//      throw InternalServerError();
//    }
//    return RecentModel.fromJson(json.decode(res.body));
//  }

  @override
  Future<String> getMagnet(String endpoint, String url) async {
    final http.Response res = await client.get('$baseUrl$endpoint?url=$url');
    if (res.statusCode == 204) {
      throw NoContentFoundException();
    } else if (res.statusCode == 500) {
      throw InternalServerError();
    }
    return (json.decode(res.body))["magnet"].toString();
  }

//  @override
//  Future<RecentDataWithImdbModel> getRecentData(String imdbCode) async {
//    final http.Response resList =
//        await client.get('$baseUrl${Constants.TGX_ENDPOINT}?search=$imdbCode');
//    final http.Response resImdb =
//        await client.get('$baseUrl${Constants.IMDB}?id=$imdbCode');
//
//    if (resList.statusCode == 204 || resImdb.statusCode == 204) {
//      throw NoContentFoundException();
//    } else if (resList.statusCode == 500 || resImdb.statusCode == 500) {
//      throw InternalServerError();
//    }
//    final List<TorrentInfoModel> list = List<TorrentInfoModel>.from(
//        (json.decode(resList.body)["data"])
//            .map((x) => TorrentInfoModel.fromJson(x)));
//    final Imdb imdb = Imdb.fromJson(json.decode(resImdb.body));
//
//    return RecentDataWithImdbModel(list: list, imdbInfo: imdb);
//  }
}

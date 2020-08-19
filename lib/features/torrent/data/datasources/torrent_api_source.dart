import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:torrentsearch/core/errors/internal_server_error.dart';
import 'package:torrentsearch/core/errors/no_content_found.dart';
import 'package:torrentsearch/features/torrent/data/models/torrent_info_model.dart';

/// Base Class for TorrentApiDataSource
abstract class TorrentApiDataSource {
  Future<List<TorrentInfoModel>> getTorrent(String endpoint, String query,
      {int pageNo = 0});
//  Future<Recent> getRecent();
//  Future<List<RecentData>> getSpecificRecent({bool movie, bool longlist});
  Future<String> getMagnet(String endpoint, String url);
  void setBaseUrl(String baseUrl);
  String getBaseUrl();
//  Future<RecentDataWithImdbModel> getRecentData(String imdbCode);

}

class TorrentApiDataSourceImpl implements TorrentApiDataSource {
  final Dio _dioClient;

  TorrentApiDataSourceImpl(this._dioClient) {
    /// Sets Default [baseUrl] for [_dioClient]
    _dioClient.options.baseUrl = 'http://torr-scraper.herokuapp.com/';
  }

  /// Sets @param[baseUrl] as [_dioClient.options.baseUrl]
  // ignore: use_setters_to_change_properties
  @override
  void setBaseUrl(String baseUrl) {
    _dioClient.options.baseUrl = baseUrl;
  }

  /// Returns [_dioClient.options.baseUrl]
  @override
  String getBaseUrl() => _dioClient.options.baseUrl;

  /// Returns [Future<List<TorrentInfoModel>>]
  /// Throws [NoContentFoundException] if Response.statusCode is 204
  /// Throws [InternalServerError] if Response.statusCode is 500
  /// @param endpoint API ENDPOINT
  /// @param query Query(Search) string
  /// @param pageNo Requested Page No
  @override
  Future<List<TorrentInfoModel>> getTorrent(String endpoint, String query,
      {int pageNo = 0}) async {
    final Response<String> res = await _dioClient.get<String>(
      endpoint,
      queryParameters: {
        'search': query,
        'page': pageNo,
      },
    );
    if (res.statusCode == 204) {
      throw NoContentFoundException();
    } else if (res.statusCode == 500) {
      throw InternalServerError();
    }
    // if (endpoint == Constants.SKYTORRENT_ENDPOINT) {
    //   return List<TorrentInfoModel>.from((json
    //           .decode(json.encode(res.data.toString()))["data"]
    //           .toString() as List)
    //       .map((x) => TorrentInfoModel.fromJson(x as Map<String, dynamic>)));
    // }
    //  ignore:argument_type_not_assignable

    return List<TorrentInfoModel>.from((json.decode(res.data)["data"] as List)
        .map((x) => TorrentInfoModel.fromJson(x as Map<String, dynamic>)));
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

  /// Returns [Future<String>] [TORRENT MAGNET LINK]
  /// Throws [NoContentFoundException] if Response.statusCode is 204
  /// Throws [InternalServerError] if Response.statusCode is 500
  /// @param endpoint API ENDPOINT
  /// @param url Url String string
  @override
  Future<String> getMagnet(String endpoint, String url) async {
    final Response<String> res = await _dioClient.get(
      endpoint,
      queryParameters: {
        'url': url,
      },
    );
    if (res.statusCode == 204) {
      throw NoContentFoundException();
    } else if (res.statusCode == 500) {
      throw InternalServerError();
    }
    return jsonDecode(res.data)["magnet"].toString();
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

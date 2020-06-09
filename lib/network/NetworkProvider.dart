
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/Magnet.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:http/http.dart' as http;
import 'package:torrentsearch/network/model/TorrentRepo.dart';


  const String BASE_URL = "https://torr-scraper.herokuapp.com/";

  Future<List<TorrentInfo>> getApiResponse(String endpoint,String query) async {
    http.Response response = await http.get('$BASE_URL$endpoint?search=$query');
    if (response.statusCode == 200) {
      return TorrentRepo.fromJSON(json.decode(response.body)).torrentInfo;
    } else if(response.statusCode == 204){
      throw NoContentFoundException();
    }else if(response.statusCode == 500) {
      throw InternalServerError();
    }
    return null;
  }

  Future<String> getMagnetResponse(String endpoint,String url) async {
    var response = await http.get("$BASE_URL$endpoint?url=$url");
    if (response.statusCode == 200) {
      return  Magnet.fromJson(json.decode(response.body)).magnet;
    } else if(response.statusCode == 204){
      throw Exception('No Content Found');
    }else {
      throw Exception('Error Connecting to Server');
    }
  }

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:torrentsearch/network/model/Magnet.dart';

import 'TorrentRepo.dart';
part 'Recent.g.dart';

@JsonSerializable()
class Recent {

  @JsonKey(name:"name")
  String name;
  @JsonKey(name:"torrent_url")
  String url;
  @JsonKey(name: "img_url")
  String imgUrl;
  @JsonKey(name: "imdbcode")
  String imdbcode;

  factory Recent.fromJson(Map<String, dynamic> json) => _$RecentFromJson(json);
  Map<String, dynamic> toJson() => _$RecentToJson(this);


  Recent(this.name, this.url, this.imgUrl,this.imdbcode);

}


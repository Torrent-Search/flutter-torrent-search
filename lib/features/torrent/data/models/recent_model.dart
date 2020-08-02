//import 'dart:convert';
//
//import 'package:torrentsearch/features/torrent/domain/entities/recent.dart';
//
//class RecentModel extends Recent {
//  const RecentModel({List<RecentData> movies, List<RecentData> shows})
//      : super(movies: movies, shows: shows);
//
//  factory RecentModel.fromRawJson(String str) =>
//      RecentModel.fromJson(json.decode(str) as Map<String, dynamic>);
//
//  String toRawJson() => json.encode(toJson());
//
//  factory RecentModel.fromJson(Map<String, dynamic> json) => RecentModel(
//        movies: List<RecentData>.from((json["movies"] as List)
//            .map((x) => RecentData.fromJson(x as Map<String, dynamic>))),
//        shows: List<RecentData>.from((json["shows"] as List)
//            .map((x) => RecentData.fromJson(x as Map<String, dynamic>))),
//      );
//
//  Map<String, dynamic> toJson() => {
//        "movies": List<dynamic>.from(movies.map((x) => x.toJson())),
//        "shows": List<dynamic>.from(shows.map((x) => x.toJson())),
//      };
//}

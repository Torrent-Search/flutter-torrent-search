//import 'package:equatable/equatable.dart';
//import 'package:meta/meta.dart';
//
//class Recent extends Equatable {
//  const Recent({
//    @required this.movies,
//    @required this.shows,
//  });
//
//  final List<RecentData> movies;
//  final List<RecentData> shows;
//
//  @override
//  List<Object> get props => [movies, shows];
//}
//
//class RecentData extends Equatable {
//  const RecentData({
//    this.name,
//    this.torrentUrl,
//    this.imgUrl,
//    this.imdbcode,
//  });
//
//  final String name;
//  final String torrentUrl;
//  final String imgUrl;
//  final String imdbcode;
//
//  factory RecentData.fromJson(Map<String, dynamic> json) => RecentData(
//        name: json["name"] as String,
//        torrentUrl: json["torrent_url"] as String,
//        imgUrl: json["img_url"] as String,
//        imdbcode: json["imdbcode"] as String,
//      );
//
//  Map<String, dynamic> toJson() => {
//        "name": name,
//        "torrent_url": torrentUrl,
//        "img_url": imgUrl,
//        "imdbcode": imdbcode,
//      };
//
//  @override
//  List<Object> get props => [name, torrentUrl, imgUrl, imdbcode];
//}

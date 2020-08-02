import 'dart:convert';

import 'package:equatable/equatable.dart';

class Torrent extends Equatable {
  const Torrent({
    this.name,
    this.torrentUrl,
    this.seeders,
    this.leechers,
    this.uploadDate,
    this.size,
    this.uploader,
    this.magnet,
    this.website,
    this.torrentFileUrl,
  });

  final String name;
  final String torrentUrl;
  final String seeders;
  final String leechers;
  final String uploadDate;
  final String size;
  final String uploader;
  final String magnet;
  final String website;
  final String torrentFileUrl;

  factory Torrent.fromRawJson(String str) =>
      Torrent.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Torrent.fromJson(Map<String, dynamic> json) => Torrent(
        name: json["name"] as String,
        torrentUrl: json["torrent_url"] as String,
        seeders: json["seeders"] as String,
        leechers: json["leechers"] as String,
        uploadDate: json["upload_date"] as String,
        size: json["size"] as String,
        uploader: json["uploader"] as String,
        magnet: json["magnet"] as String,
        website: json["website"] as String,
        torrentFileUrl: json["torrent_file_url"] as String,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "torrent_url": torrentUrl,
        "seeders": seeders,
        "leechers": leechers,
        "upload_date": uploadDate,
        "size": size,
        "uploader": uploader,
        "magnet": magnet,
        "website": website,
        "torrent_file_url": torrentFileUrl,
      };

  @override
  List<Object> get props => [
        name,
        torrentUrl,
        seeders,
        leechers,
        uploadDate,
        size,
        uploader,
        magnet,
        torrentFileUrl
      ];

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'url': torrentUrl,
        'seeders': seeders,
        'leechers': leechers,
        'uploaddate': uploadDate,
        'size': size,
        'magnet': magnet,
        'website': website,
      };

  factory Torrent.fromMap(Map<String, dynamic> json) => Torrent(
        name: json["name"] as String,
        torrentUrl: json["torrent_url"] as String,
        seeders: json["seeders"] as String,
        leechers: json["leechers"] as String,
        uploadDate: json["upload_date"] as String,
        size: json["size"] as String,
        uploader: json["uploader"] as String,
        magnet: json["magnet"] as String,
        website: json["website"] as String,
        torrentFileUrl: json["torrent_file_url"] as String,
      );
}

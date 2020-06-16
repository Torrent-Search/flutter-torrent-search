import 'package:json_annotation/json_annotation.dart';

part 'TorrentInfo.g.dart';

@JsonSerializable()
class TorrentInfo {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "torrent_url")
  String url;
  @JsonKey(name: "seeders")
  String seeders;
  @JsonKey(name: "leechers")
  String leechers;
  @JsonKey(name: "upload_date")
  String upload_date;
  @JsonKey(name: "size")
  String size;
  @JsonKey(name: "uploader")
  String uploader;
  @JsonKey(name: "magnet")
  String magnet;
  @JsonKey(name: "website")
  String website;
  @JsonKey(name: "torrentFile")
  String torrentFile;

  factory TorrentInfo.fromJson(Map<String, dynamic> json) =>
      _$TorrentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TorrentInfoToJson(this);

  TorrentInfo(this.name, this.url, this.seeders, this.leechers,
      this.upload_date, this.size, this.uploader, this.magnet, this.website);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': this.name,
        'url': this.url,
        'seeders': this.seeders,
        'leechers': this.leechers,
        'uploaddate': this.upload_date,
        'size': this.size,
        'uploader': this.uploader,
        'magnet': this.magnet,
        'website': this.website,
        'torrenfileurl': this.torrentFile,
      };

  factory TorrentInfo.fromMap(Map<String, dynamic> json) {
    return TorrentInfo(
      json['name'] as String,
      json['url'] as String,
      json['seeders'] as String,
      json['leechers'] as String,
      json['uploaddate'] as String,
      json['size'] as String,
      json['uploader'] as String,
      json['magnet'] as String,
      json['website'] as String,
    )..torrentFile = json['torrenfileurl'] as String;
  }
}

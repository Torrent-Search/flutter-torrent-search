// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TorrentInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TorrentInfo _$TorrentInfoFromJson(Map<String, dynamic> json) {
  return TorrentInfo(
    json['name'] as String,
    json['torrent_url'] as String,
    json['seeders'] as String,
    json['leechers'] as String,
    json['upload_date'] as String,
    json['size'] as String,
    json['magnet'] as String,
    json['website'] as String,
  )
    ..uploader = json['uploader'] as String
    ..torrentFile = json['torrentFile'] as String;
}

Map<String, dynamic> _$TorrentInfoToJson(TorrentInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'torrent_url': instance.url,
      'seeders': instance.seeders,
      'leechers': instance.leechers,
      'upload_date': instance.upload_date,
      'size': instance.size,
      'uploader': instance.uploader,
      'magnet': instance.magnet,
      'website': instance.website,
      'torrentFile': instance.torrentFile,
    };

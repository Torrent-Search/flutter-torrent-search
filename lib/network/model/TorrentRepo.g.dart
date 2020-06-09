// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TorrentRepo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TorrentRepo _$TorrentRepoFromJson(Map<String, dynamic> json) {
  return TorrentRepo(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : TorrentInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TorrentRepoToJson(TorrentRepo instance) =>
    <String, dynamic>{
      'data': instance.torrentInfo,
    };

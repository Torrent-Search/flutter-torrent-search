// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Magnet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Magnet _$MagnetFromJson(Map<String, dynamic> json) {
  return Magnet(
    json['magnet'] as String,
  )..torrentFile = json['torrentFile'] as String;
}

Map<String, dynamic> _$MagnetToJson(Magnet instance) => <String, dynamic>{
      'magnet': instance.magnet,
      'torrentFile': instance.torrentFile,
    };

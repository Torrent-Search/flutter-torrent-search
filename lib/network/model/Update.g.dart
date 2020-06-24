// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Update _$UpdateFromJson(Map<String, dynamic> json) {
  return Update(
    version: json['version'] as String,
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$UpdateToJson(Update instance) => <String, dynamic>{
      'version': instance.version,
      'link': instance.link,
    };

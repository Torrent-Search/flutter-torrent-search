import 'package:json_annotation/json_annotation.dart';

part 'Magnet.g.dart';

@JsonSerializable()
class Magnet{

@JsonKey(name:"magnet")
String magnet;

@JsonKey(name: "torrentFile")
String torrentFile;

Magnet(this.magnet);

factory Magnet.fromJson(Map<String, dynamic> json) => _$MagnetFromJson(json);
Map<String, dynamic> toJson() => _$MagnetToJson(this);
}
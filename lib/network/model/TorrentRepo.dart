import 'package:json_annotation/json_annotation.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';

part 'TorrentRepo.g.dart';

@JsonSerializable()
class TorrentRepo{
  @JsonKey(name:"data")
  List<TorrentInfo> torrentInfo;

  TorrentRepo(this.torrentInfo);

  factory TorrentRepo.fromJSON(Map<String, dynamic> json) => _$TorrentRepoFromJson(json);
  Map<String, dynamic> toJson() => _$TorrentRepoToJson(this);
}
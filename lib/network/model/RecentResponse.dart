import 'dart:convert';

RecentResponse RecentResponseFromJson(String str) => RecentResponse.fromJson(json.decode(str));

String RecentResponseToJson(RecentResponse data) => json.encode(data.toJson());

class RecentResponse {
  RecentResponse({
    this.data,
  });

  List<RecentInfo> data;

  factory RecentResponse.fromJson(Map<String, dynamic> json) => RecentResponse(
    data: List<RecentInfo>.from(json["Data"].map((x) => RecentInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RecentInfo {
  RecentInfo({
    this.name,
    this.torrentUrl,
    this.imgUrl,
    this.imdbcode,
  });

  String name;
  String torrentUrl;
  String imgUrl;
  String imdbcode;

  factory RecentInfo.fromJson(Map<String, dynamic> json) => RecentInfo(
    name: json["name"],
    torrentUrl: json["torrent_url"],
    imgUrl: json["img_url"],
    imdbcode: json["imdbcode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "torrent_url": torrentUrl,
    "img_url": imgUrl,
    "imdbcode": imdbcode,
  };
}

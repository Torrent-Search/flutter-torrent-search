import 'dart:convert';

class JioSaavnHome {
  JioSaavnHome({
    this.charts,
    this.topPlaylists,
    this.trending,
  });

  final List<JioSaavnInfo> charts;
  final List<JioSaavnInfo> topPlaylists;
  final List<JioSaavnInfo> trending;

  factory JioSaavnHome.fromRawJson(String str) =>
      JioSaavnHome.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JioSaavnHome.fromJson(Map<String, dynamic> json) => JioSaavnHome(
        charts: List<JioSaavnInfo>.from(
            json["charts"].map((x) => JioSaavnInfo.fromJson(x))),
        topPlaylists: List<JioSaavnInfo>.from(
            json["top_playlists"].map((x) => JioSaavnInfo.fromJson(x))),
        trending: List<JioSaavnInfo>.from(
            json["trending"].map((x) => JioSaavnInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "charts": List<dynamic>.from(charts.map((x) => x.toJson())),
        "top_playlists":
            List<dynamic>.from(topPlaylists.map((x) => x.toJson())),
        "trending": List<dynamic>.from(trending.map((x) => x.toJson())),
      };
}

class JioSaavnInfo {
  JioSaavnInfo({
    this.image,
    this.title,
    this.id,
    this.type,
  });

  final String image;
  final String title;
  final String id;
  final String type;

  factory JioSaavnInfo.fromRawJson(String str) =>
      JioSaavnInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JioSaavnInfo.fromJson(Map<String, dynamic> json) => JioSaavnInfo(
        image: json["image"],
        title: json["title"],
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "id": id,
        "type": type,
      };
}

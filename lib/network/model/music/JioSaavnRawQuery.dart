import 'dart:convert';

class JioSaavnRawQuery {
  JioSaavnRawQuery({
    this.albums,
    this.songs,
  });

  final Albums albums;
  final Songs songs;

  factory JioSaavnRawQuery.fromRawJson(String str) =>
      JioSaavnRawQuery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JioSaavnRawQuery.fromJson(Map<String, dynamic> json) =>
      JioSaavnRawQuery(
        albums: Albums.fromJson(json["albums"]),
        songs: Songs.fromJson(json["songs"]),
      );

  Map<String, dynamic> toJson() => {
        "albums": albums.toJson(),
        "songs": songs.toJson(),
      };
}

class Albums {
  Albums({
    this.data,
    this.position,
  });

  final List<AlbumsData> data;
  final int position;

  factory Albums.fromRawJson(String str) => Albums.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        data: List<AlbumsData>.from(
            json["data"].map((x) => AlbumsData.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "position": position,
      };
}

class AlbumsData {
  AlbumsData({
    this.id,
    this.title,
    this.image,
    this.music,
    this.url,
    this.type,
    this.description,
    this.ctr,
    this.position,
    this.moreInfo,
  });

  final String id;
  final String title;
  final String image;
  final String music;
  final String url;
  final String type;
  final String description;
  final int ctr;
  final int position;
  final AlbumMoreInfo moreInfo;

  factory AlbumsData.fromRawJson(String str) =>
      AlbumsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlbumsData.fromJson(Map<String, dynamic> json) => AlbumsData(
        id: json["id"],
        title: json["title"],
        image: json["image"].toString().replaceAll("50x50", "500x500"),
        music: json["music"],
        url: json["url"],
        type: json["type"],
        description: json["description"],
        ctr: json["ctr"],
        position: json["position"],
        moreInfo: json["more_info"] != null
            ? AlbumMoreInfo.fromJson(json["more_info"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "music": music,
        "url": url,
        "type": type,
        "description": description,
        "ctr": ctr,
        "position": position,
        "more_info": moreInfo.toJson(),
      };
}

class AlbumMoreInfo {
  AlbumMoreInfo({
    this.year,
    this.isMovie,
    this.language,
    this.songPids,
  });

  final String year;
  final String isMovie;
  final String language;
  final String songPids;

  factory AlbumMoreInfo.fromRawJson(String str) =>
      AlbumMoreInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlbumMoreInfo.fromJson(Map<String, dynamic> json) => AlbumMoreInfo(
        year: json["year"],
        isMovie: json["is_movie"],
        language: json["language"],
        songPids: json["song_pids"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "is_movie": isMovie,
        "language": language,
        "song_pids": songPids,
      };
}

class Songs {
  Songs({
    this.data,
    this.position,
  });

  final List<SongData> data;
  final int position;

  factory Songs.fromRawJson(String str) => Songs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Songs.fromJson(Map<String, dynamic> json) => Songs(
        data:
            List<SongData>.from(json["data"].map((x) => SongData.fromJson(x))),
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "position": position,
      };
}

class SongData {
  SongData({
    this.id,
    this.title,
    this.image,
    this.album,
    this.url,
    this.type,
    this.ctr,
    this.moreInfo,
  });

  final String id;
  final String title;
  final String image;
  final String album;
  final String url;
  final String type;
  final int ctr;
  final SongMoreInfo moreInfo;

  factory SongData.fromRawJson(String str) =>
      SongData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongData.fromJson(Map<String, dynamic> json) => SongData(
        id: json["id"],
        title: json["title"],
        image: json["image"].toString().replaceAll("50x50", "500x500"),
        album: json["album"],
        url: json["url"],
        type: json["type"],
        ctr: json["ctr"],
        moreInfo: SongMoreInfo.fromJson(json["more_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "album": album,
        "url": url,
        "type": type,
        "ctr": ctr,
        "more_info": moreInfo.toJson(),
      };
}

class SongMoreInfo {
  SongMoreInfo({
    this.primaryArtists,
    this.singers,
  });

  final String primaryArtists;
  final String singers;

  factory SongMoreInfo.fromRawJson(String str) =>
      SongMoreInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongMoreInfo.fromJson(Map<String, dynamic> json) => SongMoreInfo(
        primaryArtists: json["primary_artists"],
        singers: json["singers"],
      );

  Map<String, dynamic> toJson() => {
        "primary_artists": primaryArtists,
        "singers": singers,
      };
}

class SongdataWithUrl {
  SongdataWithUrl({
    this.id,
    this.song,
    this.image,
    this.album,
    this.albumid,
    this.encryptedMediaUrl,
    this.year,
    this.duration,
    this.singers,
  });

  final String id;
  final String song;
  final String image;
  final String album;
  final String albumid;
  final String encryptedMediaUrl;
  final String year;
  String duration;
  final String singers;

  factory SongdataWithUrl.fromRawJson(String str) =>
      SongdataWithUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongdataWithUrl.fromJson(Map<String, dynamic> json) =>
      SongdataWithUrl(
        id: json["id"],
        song: json["song"].toString().replaceAll("&quot;", ""),
        image: json["image"],
        album: json["album"],
        albumid: json["albumid"],
        encryptedMediaUrl: json["encrypted_media_url"],
        year: json["year"],
        duration: json["duration"],
        singers: json["singers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "song": song,
        "image": image,
        "album": album,
        "albumid": albumid,
        "encrypted_media_url": encryptedMediaUrl,
        "year": year,
        "duration": duration,
        "singers": singers,
      };

  factory SongdataWithUrl.fromMap(Map<String, dynamic> json) => SongdataWithUrl(
        id: json["id"],
        song: json["song"].toString().replaceAll("&quot;", ""),
        image: json["image"],
        album: json["album"],
        albumid: json["albumid"],
        encryptedMediaUrl: json["encrypted_media_url"],
        year: json["year"],
        duration: json["duration"],
        singers: json["singers"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "song": song,
        "image": image,
        "album": album,
        "albumid": albumid,
        "encrypted_media_url": encryptedMediaUrl,
        "year": year,
        "duration": duration,
        "singers": singers,
      };
}

class AlbumWithUrl {
  AlbumWithUrl({
    this.title,
    this.name,
    this.year,
    this.releaseDate,
    this.primaryArtists,
    this.primaryArtistsId,
    this.albumid,
    this.permaUrl,
    this.image,
    this.songs,
  });

  final String title;
  final String name;
  final String year;
  final String releaseDate;
  final String primaryArtists;
  final String primaryArtistsId;
  final String albumid;
  final String permaUrl;
  final String image;
  final List<SongdataWithUrl> songs;

  factory AlbumWithUrl.fromRawJson(String str) =>
      AlbumWithUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlbumWithUrl.fromJson(Map<String, dynamic> json) => AlbumWithUrl(
        title: json["title"],
        name: json["name"],
        year: json["year"],
        releaseDate: json["release_date"],
        primaryArtists: json["primary_artists"],
        primaryArtistsId: json["primary_artists_id"],
        albumid: json["albumid"],
        permaUrl: json["perma_url"],
        image: json["image"],
        songs: List<SongdataWithUrl>.from(
            json["songs"].map((x) => SongdataWithUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "name": name,
        "year": year,
        "release_date": releaseDate,
        "primary_artists": primaryArtists,
        "primary_artists_id": primaryArtistsId,
        "albumid": albumid,
        "perma_url": permaUrl,
        "image": image,
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
      };
}

class Playlist {
  Playlist({
    this.id,
    this.name,
    this.image,
    this.songs,
  });

  final String name;
  final String image;
  final String id;
  final List<SongdataWithUrl> songs;

  factory Playlist.fromRawJson(String str) =>
      Playlist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["listid"],
        name: json["listname"],
        image: json["image"],
        songs: List<SongdataWithUrl>.from(
            json["songs"].map((x) => SongdataWithUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "listid": id,
        "listname": name,
        "image": image,
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
      };
}

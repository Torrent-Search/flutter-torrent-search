import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';

class TorrentInfoModel extends Torrent {
  /// @param [name] Name of the Torrent File/Folder
  /// @param [url] Direct Url of the Torrent File/Folder info page
  /// @param [seeders] Seeders of the Torrent File/Folder
  /// @param [leechers] Leechers of the Torrent File/Folder
  /// @param [uploadDate] Uploade Data of the Torrent File/Folder
  /// @param [size] Size of the Torrent File/Folder
  /// @param [uploader] Uploader of the Torrent File/Folder
  /// @param [magner] Magner Link of the Torrent File/Folder
  /// @param [website] Name of Website from Where the Torrent Info is Scraped
  const TorrentInfoModel(
      {String name,
      String torrentUrl,
      String seeders,
      String leechers,
      String uploadDate,
      String size,
      String uploader,
      String magnet,
      String website,
      String torrentFileUrl})
      : super(
            name: name,
            torrentUrl: torrentUrl,
            seeders: seeders,
            leechers: leechers,
            uploadDate: uploadDate,
            size: size,
            uploader: uploader,
            magnet: magnet,
            website: website,
            torrentFileUrl: torrentFileUrl);

  /// Returns [TorrentInfoModel] from Json
  factory TorrentInfoModel.fromJson(Map<String, dynamic> json) =>
      TorrentInfoModel(
        name: json["name"] as String,
        torrentUrl: json["torrent_url"] as String,
        seeders: json["seeders"] as String,
        leechers: json["leechers"] as String,
        uploadDate: json["upload_date"] as String,
        size: json["size"] as String,
        uploader: json["uploader"] as String,
        magnet: json["magnet"] as String,
        website: json["website"] as String,
        torrentFileUrl: json["torrent_file_url"] as String,
      );
}

import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';

/// [Base Class] for [TorrentRepository]
abstract class TorrentRepository {
  Future<List<Torrent>> getTorrent(String endpoint, String query, int pageNo);
//  Future<Recent> getRecents();
//  Future<List<RecentData>> getSpecificRecent({bool movie, bool longlist});
  Future<String> getMagnet(String endpoint, String query);
//  Future<RecentDataWithImdb> getRecentData(String imdbCode);
  // Future<Torrent> getMagnet(String endpoint, String query);
}

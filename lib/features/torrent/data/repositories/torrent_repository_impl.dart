import 'package:torrentsearch/features/torrent/data/datasources/torrent_api_source.dart';
import 'package:torrentsearch/features/torrent/data/models/torrent_info_model.dart';
import 'package:torrentsearch/features/torrent/domain/repositories/torrent_repository.dart';

class TorrentRepositoryImpl implements TorrentRepository {
  final TorrentApiDataSource _dataSource;

  const TorrentRepositoryImpl(this._dataSource);

  @override
  Future<List<TorrentInfoModel>> getTorrent(
      String endpoint, String query, int pageNo) async {
    return _dataSource.getTorrent(endpoint, query);
  }

//  @override
//  Future<Recent> getRecents() async {
//    return _dataSource.getRecent();
//  }

  @override
  Future<String> getMagnet(String endpoint, String query) {
    return _dataSource.getMagnet(endpoint, query);
  }

//  @override
//  Future<RecentDataWithImdb> getRecentData(String imdbCode) {
//    return _dataSource.getRecentData(imdbCode);
//  }
//
//  @override
//  Future<List<RecentData>> getSpecificRecent({bool movie, bool longlist}) {
//    return _dataSource.getSpecificRecent(movie: movie, longlist: longlist);
//  }
}

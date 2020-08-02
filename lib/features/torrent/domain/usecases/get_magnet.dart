import 'package:torrentsearch/features/torrent/domain/repositories/torrent_repository.dart';

class GetMagnet {
  final TorrentRepository repository;

  const GetMagnet(this.repository);

  Future<String> call(String endpoint, String url) {
    return repository.getMagnet(endpoint, url);
  }
}

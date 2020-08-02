import 'package:equatable/equatable.dart';
import 'package:torrentsearch/core/usecase/usecase.dart';
import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';
import 'package:torrentsearch/features/torrent/domain/repositories/torrent_repository.dart';

class GetTorrent implements TorrentUsecases<List<Torrent>, Param> {
  final TorrentRepository repository;

  const GetTorrent(this.repository);

  @override
  Future<List<Torrent>> call(Param params) async {
    return repository.getTorrent(params.endpoint, params.query, params.pageNo);
  }
}

class Param extends Equatable {
  final String endpoint;
  final String query;
  final int pageNo;

  const Param(this.endpoint, this.query, {this.pageNo = 0});

  @override
  List<Object> get props => [endpoint, query, pageNo];
}

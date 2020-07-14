part of 'torrent_bloc.dart';

abstract class TorrentEvent extends Equatable {
  const TorrentEvent();
}

class TorrentSearch extends TorrentEvent {
  final String base_url, endpoint, query;

  TorrentSearch(this.base_url, this.endpoint, this.query);

  @override
  List<Object> get props => [base_url, query, query];
}

class TorrentRecent extends TorrentEvent {
  final String base_url;
  final bool movie;
  final bool long_list;

  TorrentRecent(this.base_url, this.movie, this.long_list);

  @override
  List<Object> get props => [base_url, movie, long_list];
}

class TorrentHomeRecent extends TorrentEvent {
  final String base_url;

  TorrentHomeRecent(this.base_url);

  @override
  List<Object> get props => [base_url];
}

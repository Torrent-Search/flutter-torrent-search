part of 'torrent_bloc.dart';

abstract class TorrentEvent extends Equatable {
  const TorrentEvent();
}

class GetSpecificRecentEvent extends TorrentEvent {
  final bool movie, longList;
  const GetSpecificRecentEvent({this.movie = true, this.longList = true});
  @override
  List<Object> get props => [movie, longList];
}

class GetRecentEvent extends TorrentEvent {
  const GetRecentEvent();
  @override
  List<Object> get props => [];
}

class GetTorrentEvent extends TorrentEvent {
  final String endpoint, query;
  const GetTorrentEvent(this.endpoint, this.query);
  @override
  List<Object> get props => [endpoint, query];
}

class GetNextPageEvent extends TorrentEvent {
  final String endpoint, query;
  final int pageNo;
  const GetNextPageEvent(this.endpoint, this.query, {this.pageNo = 0});
  @override
  List<Object> get props => [endpoint, query, pageNo];
}

class GetRecentDataEvent extends TorrentEvent {
  final String imdbCode;
  const GetRecentDataEvent(this.imdbCode);
  @override
  List<Object> get props => [imdbCode];
}

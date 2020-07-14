part of 'torrent_bloc.dart';

abstract class TorrentState extends Equatable {
  const TorrentState();
}

class TorrentInitial extends TorrentState {
  @override
  List<Object> get props => [];
}

class TorrentLoaded extends TorrentState {
  final List<TorrentInfo> list;

  TorrentLoaded(this.list);

  @override
  List<Object> get props => [list];
}

class TorrentError extends TorrentState {
  final Exception exception;

  TorrentError(this.exception);

  @override
  List<Object> get props => [exception];
}

class TorrentRecentLoaded extends TorrentState {
  final List<RecentInfo> list;

  TorrentRecentLoaded(this.list);

  @override
  List<Object> get props => [list];
}

class TorrentHomeRecentLoaded extends TorrentState {
  final RecentResponse data;

  TorrentHomeRecentLoaded(this.data);

  @override
  List<Object> get props => [data];
}

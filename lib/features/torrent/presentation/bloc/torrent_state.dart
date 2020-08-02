part of 'torrent_bloc.dart';

abstract class TorrentState extends Equatable {
  const TorrentState();
}

class TorrentInitial extends TorrentState {
  const TorrentInitial();
  @override
  bool get stringify => true;
  @override
  List<Object> get props => [];
}

//class TorrentRecentLoadedState extends TorrentState {
//  final Recent recent;
//  @override
//  const TorrentRecentLoadedState(this.recent);
//
//  @override
//  List<Object> get props => [recent];
//}

class TorrentLoaded extends TorrentState {
  final List<Torrent> torrents;
  final bool reachedMax, loading;

  const TorrentLoaded(this.torrents,
      {this.reachedMax = false, this.loading = false});

  TorrentLoaded copyWith(
      {List<Torrent> torrents, bool reachedMax, bool loading}) {
    return TorrentLoaded(torrents ?? this.torrents,
        reachedMax: reachedMax ?? this.reachedMax,
        loading: loading ?? this.loading);
  }

  @override
  List<Object> get props => [torrents, reachedMax];
}

class TorrentErrorState extends TorrentState {
  final Exception exception;

  const TorrentErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}

//class TorrentRecentDataLoaded extends TorrentState {
//  final RecentDataWithImdb recentData;
//
//  const TorrentRecentDataLoaded(this.recentData);
//
//  @override
//  List<Object> get props => [recentData];
//}
//
//class TorrentSpecificRecentDataLoaded extends TorrentState {
//  final List<RecentData> recentData;
//
//  const TorrentSpecificRecentDataLoaded(this.recentData);
//
//  @override
//  List<Object> get props => [recentData];
//}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';
import 'package:torrentsearch/features/torrent/domain/usecases/get_magnet.dart';
import 'package:torrentsearch/features/torrent/domain/usecases/get_torrent.dart';

part 'torrent_event.dart';
part 'torrent_state.dart';

class TorrentBloc extends Bloc<TorrentEvent, TorrentState> {
//  final GetRecent getRecent;
  final GetTorrent getTorrent;
  final GetMagnet getMagnet;
//  final GetRecentData getRecentData;
//  final GetSpecificRecent getSpecificRecent;
//  TorrentBloc(
//      {@required this.getRecent,
//      @required this.getTorrent,
//      @required this.getMagnet,
//      @required this.getRecentData,
//      @required this.getSpecificRecent})
//      : super(const TorrentInitial());

  TorrentBloc({
    @required this.getTorrent,
    @required this.getMagnet,
  }) : super(const TorrentInitial());

  @override
  Stream<TorrentState> mapEventToState(
    TorrentEvent event,
  ) async* {
    final currentState = state;
//    if (event is GetRecentEvent) {
//      try {
//        final Recent recent = await getRecent.call();
//        yield TorrentRecentLoadedState(recent);
//      } on Exception catch (e) {
//        yield TorrentErrorState(e);
//      }
//    }
    if (event is GetTorrentEvent) {
      try {
        final List<Torrent> torrents = await getTorrent
            .call(Param(event.endpoint, event.query, pageNo: event.pageNo));
        yield TorrentLoaded(torrents);
      } on Exception catch (e) {
        yield TorrentErrorState(e);
      }
    }

    if (event is GetNextPageEvent) {
      yield (currentState as TorrentLoaded).copyWith(loading: true);
      try {
        final List<Torrent> torrents = await getTorrent
            .call(Param(event.endpoint, event.query, pageNo: event.pageNo));
        yield TorrentLoaded(
            (currentState as TorrentLoaded).torrents + torrents);
      } on Exception {
        yield (currentState as TorrentLoaded).copyWith(reachedMax: true);
      }
    }

//    if (event is GetRecentDataEvent) {
//      try {
//        final RecentDataWithImdb torrents =
//            await getRecentData.call(event.imdbCode);
//        yield TorrentRecentDataLoaded(torrents);
//      } on Exception catch (e) {
//        yield TorrentErrorState(e);
//      }
//    }
//
//    if (event is GetSpecificRecentEvent) {
//      try {
//        final List<RecentData> torrents =
//            await getSpecificRecent.call(event.movie, event.longList);
//        yield TorrentSpecificRecentDataLoaded(torrents);
//      } on Exception catch (e) {
//        yield TorrentErrorState(e);
//      }
//    }
  }

  void dispose() => close();
}

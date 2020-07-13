import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:torrentsearch/network/Network.dart';

part 'torrent_event.dart';

part 'torrent_state.dart';

class TorrentBloc extends Bloc<TorrentEvent, TorrentState> {
  TorrentBloc() : super(TorrentInitial());

  @override
  Stream<TorrentState> mapEventToState(
    TorrentEvent event,
  ) async* {
    if (event is TorrentSearch) {
      yield TorrentInitial();
      try {
        List<TorrentInfo> list =
            await getApiResponse(event.base_url, event.endpoint, event.query);
        yield TorrentLoaded(list);
      } on Exception catch (e) {
        yield TorrentError(e);
      }
    }

    if (event is TorrentRecent) {
      yield TorrentInitial();
      try {
        List<RecentInfo> list = event.movie
            ? await getRecentMovies(event.base_url, longList: event.long_list)
            : await getRecentSeries(event.base_url, longList: event.long_list);
        yield TorrentRecentLoaded(list);
      } on Exception catch (e) {
        yield TorrentError(e);
      }
    }
  }

  void dispose() {
    this.close();
  }
}

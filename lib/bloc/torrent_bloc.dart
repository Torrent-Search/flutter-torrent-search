/*
 *     Copyright (C) 2020 by Tejas Patil <tejasvp25@gmail.com>
 *
 *     torrentsearch is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     torrentsearch is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with torrentsearch.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:torrentsearch/network/Network.dart';

part 'torrent_event.dart';

part 'torrent_state.dart';

class TorrentBloc extends Bloc<TorrentEvent, TorrentState> {
  int page = 0;
  TorrentBloc() : super(TorrentInitial());

  @override
  Stream<TorrentState> mapEventToState(
    TorrentEvent event,
  ) async* {
    if (event is TorrenteNextPage) {
      page++;
      try {
        List<TorrentInfo> list = await getApiResponse(
            event.baseUrl, event.endpoint, event.query,
            page: page);

        if (state is TorrentLoaded) {
          list = (state as TorrentLoaded).list + list;
        }

        yield TorrentLoaded(list);
      } on Exception catch (e) {
        if (state is TorrentLoaded) {
          yield TorrentLoaded((state as TorrentLoaded).list, maxReached: true);
        }
      }
    }
    if (event is TorrentSearch) {
      yield TorrentInitial();
      try {
        List<TorrentInfo> list =
            await getApiResponse(event.baseUrl, event.endpoint, event.query);

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

    if (event is TorrentHomeRecent) {
      yield TorrentInitial();
      try {
        RecentResponse data = await getRecents(event.base_url);
        yield TorrentHomeRecentLoaded(data);
      } on Exception catch (e) {
        yield TorrentError(e);
      }
    }
  }

  void dispose() {
    this.close();
  }
}

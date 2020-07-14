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

part 'music_event.dart';

part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicInitial());

  @override
  Stream<MusicState> mapEventToState(MusicEvent event,) async* {
    if (event is MusicSearchEvent) {
      yield MusicInitial();
      try {
        final JioSaavnRawQuery data =
        await getJioSaavnRawResponse(event.base_url, event.query);
        yield MusicSearchLoaded(data);
      } on Exception catch (e) {
        yield MusicError(e);
      }
    }

    if (event is GetSongDataEvent) {
      yield MusicInitial();
      try {
        final SongdataWithUrl data =
        await getJioSongdataWithUrl(event.base_url, event.song_id);
        yield MusicSongLoaded(data);
      } on Exception catch (e) {
        yield MusicError(e);
      }
    }

    if (event is GetPlaylistDataEvent) {
      yield MusicInitial();
      try {
        final Playlist data =
        await getPlaylist(event.base_url, event.playlist_id);
        yield MusicPlaylistLoaded(data);
      } on Exception catch (e) {
        yield MusicError(e);
      }
    }

    if (event is GetAlbumDataEvent) {
      yield MusicInitial();
      try {
        final AlbumWithUrl data =
        await getJioAlbumWithUrl(event.base_url, event.album_id);
        yield MusicAlbumLoaded(data);
      } on Exception catch (e) {
        yield MusicError(e);
      }
    }

    if (event is GetHomedataEvent) {
      yield MusicInitial();
      try {
        final JioSaavnHome data = await getJioSaavnHome(event.base_url);
        yield MusicHomeLoaded(data);
      } on Exception catch (e) {
        yield MusicError(e);
      }
    }
  }

  void dispose() {
    this.close();
  }
}

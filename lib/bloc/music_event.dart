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

part of 'music_bloc.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();
}

class MusicSearchEvent extends MusicEvent {
  final String base_url, query;

  MusicSearchEvent(this.base_url, this.query);

  @override
  List<Object> get props => [base_url, query];
}

class GetSongDataEvent extends MusicEvent {
  final String base_url, song_id;

  GetSongDataEvent(this.base_url, this.song_id);

  @override
  List<Object> get props => [base_url, song_id];
}

class GetAlbumDataEvent extends MusicEvent {
  final String base_url, album_id;

  GetAlbumDataEvent(this.base_url, this.album_id);

  @override
  List<Object> get props => [base_url, album_id];
}

class GetPlaylistDataEvent extends MusicEvent {
  final String base_url, playlist_id;

  GetPlaylistDataEvent(this.base_url, this.playlist_id);

  @override
  List<Object> get props => [base_url, playlist_id];
}

class GetHomedataEvent extends MusicEvent {
  final String base_url;

  GetHomedataEvent(this.base_url);

  @override
  List<Object> get props => [base_url];
}

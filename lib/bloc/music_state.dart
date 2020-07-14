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

abstract class MusicState extends Equatable {
  const MusicState();
}

class MusicInitial extends MusicState {
  @override
  List<Object> get props => [];
}

class MusicSongLoaded extends MusicState {
  final SongdataWithUrl data;

  MusicSongLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MusicAlbumLoaded extends MusicState {
  final AlbumWithUrl data;

  MusicAlbumLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MusicPlaylistLoaded extends MusicState {
  final Playlist data;

  MusicPlaylistLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MusicSearchLoaded extends MusicState {
  final JioSaavnRawQuery data;

  MusicSearchLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MusicError extends MusicState {
  final Exception exception;

  MusicError(this.exception);

  @override
  List<Object> get props => [exception];
}

class MusicHomeLoaded extends MusicState {
  final JioSaavnHome data;

  MusicHomeLoaded(this.data);

  @override
  List<Object> get props => [data];
}

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

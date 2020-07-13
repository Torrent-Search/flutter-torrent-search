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

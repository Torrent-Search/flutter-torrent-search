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

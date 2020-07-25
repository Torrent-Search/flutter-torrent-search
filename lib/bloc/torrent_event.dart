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

abstract class TorrentEvent extends Equatable {
  const TorrentEvent();
}

class TorrentSearch extends TorrentEvent {
  final String baseUrl, endpoint, query;

  TorrentSearch(this.baseUrl, this.endpoint, this.query);

  @override
  List<Object> get props => [baseUrl, query, query];
}

class TorrenteNextPage extends TorrentEvent {
  final String baseUrl, endpoint, query;

  TorrenteNextPage(this.baseUrl, this.endpoint, this.query);

  @override
  List<Object> get props => [baseUrl, query, query];
}

class TorrentRecent extends TorrentEvent {
  final String base_url;
  final bool movie;
  final bool long_list;

  TorrentRecent(this.base_url, this.movie, this.long_list);

  @override
  List<Object> get props => [base_url, movie, long_list];
}

class TorrentHomeRecent extends TorrentEvent {
  final String base_url;

  TorrentHomeRecent(this.base_url);

  @override
  List<Object> get props => [base_url];
}

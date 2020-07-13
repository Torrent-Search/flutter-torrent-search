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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/bloc/torrent_bloc.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/Utils.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class AllRecents extends StatefulWidget {
  final bool movies;

  const AllRecents(this.movies);

  @override
  _AllRecentsState createState() => _AllRecentsState();
}

class _AllRecentsState extends State<AllRecents> {
  TorrentBloc _torrentBloc;
  PreferenceProvider _provider;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    final double height = mediaQueryData.size.height;
    final Orientation orientation = mediaQueryData.orientation;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                widget.movies ? "Movies" : "TV Shows",
                style: TextStyle(letterSpacing: 3.0),
              ),
              centerTitle: true,
              floating: true,
            ),
            BlocProvider(
              create: (context) => _torrentBloc,
              child: BlocBuilder<TorrentBloc, TorrentState>(
                builder: (BuildContext context, TorrentState state) {
                  if (state is TorrentRecentLoaded) {
                    return _buildBody(orientation, width, height, state.list);
                  } else if (state is TorrentError) {
                    return SliverFillRemaining(
                        child: ExceptionWidget(state.exception));
                  } else {
                    return SliverFillRemaining(child: LoadingWidget());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _torrentBloc = TorrentBloc();
    _provider = Provider.of<PreferenceProvider>(context);
    _torrentBloc.add(TorrentRecent(_provider.baseUrl, widget.movies, true));
  }

  SliverPadding _buildBody(Orientation orientation, double width, double height,
      List<RecentInfo> list) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      sliver: SliverGrid.count(
        crossAxisCount: Orientation.portrait == orientation ? 2 : 3,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: (((width) / 2) / ((height / 2) - height * 0.1)),
        children: list.map((e) {
          return Thumbnail(e);
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _torrentBloc.dispose();
    super.dispose();
  }
}

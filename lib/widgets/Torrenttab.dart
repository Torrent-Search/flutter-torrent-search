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
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';

import 'ExceptionWidget.dart';
import 'LoadingWidget.dart';
import 'TorrentCard.dart';

class Torrenttab extends StatefulWidget {
  String endpoint, query;
  BuildContext ctx;

  Torrenttab(String site, String query) {
    this.endpoint = site;
    this.query = query;
  }

  @override
  _TorrenttabState createState() => _TorrenttabState();
}

class _TorrenttabState extends State<Torrenttab>
    with AutomaticKeepAliveClientMixin<Torrenttab> {
  PreferenceProvider preferenceProvider;
  String baseUrl;
  TorrentBloc _torrentBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    preferenceProvider = Provider.of<PreferenceProvider>(context);
    baseUrl = preferenceProvider.baseUrl;

    _torrentBloc = TorrentBloc();
    _torrentBloc.add(TorrentSearch(baseUrl, widget.endpoint, widget.query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _torrentBloc,
          child: BlocBuilder<TorrentBloc, TorrentState>(
            builder: (BuildContext context, TorrentState state) {
              if (state is TorrentLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: state.list.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    final TorrentInfo info = state.list[index];
                    return TorrentCard(info //[index]
                        );
                  },
                );
              } else if (state is TorrentError) {
                return ExceptionWidget(state.exception);
              } else {
                return LoadingWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _torrentBloc.dispose();
    super.dispose();
  }
}

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
import 'package:torrentsearch/bloc/music_bloc.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class PlaylistInformation extends StatefulWidget {
  String id;

  PlaylistInformation({this.id});

  @override
  PlaylistInformationState createState() => PlaylistInformationState();
}

class PlaylistInformationState extends State<PlaylistInformation> {
  MusicBloc _musicBloc;
  PreferenceProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _musicBloc,
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (BuildContext context, MusicState state) {
              if (state is MusicPlaylistLoaded) {
                return _buildBody(
                  context,
                  state.data,
                );
              } else if (state is MusicError) {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _musicBloc = MusicBloc();
    _provider = Provider.of<PreferenceProvider>(context);
    _musicBloc.add(GetPlaylistDataEvent(_provider.baseUrl, widget.id));
  }

  CustomScrollView _buildBody(BuildContext context,
      Playlist playlist,) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double height = mediaQueryData.size.height;
    final double width = mediaQueryData.size.width;
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            playlist.name,
            style: TextStyle(letterSpacing: 2.0),
          ),
          centerTitle: true,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                height: height * 0.35,
                width: width,
                child: Center(
                  child: MusicThumbnail(
                    url: playlist.image,
                    showProgress: false,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    playlist.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            final SongdataWithUrl songdata = playlist.songs[index];
            return MusicTile(songdata);
          }, childCount: playlist.songs.length),
        )
      ],
    );
  }

  @override
  void dispose() {
    _musicBloc.dispose();
    super.dispose();
  }
}

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
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/Utils.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class MusicHome extends StatefulWidget {
  @override
  MusicHomeState createState() => MusicHomeState();
}

class MusicHomeState extends State<MusicHome>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController =
      TextEditingController(text: "");

  final DatabaseHelper databaseHelper = DatabaseHelper();
  final Preferences pref = Preferences();

  @override
  void initState() {
    super.initState();
  }

  MusicBloc _musicBloc;
  PreferenceProvider _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _musicBloc = MusicBloc();
    _provider = Provider.of<PreferenceProvider>(context);
    _musicBloc.add(GetHomedataEvent(_provider.baseUrl));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _musicBloc,
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (BuildContext context, MusicState state) {
              if (state is MusicHomeLoaded) {
                return _buildBody(context, data: state.data, loading: false);
              } else if (state is MusicError) {
                return ExceptionWidget(state.exception);
              } else {
                return _buildBody(context, loading: true);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String header, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 16),
            textAlign: TextAlign.left,
          ),
          Spacer(),
          InkWell(
            child: Text(
              "View all",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                letterSpacing: 1.0,
              ),
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accentColor = theme.accentColor;
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    );
    final Color fillColor = theme.brightness == Brightness.dark
        ? Color(0xff424242)
        : Colors.black12;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              hintText: "Search Music Here",
              prefixIcon: Icon(
                Icons.search,
                color: accentColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _textEditingController.clear();
                },
                color: accentColor,
              ),
              contentPadding: EdgeInsets.all(10.0),
              border: inputBorder,
              focusedBorder: inputBorder,
            ),
            cursorColor: accentColor,
            keyboardType: TextInputType.text,
            maxLines: 1,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.search,
            onSubmitted: (term) {
              if (_textEditingController.text != "") {
                databaseHelper.insert(
                    history:
                    History(_textEditingController.text, type: "music"));
                Navigator.pushNamed(context, "/musicresult",
                    arguments: _textEditingController.text);
              }
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton.icon(
              label: Text(
                "SEARCH",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.music_note,
                color: Colors.white,
              ),
              onPressed: () {
                if (_textEditingController.text != "") {
                  databaseHelper.insert(
                      history:
                      History(_textEditingController.text, type: "music"));

                  Navigator.pushNamed(
                    context,
                    "/musicresult",
                    arguments: _textEditingController.text,
                  );
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: Text(
                "SETTINGS",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pushNamed(context, "/settings");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildList(BuildContext context,
      {List<JioSaavnInfo> data, bool loading = false}) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    return loading
        ? Container(
      height: width * 0.35,
      width: width * 0.40,
      child: LoadingWidget(),
    )
        : Container(
      height: width * 0.40,
      width: width * 0.40,
      padding: EdgeInsets.only(left: 5.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext ctxt, int index) {
          final JioSaavnInfo info = data[index];
          return MusicThumbnail(
            url: info.image,
            onpressed: () {
              switch (info.type) {
                case "album":
                  Navigator.of(context)
                      .pushNamed("/albuminfo", arguments: info.id);
                  break;
                case "playlist":
                  Navigator.of(context)
                      .pushNamed("/playlistinfo", arguments: info.id);
                  break;
                case "song":
                  Navigator.of(context)
                      .pushNamed("/musicinfo", arguments: info.id);
                  break;
                default:
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context,
      {JioSaavnHome data, bool loading = true}) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _buildSearch(context),
        _buildHeader(
            "Charts",
            loading
                ? () {}
                : () {
              Navigator.pushNamed(
                context,
                "/allmusic",
                arguments: {"list": data.charts, "type": "Charts"},
              );
            }),
        _buildList(context,
            data: loading ? null : data.charts, loading: loading),
        _buildHeader(
            "Trending",
            loading
                ? () {}
                : () {
              Navigator.pushNamed(
                context,
                "/allmusic",
                arguments: {"list": data.trending, "type": "Trending"},
              );
            }),
        _buildList(context,
            data: loading ? null : data.trending, loading: loading),
        _buildHeader(
            "Top Playlists",
            loading
                ? () {}
                : () {
              Navigator.pushNamed(
                context,
                "/allmusic",
                arguments: {
                  "list": data.topPlaylists,
                  "type": "Top Playlists"
                },
              );
            }),
        _buildList(context,
            data: loading ? null : data.topPlaylists, loading: loading),
        SizedBox(height: 70.0),
      ],
    );
  }

  @override
  void dispose() {
    _musicBloc.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/bloc/music_bloc.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/LoadingWidget.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';

class MusicResult extends StatefulWidget {
  final String query;

  const MusicResult(this.query);

  @override
  _MusicResultState createState() => _MusicResultState();
}

class _MusicResultState extends State<MusicResult> {
  MusicBloc _musicBloc;
  PreferenceProvider _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _musicBloc = MusicBloc();
    _provider = Provider.of<PreferenceProvider>(context);
    _musicBloc.add(MusicSearchEvent(_provider.baseUrl, widget.query));
  }

  @override
  Widget build(BuildContext context) {
    final PreferenceProvider _provider =
        Provider.of<PreferenceProvider>(context);
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RESULTS',
          style: TextStyle(
            letterSpacing: 3.0,
            fontFamily: "OpenSans",
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _musicBloc,
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (BuildContext context, MusicState state) {
              if (state is MusicSearchLoaded) {
                return _buildBody(state.data, width);
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

  ListView _buildBody(JioSaavnRawQuery data, double width) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Text(
            "Album",
            style: TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
        data.albums.data.length > 0
            ? Container(
          height: width * 0.40,
          width: width * 0.40,
          child: ListView.builder(
            itemCount: data.albums.data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final AlbumsData albumData = data.albums.data[index];
              return MusicThumbnail(
                albumsData: albumData,
                onpressed: () {
                  Navigator.pushNamed(context, "/albuminfo",
                      arguments: albumData.id);
                },
                showProgress: true,
              );
            },
          ),
        )
            : ExceptionWidget(NoContentFoundException()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Text(
            "Songs",
            style: TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
        data.songs.data.length > 0
            ? Container(
          height: width * 0.40,
          width: width * 0.40,
          child: ListView.builder(
            itemCount: data.songs.data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final SongData songdata = data.songs.data[index];
              return MusicThumbnail(
                songData: songdata,
                onpressed: () {
                  Navigator.pushNamed(context, "/musicinfo",
                      arguments: songdata.id);
                },
                showProgress: true,
              );
            },
          ),
        )
            : ExceptionWidget(NoContentFoundException()),
      ],
    );
  }

  @override
  void dispose() {
    _musicBloc.dispose();
    super.dispose();
  }
}

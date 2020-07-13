import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/bloc/music_bloc.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/Utils.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class AlbumInformation extends StatefulWidget {
  String id;

  AlbumInformation({this.id});

  @override
  _AlbumInformationState createState() => _AlbumInformationState();
}

class _AlbumInformationState extends State<AlbumInformation> {
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
              if (state is MusicAlbumLoaded) {
                return _buildBody(context, state.data);
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
    _musicBloc.add(GetAlbumDataEvent(_provider.baseUrl, widget.id));
  }

  CustomScrollView _buildBody(BuildContext context, AlbumWithUrl data) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double height = mediaQueryData.size.height;
    final double width = mediaQueryData.size.width;
    return CustomScrollView(
      shrinkWrap: false,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            data.title,
            style: TextStyle(letterSpacing: 2.0),
          ),
          centerTitle: true,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              height: height * 0.35,
              width: width,
              child: Center(
                child: MusicThumbnail(
                  url: data.image,
                  showProgress: false,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  data.title,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildText(context, "Year", data.year),
                SizedBox(height: 20.0),
                _buildText(context, "Primary Artist", data.primaryArtists),
              ],
            ),
          ]),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            final SongdataWithUrl songdata = data.songs[index];
            return MusicTile(songdata);
          }, childCount: data.songs.length),
        ),
      ],
    );
  }

  Widget _buildText(BuildContext ctx, String header, String info) {
    final ThemeData themeData = Theme.of(ctx);
    final TextStyle textStyle = themeData.textTheme.bodyText2
        .copyWith(fontWeight: FontWeight.normal, fontSize: 13.0);
    final TextStyle textStyleWithSize = themeData.textTheme.bodyText2.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    if (info.split(",").length > 1) {
      List<String> strings = info.split(",");
      info = "";
      strings.forEach((element) {
        info += (element.trim() + "\n");
      });
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          header,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyleWithSize,
        ),
        Text(
          info,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _musicBloc.dispose();
    super.dispose();
  }
}

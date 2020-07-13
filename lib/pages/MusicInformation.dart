import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/bloc/music_bloc.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/Utils.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class MusicInformation extends StatefulWidget {
  final String pid;
  final SongdataWithUrl songdata;

  MusicInformation({this.pid, this.songdata});

  @override
  _MusicInformationState createState() => _MusicInformationState();
}

class _MusicInformationState extends State<MusicInformation> {
  String title = "";

  MusicBloc _musicBloc;
  PreferenceProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.songdata == null
            ? BlocProvider(
                create: (context) => _musicBloc,
                child: BlocBuilder<MusicBloc, MusicState>(
                  builder: (BuildContext context, MusicState state) {
                    if (state is MusicSongLoaded) {
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
              )
            : _buildBody(context, widget.songdata),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.songdata == null) {
      _musicBloc = MusicBloc();
      _provider = Provider.of<PreferenceProvider>(context);
      _musicBloc.add(GetSongDataEvent(_provider.baseUrl, widget.pid));
    }
  }

  Widget _buildText(BuildContext ctx, String header, String info) {
    final ThemeData themeData = Theme.of(ctx);
    final TextStyle textStyle = themeData.textTheme.bodyText2
        .copyWith(fontWeight: FontWeight.normal, fontSize: 13.0);
    final TextStyle textStyleWithSize = themeData.textTheme.bodyText2.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    if (header == null) {
      header = "";
    }
    if (info == null) {
      info = "";
    }
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

  Widget _buildBody(BuildContext context, SongdataWithUrl songdata) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    final double height = mediaQueryData.size.height;
    // songdata.duration = "a";
    try {
      final String duration =
          (double.parse(songdata.duration) / 60).toStringAsPrecision(2) +
              " Minute";
      songdata.duration = duration;
    } on Exception {}
    return CustomScrollView(
      shrinkWrap: false,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            songdata.song ?? "",
            style: TextStyle(letterSpacing: 2.0),
          ),
          centerTitle: true,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: height * 0.35,
              child: Center(
                child: MusicThumbnail(
                  url: songdata.image,
                  showProgress: false,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  songdata.song ?? "",
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
                Container(
                  width: width * 0.50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildText(context, "Album", songdata.album),
                      SizedBox(height: 20.0),
                      _buildText(context, "Singer", songdata.singers),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildText(context, "Duration", songdata.duration),
                      SizedBox(height: 20.0),
                      _buildText(context, "Year", songdata.year),
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: RaisedButton.icon(
                  label: Text(
                    "Download",
                    style: TextStyle(
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    Icons.file_download,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final String fileName = getFileName(songdata.song);
                    showFlushBar(
                        context,
                        await DownloadService.requestDownload(TaskInfo(
                            name: fileName, link: songdata.encryptedMediaUrl)));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: Theme
                      .of(context)
                      .accentColor,
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.songdata == null) {
      _musicBloc.dispose();
    }
    super.dispose();
  }
}

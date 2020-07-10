import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';
import 'package:torrentsearch/utils/DownloadService.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/utils/UrlUtils.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/LoadingWidget.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';

class MusicInformation extends StatefulWidget {
  final String pid;
  final SongdataWithUrl songdata;

  MusicInformation({this.pid, this.songdata});

  @override
  _MusicInformationState createState() => _MusicInformationState();
}

class _MusicInformationState extends State<MusicInformation> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    final PreferenceProvider _provider =
        Provider.of<PreferenceProvider>(context);

    return widget.songdata == null
        ? FutureBuilder(
            future: getJioSongdataWithUrl(_provider.baseUrl, widget.pid),
            builder: (BuildContext context,
                AsyncSnapshot<SongdataWithUrl> snapshot) {
              if (snapshot.hasData) {
                try {
                  double minute = int.parse(snapshot.data.duration) / 60;
                  snapshot.data.duration = minute.toStringAsFixed(2);
                } on Exception {}
                return _buildBody(snapshot.data);
              } else if (snapshot.hasError) {
                Scaffold(
                  appBar: AppBar(),
                  body: SafeArea(
                    child: ExceptionWidget(snapshot.error),
                  ),
                );
              }
              return Scaffold(
                appBar: AppBar(),
                body: SafeArea(
                  child: LoadingWidget(),
                ),
              );
            },
          )
        : _buildBody(widget.songdata);
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

  Widget _buildBody(SongdataWithUrl songdata) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final ThemeData themeData = Theme.of(context);
    final double width = mediaQueryData.size.width;
    final double height = mediaQueryData.size.height;
    final double blurRadius = 15.0;
    final Color shadowColor = themeData.brightness == Brightness.dark
        ? Color(0xff424242)
        : Colors.black54;
    final BorderRadius borderRadius = BorderRadius.circular(20);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
                        if (!DownloadService.checkIfDownloading(fileName)) {
                          if (await DownloadService.requestDownload(TaskInfo(
                              name: fileName,
                              link: songdata.encryptedMediaUrl))) {
                            showFlushbar(
                                context, "Downloading to Internal/Downloads");
                          } else {
                            showFlushbar(context, "Already downloaded");
                          }
                        } else {
                          showFlushbar(context, "Already Downloading/Paused");
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: themeData.accentColor,
                    ),
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void showFlushbar(BuildContext context, String msg) {
    Flushbar(
      message: msg,
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }
}

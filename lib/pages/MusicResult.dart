import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
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
        child: FutureBuilder(
          future: getJioSaavnRawResponse(_provider.baseUrl, widget.query),
          builder:
              (BuildContext ctx, AsyncSnapshot<JioSaavnRawQuery> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: Text(
                      "Album",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  snapshot.data.albums.data.length > 0
                      ? Container(
                          height: width * 0.40,
                          width: width * 0.40,
                          child: ListView.builder(
                            itemCount: snapshot.data.albums.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final AlbumsData data =
                                  snapshot.data.albums.data[index];
                              return MusicThumbnail(
                                albumsData: data,
                                onpressed: () {
                                  Navigator.pushNamed(context, "/albuminfo",
                                      arguments: data.id);
                                },
                                showProgress: true,
                              );
                            },
                          ),
                        )
                      : ExceptionWidget(NoContentFoundException()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: Text(
                      "Songs",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  snapshot.data.songs.data.length > 0
                      ? Container(
                          height: width * 0.40,
                          width: width * 0.40,
                          child: ListView.builder(
                            itemCount: snapshot.data.songs.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final SongData data =
                              snapshot.data.songs.data[index];
                              return MusicThumbnail(
                                songData: data,
                                onpressed: () {
                                  Navigator.pushNamed(context, "/musicinfo",
                                      arguments: data.id);
                                },
                                showProgress: true,
                              );
                            },
                          ),
                        )
                      : ExceptionWidget(NoContentFoundException()),
                ],
              );
            } else if (snapshot.hasError) {
              return ExceptionWidget(snapshot.error);
            }
            return LoadingWidget();
          },
        ),
      ),
    );
  }
}

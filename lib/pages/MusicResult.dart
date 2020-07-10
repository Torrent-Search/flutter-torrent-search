import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
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
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    final double height = MediaQuery.of(context).size.height;
    final Color accentColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RESULTS',
          style: TextStyle(color: Colors.white, letterSpacing: 3.0),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
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
                              return MusicThumbnail(
                                albumsData: snapshot.data.albums.data[index],
                                onpressed: () {
                                  Navigator.pushNamed(context, "/albuminfo",
                                      arguments:
                                          snapshot.data.albums.data[index].id);
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
                              return MusicThumbnail(
                                songData: snapshot.data.songs.data[index],
                                onpressed: () {
                                  Navigator.pushNamed(context, "/musicinfo",
                                      arguments:
                                          snapshot.data.songs.data[index].id);
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
            return Center(
                child: SpinKitThreeBounce(
              color: accentColor,
            ));
            ;
          },
        ),
      ),
    );
  }
}

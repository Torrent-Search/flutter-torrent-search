import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/LoadingWidget.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';
import 'package:torrentsearch/widgets/MusicTile.dart';

class AlbumInformation extends StatefulWidget {
  String id;

  AlbumInformation({this.id});

  @override
  _AlbumInformationState createState() => _AlbumInformationState();
}

class _AlbumInformationState extends State<AlbumInformation> {
  @override
  Widget build(BuildContext context) {
    final PreferenceProvider _provider =
        Provider.of<PreferenceProvider>(context);
    final ThemeData themeData = Theme.of(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double height = mediaQueryData.size.height;
    final double width = mediaQueryData.size.width;

    return FutureBuilder(
      future: getJioAlbumWithUrl(_provider.baseUrl, widget.id),
      builder: (BuildContext context, AsyncSnapshot<AlbumWithUrl> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                shrinkWrap: false,
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text(
                      snapshot.data.title,
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
                            url: snapshot.data.image,
                            showProgress: false,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            snapshot.data.title,
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
                          _buildText(context, "Year", snapshot.data.year),
                          SizedBox(height: 20.0),
                          _buildText(context, "Primary Artist",
                              snapshot.data.primaryArtists),
                        ],
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final SongdataWithUrl data = snapshot.data.songs[index];
                      return MusicTile(data);
                    }, childCount: snapshot.data.songs.length),
                  ),
                ],
              ),
            ),
          );
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
          body: SafeArea(child: LoadingWidget()),
        );
      },
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
}

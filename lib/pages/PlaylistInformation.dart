import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/LoadingWidget.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';
import 'package:torrentsearch/widgets/MusicTile.dart';

class PlaylistInformation extends StatefulWidget {
  String id;

  PlaylistInformation({this.id});

  @override
  PlaylistInformationState createState() => PlaylistInformationState();
}

class PlaylistInformationState extends State<PlaylistInformation> {
  @override
  Widget build(BuildContext context) {
    final PreferenceProvider _provider =
        Provider.of<PreferenceProvider>(context);
    final ThemeData themeData = Theme.of(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double height = mediaQueryData.size.height;
    final double width = mediaQueryData.size.width;

    return FutureBuilder(
      future: getPlaylist(_provider.baseUrl, widget.id),
      builder: (BuildContext context, AsyncSnapshot<Playlist> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text(
                      snapshot.data.name,
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
                              url: snapshot.data.image,
                              showProgress: false,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              snapshot.data.name,
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
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final SongdataWithUrl data = snapshot.data.songs[index];
                      return MusicTile(data);
                    }, childCount: snapshot.data.songs.length),
                  )
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

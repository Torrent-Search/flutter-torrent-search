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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:torrentsearch/network/model/music/JioSaavnHome.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';
import 'package:torrentsearch/widgets/Thumbnail.dart';

class AllMusic extends StatefulWidget {
  final String type;
  final List<JioSaavnInfo> infos;

  const AllMusic(this.infos, this.type);

  @override
  _AllRecentsState createState() => _AllRecentsState();
}

class _AllRecentsState extends State<AllMusic> {
  @override
  Widget build(BuildContext context) {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    final double height = mediaQueryData.size.height;
    final Color accentColor = Theme.of(context).accentColor;
    final Orientation orientation = mediaQueryData.orientation;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                widget.type,
                style: TextStyle(letterSpacing: 3.0),
              ),
              centerTitle: true,
              iconTheme: IconThemeData(
                color:
                    preferenceProvider.darkTheme ? Colors.white : Colors.black,
              ),
              floating: true,
            ),
            SliverGrid.count(
              crossAxisCount: Orientation.portrait == orientation ? 2 : 3,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 1,
              children: widget.infos.map((e) {
                return MusicThumbnail(
                  url: e.image,
                  // width: width * 0.40,
                  // height: width * 0.40,
                  onpressed: () {
                    switch (e.type) {
                      case "album":
                        Navigator.of(context)
                            .pushNamed("/albuminfo", arguments: e.id);
                        break;
                      case "playlist":
                        Navigator.of(context)
                            .pushNamed("/playlistinfo", arguments: e.id);
                        break;
                      case "song":
                        Navigator.of(context)
                            .pushNamed("/musicinfo", arguments: e.id);
                        break;
                      default:
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

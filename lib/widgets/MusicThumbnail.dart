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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';

class MusicThumbnail extends StatelessWidget {
  final AlbumsData albumsData;
  final SongData songData;
  final double width, height;
  final Function onpressed;
  final bool showProgress;
  String url = null;

  MusicThumbnail(
      {this.albumsData = null,
      this.songData = null,
      this.width,
      this.height,
      this.onpressed,
      this.url,
      this.showProgress = true});

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(20);
    final double blurRadius = 15.0;
    final ThemeData themeData = Theme.of(context);
    final Color shadowColor = themeData.brightness == Brightness.dark
        ? Color(0xff424242)
        : Colors.black54;

    return Container(
      height: height ?? null,
      width: width ?? null,
      margin: EdgeInsets.all(blurRadius),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.transparent,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor,
            blurRadius: blurRadius,
            offset: Offset(0.0, 0.50),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onpressed,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: showProgress
              ? CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: url ??
                      (albumsData == null ? songData.image : albumsData.image),
                  progressIndicatorBuilder: (ctx, url, progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            themeData.accentColor),
                      ),
                    );
                  },
                )
              : CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl: url ??
                      (albumsData == null ? songData.image : albumsData.image),
                ),
        ),
      ),
    );
  }
}

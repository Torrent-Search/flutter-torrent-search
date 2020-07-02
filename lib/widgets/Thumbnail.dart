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
import 'package:torrentsearch/network/model/RecentResponse.dart';

class Thumbnail extends StatelessWidget {
  final RecentInfo _recentInfo;
  final double width, height;
  const Thumbnail(this._recentInfo, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(20);
    final double blurRadius = 15.0;
    final Color shadowColor = Theme.of(context).brightness == Brightness.dark
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
        onTap: () {
          Navigator.pushNamed(context, "/recentinfo", arguments: {
            "imdbcode": _recentInfo.imdbcode,
            "imgurl": _recentInfo.imgUrl,
          });
        },
        child: ClipRRect(
          borderRadius: borderRadius,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: _recentInfo.imgUrl,
            progressIndicatorBuilder: (ctx, url, progress) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

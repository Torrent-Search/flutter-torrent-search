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

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/Utils.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class MusicTile extends StatefulWidget {
  final SongdataWithUrl data;
  final bool useLikeIcon;

  const MusicTile(this.data, {this.useLikeIcon = true});

  @override
  _MusicTileState createState() => _MusicTileState();
}

class _MusicTileState extends State<MusicTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.data.song),
      subtitle: Text(widget.data.year),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              final String fileName = getFileName(widget.data.song);
              showFlushBar(
                  context,
                  await DownloadService.requestDownload(TaskInfo(
                      name: fileName, link: widget.data.encryptedMediaUrl)));
            },
          ),
          widget.useLikeIcon
              ? LikeButton(
            onTap: (bool isLiked) async {
              final DatabaseHelper dbhelper = DatabaseHelper();
              if (!isLiked) {
                dbhelper.insert(songdata: widget.data);
                showFlushBar(context, "Added to Favourite");
                return true;
              } else {
                dbhelper.delete(widget.data.id, song: true);
                showFlushBar(context, "Removed from Favourite");
                return false;
              }
            },
          )
              : IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final DatabaseHelper dbhelper = DatabaseHelper();
              dbhelper.delete(widget.data.id, song: true);
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, "/musicinfo",
                  arguments: widget.data.id);
            },
          )
        ],
      ),
      leading: MusicThumbnail(
        url: widget.data.image,
        showProgress: false,
      ),
    );
  }
}

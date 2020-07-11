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

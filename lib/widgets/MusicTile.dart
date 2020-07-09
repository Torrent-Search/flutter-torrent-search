import 'package:downloader/downloader.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';

class MusicTile extends StatelessWidget {
  final SongdataWithUrl data;

  const MusicTile(this.data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data.song),
      subtitle: Text(data.year),
      trailing: IconButton(
        icon: Icon(Icons.file_download),
        onPressed: () {
          Downloader.download(data.encryptedMediaUrl, data.song, "mp3");
        },
      ),
      leading: MusicThumbnail(
        url: data.image,
        showProgress: false,
      ),
    );
  }
}

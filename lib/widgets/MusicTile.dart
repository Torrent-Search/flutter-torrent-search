import 'package:flutter/material.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/Utils.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

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
        onPressed: () async {
          final String fileName = getFileName(data.song);
          showFlushBar(
              context,
              await DownloadService.requestDownload(
                  TaskInfo(name: fileName, link: data.encryptedMediaUrl)));
        },
      ),
      leading: MusicThumbnail(
        url: data.image,
        showProgress: false,
      ),
    );
  }
}

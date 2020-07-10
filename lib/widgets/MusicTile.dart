import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/network/model/music/JioSaavnRawQuery.dart';
import 'package:torrentsearch/utils/DownloadService.dart';
import 'package:torrentsearch/utils/UrlUtils.dart';
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
        onPressed: () async {
          final String fileName = getFileName(data.song);
          if (!DownloadService.checkIfDownloading(fileName)) {
            if (await DownloadService.requestDownload(
                TaskInfo(name: fileName, link: data.encryptedMediaUrl))) {
              showFlushbar(context, "Downloading to Internal/Downloads");
            } else {
              showFlushbar(context, "Already downloaded");
            }
          } else {
            showFlushbar(context, "Already Downloading/Paused");
          }
        },
      ),
      leading: MusicThumbnail(
        url: data.image,
        showProgress: false,
      ),
    );
  }

  void showFlushbar(BuildContext context, String msg) {
    Flushbar(
      message: msg,
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }
}

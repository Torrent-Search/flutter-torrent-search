import 'package:flutter/material.dart';
import 'package:torrentsearch/core/constants.dart';
import 'package:torrentsearch/core/utils/flushbar.dart';
import 'package:torrentsearch/core/utils/method_channel_utils.dart';
import 'package:torrentsearch/features/torrent/data/database/database_helper.dart';
import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';
import 'package:torrentsearch/features/torrent/domain/usecases/get_magnet.dart';
import 'package:torrentsearch/injector.dart';

class TorrentTile extends StatefulWidget {
  final Torrent info;
  final bool favourite;
  const TorrentTile(this.info, {this.favourite = false});

  @override
  _TorrentTileState createState() => _TorrentTileState();
}

class _TorrentTileState extends State<TorrentTile> {
  bool addedToFavourite = false;
  bool copyRequested = false;
  bool shareRequested = false;

  String magnet = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    magnet = widget.info.magnet ?? "";
    addedToFavourite = widget.favourite;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Text(
                      widget.info.name,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buikdPopupMenuButton(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.lightGreenAccent,
                          ),
                          const SizedBox(width: 2.0),
                          Text(
                            widget.info.seeders,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.data_usage),
                          const SizedBox(width: 2.0),
                          Text(
                            widget.info.size,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 2.0),
                          Text(
                            widget.info.leechers,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.event),
                          const SizedBox(width: 2.0),
                          Text(
                            widget.info.uploadDate ?? "",
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () async {
                      if (magnet == "" && !copyRequested) {
                        setState(() => copyRequested = true);
                        showFlushBar(
                            context, "Fetching Magnet Link From Server");
                        try {
                          await setMagnet();
                          await MethodChannelUtils.copyToClipboard(magnet);
                          showFlushBar(
                              context, "Magnet Link Copied to Clipboard");
                        } on Exception {
                          showFlushBar(context, "Error Occured");
                        }
                      } else {
                        await MethodChannelUtils.copyToClipboard(magnet);
                        showFlushBar(
                            context, "Magnet Link Copied to Clipboard");
                      }
                      setState(() => copyRequested = false);
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      if (!addedToFavourite) {
                        await DatabaseHelper().insert(torrentinfo: widget.info);
                        setState(() => addedToFavourite = true);
                      } else {
                        await DatabaseHelper()
                            .delete(widget.info.name, torrentinfo: true);
                        setState(() => addedToFavourite = false);
                      }
                    },
                    icon: addedToFavourite
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite, color: Colors.black38),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton _buikdPopupMenuButton() {
    return PopupMenuButton(
      onSelected: (str) async {
        switch (str as String) {
          case "share":
            if (magnet == "" && !shareRequested) {
              setState(() => shareRequested = true);
              showFlushBar(context, "Fetching Magnet Link From Server");
              try {
                await setMagnet();
                await MethodChannelUtils.share(magnet);
              } on Exception catch (e) {
                showFlushBar(context, e.toString());
              }
            } else {
              await MethodChannelUtils.share(magnet);
            }
            setState(() => shareRequested = false);
            break;
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: "share",
          child: FlatButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share),
            label: Text(
              "Share",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 16.0, letterSpacing: 1.0),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> setMagnet() async {
    magnet =
        await sl<GetMagnet>().call(getMagnetEndpoint(), widget.info.torrentUrl);
  }

  String getMagnetEndpoint() {
    if (magnet == "") {
      switch (widget.info.website) {
        case "Kickass":
          return Constants.KICKASS_MG_ENDPOINT;
          break;
        case "1337x":
          return Constants.ENDPOINT_MG_1337x;
          break;
        case "Limetorrents":
          return Constants.LIMETORRENTS_ENDPOINT_MG;
          break;
      }
    }
    return "";
  }
}

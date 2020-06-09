import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
import 'package:intent/extra.dart' as android_extra;
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/utils/Themes.dart';

class TorrentCard extends StatefulWidget {
  TorrentInfo info;
  bool isClicked = false;
  TorrentCard(TorrentInfo list) {
    this.info = list;
  }
  @override
  _TorrentCardState createState() => _TorrentCardState();
}

class _TorrentCardState extends State<TorrentCard> {
  @override
  Widget build(BuildContext context) {
    final Brightness br = Theme.of(context).brightness;
    return InkWell(
      onTap: () async {
        if (widget.isClicked == false) {
          String endpoint;
          if (widget.info.magnet == "") {
            switch (widget.info.website) {
              case "Kickass":
                endpoint = ApiConstants.KICKASS_MG_ENDPOINT;
                break;
              case "1337x":
                endpoint = ApiConstants.ENDPOINT_MG_1337x;
                break;
              case "Limetorrents":
                endpoint = ApiConstants.LIMETORRENTS_ENDPOINT_MG;
                break;
            }
            widget.info.magnet = await getMagnetResponse(endpoint, widget.info.url);
        }
        android_intent.Intent()
            ..setAction(android_action.Action.ACTION_SEND)
            ..putExtra(android_extra.Extra.EXTRA_TEXT, widget.info.magnet)
            ..setType("text/plain")
            ..startActivity(createChooser: true);
          widget.isClicked = false;
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Text(
                      widget.info.name,
                      textAlign: TextAlign.center,
                      style: defaultTextStyleBold(br)
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.lightGreenAccent,
                            ),
                            SizedBox(width: 2.0),
                            Text(
                              widget.info.seeders,
                              style: defaultTextStyle(br),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.data_usage),
                            SizedBox(width: 2.0),
                            Text(
                              widget.info.size,
                              style: defaultTextStyle(br),
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
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 2.0),
                            Text(
                              widget.info.leechers,
                              style: defaultTextStyle(br),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.cloud_upload),
                            SizedBox(width: 2.0),
                            Text(
                              widget.info.uploader,
                              style: defaultTextStyle(br),
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
                            Icon(Icons.cloud),
                            SizedBox(width: 2.0),
                            Text(
                              widget.info.website,
                              style: defaultTextStyle(br),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.event),
                            SizedBox(width: 2.0),
                            Text(
                              widget.info.upload_date,
                              style: defaultTextStyle(br),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

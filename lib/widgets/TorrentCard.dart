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

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intent/action.dart' as android_action;
import 'package:intent/extra.dart' as android_extra;
import 'package:intent/intent.dart' as android_intent;
import 'package:like_button/like_button.dart';
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/utils/Themes.dart';

class TorrentCard extends StatefulWidget {
  TorrentInfo info;
  bool isClicked = false;
  bool useLikeIcon;
  TorrentCard(TorrentInfo list, {bool useLikeIcon = true}) {
    this.info = list;
    this.useLikeIcon = useLikeIcon;
  }
  @override
  _TorrentCardState createState() => _TorrentCardState();
}

class _TorrentCardState extends State<TorrentCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final Brightness br = Theme.of(context).brightness;
    return Padding(
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
                  child: Text(widget.info.name,
                      textAlign: TextAlign.center,
                      style: defaultTextStyleBold(br)),
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
                          Icon(Icons.event),
                          SizedBox(width: 2.0),
                          Text(
                            widget.info.upload_date == null
                                ? ""
                                : widget.info.upload_date,
                            style: defaultTextStyle(br),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () async {
                      if (widget.isClicked == false) {
                        await setMagnet(context);
                        ClipboardManager.copyToClipBoard(widget.info.magnet)
                            .then((value) {
                          showFlushBar(
                              context, "Magnet link Copied to Clipboard");
                        });
                        widget.isClicked = false;
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      if (widget.isClicked == false) {
                        await setMagnet(context);
                        android_intent.Intent()
                          ..setAction(android_action.Action.ACTION_SEND)
                          ..putExtra(android_extra.Extra.EXTRA_TEXT,
                              widget.info.magnet)
                          ..setType("text/plain")
                          ..startActivity(createChooser: true);
                        widget.isClicked = false;
                      }
                    },
                  ),
                  widget.useLikeIcon
                      ? Container(
                          alignment: Alignment.bottomRight,
                          child: LikeButton(
                            onTap: (bool isLiked) async {
                              final DatabaseHelper dbhelper = DatabaseHelper();
                              if (!isLiked) {
                                await setMagnet(context);
                                await dbhelper.insert(torrentinfo: widget.info);
                                showFlushBar(context, "Added to Favourite");
                                return true;
                              } else {
                                await dbhelper.delete(widget.info.name,
                                    torrentinfo: true);
                                showFlushBar(context, "Removed from Favourite");
                                return false;
                              }
                            },
                          ),
                        )
                      : Container(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              final DatabaseHelper dbhelper = DatabaseHelper();
                              await dbhelper.delete(widget.info.name,
                                  torrentinfo: true);
                              setState(() {});
                            },
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setMagnet(BuildContext ctx) async {
    if (widget.info.magnet == "") {
      String endpoint;
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
      showFlushBar(ctx, "Fetching Magnet Link from Server");
      widget.info.magnet = await getMagnetResponse(endpoint, widget.info.url);
    }
    return;
  }

  void showFlushBar(BuildContext ctx, String msg) {
    Flushbar(
      message: msg,
      duration: Duration(seconds: 1),
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(ctx);
  }
}

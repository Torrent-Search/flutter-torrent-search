import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intent/action.dart' as android_action;
import 'package:intent/extra.dart' as android_extra;
import 'package:intent/intent.dart' as android_intent;
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/utils/Themes.dart';

class FavouriteTorrents extends StatefulWidget {
  bool isClicked = false;

  @override
  _FavouriteTorrentsState createState() => _FavouriteTorrentsState();
}

class _FavouriteTorrentsState extends State<FavouriteTorrents> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _databaseHelper.queryAll(torrentinfo: true),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) {
                  return _buildCard(
                    context,
                    TorrentInfo.fromMap(snapshot.data[index]),
                  );
                },
              );
            }
            return _buildNoFavourite();
          }
          return SpinKitThreeBounce(
            color: accentColor,
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext ctx, TorrentInfo info) {
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
                  child: Text(info.name,
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
                            info.seeders,
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
                            info.size,
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
                            info.leechers,
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
                            info.upload_date == null ? "" : info.upload_date,
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
                        String endpoint;
                        if (info.magnet == "") {
                          switch (info.website) {
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
                          info.magnet =
                              await getMagnetResponse(endpoint, info.url);
                        }
                        ClipboardManager.copyToClipBoard(info.magnet)
                            .then((value) {
                          Flushbar(
                            message: "Magnet link Copied to Clipboard",
                            duration: Duration(seconds: 2),
                            flushbarStyle: FlushbarStyle.FLOATING,
                          ).show(context);
                        });
                        widget.isClicked = false;
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      if (widget.isClicked == false) {
                        String endpoint;
                        if (info.magnet == "") {
                          switch (info.website) {
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
                          info.magnet =
                              await getMagnetResponse(endpoint, info.url);
                        }
                        android_intent.Intent()
                          ..setAction(android_action.Action.ACTION_SEND)
                          ..putExtra(
                              android_extra.Extra.EXTRA_TEXT, info.magnet)
                          ..setType("text/plain")
                          ..startActivity(createChooser: true);
                        widget.isClicked = false;
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final DatabaseHelper dbhelper = DatabaseHelper();
                        await dbhelper.delete(info.name, torrentinfo: true);
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

  Widget _buildNoFavourite() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.favorite,
          size: 50.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "No Favourites added",
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    ));
  }
}

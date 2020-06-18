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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/widgets/TorrentCard.dart';

class Torrenttab extends StatefulWidget {
  String endpoint, query;
  BuildContext ctx;

  Torrenttab(String site, String query) {
    this.endpoint = site;
    this.query = query;
  }

  @override
  _TorrenttabState createState() => _TorrenttabState();
}

class _TorrenttabState extends State<Torrenttab>
    with AutomaticKeepAliveClientMixin<Torrenttab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).accentColor;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder<List<TorrentInfo>>(
              future: getApiResponse(widget.endpoint, widget.query),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AnimationLimiter(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: Duration(milliseconds: 300),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: TorrentCard(snapshot.data[index] //[index]
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  switch (snapshot.error.runtimeType) {
                    case NoContentFoundException:
                      return noContentFound();
                      break;
                    case InternalServerError:
                      return serverError();
                      break;
                    case SocketException:
                      return noInternet();
                      break;
                    default:
                      return unExpectedError();
                  }
                } else {
                  return Center(
                      child: SpinKitThreeBounce(
                    color: accentColor,
                  ));
                }
              }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }
}

Widget noContentFound() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.not_interested,
        size: 50.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Text(
        "No Content Found",
        style: TextStyle(
          fontSize: 20.0,
        ),
      )
    ],
  ));
}

Widget serverError() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.error_outline,
        size: 50.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Text(
        "Sorry for incovenience\nServer is not working properly",
        style: TextStyle(
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      )
    ],
  ));
}

Widget noInternet() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.cloud_off,
        size: 50.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Text(
        "Check Your internet connection",
        style: TextStyle(
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      )
    ],
  ));
}

Widget unExpectedError() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.error_outline,
        size: 50.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Text(
        "Unexpcted Error Occured",
        style: TextStyle(
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      )
    ],
  ));
}

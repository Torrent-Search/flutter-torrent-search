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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/Imdb.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/TorrentCard.dart';
import 'package:torrentsearch/widgets/Torrenttab.dart';

class RecentInformation extends StatefulWidget {
  @override
  _RecentInformationState createState() => _RecentInformationState();
}

class _RecentInformationState extends State<RecentInformation> {
  Future<Imdb> _imdb;
  bool isClicked = false;
  String plot = "Loading...";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map search = ModalRoute.of(context).settings.arguments;
    final double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<PreferenceProvider>(context);
    final double width = MediaQuery.of(context).size.width;
    final borderRadius = BorderRadius.circular(5);
    final Color accentColor = Theme.of(context).accentColor;
    if (_imdb == null) {
      _imdb = getImdb(search["imdbcode"]);
    }
    return Scaffold(
        backgroundColor: themeProvider.darkTheme
            ? Theme.of(context).backgroundColor
            : Colors.white,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: width * 0.30,
                    height: height * 0.25,
                    padding: EdgeInsets.only(top: 10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: search["imgurl"],
                          progressIndicatorBuilder: (ctx, url, progress) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(accentColor),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  buildInfo(search["imdbcode"], width, height)
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: _imdb,
                  builder: (BuildContext ctx, AsyncSnapshot<Imdb> snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data.plot,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Error !",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      );
                    }
                    return Text(
                      "Loading...",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
//                SizedBox(height: 20.0,),
              FutureBuilder<List<TorrentInfo>>(
                  future: getApiResponse(
                      ApiConstants.TGX_ENDPOINT, search["imdbcode"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.map((e) {
                          return TorrentCard(e);
                        }).toList(),
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
                  })
            ],
          ),
        ));
  }

  Widget buildInfo(String imdbid, double width, double height) {
    final Color accentColor = Theme.of(context).accentColor;
    final Brightness br = Theme.of(context).brightness;
    return Container(
      height: height * 0.25,
      width: width * 0.60,
      child: FutureBuilder(
        future: _imdb,
        builder: (BuildContext ctx, AsyncSnapshot<Imdb> snapshot) {
          if (snapshot.hasData) {
            plot = snapshot.data.plot;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: "Title : ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: br == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: snapshot.data.title,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: br == Brightness.dark
                                    ? Colors.white
                                    : Colors.black))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: "Rating : ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: br == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: snapshot.data.imdbRating,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: br == Brightness.dark
                                    ? Colors.white
                                    : Colors.black))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: "Year : ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: br == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: snapshot.data.year,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: br == Brightness.dark
                                    ? Colors.white
                                    : Colors.black))
                      ]),
                )
              ],
            );
          } else if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
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
        },
      ),
    );
  }
}

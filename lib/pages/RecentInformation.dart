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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/Imdb.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/LoadingWidget.dart';
import 'package:torrentsearch/widgets/TorrentCard.dart';

class RecentInformation extends StatefulWidget {
  final Map search;

  const RecentInformation(this.search);

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
    final double height = MediaQuery.of(context).size.height;
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    final double width = MediaQuery.of(context).size.width;
    final BorderRadius borderRadius = BorderRadius.circular(20);
    final Color accentColor = Theme.of(context).accentColor;
    final String baseUrl = preferenceProvider.baseUrl;
    final double blurRadius = 15.0;
    final ThemeData themeData = Theme.of(context);
    final TextStyle textStyle = themeData.textTheme.bodyText2
        .copyWith(fontWeight: FontWeight.normal, fontSize: 13.0);
    final TextStyle textStyleWithSize = themeData.textTheme.bodyText2.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    if (_imdb == null) {
      _imdb = getImdb(baseUrl, widget.search["imdbcode"]);
    }
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              title: FutureBuilder(
                future: _imdb,
                builder: (BuildContext ctx, AsyncSnapshot<Imdb> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.title,
                      style: TextStyle(letterSpacing: 2.0),
                    );
                  }
                  return Text(
                    "",
                    style: TextStyle(letterSpacing: 2.0),
                  );
                },
              ),
              centerTitle: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: width * 0.30,
                      height: height * 0.25,
                      margin: EdgeInsets.all(blurRadius),
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Colors.transparent,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 15.0,
                            offset: Offset(0.0, 0.50),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: widget.search["imgurl"],
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
                    buildInfo(widget.search["imdbcode"], width, height)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _imdb,
                    builder: (BuildContext ctx, AsyncSnapshot<Imdb> snapshot) {
                      if (snapshot.hasData) {
                        return RichText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: "Plot\n",
                              style: textStyleWithSize,
                              children: <TextSpan>[
                                TextSpan(
                                  text: snapshot.data.plot,
                                  style: textStyle,
                                )
                              ]),
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
                FutureBuilder<List<TorrentInfo>>(
                    future: getApiResponse(baseUrl, ApiConstants.TGX_ENDPOINT,
                        widget.search["imdbcode"]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data.map((e) {
                            return TorrentCard(e);
                          }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return ExceptionWidget(snapshot.error);
                      } else {
                        return LoadingWidget();
                      }
                    })
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfo(String imdbid, double width, double height) {
    final Brightness br = Theme.of(context).brightness;
    final TextStyle textStyle = TextStyle(
        color: br == Brightness.dark ? Colors.white : Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 13.0);
    final TextStyle textStyleWithSize = TextStyle(
      color: br == Brightness.dark ? Colors.white : Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
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
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Title\n",
                          style: textStyleWithSize,
                          children: <TextSpan>[
                            TextSpan(
                              text: snapshot.data.title,
                              style: textStyle,
                            )
                          ]),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Rating\n",
                          style: textStyleWithSize,
                          children: <TextSpan>[
                            TextSpan(
                              text: snapshot.data.imdbRating,
                              style: textStyle,
                            )
                          ]),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Year\n",
                        style: textStyleWithSize,
                        children: <TextSpan>[
                          TextSpan(
                            text: snapshot.data.year,
                            style: textStyle,
                          )
                        ]),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return ExceptionWidget(snapshot.error);
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}

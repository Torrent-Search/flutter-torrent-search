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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/utils/Preferences.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/Thumbnail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textEditingController;
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final Preferences pref = Preferences();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    final Color accentColor = Theme.of(context).accentColor;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/favourite");
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.history,
                      color: accentColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/history");
                    },
                  ),
                ],
                title: Text(
                  "Torrent Search",
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                centerTitle: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildSearch(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Movies",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        InkWell(
                          child: Text(
                            "View all",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/allrecents",
                                arguments: true);
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildRecent(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "TV Shows",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        InkWell(
                          child: Text(
                            "View all",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/allrecents",
                                arguments: false);
                          },
                        )
                      ],
                    ),
                  ),
                  _buildRecent(context, movies: false),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext ctx) {
    final ThemeData theme = Theme.of(context);
    final Color accentColor = theme.accentColor;
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    );
    final Color fillColor = theme.brightness == Brightness.dark
        ? Color(0xff424242)
        : Colors.black12;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              hintText: "Search Here",
              prefixIcon: Icon(
                Icons.search,
                color: accentColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _textEditingController.clear();
                },
                color: accentColor,
              ),
              contentPadding: EdgeInsets.all(10.0),
              border: inputBorder,
              focusedBorder: inputBorder,
            ),
            cursorColor: accentColor,
            keyboardType: TextInputType.text,
            maxLines: 1,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.search,
            onSubmitted: (term) {
              if (_textEditingController.text != "") {
                databaseHelper.insert(
                    history: History(_textEditingController.text));
                Navigator.pushNamed(context, "/result",
                    arguments: _textEditingController.text);
              }
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton.icon(
              label: Text(
                "SEARCH",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                if (_textEditingController.text != "") {
                  databaseHelper.insert(
                      history: History(_textEditingController.text));
                  Navigator.pushNamed(context, "/result",
                      arguments: _textEditingController.text);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: Text(
                "SETTINGS",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pushNamed(context, "/settings");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRecent(BuildContext ctx, {movies = true}) {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    final String baseUrl = preferenceProvider.baseUrl;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    final double height = MediaQuery.of(context).size.height;
    final Color accentColor = Theme.of(context).accentColor;
    return Container(
      height: height * 0.35,
      padding: EdgeInsets.only(left: 5.0),
      child: FutureBuilder<List<RecentInfo>>(
          future: movies ? getRecentMovies(baseUrl) : getRecentSeries(baseUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Thumbnail(snapshot.data[index], width: width * 0.40);
                },
              );
            } else if (snapshot.hasError) {
              return ExceptionWidget(snapshot.error);
            } else {
              return Center(
                  child: SpinKitThreeBounce(
                color: accentColor,
              ));
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}

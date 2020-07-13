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
import 'package:torrentsearch/pages/MusicHome.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int current_page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double height = mediaQueryData.size.height;
    final double width = mediaQueryData.size.width;
    final ThemeData themeData = Theme.of(context);
    final Color colorEnabled = themeData.accentColor;
    final Color colorDisabled = themeData.disabledColor;

    return Scaffold(
      appBar: _buildAppBar(themeData.accentColor),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              allowImplicitScrolling: false,
              physics: BouncingScrollPhysics(),
              onPageChanged: (int val) => setState(() {
                current_page = val;
              }),
              children: <Widget>[
                Torrent(),
                MusicHome(),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.public),
                        onPressed: () {
                          goToNextPage();
                        },
                        color: current_page == 0 ? colorEnabled : colorDisabled,
                      ),
                      IconButton(
                        icon: Icon(Icons.music_note),
                        onPressed: () {
                          goToNextPage();
                        },
                        color: current_page == 1 ? colorEnabled : colorDisabled,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    _pageController.animateToPage(current_page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  Widget _buildAppBar(Color accentColor) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.favorite,
          color: accentColor,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/favourite", arguments: current_page);
        },
      ),
      actions: <Widget>[
        current_page == 1
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.cloud_download,
                      color: accentColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/downloads");
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.history,
                      color: accentColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/history",
                          arguments: current_page);
                    },
                  ),
                ],
              )
            : IconButton(
                icon: Icon(
                  Icons.history,
                  color: accentColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/history",
                      arguments: current_page);
                },
              ),
      ],
      title: Text(
        current_page == 0 ? "Torrent Search" : "Music Search",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25.0, color: accentColor),
      ),
      centerTitle: true,
    );
  }
}

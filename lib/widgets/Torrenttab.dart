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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/LoadingWidget.dart';
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
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    final String baseUrl = preferenceProvider.baseUrl;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder<List<TorrentInfo>>(
              future: getApiResponse(baseUrl, widget.endpoint, widget.query),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      final TorrentInfo info = snapshot.data[index];
                      return TorrentCard(info //[index]
                          );
                    },
                  );
                } else if (snapshot.hasError) {
                  return ExceptionWidget(snapshot.error);
                } else {
                  return LoadingWidget();
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

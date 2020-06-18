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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';

class SearchHistory extends StatefulWidget {
  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).accentColor;
    final themeProvider = Provider.of<PreferenceProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.darkTheme
          ? Theme.of(context).backgroundColor
          : Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Search History",
          style: TextStyle(letterSpacing: 3.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: themeProvider.darkTheme ? Colors.white : Colors.black),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _databaseHelper.queryAll(history: true),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) {
                    History history = History.fromMap(snapshot.data[index]);
                    return Card(
                      elevation: 2.0,
                      child: ListTile(
                          title: Text(history.searchHistory),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _databaseHelper.delete(history.searchHistory,
                                      history: true);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/result",
                                      arguments: history.searchHistory);
                                },
                              ),
                            ],
                          )),
                    );
                  },
                );
              }
              return _buildNoSearchHistory();
            }
            return SpinKitThreeBounce(
              color: accentColor,
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoSearchHistory() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.history,
          size: 50.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "You haven't Searched anything yet",
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    ));
  }
}

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
                    return ListTile(
                      title: Text(history.searchHistory),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _databaseHelper.delete(history.searchHistory,
                              history: true);
                          setState(() {});
                        },
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/result",
                            arguments: history.searchHistory);
                      },
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

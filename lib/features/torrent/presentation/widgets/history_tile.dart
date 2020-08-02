import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/core/routes/routes.gr.dart';
import 'package:torrentsearch/features/torrent/data/database/database_helper.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    @required this.history,
  });

  final History history;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text(history.searchHistory),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                DatabaseHelper().delete(history.searchHistory, history: true);
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ExtendedNavigator.of(context).popAndPush(
                  "/result",
                  arguments:
                      TorrentResultArguments(query: history.searchHistory),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

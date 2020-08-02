import 'package:flutter/material.dart';
import 'package:torrentsearch/core/widget/loading_widget.dart';
import 'package:torrentsearch/features/torrent/data/database/database_helper.dart';
import 'package:torrentsearch/features/torrent/presentation/widgets/history_tile.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory();

  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DatabaseHelper().queryAll(history: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SEARCH HISTORY",
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: DatabaseHelper().streamController.stream,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length != 0) {
                return ListView.builder(
                  itemCount:
                      (snapshot.data as List<Map<String, dynamic>>).length,
                  itemBuilder: (ctx, index) {
                    final History history = History.fromMap(
                        snapshot.data[index] as Map<String, dynamic>);
                    return HistoryTile(history: history);
                  },
                );
              }
              return _buildNoSearchHistory();
            }
            return const LoadingWidget();
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
          const Icon(
            Icons.history,
            size: 50.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "You haven't Searched anything yet",
            style:
                Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20.0),
          )
        ],
      ),
    );
  }
}

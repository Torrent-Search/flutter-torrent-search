import 'package:flutter/material.dart';
import 'package:torrentsearch/core/widget/loading_widget.dart';
import 'package:torrentsearch/features/torrent/data/database/database_helper.dart';
import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';
import 'package:torrentsearch/features/torrent/presentation/widgets/torrent_tile.dart';

//  ignore_for_file:argument_type_not_assignable

class Favourite extends StatefulWidget {
  const Favourite();

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DatabaseHelper().queryAll(torrentinfo: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAVOURITE",
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
              ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: DatabaseHelper().streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              return ListView.builder(
                itemCount: (snapshot.data as List).length,
                itemBuilder: (ctx, index) {
                  return TorrentTile(
                    Torrent.fromMap(
                        (snapshot.data as List)[index] as Map<String, dynamic>),
                    favourite: true,
                  );
                },
              );
            }
            return _buildNoFavourite();
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildNoFavourite() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.favorite,
            size: 50.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "No Favourites added",
            style:
                Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20.0),
          )
        ],
      ),
    );
  }
}

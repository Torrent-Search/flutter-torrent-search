import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:torrentsearch/core/constants.dart';
import 'package:torrentsearch/core/widget/exception_widget.dart';
import 'package:torrentsearch/core/widget/loading_widget.dart';
import 'package:torrentsearch/features/torrent/presentation/bloc/torrent_bloc.dart';
import 'package:torrentsearch/features/torrent/presentation/widgets/torrent_tile.dart';
import 'package:torrentsearch/injector.dart';

class TorrentTab extends StatefulWidget {
  final String endpoint, query;
  const TorrentTab({@required this.endpoint, @required this.query});

  @override
  _TorrentTabState createState() => _TorrentTabState();
}

class _TorrentTabState extends State<TorrentTab>
    with AutomaticKeepAliveClientMixin {
  TorrentBloc _torrentBloc;
  int pageNo = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _torrentBloc = sl<TorrentBloc>();
    _torrentBloc
        .add(GetTorrentEvent(widget.endpoint, widget.query, pageNo: pageNo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TorrentBloc, TorrentState>(
      bloc: _torrentBloc,
      builder: (context, state) {
        if (state is TorrentLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: calculateItemCount(),
            itemBuilder: (BuildContext context, int index) {
              if (!state.reachedMax && index >= state.torrents.length) {
                if (state.loading) return const CupertinoActivityIndicator();
                return _buildLoadMoreButton();
              }
              return TorrentTile(state.torrents[index]);
            },
          );
        }
        if (state is TorrentErrorState) {
          return ExceptionWidget(state.exception);
        }
        return const LoadingWidget();
      },
    );
  }

  @override
  void dispose() {
    _torrentBloc.dispose();
    super.dispose();
  }

  int calculateItemCount() {
    final TorrentLoaded torrentLoaded = _torrentBloc.state as TorrentLoaded;

    switch (widget.endpoint) {
      case Constants.ENDPOINT_1337x:
      case Constants.HORRIBLESUBS_ENDPOINT:
      case Constants.KICKASS_ENDPOINT:
      case Constants.LIMETORRENTS_ENDPOINT:
      case Constants.NYAA_ENDPOINT:
      case Constants.SKYTORRENT_ENDPOINT:
      case Constants.TORRENTDOWNLOADS_ENDPOINT:
      case Constants.ZOOQLE:
        if (!torrentLoaded.reachedMax) {
          return torrentLoaded.torrents.length + 1;
        } else {
          return torrentLoaded.torrents.length;
        }
        break;
    }
    return torrentLoaded.torrents.length;
  }

  Padding _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: RaisedButton(
        onPressed: () {
          if (_torrentBloc.state is TorrentLoaded) {
            if (!(_torrentBloc.state as TorrentLoaded).loading) {
              pageNo++;
              _torrentBloc.add(GetNextPageEvent(widget.endpoint, widget.query,
                  pageNo: pageNo));
            }
          }
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: const Text(
          "Load More",
          style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

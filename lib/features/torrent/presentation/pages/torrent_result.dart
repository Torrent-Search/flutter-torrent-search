import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/core/constants.dart';
import 'package:torrentsearch/features/torrent/presentation/widgets/torrent_tab.dart';

class TorrentResult extends StatefulWidget {
  final String query;

  const TorrentResult({@required this.query});

  @override
  _TorrentResultState createState() => _TorrentResultState();
}

class _TorrentResultState extends State<TorrentResult>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: Constants.INDEXERS.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Results",
          style: TextStyle(
            fontFamily: "OpenSans",
            color: Colors.white,
          ),
        ),
        backgroundColor: accentColor,
        bottom: TabBar(
          labelColor: accentColor,
          isScrollable: true,
          tabs: Constants.INDEXERS.map((e) => Text(e)).toList(),
          controller: tabController,
        ),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      ),
      body: SafeArea(
        child: ExtendedTabBarView(
          controller: tabController,
          cacheExtent: Constants.INDEXERS.length,
          physics: const BouncingScrollPhysics(),
          children: [
            TorrentTab(
              endpoint: Constants.ENDPOINT_1337x,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.EZTV_TORRENT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.KICKASS_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.LIMETORRENTS_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.SKYTORRENT_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.TPB_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.TORRENTDOWNLOADS_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.TGX_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.YTS_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.ZOOQLE,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.NYAA_ENDPOINT,
              query: widget.query,
            ),
            TorrentTab(
              endpoint: Constants.HORRIBLESUBS_ENDPOINT,
              query: widget.query,
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Results"),
  //       bottom: TabBar(
  //         labelColor: Theme.of(context).accentColor,
  //         isScrollable: true,
  //         tabs: [
  //           const Text("1337x"),
  //         ],
  //         controller: tabController,
  //       ),
  //     ),
  //     body: TabBarView(
  //       controller: tabController,
  //       children: [
  //         TorrentTab(endpoint: Constants.ENDPOINT_1337x, query: widget.query),
  //       ],
  //     ),
  //   );
  // }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

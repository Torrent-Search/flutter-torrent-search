import 'package:extended_tabs/extended_tabs.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/widgets/Torrenttab.dart';

class TorrentResult extends StatefulWidget {
  @override
  _TorrentResultState createState() => _TorrentResultState();
}

class _TorrentResultState extends State<TorrentResult> {

  bool _isSnackbarShown = false;
  @override
  void initState() {
  }
  @override
  Widget build(BuildContext context) {
    String search = ModalRoute.of(context).settings.arguments;
      return SafeArea(
        child: DefaultTabController(
          length: 12,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Theme.of(context).accentColor,
              title: Text(
                  'RESULTS',
                  style:TextStyle(
                    color: Colors.white,
                    letterSpacing: 3.0
                  ),
              ),
              centerTitle: true,
              bottom: TabBar(
                labelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).accentColor,
                isScrollable: true,
                tabs: <Widget>[
                  Text("1337x"),
                  Text("EZTV"),
                  Text("Kickass"),
                  Text("Limetorrents"),
                  Text("Rarbg"),
                  Text("Skytorrents"),
                  Text("The Pirate Bay"),
                  Text("Torrent Download"),
                  Text("Torrent Galaxy"),
                  Text("YTS"),
                  Text("Nyaa"),
                  Text("Horriblesubs"),
                ],
              ),
            ),
            body: ExtendedTabBarView(
              children: <Widget>[
                Torrenttab(ApiConstants.ENDPOINT_1337x,search),
                Torrenttab(ApiConstants.EZTV_TORRENT,search),
                Torrenttab(ApiConstants.KICKASS_ENDPOINT,search),
                Torrenttab(ApiConstants.LIMETORRENTS_ENDPOINT,search),
                Torrenttab(ApiConstants.RARBG_ENDPOINT,search),
                Torrenttab(ApiConstants.SKYTORRENT_ENDPOINT,search),
                Torrenttab(ApiConstants.TPB_ENDPOINT,search),
                Torrenttab(ApiConstants.TORRENTDOWNLOADS_ENDPOINT,search),
                Torrenttab(ApiConstants.TGX_ENDPOINT,search),
                Torrenttab(ApiConstants.YTS_ENDPOINT,search),
                Torrenttab(ApiConstants.NYAA_ENDPOINT,search),
                Torrenttab(ApiConstants.HORRIBLESUBS_ENDPOINT,search),
              ],
              cacheExtent: 12,
            ),
          ),
        ),
      );
  }

  void showFlushbar(BuildContext context){
    Flushbar(
      message: "Tap on List Item to Copy/Share Magnet Link",
      duration: Duration(seconds: 4),
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }


}

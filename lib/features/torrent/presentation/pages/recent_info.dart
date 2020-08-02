//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:torrentsearch/core/widget/loading_widget.dart';
//import 'package:torrentsearch/features/torrent/domain/entities/recent_data.dart';
//import 'package:torrentsearch/features/torrent/presentation/bloc/torrent_bloc.dart';
//import 'package:torrentsearch/features/torrent/presentation/widgets/torrent_thumbnail.dart';
//import 'package:torrentsearch/features/torrent/presentation/widgets/torrent_tile.dart';
//import 'package:torrentsearch/injector.dart';
//
//class RecentInfo extends StatefulWidget {
//  final String imdbCode;
//
//  const RecentInfo(this.imdbCode);
//
//  @override
//  _RecentInfoState createState() => _RecentInfoState();
//}
//
//class _RecentInfoState extends State<RecentInfo> {
//  TorrentBloc _torrentBloc;
//
//  @override
//  Widget build(BuildContext context) {
//    return BlocBuilder<TorrentBloc, TorrentState>(
//        bloc: _torrentBloc,
//        builder: (BuildContext context, TorrentState state) {
//          if (state is TorrentRecentDataLoaded) {
//            return _buildBody();
//          }
//          if (state is TorrentErrorState) {
//            return _buildScaffoldedWidget(ErrorWidget(state.exception));
//          }
//          return _buildScaffoldedWidget(const LoadingWidget());
//        });
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    if (_torrentBloc == null) {
//      _torrentBloc = sl<TorrentBloc>();
//      _torrentBloc.add(GetRecentDataEvent(widget.imdbCode));
//    }
//  }
//
//  Widget _buildBody() {
//    final MediaQueryData mediaQueryData = MediaQuery.of(context);
//    final width = mediaQueryData.size.width;
//    final height = mediaQueryData.size.height;
//    final TextStyle textStyle = Theme.of(context)
//        .textTheme
//        .bodyText2
//        .copyWith(fontWeight: FontWeight.normal, fontSize: 13.0);
//    final TextStyle textStyleWithSize = textStyle.copyWith(
//      fontSize: 15,
//      fontWeight: FontWeight.bold,
//    );
//    final RecentDataWithImdb data =
//        (_torrentBloc.state as TorrentRecentDataLoaded).recentData;
//    return Scaffold(
//      body: SafeArea(
//        child: CustomScrollView(
//          slivers: <Widget>[
//            SliverAppBar(
//              title: Text(data.imdbInfo.title),
//              centerTitle: true,
//              floating: true,
//            ),
//            SliverList(
//              delegate: SliverChildListDelegate(
//                [
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      TorrentThumbnail(
//                        width: width * 0.30,
//                        height: height * 0.25,
//                        imageUrl: data.imdbInfo.poster,
//                      ),
//                      buildInfo(data.imdbInfo, width, height),
//                    ],
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RichText(
//                      textAlign: TextAlign.center,
//                      maxLines: 3,
//                      overflow: TextOverflow.ellipsis,
//                      text: TextSpan(
//                        text: "Plot\n",
//                        style: textStyleWithSize,
//                        children: <TextSpan>[
//                          TextSpan(
//                            text: data.imdbInfo.plot,
//                            style: textStyle,
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  Column(
//                    children: data.list
//                        .map((e) => TorrentTile(e))
//                        .toList(growable: false),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget buildInfo(Imdb imdb, double width, double height) {
//    final Brightness br = Theme.of(context).brightness;
//    final TextStyle textStyle = TextStyle(
//        color: br == Brightness.dark ? Colors.white : Colors.black,
//        fontWeight: FontWeight.normal,
//        fontSize: 13.0);
//    final TextStyle textStyleWithSize = TextStyle(
//      color: br == Brightness.dark ? Colors.white : Colors.black,
//      fontSize: 15,
//      fontWeight: FontWeight.bold,
//    );
//    return Container(
//      height: height * 0.25,
//      width: width * 0.60,
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              RichText(
//                textAlign: TextAlign.center,
//                text: TextSpan(
//                  text: "Title\n",
//                  style: textStyleWithSize,
//                  children: <TextSpan>[
//                    TextSpan(
//                      text: imdb.title,
//                      style: textStyle,
//                    ),
//                  ],
//                ),
//              ),
//              RichText(
//                textAlign: TextAlign.center,
//                text: TextSpan(
//                  text: "Rating\n",
//                  style: textStyleWithSize,
//                  children: <TextSpan>[
//                    TextSpan(
//                      text: imdb.imdbRating,
//                      style: textStyle,
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//          const SizedBox(height: 15.0),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              RichText(
//                textAlign: TextAlign.center,
//                text: TextSpan(
//                  text: "Year\n",
//                  style: textStyleWithSize,
//                  children: <TextSpan>[
//                    TextSpan(
//                      text: imdb.year,
//                      style: textStyle,
//                    ),
//                  ],
//                ),
//              ),
//              RichText(
//                textAlign: TextAlign.center,
//                text: TextSpan(
//                  text: "Runtime\n",
//                  style: textStyleWithSize,
//                  children: <TextSpan>[
//                    TextSpan(
//                      text: imdb.runtime,
//                      style: textStyle,
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _buildScaffoldedWidget(Widget widget) =>
//      Scaffold(appBar: AppBar(), body: widget);
//
//  @override
//  void dispose() {
//    _torrentBloc.dispose();
//    super.dispose();
//  }
//}

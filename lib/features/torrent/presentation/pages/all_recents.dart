//import 'package:auto_route/auto_route.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:torrentsearch/core/routes/routes.gr.dart';
//import 'package:torrentsearch/core/widget/exception_widget.dart';
//import 'package:torrentsearch/core/widget/loading_widget.dart';
//import 'package:torrentsearch/features/torrent/domain/entities/recent.dart';
//import 'package:torrentsearch/features/torrent/presentation/bloc/torrent_bloc.dart';
//import 'package:torrentsearch/features/torrent/presentation/widgets/torrent_thumbnail.dart';
//import 'package:torrentsearch/injector.dart';
//
//class AllRecents extends StatefulWidget {
//  final bool movies;
//
//  const AllRecents(this.movies);
//
//  @override
//  _AllRecentsState createState() => _AllRecentsState();
//}
//
//class _AllRecentsState extends State<AllRecents> {
//  TorrentBloc _torrentBloc;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    if (_torrentBloc == null) {
//      _torrentBloc = sl<TorrentBloc>();
//      _torrentBloc.add(
//        GetSpecificRecentEvent(movie: widget.movies),
//      );
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final MediaQueryData mediaQueryData = MediaQuery.of(context);
//    final double width = mediaQueryData.size.width;
//    final double height = mediaQueryData.size.height;
//    final Orientation orientation = mediaQueryData.orientation;
//    return Scaffold(
//      body: SafeArea(
//        child: CustomScrollView(
//          physics: const BouncingScrollPhysics(),
//          slivers: <Widget>[
//            SliverAppBar(
//              title: Text(
//                widget.movies ? "Movies" : "TV Shows",
//              ),
//              centerTitle: true,
//              floating: true,
//            ),
//            BlocProvider(
//              create: (context) => _torrentBloc,
//              child: BlocBuilder<TorrentBloc, TorrentState>(
//                builder: (BuildContext context, TorrentState state) {
//                  if (state is TorrentSpecificRecentDataLoaded) {
//                    return _buildBody(
//                        orientation, width, height, state.recentData);
//                  } else if (state is TorrentErrorState) {
//                    return SliverFillRemaining(
//                        child: ExceptionWidget(state.exception));
//                  } else {
//                    return const SliverFillRemaining(child: LoadingWidget());
//                  }
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  SliverPadding _buildBody(Orientation orientation, double width, double height,
//      List<RecentData> list) {
//    return SliverPadding(
//      padding: const EdgeInsets.symmetric(horizontal: 10.0),
//      sliver: SliverGrid.count(
//        crossAxisCount: Orientation.portrait == orientation ? 2 : 3,
//        mainAxisSpacing: 5.0,
//        crossAxisSpacing: 5.0,
//        childAspectRatio: (width / 2) / ((height / 2) - height * 0.1),
//        children: list.map((e) {
//          return TorrentThumbnail(
//            imageUrl: e.imgUrl,
//            onTap: () => ExtendedNavigator.of(context).push("/recent",
//                arguments: RecentInfoArguments(imdbCode: e.imdbcode)),
//          );
//        }).toList(growable: false),
//      ),
//    );
//  }
//
//  @override
//  void dispose() {
//    _torrentBloc.dispose();
//    super.dispose();
//  }
//}

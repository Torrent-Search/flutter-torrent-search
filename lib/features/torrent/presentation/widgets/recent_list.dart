//import 'package:auto_route/auto_route.dart';
//import 'package:flutter/material.dart';
//import 'package:torrentsearch/core/routes/routes.gr.dart';
//import 'package:torrentsearch/features/torrent/domain/entities/recent.dart';
//import 'package:torrentsearch/features/torrent/presentation/widgets/torrent_thumbnail.dart';
//import 'package:meta/meta.dart';
//
//class RecentList extends StatelessWidget {
//  final List<RecentData> list;
//
//  const RecentList({@required this.list});
//
//  @override
//  Widget build(BuildContext context) {
//    final width = MediaQuery.of(context).size.width;
//    final height = MediaQuery.of(context).size.height * 0.35;
//
//    return Container(
//      width: width,
//      height: height,
//      child: ListView.builder(
//        shrinkWrap: true,
//        scrollDirection: Axis.horizontal,
//        itemBuilder: (context, index) => TorrentThumbnail(
//          imageUrl: list[index].imgUrl,
//          imdbCode: list[index].imdbcode,
//          width: width * 0.35,
//          onTap: () => ExtendedNavigator.of(context).push("/recent",
//              arguments: RecentInfoArguments(imdbCode: list[index].imdbcode)),
//        ),
//        itemCount: list.length,
//      ),
//    );
//  }
//}

import 'package:flutter/material.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String url;
  final double height, width;

  SliverHeaderDelegate({this.url, this.height, this.width});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      width: width,
      child: Center(
        child: MusicThumbnail(
          url: url,
        ),
      ),
    );
  }

  @override
  double get maxExtent => this.height ?? 280.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

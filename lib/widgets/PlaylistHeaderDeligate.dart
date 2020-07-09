import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:torrentsearch/widgets/MusicThumbnail.dart';

class PlaylistHeaderDeligate implements SliverPersistentHeaderDelegate {
  final String url;
  final String name;
  final double extent;

  PlaylistHeaderDeligate(this.url, this.name, this.extent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: MusicThumbnail(
                url: url,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 2.0,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration get snapConfiguration => snapConfiguration;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      stretchConfiguration;
}

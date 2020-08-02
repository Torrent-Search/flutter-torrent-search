import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:torrentsearch/core/widget/loading_widget.dart';

class TorrentThumbnail extends StatelessWidget {
  static const blurRadius = 15.0;
  static const containerMargin = EdgeInsets.all(blurRadius + 5.0);
  final String imageUrl, imdbCode;
  final double height, width;
  final void Function() onTap;

  const TorrentThumbnail(
      {@required this.imageUrl,
      this.imdbCode,
      this.height,
      this.width,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);

    final shadowColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff424242)
        : Colors.black54;
    final boxDecoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(0.0, 0.50),
          blurRadius: blurRadius,
        ),
      ],
    );

    return InkWell(
      onTap: onTap ?? () => null,
      borderRadius: borderRadius,
      child: Container(
        margin: containerMargin,
        decoration: boxDecoration,
        width: width,
        child: InkWell(
          child: ClipRRect(
            borderRadius: borderRadius,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, progress) =>
                  const LoadingWidget(),
            ),
          ),
        ),
      ),
    );
  }
}

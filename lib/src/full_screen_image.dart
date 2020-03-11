import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String url;

  const FullScreenImage({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(url),
        maxScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(
          tag: url,
        ),
      ),
    );
  }
}

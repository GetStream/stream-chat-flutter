import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// A full screen image widget
class FullScreenImage extends StatelessWidget {
  /// The url of the image
  final String url;

  /// Instantiate a new FullScreenImage
  const FullScreenImage({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: PhotoView(
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

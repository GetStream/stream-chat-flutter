import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreamSvgIcon extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  final Color color;

  const StreamSvgIcon({
    this.assetName,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final key = Key('StreamSvgIcon-$assetName');
    return kIsWeb
        ? Image.network(
            'packages/stream_chat_flutter/svgs/$assetName',
            width: width,
            height: height,
            key: key,
            color: color,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          )
        : SvgPicture.asset(
            'lib/svgs/$assetName',
            package: 'stream_chat_flutter',
            key: key,
            width: width,
            height: height,
            fit: BoxFit.cover,
            color: color,
            alignment: Alignment.center,
          );
  }
}

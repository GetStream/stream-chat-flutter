import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreamSvgIcon extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  final Color color;

  const StreamSvgIcon({
    Key key,
    this.assetName,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
            'packages/stream_chat_flutter/svgs/$assetName',
            width: width,
            height: height,
            color: color,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          )
        : SvgPicture.asset(
            'lib/svgs/$assetName',
            package: 'stream_chat_flutter',
            width: width,
            height: height,
            fit: BoxFit.cover,
            color: color,
            alignment: Alignment.center,
          );
  }
}

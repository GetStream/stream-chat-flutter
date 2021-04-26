import 'package:flutter/material.dart';

import 'stream_chat_theme.dart';

class UploadProgressIndicator extends StatelessWidget {
  final int uploaded;
  final int total;
  late final Color progressIndicatorColor;
  final EdgeInsetsGeometry padding;
  final bool showBackground;
  final TextStyle? textStyle;

  UploadProgressIndicator({
    Key? key,
    required this.uploaded,
    required this.total,
    Color? progressIndicatorColor,
    this.padding = const EdgeInsets.only(
      top: 5,
      bottom: 5,
      right: 11,
      left: 5,
    ),
    this.showBackground = true,
    this.textStyle,
  })  : progressIndicatorColor =
            progressIndicatorColor ?? const Color(0xffb2b2b2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final _percentage = (uploaded / total) * 100;
    Widget child = Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(progressIndicatorColor),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${_percentage.toInt()}%',
            style: textStyle ??
                theme.textTheme.footnote.copyWith(
                  color: theme.colorTheme.white,
                ),
          ),
        ],
      ),
    );
    if (showBackground) {
      child = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorTheme.overlayDark.withOpacity(0.6),
        ),
        child: child,
      );
    }
    return child;
  }
}

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget for showing upload progress
class UploadProgressIndicator extends StatelessWidget {
  /// Constructor for creating an [UploadProgressIndicator]
  const UploadProgressIndicator({
    Key? key,
    required this.uploaded,
    required this.total,
    this.progressIndicatorColor = const Color(0xffb2b2b2),
    this.padding = const EdgeInsets.only(
      top: 5,
      bottom: 5,
      right: 11,
      left: 5,
    ),
    this.showBackground = true,
    this.textStyle,
  }) : super(key: key);

  /// Bytes uploaded
  final int uploaded;

  /// Total bytes
  final int total;

  /// Color of progress indicator
  final Color progressIndicatorColor;

  /// Padding for widget
  final EdgeInsetsGeometry padding;

  /// Flag for showing background
  final bool showBackground;

  /// [TextStyle] to be applied to text
  final TextStyle? textStyle;

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
          const SizedBox(width: 8),
          Text(
            '${_percentage.toInt()}%',
            style: textStyle ??
                theme.textTheme.footnote.copyWith(
                  color: theme.colorTheme.barsBg,
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

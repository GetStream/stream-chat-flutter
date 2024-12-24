import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUploadProgressIndicator}
/// Shows the upload progress of an attachment.
/// {@endtemplate}
class StreamUploadProgressIndicator extends StatelessWidget {
  /// {@macro streamUploadProgressIndicator}
  const StreamUploadProgressIndicator({
    super.key,
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
  });

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
            child: CircularProgressIndicator.adaptive(
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
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          color: theme.colorTheme.overlayDark.withOpacity(0.6),
        ),
        child: child,
      );
    }
    return child;
  }
}

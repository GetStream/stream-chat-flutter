import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template attachmentError}
/// Widget for building in case of error
/// {@endtemplate}
class AttachmentError extends StatelessWidget {
  /// {@macro attachmentError}
  const AttachmentError({
    Key? key,
    this.size,
  }) : super(key: key);

  /// Size of error
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size?.width,
        height: size?.height,
        color:
            StreamChatTheme.of(context).colorTheme.accentError.withOpacity(0.1),
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
          ),
        ),
      ),
    );
  }
}

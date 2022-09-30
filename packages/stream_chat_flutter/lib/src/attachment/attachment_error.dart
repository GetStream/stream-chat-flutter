import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template attachmentError}
/// Widget for building in case of error
/// {@endtemplate}
class AttachmentError extends StatelessWidget {
  /// {@macro attachmentError}
  const AttachmentError({
    super.key,
    this.constraints,
  });

  /// constraints of error
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: constraints ?? const BoxConstraints.expand(),
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

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamProgressIndicator}
/// A simple progress indicator that can be used in place of the default
/// [CircularProgressIndicator] in the Stream Chat widgets.
/// {@endtemplate}
class StreamLoadingIndicator extends StatelessWidget {
  /// {@macro streamProgressIndicator}
  const StreamLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final color = StreamChatTheme.of(context).colorTheme.accentPrimary;
    return CircularProgressIndicator.adaptive(
      strokeWidth: 2,
      backgroundColor: color,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template StreamVoiceRecordingLoading}
/// Loading widget for audio message. Use this when the url from the audio
/// message is still not available. One use situation in when the audio is
/// still being uploaded.
/// {@endtemplate}
class StreamVoiceRecordingLoading extends StatelessWidget {
  /// {@macro StreamVoiceRecordingLoading}
  const StreamVoiceRecordingLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context).voiceRecordingTheme.loadingTheme;

    return Padding(
      padding: theme.padding!,
      child: SizedBox(
        height: theme.size!.height,
        width: theme.size!.width,
        child: CircularProgressIndicator(
          strokeWidth: theme.strokeWidth!,
          color: theme.color,
        ),
      ),
    );
  }
}

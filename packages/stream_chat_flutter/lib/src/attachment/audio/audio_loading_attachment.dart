import 'package:flutter/material.dart';

/// {@template AudioLoadingMessage}
/// Loading widget for audio message. Use this when the url from the audio
/// message is still now available. One use situation in when the audio is
/// still being uploaded.
/// {@endtemplate}
class AudioLoadingMessage extends StatelessWidget {
  /// {@macro AudioLoadingMessage}
  const AudioLoadingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.mic),
          ),
        ],
      ),
    );
  }
}

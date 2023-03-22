import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/attachment/audio/audio_player_attachment.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Docs
class AudioPlayerSingleAudio extends StatelessWidget {
  /// Docs
  const AudioPlayerSingleAudio({
    super.key,
    required this.attachment,
    this.actionButton,
  });

  /// Docs
  final Attachment attachment;

  /// Docs
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    final audioFilePath = attachment.file?.path;
    Widget playerMessage;

    final player = AudioPlayer();

    if (attachment.file?.path != null) {
      player.setAudioSource(AudioSource.file(audioFilePath!));
    } else if (attachment.assetUrl != null) {
      player.setAudioSource(AudioSource.uri(Uri.parse(attachment.assetUrl!)));
    }

    Duration duration;
    if (attachment.extraData['duration'] != null) {
      duration =
          Duration(milliseconds: attachment.extraData['duration']! as int);
    } else {
      duration = Duration.zero;
    }

    List<double> waveBars;
    if (attachment.extraData['waveList'] != null) {
      waveBars = (attachment.extraData['waveList']! as List<dynamic>)
          .map((e) => double.tryParse(e.toString()))
          .whereNotNull()
          .toList();
    } else {
      waveBars = List.filled(60, 0);
    }

    playerMessage = AudioPlayerMessage(
      player: player,
      duration: duration,
      waveBars: waveBars,
      fileSize: attachment.fileSize,
      actionButton: actionButton,
      singleAudio: true,
    );

    final colorTheme = StreamChatTheme.of(context).colorTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorTheme.barsBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorTheme.borders,
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.65,
      child: playerMessage,
    );
  }
}

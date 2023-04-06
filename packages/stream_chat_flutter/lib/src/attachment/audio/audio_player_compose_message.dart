import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/attachment/audio/audio_player_attachment.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template audioListPlayer}
/// AudioPlayer intended to be used inside message composer. This audio player
/// plays only one music at a time.
/// {@endtemplate}
class AudioPlayerComposeMessage extends StatefulWidget {
  /// {@macro audioListPlayer}
  const AudioPlayerComposeMessage({
    super.key,
    required this.attachment,
    this.actionButton,
  });

  /// Attachment of the audio
  final Attachment attachment;

  /// An action button to that can be used to perform actions. Example: Delete
  /// audio from compose.
  final Widget? actionButton;

  @override
  State<AudioPlayerComposeMessage> createState() =>
      _AudioPlayerComposeMessageState();
}

class _AudioPlayerComposeMessageState extends State<AudioPlayerComposeMessage> {
  final _player = AudioPlayer();
  StreamSubscription<PlayerState>? stateSubscription;

  @override
  Widget build(BuildContext context) {
    final audioFilePath = widget.attachment.file?.path;
    Widget playerMessage;

    if (widget.attachment.file?.path != null) {
      _player.setAudioSource(AudioSource.file(audioFilePath!));
    } else if (widget.attachment.assetUrl != null) {
      _player.setAudioSource(
        AudioSource.uri(Uri.parse(widget.attachment.assetUrl!)),
      );
    }

    Duration duration;
    if (widget.attachment.extraData['duration'] != null) {
      duration = Duration(
        milliseconds: widget.attachment.extraData['duration']! as int,
      );
    } else {
      duration = Duration.zero;
    }

    List<double> waveBars;
    if (widget.attachment.extraData['waveList'] != null) {
      waveBars = (widget.attachment.extraData['waveList']! as List<dynamic>)
          .map((e) => double.tryParse(e.toString()))
          .whereNotNull()
          .toList();
    } else {
      waveBars = List.filled(60, 0);
    }

    stateSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _player.stop().then((value) => _player.seek(Duration.zero, index: 0));
      }
    });

    playerMessage = AudioPlayerMessage(
      player: _player,
      duration: duration,
      waveBars: waveBars,
      fileSize: widget.attachment.fileSize,
      actionButton: widget.actionButton,
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

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
    stateSubscription?.cancel();
  }
}

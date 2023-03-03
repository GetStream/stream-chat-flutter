import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/attachment/audio_loading_attachment.dart';
import 'package:stream_chat_flutter/src/attachment/audio_player_attachment.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Docs
class AudioPlayerWrapper extends StatefulWidget {
  /// Docs
  const AudioPlayerWrapper({
    super.key,
    required this.attachments,
    this.attachmentBorderRadiusGeometry,
    this.constraints,
  });

  /// Docs
  final List<Attachment> attachments;

  /// {@template attachmentBorderRadiusGeometry}
  /// The border radius of an attachment
  /// {@endtemplate}
  final BorderRadiusGeometry? attachmentBorderRadiusGeometry;

  /// Contraints of attachments
  final BoxConstraints? constraints;

  @override
  State<AudioPlayerWrapper> createState() => _AudioPlayerWrapperState();
}

class _AudioPlayerWrapperState extends State<AudioPlayerWrapper> {
  final _player = AudioPlayer();
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  Widget _createAudioPlayer(int index, Attachment attachment) {
    final url = attachment.assetUrl;
    Widget playerMessage;

    if (url == null) {
      playerMessage = const AudioLoadingMessage();
    } else {
      playerMessage = AudioPlayerMessage(player: _player, index: index);
    }

    final colorTheme = StreamChatTheme.of(context).colorTheme;

    return Container(
      margin: const EdgeInsets.all(2),
      constraints: widget.constraints,
      decoration: BoxDecoration(
        color: colorTheme.barsBg,
        border: Border.all(
          color: colorTheme.borders,
        ),
        borderRadius:
            widget.attachmentBorderRadiusGeometry ?? BorderRadius.circular(10),
      ),
      child: playerMessage,
    );
  }

  void _playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await _player.stop();
      await _player.seek(Duration.zero, index: 0);
    }
  }

  @override
  void initState() {
    super.initState();

    final playList = widget.attachments
        .where((attachment) => attachment.assetUrl != null)
        .map((attachment) => AudioSource.uri(Uri.parse(attachment.assetUrl!)))
        .toList();

    final audioSource = ConcatenatingAudioSource(children: playList);

    _player
      ..setShuffleModeEnabled(false)
      ..setLoopMode(LoopMode.off)
      ..setAudioSource(audioSource);
  }

  @override
  void dispose() {
    super.dispose();

    _playerStateChangedSubscription.cancel();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _playerStateChangedSubscription =
        _player.playerStateStream.listen(_playerStateListener);

    return Column(
      children: widget.attachments.mapIndexed(_createAudioPlayer).toList(),
    );
  }
}

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template StreamVoiceRecordingListPlayer}
/// Display many audios and displays a list of AudioPlayerMessage.
/// {@endtemplate}
@Deprecated('Use StreamVoiceRecordingAttachmentPlaylist instead')
class StreamVoiceRecordingListPlayer extends StatefulWidget {
  /// {@macro StreamVoiceRecordingListPlayer}
  const StreamVoiceRecordingListPlayer({
    super.key,
    required this.playList,
    this.attachmentBorderRadiusGeometry,
    this.constraints,
  });

  /// List of audio attachments.
  final List<PlayListItem> playList;

  /// The border radius of each audio.
  final BorderRadiusGeometry? attachmentBorderRadiusGeometry;

  /// Constraints of audio attachments
  final BoxConstraints? constraints;

  @override
  State<StreamVoiceRecordingListPlayer> createState() =>
      _StreamVoiceRecordingListPlayerState();
}

@Deprecated("Use 'StreamVoiceRecordingAttachmentPlaylist' instead")
class _StreamVoiceRecordingListPlayerState
    extends State<StreamVoiceRecordingListPlayer> {
  final _player = AudioPlayer();
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  Widget _createAudioPlayer(int index, PlayListItem item) {
    final url = item.assetUrl;
    Widget child;

    if (url == null) {
      child = const StreamVoiceRecordingLoading();
    } else {
      child = StreamVoiceRecordingPlayer(
        player: _player,
        duration: item.duration,
        waveBars: item.waveForm,
        index: index,
      );
    }

    final theme =
        StreamChatTheme.of(context).voiceRecordingTheme.listPlayerTheme;

    return Container(
      margin: theme.margin,
      constraints: widget.constraints,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: Border.all(
          color: theme.borderColor!,
        ),
        borderRadius:
            widget.attachmentBorderRadiusGeometry ?? theme.borderRadius,
      ),
      child: child,
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

    _playerStateChangedSubscription =
        _player.playerStateStream.listen(_playerStateListener);
  }

  @override
  void dispose() {
    super.dispose();

    _playerStateChangedSubscription.cancel();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playList = widget.playList
        .where((attachment) => attachment.assetUrl != null)
        .map((attachment) => AudioSource.uri(Uri.parse(attachment.assetUrl!)))
        .toList();

    final audioSource = ConcatenatingAudioSource(children: playList);

    _player
      ..setShuffleModeEnabled(false)
      ..setLoopMode(LoopMode.off)
      ..setAudioSource(audioSource, preload: false);

    return Column(
      children: widget.playList.mapIndexed(_createAudioPlayer).toList(),
    );
  }
}

/// {@template PlayListItem}
/// Represents an audio attachment meta data.
/// {@endtemplate}
class PlayListItem {
  /// {@macro PlayListItem}
  const PlayListItem({
    this.assetUrl,
    required this.duration,
    required this.waveForm,
  });

  /// The url of the audio.
  final String? assetUrl;

  /// The duration of the audio.
  final Duration duration;

  /// The wave form of the audio.
  final List<double> waveForm;
}

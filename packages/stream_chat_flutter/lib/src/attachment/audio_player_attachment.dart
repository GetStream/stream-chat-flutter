import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/attachment/audio_loading_attachment.dart';

/// Docs
class AudioPlayerMessage extends StatefulWidget {
  /// Docs
  const AudioPlayerMessage({
    super.key,
    required this.source,
    required this.id,
  });

  /// Docs
  final AudioSource source;

  /// Docs
  final String id;

  @override
  AudioPlayerMessageState createState() => AudioPlayerMessageState();
}

/// Docs
class AudioPlayerMessageState extends State<AudioPlayerMessage> {
  final _audioPlayer = AudioPlayer();

  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  /// Docs
  late Future<Duration?> futureDuration;

  @override
  void initState() {
    super.initState();

    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen(playerStateListener);

    futureDuration = _audioPlayer.setAudioSource(
      widget.source,
      initialPosition: Duration.zero,
    );
  }

  /// Docs
  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await reset();
    }
  }

  /// Docs
  void onError(Object e, StackTrace st) {
    if (e is PlayerException) {
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
    } else {
      print('An error occurred: $e');
    }
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Duration?>(
      future: futureDuration,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _controlButtons(),
              _slider(snapshot.data),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Error!!');
        } else {
          return const AudioLoadingMessage();
        }
      },
    );
  }

  Widget _controlButtons() {
    return StreamBuilder<bool>(
      stream: _audioPlayer.playingStream,
      builder: (context, _) {
        final color =
            _audioPlayer.playerState.playing ? Colors.red : Colors.blue;
        final icon =
            _audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow;
        return Padding(
          padding: const EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () {
              if (_audioPlayer.playerState.playing) {
                pause();
              } else {
                play();
              }
            },
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, color: color, size: 30),
            ),
          ),
        );
      },
    );
  }

  Widget _slider(Duration? duration) {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && duration != null) {
          return CupertinoSlider(
            value: min(
              snapshot.data!.inMicroseconds / duration.inMicroseconds,
              1,
            ),
            onChangeStart: (val) {
              if (_audioPlayer.playing) {
                _audioPlayer.pause();
              }
            },
            onChangeEnd: (val) {
              _audioPlayer.seek(duration * val);
            },
            onChanged: (val) {

            },
            activeColor: Colors.yellow,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  /// Docs
  Future<void> play() {
    return _audioPlayer.play();
  }

  /// Docs
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  /// Docs
  Future<void> reset() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(Duration.zero);
  }
}

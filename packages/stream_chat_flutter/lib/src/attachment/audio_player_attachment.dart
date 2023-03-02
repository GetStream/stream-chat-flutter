import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/attachment/audio_loading_attachment.dart';

/// Docs
class AudioPlayerMessage extends StatefulWidget {
  /// Docs
  const AudioPlayerMessage({
    super.key,
    required this.player,
    required this.fileName,
    required this.index,
    required this.loadFuture,
  });

  /// Docs
  final AudioPlayer player;

  /// Docs
  final int index;

  /// Docs
  final String fileName;

  /// Docs
  final Future<Duration?> loadFuture;

  @override
  AudioPlayerMessageState createState() => AudioPlayerMessageState();
}

/// Docs
class AudioPlayerMessageState extends State<AudioPlayerMessage> {
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  @override
  void initState() {
    super.initState();

    _playerStateChangedSubscription =
        widget.player.playerStateStream.listen(playerStateListener);
  }

  /// Docs
  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await _reset();
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
    widget.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Duration?>(
      future: widget.loadFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: <Widget>[
                _controlButtons(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.fileName),
                    Row(
                      children: [
                        _timer(snapshot.data!),
                        _slider(snapshot.data),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Error!!'));
        } else {
          return const AudioLoadingMessage();
        }
      },
    );
  }

  Widget _controlButtons() {
    return StreamBuilder<int?>(
      initialData: 0,
      stream: widget.player.currentIndexStream,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data;
        return StreamBuilder<bool>(
          initialData: false,
          stream: widget.player.playingStream,
          builder: (context, snapshot) {
            final playingCurrentAudio =
                snapshot.data == true && currentIndex == widget.index;

            final color = playingCurrentAudio ? Colors.red : Colors.blue;
            final icon = playingCurrentAudio ? Icons.pause : Icons.play_arrow;

            final playButton = Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: () {
                  if (playingCurrentAudio) {
                    _pause();
                  } else {
                    _play();
                  }
                },
                child: Icon(icon, color: color, size: 30),
              ),
            );

            final speedButton = TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                minimumSize: const Size(30, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(widget.player.speed.toString()),
              onPressed: () {
                setState(() {
                  if (widget.player.speed == 2) {
                    widget.player.setSpeed(1);
                  } else {
                    widget.player.setSpeed(widget.player.speed + 0.5);
                  }
                });
              },
            );

            return Row(children: [playButton, speedButton]);
          },
        );
      },
    );
  }

  Widget _timer(Duration totalDuration) {
    return StreamBuilder<Duration>(
      stream: widget.player.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            (widget.player.currentIndex == widget.index &&
                (widget.player.playing ||
                    snapshot.data!.inSeconds > 0 ||
                    snapshot.data!.inMinutes > 0))) {
          final minutes = _twoDigits(snapshot.data!.inMinutes);
          final seconds = _twoDigits(snapshot.data!.inSeconds);

          return Text('$minutes:$seconds');
        } else {
          final minutes = _twoDigits(totalDuration.inMinutes);
          final seconds = _twoDigits(totalDuration.inSeconds);

          return Text('$minutes:$seconds');
        }
      },
    );
  }

  Widget _slider(Duration? totalDuration) {
    return StreamBuilder<int?>(
      initialData: 0,
      stream: widget.player.currentIndexStream,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data;

        return StreamBuilder<Duration>(
          stream: widget.player.positionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && totalDuration != null) {
              return Slider.adaptive(
                value: _sliderValue(
                  snapshot.data!,
                  totalDuration,
                  currentIndex,
                ),
                onChangeStart: (val) {
                  if (widget.player.playing) {
                    widget.player.pause();
                  }
                },
                onChangeEnd: (val) {
                  widget.player.seek(totalDuration * val, index: widget.index);
                },
                onChanged: (val) {
                  widget.player.seek(totalDuration * val, index: widget.index);
                },
                activeColor: Colors.yellow,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  double _sliderValue(
    Duration duration,
    Duration totalDuration,
    int? currentIndex,
  ) {
    if (widget.index != currentIndex) {
      return 0;
    } else {
      return min(duration.inMicroseconds / totalDuration.inMicroseconds, 1);
    }
  }

  /// Docs
  Future<void> _play() {
    if (widget.index == widget.player.currentIndex) {
      return widget.player.play();
    } else {
      widget.player.seek(Duration.zero, index: widget.index);
      return widget.player.play();
    }
  }

  /// Docs
  Future<void> _pause() {
    return widget.player.pause();
  }

  /// Docs
  Future<void> _reset() async {
    return widget.player.stop();
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}

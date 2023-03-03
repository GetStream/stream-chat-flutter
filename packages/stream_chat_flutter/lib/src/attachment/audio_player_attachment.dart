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
  });

  /// Docs
  final AudioPlayer player;

  /// Docs
  final int index;

  /// Docs
  final String fileName;

  @override
  AudioPlayerMessageState createState() => AudioPlayerMessageState();
}

/// Docs
class AudioPlayerMessageState extends State<AudioPlayerMessage> {
  var _seeking = false;

  @override
  void initState() {
    super.initState();
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
    widget.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: widget.player.durationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                _controlButton(),
                _timer(snapshot.data!),
                _slider(snapshot.data),
                _speedAndActionButton(),
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

  Widget _controlButton() {
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
              padding: const EdgeInsets.only(right: 4),
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

            return Row(children: [playButton]);
          },
        );
      },
    );
  }

  Widget _speedAndActionButton() {
    final speedButton = StreamBuilder<double>(
      stream: widget.player.speedStream,
      builder: (context, snapshot) {
        final speed = snapshot.data ?? 1;
        return TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(20, 20),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(speed.toString()),
          onPressed: () {
            setState(() {
              if (speed == 2) {
                widget.player.setSpeed(1);
              } else {
                widget.player.setSpeed(speed + 0.5);
              }
            });
          },
        );
      },
    );

    return speedButton;
  }

  Widget _timer(Duration totalDuration) {
    return StreamBuilder<Duration>(
      stream: widget.player.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            (widget.player.currentIndex == widget.index &&
                (widget.player.playing ||
                    snapshot.data!.inMilliseconds > 0 ||
                    _seeking))) {
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
              return Expanded(
                child: Slider.adaptive(
                  value: _sliderValue(
                    snapshot.data!,
                    totalDuration,
                    currentIndex,
                  ),
                  onChangeStart: (val) {
                    setState(() {
                      _seeking = true;
                    });
                    if (widget.player.playing) {
                      widget.player.pause();
                    }
                  },
                  onChangeEnd: (val) {
                    setState(() {
                      _seeking = false;
                    });
                    widget.player
                        .seek(totalDuration * val, index: widget.index);
                  },
                  onChanged: (val) {
                    widget.player
                        .seek(totalDuration * val, index: widget.index);
                  },
                  activeColor: Colors.yellow,
                ),
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

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}

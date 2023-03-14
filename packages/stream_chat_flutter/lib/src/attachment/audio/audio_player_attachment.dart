import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/attachment/audio/audio_loading_attachment.dart';
import 'package:stream_chat_flutter/src/attachment/audio/audio_wave_slider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Docs
class AudioPlayerMessage extends StatefulWidget {
  /// Docs
  const AudioPlayerMessage({
    super.key,
    required this.player,
    required this.audioFile,
    required this.duration,
    this.waveBars,
    this.index,
    this.fileSize,
    this.actionButton,
    this.singleAudio = false,
  });

  /// Docs
  final AudioPlayer player;

  /// Docs
  final List<double>? waveBars;

  /// Docs
  final AttachmentFile? audioFile;

  /// Docs
  final Duration duration;

  /// Docs
  final int? index;

  /// Docs
  final int? fileSize;

  /// Docs
  final Widget? actionButton;

  /// Docs
  final bool singleAudio;

  @override
  AudioPlayerMessageState createState() => AudioPlayerMessageState();
}

/// Docs
class AudioPlayerMessageState extends State<AudioPlayerMessage> {
  var _seeking = false;
  StreamSubscription<PlayerState>? _stateSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.singleAudio) {
      void playerStateListener(PlayerState state) async {
        if (state.processingState == ProcessingState.completed) {
          await widget.player.stop();
          await widget.player.seek(Duration.zero, index: 0);
        }
      }

      widget.player.playerStateStream.listen(playerStateListener);
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
    super.dispose();

    widget.player.dispose();
    _stateSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.duration != Duration.zero) {
      return _content(widget.duration);
    } else {
      return StreamBuilder<Duration?>(
        stream: widget.player.durationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _content(snapshot.data!);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Error!!'));
          } else {
            return const AudioLoadingMessage();
          }
        },
      );
    }
  }

  Widget _content(Duration totalDuration) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 56,
      child: Row(
        children: <Widget>[
          _controlButton(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timer(totalDuration),
              _fileSizeWidget(widget.fileSize),
            ],
          ),
          _audioWaveSlider(totalDuration),
          _speedAndActionButton(),
        ],
      ),
    );
  }

  Widget _controlButton() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _playingThisStream(),
      builder: (context, snapshot) {
        final playingThis = snapshot.data == true;

        final color = playingThis ? Colors.red : Colors.blue;
        final icon = playingThis ? Icons.pause : Icons.play_arrow;

        final playButton = Padding(
          padding: const EdgeInsets.only(right: 4),
          child: GestureDetector(
            onTap: () {
              if (playingThis) {
                _pause();
              } else {
                _play();
              }
            },
            child: Icon(icon, color: color),
          ),
        );

        return playButton;
      },
    );
  }

  Widget _speedAndActionButton() {
    if (widget.actionButton != null) {
      return widget.actionButton!;
    }

    final showSpeed = _playingThisStream().flatMap((showSpeed) =>
        widget.player.speedStream.map((speed) => showSpeed ? speed : -1.0));

    final content = StreamBuilder<double>(
      initialData: -1,
      stream: showSpeed,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data! > 0) {
          final speed = snapshot.data!;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              '${speed}x',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
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
        } else {
          return StreamSvgIcon.filetypeAac();
        }
      },
    );

    return SizedBox(width: 36, height: 36, child: content);
  }

  Widget _fileSizeWidget(int? fileSize) {
    if (fileSize != null) {
      return Text(
        fileSize.toHumanReadableSize(),
        style: const TextStyle(fontSize: 10),
      );
    } else {
      return const SizedBox.shrink();
    }
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

  Widget _audioWaveSlider(Duration totalDuration) {
    final positionStream = widget.player.currentIndexStream.flatMap(
      (index) => widget.player.positionStream.map((duration) => _sliderValue(
            duration,
            totalDuration,
            index,
          )),
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AudioWaveSlider(
          bars: widget.waveBars ?? List<double>.filled(50, 0),
          progressStream: positionStream,
          onChangeStart: (val) {
            setState(() {
              _seeking = true;
            });
          },
          onChanged: (val) {
            widget.player.pause();
            widget.player.seek(
              totalDuration * val,
              index: widget.index ?? 0,
            );
          },
          onChangeEnd: () {
            setState(() {
              _seeking = false;
            });
          },
        ),
      ),
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

  Stream<bool> _playingThisStream() {
    return widget.player.playingStream.flatMap((playing) {
      return widget.player.currentIndexStream.map(
        (index) => playing && index == widget.index,
      );
    });
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
    return value.remainder(60).toString().padLeft(2, '0');
  }
}

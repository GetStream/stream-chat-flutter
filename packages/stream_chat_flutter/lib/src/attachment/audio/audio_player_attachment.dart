import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/attachment/audio/audio_loading_attachment.dart';
import 'package:stream_chat_flutter/src/attachment/audio/audio_wave_slider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template AudioPlayerMessage}
/// Embedded player for audio messages. It displays the data for the audio
/// message and allow the user to interact with the player providing buttons
/// to play/pause, seek the audio and change the speed of reproduction.
///
/// When waveBars are not provided they are shown as 0 bars.
/// {@endtemplate}
class AudioPlayerMessage extends StatefulWidget {
  /// {@macro AudioPlayerMessage}
  const AudioPlayerMessage({
    super.key,
    required this.player,
    required this.duration,
    this.waveBars,
    this.index = 0,
    this.fileSize,
    this.actionButton,
    this.singleAudio = false,
  });

  /// The player of the audio.
  final AudioPlayer player;

  /// The wave bars of the recorded audio from 0 to 1. When not provided
  /// this Widget shows then as small dots.
  final List<double>? waveBars;

  /// The duration of the audio.
  final Duration duration;

  /// The index of the audio inside the play list. If not provided, this is
  /// assumed to be zero.
  final int index;

  /// The file size in bits.
  final int? fileSize;

  /// An action button to be used.
  final Widget? actionButton;

  /// Marks if this is a single audio message or this audio is inside.
  /// If this is true, the audio will reset itself when it ends, otherwise
  /// it gets managed by the player.
  final bool singleAudio;

  @override
  _AudioPlayerMessageState createState() => _AudioPlayerMessageState();
}

class _AudioPlayerMessageState extends State<AudioPlayerMessage> {
  var _seeking = false;
  late StreamSubscription<PlayerState> _playStateSubscription;
  var _waitingForLoad = false;

  @override
  void initState() {
    super.initState();

    _playStateSubscription =
        widget.player.playerStateStream.listen(_playerStateListener);
  }

  @override
  void dispose() {
    super.dispose();

    widget.player.dispose();
    _playStateSubscription.cancel();
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
            return const Center(child: Text('Error!!'));
          } else {
            return const AudioLoadingMessage();
          }
        },
      );
    }
  }

  Widget _content(Duration totalDuration) {
    final streamChatThemeData = StreamChatTheme.of(context).primaryIconTheme;

    return Container(
      padding: const EdgeInsets.all(8),
      height: 60,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 36,
            height: 36,
            child: _controlButton(streamChatThemeData),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timer(totalDuration),
                _fileSizeWidget(widget.fileSize),
              ],
            ),
          ),
          _audioWaveSlider(totalDuration),
          _speedAndActionButton(),
        ],
      ),
    );
  }

  void _playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed &&
        widget.singleAudio) {
      await widget.player.stop();
      await widget.player.seek(Duration.zero, index: 0);
    }

    final currentAudio = widget.player.currentIndex == widget.index;

    if (currentAudio && state.processingState == ProcessingState.ready) {
      setState(() {
        _waitingForLoad = false;
      });
    } else if (currentAudio &&
        state.processingState == ProcessingState.loading) {
      setState(() {
        _waitingForLoad = true;
      });
    }
  }

  Widget _controlButton(IconThemeData iconTheme) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _playingThisStream(),
      builder: (context, snapshot) {
        final playingThis = snapshot.data == true;

        final icon = playingThis ? Icons.pause : Icons.play_arrow;

        if (!_waitingForLoad) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            child: Icon(icon, color: Colors.black),
            onPressed: () {
              if (playingThis) {
                _pause();
              } else {
                _play();
              }
            },
          );
        } else {
          return const CircularProgressIndicator(strokeWidth: 3);
        }
      },
    );
  }

  Widget _speedAndActionButton() {
    final showSpeed = _playingThisStream().flatMap((showSpeed) =>
        widget.player.speedStream.map((speed) => showSpeed ? speed : -1.0));

    return StreamBuilder<double>(
      initialData: -1,
      stream: showSpeed,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data! > 0) {
          final speed = snapshot.data!;
          return SizedBox(
            width: 44,
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
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
            ),
          );
        } else {
          if (widget.actionButton != null) {
            return widget.actionButton!;
          } else {
            return SizedBox(
              width: 44,
              height: 36,
              child: StreamSvgIcon.filetypeAac(),
            );
          }
        }
      },
    );
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
          return Text(snapshot.data!.toMinutesAndSeconds());
        } else {
          return Text(totalDuration.toMinutesAndSeconds());
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
            index: widget.index,
          );
        },
        onChangeEnd: () {
          setState(() {
            _seeking = false;
          });
        },
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

  Future<void> _play() async {
    if (widget.index != widget.player.currentIndex) {
      widget.player.seek(Duration.zero, index: widget.index);
    }

    widget.player.play();
  }

  Future<void> _pause() {
    return widget.player.pause();
  }
}

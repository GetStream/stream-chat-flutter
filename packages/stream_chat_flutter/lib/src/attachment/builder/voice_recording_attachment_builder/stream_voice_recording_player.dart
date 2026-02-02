// coverage:ignore-file

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/attachment/builder/voice_recording_attachment_builder/stream_voice_recording_slider.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template StreamVoiceRecordingPlayer}
/// Embedded player for audio messages. It displays the data for the audio
/// message and allow the user to interact with the player providing buttons
/// to play/pause, seek the audio and change the speed of reproduction.
///
/// When waveBars are not provided they are shown as 0 bars.
/// {@endtemplate}
@Deprecated("Use 'StreamVoiceRecordingAttachment' instead")
class StreamVoiceRecordingPlayer extends StatefulWidget {
  /// {@macro StreamVoiceRecordingPlayer}
  const StreamVoiceRecordingPlayer({
    super.key,
    required this.player,
    required this.duration,
    this.waveBars,
    this.index = 0,
    this.fileSize,
    this.actionButton,
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

  @override
  _StreamVoiceRecordingPlayerState createState() =>
      _StreamVoiceRecordingPlayerState();
}

@Deprecated("Use 'StreamVoiceRecordingAttachment' instead")
class _StreamVoiceRecordingPlayerState
    extends State<StreamVoiceRecordingPlayer> {
  var _seeking = false;

  @override
  void dispose() {
    super.dispose();

    widget.player.dispose();
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
            return const StreamVoiceRecordingLoading();
          }
        },
      );
    }
  }

  Widget _content(Duration totalDuration) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 60,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 36,
            height: 36,
            child: _controlButton(),
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

  Widget _controlButton() {
    final theme = StreamChatTheme.of(context).voiceRecordingTheme.playerTheme;

    return StreamBuilder<bool>(
      initialData: false,
      stream: _playingThisStream(),
      builder: (context, snapshot) {
        final playingThis = snapshot.data == true;

        final icon = playingThis ? theme.pauseIcon : theme.playIcon;

        final processingState = widget.player.playerStateStream
            .map((event) => event.processingState);

        return StreamBuilder<ProcessingState>(
          stream: processingState,
          initialData: ProcessingState.idle,
          builder: (context, snapshot) {
            final state = snapshot.data ?? ProcessingState.idle;
            if (state == ProcessingState.ready ||
                state == ProcessingState.idle ||
                !playingThis) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: theme.buttonElevation,
                  padding: theme.buttonPadding,
                  backgroundColor: theme.buttonBackgroundColor,
                  shape: theme.buttonShape,
                ),
                child: Icon(icon, color: theme.iconColor),
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
      },
    );
  }

  Widget _speedAndActionButton() {
    final theme = StreamChatTheme.of(context).voiceRecordingTheme.playerTheme;

    final speedStream = _playingThisStream().flatMap((showSpeed) =>
        widget.player.speedStream.map((speed) => showSpeed ? speed : -1.0));

    return StreamBuilder<double>(
      initialData: -1,
      stream: speedStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data! > 0) {
          final speed = snapshot.data!;
          return SizedBox(
            width: theme.speedButtonSize!.width,
            height: theme.speedButtonSize!.height,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: theme.speedButtonElevation,
                backgroundColor: theme.speedButtonBackgroundColor,
                padding: theme.speedButtonPadding,
                shape: theme.speedButtonShape,
              ),
              child: Text(
                '${speed}x',
                style: theme.speedButtonTextStyle,
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
              width: theme.speedButtonSize!.width,
              height: theme.speedButtonSize!.height,
              child: theme.fileTypeIcon,
            );
          }
        }
      },
    );
  }

  Widget _fileSizeWidget(int? fileSize) {
    final theme = StreamChatTheme.of(context).voiceRecordingTheme.playerTheme;

    if (fileSize != null) {
      return Text(
        fileSize.toHumanReadableSize(),
        style: theme.fileSizeTextStyle,
      );
    } else {
      return const Empty();
    }
  }

  Widget _timer(Duration totalDuration) {
    final theme = StreamChatTheme.of(context).voiceRecordingTheme.playerTheme;

    return StreamBuilder<Duration>(
      stream: widget.player.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            (widget.player.currentIndex == widget.index &&
                (widget.player.playing ||
                    snapshot.data!.inMilliseconds > 0 ||
                    _seeking))) {
          return Text(
            snapshot.data!.toMinutesAndSeconds(),
            style: theme.timerTextStyle,
          );
        } else {
          return Text(
            totalDuration.toMinutesAndSeconds(),
            style: theme.timerTextStyle,
          );
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
      child: StreamVoiceRecordingSlider(
        waves: widget.waveBars ?? List<double>.filled(50, 0),
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

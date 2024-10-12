import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/message_input/voice_notes/audio_loading_message.dart';
import 'package:stream_chat_flutter/src/message_input/voice_notes/audio_wave_bars.dart';

class AudioPlayerMessage extends StatefulWidget {
  const AudioPlayerMessage({
    super.key,
    required this.source,
    required this.id,
    this.localFilePath,
    this.fileWaveFormData,
    required this.isMyMessage,
  });

  final AudioSource source;
  final String? localFilePath;
  final String id;
  final List<double>? fileWaveFormData;
  final bool isMyMessage;

  @override
  AudioPlayerMessageState createState() => AudioPlayerMessageState();
}

class AudioPlayerMessageState extends State<AudioPlayerMessage> {
  final _audioPlayer = AudioPlayer();
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  late Future<Duration?> futureDuration;

  @override
  void initState() {
    super.initState();

    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen(playerStateListener);

    futureDuration = _audioPlayer.setAudioSource(widget.source);
  }

  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await reset();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 8),
              _controlButtons(snapshot.data),
              if (widget.fileWaveFormData != null) ...[
                Expanded(
                    child: StreamBuilder<Duration?>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    return AudioWaveBars(
                        amplitudes: widget.fileWaveFormData!,
                        height: 35,
                        barColor:
                            widget.isMyMessage ? Colors.white : Colors.teal,
                        barSpacing: 2,
                        barColorActive: Colors.black45,
                        progress: _audioPlayer.duration != null
                            ? _audioPlayer.position.inMicroseconds /
                                _audioPlayer.duration!.inMicroseconds
                            : 0,
                        barBorderRadius: 10,
                        barWidth: 2);
                  },
                )),
              ],
              const SizedBox(
                width: 16,
              )
            ],
          );
        }
        return const AudioLoadingMessage();
      },
    );
  }

  Widget _controlButtons(Duration? duration) {
    return StreamBuilder<bool>(
      stream: _audioPlayer.playingStream,
      builder: (context, _) {
        const color = Colors.white;
        final icon =
            _audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow;
        String audioDuration = duration.toString().split('.').first;
        audioDuration = audioDuration.split(':').sublist(1).join(':');
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              if (_audioPlayer.playerState.playing) {
                pause();
              } else {
                play();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 30),
                Text(
                  audioDuration,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
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
          return Slider(
            thumbColor: Colors.white,
            activeColor: Colors.white,
            value: snapshot.data!.inMicroseconds / duration.inMicroseconds,
            onChanged: (val) {
              _audioPlayer.seek(duration * val);
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }
}

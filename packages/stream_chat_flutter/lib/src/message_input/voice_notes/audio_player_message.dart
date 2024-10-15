import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_wave_bars.dart';
import 'audio_loading_message.dart';

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
  double _progress = 0.0;
  Duration? _totalDuration;

  @override
  void initState() {
    super.initState();

    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen(playerStateListener);

    futureDuration = _audioPlayer.setAudioSource(widget.source);

    // Listen to the duration stream to get the total duration
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Update progress based on current position and total duration
    _audioPlayer.positionStream.listen((position) {
      final totalDuration = _totalDuration;
      if (totalDuration != null && totalDuration.inMilliseconds > 0) {
        setState(() {
          final progress = position.inMilliseconds.toDouble() /
              totalDuration.inMilliseconds.toDouble();
          _progress = progress.clamp(0.0, 1.0);
        });
      } else {
        // Duration is not yet available
        setState(() {
          _progress = 0.0;
        });
      }
    });
  }

  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      setState(() {
        _progress = 1.0;
      });
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
                  child: AudioWaveBars(
                    amplitudes: widget.fileWaveFormData!,
                    height: 35,
                    barColor: widget.isMyMessage ? Colors.white : Colors.teal,
                    barSpacing: 2,
                    barColorActive: Colors.white,
                    progress: _progress,
                    barBorderRadius: 10,
                    barWidth: 2,
                  ),
                ),
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
        String audioDuration =
            _totalDuration?.toString().split('.').first ?? '0:00';
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

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
    setState(() {
      _progress = 0.0;
    });
  }
}

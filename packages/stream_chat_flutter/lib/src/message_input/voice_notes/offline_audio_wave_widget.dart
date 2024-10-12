import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

/// Extracts the audio wave from the audio file
/// And provides a play button along side it
class OfflineAudioWaveWidget extends StatefulWidget {
  const OfflineAudioWaveWidget(
      {super.key,
      required this.audioPath,
      this.height,
      this.width,
      this.onWaveformDataExtracted});

  /// The local path of the audio file
  final String audioPath;

  /// The height of the widget
  final double? height;

  /// The width of the widget
  final double? width;

  /// When the wave form data is extracted from the file
  final ValueSetter<List<double>>? onWaveformDataExtracted;

  @override
  State<OfflineAudioWaveWidget> createState() => _OfflineAudioWaveWidgetState();
}

class _OfflineAudioWaveWidgetState extends State<OfflineAudioWaveWidget> {
  PlayerController controller = PlayerController();

  @override
  void initState() {
    // Or directly extract from preparePlayer and initialise audio player
    controller.preparePlayer(
      path: widget.audioPath,
      shouldExtractWaveform: false,
      noOfSamples: 100,
      volume: 1.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.extractWaveformData(path: widget.audioPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // When the audio wave data is extracted from the file
              // Fire this callback
              widget.onWaveformDataExtracted
                  ?.call(snapshot.data as List<double>);
              return SizedBox(
                height: widget.height ?? 50,
                width: widget.width ?? double.infinity,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.playerState.isPlaying) {
                          controller.pausePlayer();
                          return;
                        }

                        controller.startPlayer(finishMode: FinishMode.pause);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF05A390),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: StreamBuilder<PlayerState>(
                          stream: controller.onPlayerStateChanged,
                          builder: (context, snapshot) => Icon(
                              controller.playerState.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) => AudioFileWaveforms(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          size:
                              Size(constraints.maxWidth, constraints.maxHeight),
                          playerController: controller,
                          waveformData: snapshot.data!,
                          enableSeekGesture: false,
                          continuousWaveform: true,
                          waveformType: WaveformType.fitWidth,
                          playerWaveStyle: const PlayerWaveStyle(
                            fixedWaveColor: Colors.teal,
                            liveWaveColor: Colors.black,
                            spacing: 6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }
          return const SizedBox(
            height: 50,
          );
        });
  }
}

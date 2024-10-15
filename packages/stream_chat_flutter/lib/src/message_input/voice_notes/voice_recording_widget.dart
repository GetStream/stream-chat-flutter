import 'dart:developer' as dev;
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/custom_theme/unikon_theme.dart';
import 'package:stream_chat_flutter/src/message_input/voice_notes/offline_audio_wave_widget.dart';

/// This will handle the recording and the preview of the
/// voice recording before sending it to the chat server
class VoiceRecordingWidget extends StatefulWidget {
  const VoiceRecordingWidget({
    super.key,
    required this.onRecordingSend,
    required this.onRecordingStarted,
    required this.onRecordingAborted,
  });

  final Function(String recordedFilePath, List<double>? fileWaveFormData)
      onRecordingSend;
  final Function() onRecordingStarted;
  final Function() onRecordingAborted;

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget> {
  late final RecorderController _controller;
  bool _isRecording = false;
  String? recordedFilePath;
  List<double>? _fileWaveFormData;

  @override
  void initState() {
    // Initialize the controller
    _controller = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;

    // Start the recording
    _start();
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _stop() async {
    recordedFilePath = await _controller.stop();
    setState(() => _isRecording = false);
    _controller.refresh();
  }

  Future<void> _start() async {
    try {
      if (await _controller.checkPermission()) {
        final tempDir = await getTemporaryDirectory();
        await _controller.record(
            path: "${tempDir.path}/${Random.secure().nextInt(999999)}.m4a");
        if (_controller.isRecording) {
          widget.onRecordingStarted();
        }
        setState(() {
          _isRecording = _controller.isRecording;
        });
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Colors.white,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (recordedFilePath != null &&
                      recordedFilePath!.isNotEmpty &&
                      !_isRecording) ...[
                    Expanded(
                        child: OfflineAudioWaveWidget(
                      audioPath: recordedFilePath ?? "",
                      height: 30,
                      width: constraints.maxWidth,
                      onWaveformDataExtracted: (value) =>
                          _fileWaveFormData = value,
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(UnikonColorTheme.recordingIcon),
                    ),
                    Expanded(
                      child: AudioWaveforms(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        size: Size(constraints.maxWidth, 30),
                        recorderController: _controller,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        enableGesture: true,
                        waveStyle: const WaveStyle(
                          showDurationLabel: false,
                          spacing: 8.0,
                          showBottom: true,
                          extendWaveform: true,
                          showMiddleLine: false,
                          showTop: true,
                          waveColor: Colors.teal,
                          waveCap: StrokeCap.round,
                        ),
                      ),
                    ),
                  ],

                  // Timer
                  StreamBuilder<Duration>(
                    stream: _controller.onCurrentDuration,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          formatDuration(snapshot.data!),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333)),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  // Delete button
                  IconButton(
                    onPressed: () async {
                      if (_isRecording) {
                        await _stop();
                        recordedFilePath != null;
                      } else if (recordedFilePath != null) {
                        setState(() {
                          recordedFilePath = null;
                        });
                      }
                      widget.onRecordingAborted();
                    },
                    icon: Image.asset(
                      UnikonColorTheme.deleteIcon,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          _buildStopAndSendButton(),
        ],
      ),
    );
  }

  // Stop and send button
  Widget _buildStopAndSendButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _isRecording
            ? UnikonColorTheme.stopAudioRecordingMessageColor
            : UnikonColorTheme.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: IconButton(
          onPressed: () async {
            if (_isRecording) {
              await _stop();
            } else if (recordedFilePath != null) {
              widget.onRecordingSend(recordedFilePath!, _fileWaveFormData);
            }
          },
          padding: EdgeInsets.zero,
          splashRadius: 24,
          constraints: const BoxConstraints.tightFor(
            height: 24,
            width: 24,
          ),
          icon: _isRecording
              ? const DecoratedBox(
                  decoration: BoxDecoration(
                    color: UnikonColorTheme.messageSentIndicatorColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.stop,
                      size: 20,
                      color: UnikonColorTheme.stopAudioRecordingMessageColor,
                    ),
                  ),
                )
              : const Icon(
                  Icons.send,
                  size: 20,
                  color: UnikonColorTheme.messageSentIndicatorColor,
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/attachment/audio/audio_wave_bars_widget.dart';
import 'package:stream_chat_flutter/src/attachment/audio/record_controller.dart';
import 'package:stream_chat_flutter/src/message_input/on_press_button.dart';
import 'package:stream_chat_flutter/src/message_input/record/record_timer_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

///Docs
class RecordField extends StatelessWidget {
  ///Docs
  const RecordField({
    super.key,
    required this.recordController,
    this.resumeRecordButtonBuilder,
    this.pauseRecordButtonBuilder,
    this.cancelRecordButtonBuilder,
    this.confirmRecordButtonBuilder,
    this.recordTimerBuilder,
    this.audioWaveBarsBuilder,
    this.onAudioRecorded,
  });

  ///Docs
  final StreamRecordController recordController;

  /// Builder for customizing the resumeRecord button.
  ///
  /// The builder contains the default [OnPressButton.resumeRecord] that can be
  /// customized by calling `.copyWith`.
  final ResumeRecordButtonBuilder? resumeRecordButtonBuilder;

  /// Builder for customizing the resumeRecord button.
  ///
  /// The builder contains the default [OnPressButton.pause] that can be
  /// customized by calling `.copyWith`.
  final PauseRecordButtonBuilder? pauseRecordButtonBuilder;

  /// Builder for customizing the resumeRecord button.
  ///
  /// The builder contains the default [OnPressButton.pause] that can be
  /// customized by calling `.copyWith`.
  final CancelRecordButtonBuilder? cancelRecordButtonBuilder;

  /// Builder for customizing the confirmRecord button.
  ///
  /// The builder contains the default [OnPressButton.confirmAudio] that can be
  /// customized by calling `.copyWith`.
  final ConfirmRecordButtonBuilder? confirmRecordButtonBuilder;

  /// Builder for customizing the record timer.
  ///
  /// The builder contains the default [RecordTimer] that can be
  /// customized by calling `.copyWith`.
  final RecordTimerBuilder? recordTimerBuilder;

  /// Builder for customizing the audio wave bars.
  ///
  /// The builder contains the default [AudioWaveBars] that can be
  /// customized by calling `.copyWith`.
  final AudioWaveBarsBuilder? audioWaveBarsBuilder;

  /// Callback called when audio record is complete.
  final void Function(BuildContext, Future<Attachment?>)? onAudioRecorded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildRecordTimer(context, recordController.recordState),
            ),
            Expanded(
              child: SizedBox(
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: _buildAudioWaveBars(
                    context,
                    recordController.amplitudeStream,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: StreamBuilder<RecordState>(
            initialData: RecordState.record,
            stream: recordController.recordState,
            builder: (context, snapshot) {
              final recordingState = snapshot.data ?? RecordState.stop;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCancelRecordButton(context, recordingState),
                  if (recordingState == RecordState.record)
                    _buildPauseRecordButton(context),
                  if (recordingState != RecordState.record)
                    _buildResumeRecordButton(context),
                  _buildConfirmRecordButton(context),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecordTimer(
    BuildContext context,
    Stream<RecordState> recordStateStream,
  ) {
    final defaultTimer = RecordTimer(recordState: recordStateStream);
    return recordTimerBuilder?.call(context, defaultTimer) ?? defaultTimer;
  }

  Widget _buildAudioWaveBars(
    BuildContext context,
    Stream<Amplitude> amplitudeStream,
  ) {
    final defaultWaveBars = AudioWaveBars(amplitudeStream: amplitudeStream);
    return audioWaveBarsBuilder?.call(context, defaultWaveBars) ??
        defaultWaveBars;
  }

  Widget _buildCancelRecordButton(
    BuildContext context,
    RecordState recordingState,
  ) {
    if (recordingState == RecordState.record) {
      return const StreamSvgIcon.microphone(color: Colors.red);
    } else {
      final defaultButton = OnPressButton.cancelRecord(
        onPressed: recordController.cancelRecording,
      );

      return cancelRecordButtonBuilder?.call(context, defaultButton) ??
          defaultButton;
    }
  }

  Widget _buildPauseRecordButton(BuildContext context) {
    final defaultButton =
        OnPressButton.pauseRecord(onPressed: recordController.pauseRecording);

    return pauseRecordButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }

  Widget _buildResumeRecordButton(BuildContext context) {
    final defaultButton =
        OnPressButton.resumeRecord(onPressed: recordController.record);

    return resumeRecordButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }

  Widget _buildConfirmRecordButton(BuildContext context) {
    final defaultButton = OnPressButton.confirmAudio(
      onPressed: () {
        onAudioRecorded?.call(context, recordController.finishRecording());
      },
    );

    return confirmRecordButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }
}

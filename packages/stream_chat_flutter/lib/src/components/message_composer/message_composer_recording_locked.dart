import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

class MessageComposerRecordingLocked extends StatelessWidget {
  const MessageComposerRecordingLocked({
    super.key,
    required this.audioRecorderController,
    required this.feedback,
    required this.messageInputController,
    required this.sendMessageCallback,
  });
  final StreamAudioRecorderController audioRecorderController;
  final AudioRecorderFeedback feedback;
  final StreamMessageInputController messageInputController;
  final VoidCallback? sendMessageCallback;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              alignment: Alignment.center,
              child: Icon(
                icons.microphone,
                color: context.streamColorScheme.accentError,
                size: 20,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: audioRecorderController,
              builder: (context, state, child) {
                final duration = switch (state) {
                  RecordStateRecording() => state.duration,
                  RecordStateStopped() => state.audioRecording.duration,
                  RecordStateIdle() => Duration.zero,
                };

                return Text(
                  duration.toMinutesAndSeconds(),
                  style: textTheme.captionEmphasis.copyWith(
                    color: colorScheme.textPrimary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamButton.icon(
              key: const ValueKey('cancel-record-button'),
              style: StreamButtonStyle.secondary,
              type: StreamButtonType.outline,
              size: StreamButtonSize.small,
              icon: icons.trashBin,
              onTap: audioRecorderController.cancelRecord,
            ),
            if (audioRecorderController.isRecording)
              StreamButton.icon(
                key: const ValueKey('stop-record-button'),
                style: StreamButtonStyle.destructive,
                type: StreamButtonType.outline,
                size: StreamButtonSize.small,
                icon: icons.stop,
                onTap: audioRecorderController.stopRecord,
              ),
            StreamButton.icon(
              key: const ValueKey('finish-record-button'),
              style: StreamButtonStyle.primary,
              type: StreamButtonType.solid,
              size: StreamButtonSize.small,
              icon: icons.checkmark2Small,
              onTap: () async {
                await feedback.onRecordFinish(context);
                final audio = await audioRecorderController.finishRecord();
                if (audio != null) {
                  messageInputController.addAttachment(audio);
                }

                // Once the recording is finished, cancel the recorder.
                audioRecorderController.cancelRecord(discardTrack: false);

                // Send the message if the user has enabled the option to
                // send the voice recording automatically.
                sendMessageCallback?.call();
              },
            ),
          ],
        ),
      ],
    );
  }
}

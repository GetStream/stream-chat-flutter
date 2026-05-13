import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/src/audio/audio_sampling.dart' as sampling;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

const _kDefaultWaveformHeight = 20.0;
const _kDefaultWaveformLimit = 35;

/// Widget to display the recording locked state.
/// This widget can be used inside of the [StreamBaseMessageComposer] instead of the default `inputCenter`.
class MessageComposerRecordingLocked extends StatelessWidget {
  /// Creates a new instance of [MessageComposerRecordingLocked].
  /// [audioRecorderController] is the controller for the audio recorder.
  /// [feedback] is the feedback for the audio recorder.
  /// [messageComposerController] is the controller for the message composer.
  /// [sendMessageCallback] is the callback for when the message is sent automatically.
  const MessageComposerRecordingLocked({
    super.key,
    required this.audioRecorderController,
    required this.feedback,
    required this.messageComposerController,
    required this.sendMessageCallback,
    required this.state,
  });

  /// The controller for the audio recorder.
  final StreamAudioRecorderController audioRecorderController;

  /// The feedback for the audio recorder.
  final AudioRecorderFeedback feedback;

  /// The controller for the message composer.
  final StreamMessageComposerController messageComposerController;

  /// The callback for when the message is sent automatically.
  /// This callback should be null when the message is not supposed to be sent automatically.
  final VoidCallback? sendMessageCallback;

  /// The state of the recording.
  final RecordStateRecording state;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;

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
                icons.voice,
                color: context.streamColorScheme.accentError,
                size: 20,
              ),
            ),
            Text(
              state.duration.toMinutesAndSeconds(),
              style: textTheme.captionEmphasis.copyWith(
                color: colorScheme.textPrimary,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
            Expanded(
              child: Container(
                height: _kDefaultWaveformHeight,
                padding: EdgeInsets.symmetric(horizontal: spacing.md),
                child: StreamAudioWaveform(waveform: state.waveform, limit: 50),
              ),
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
              icon: Icon(icons.delete),
              onPressed: audioRecorderController.cancelRecord,
            ),
            if (audioRecorderController.value is RecordStateRecording)
              StreamButton.icon(
                key: const ValueKey('stop-record-button'),
                style: StreamButtonStyle.destructive,
                type: StreamButtonType.outline,
                size: StreamButtonSize.small,
                icon: Icon(icons.stopFill),
                onPressed: audioRecorderController.stopRecord,
              ),
            StreamButton.icon(
              key: const ValueKey('finish-record-button'),
              style: StreamButtonStyle.primary,
              type: StreamButtonType.solid,
              size: StreamButtonSize.small,
              icon: Icon(icons.checkmark),
              onPressed: () async {
                await feedback.onRecordFinish(context);
                final audio = await audioRecorderController.finishRecord();
                if (audio != null) {
                  messageComposerController.addAttachment(audio);
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

/// Widget to display the recording stopped state.
/// This widget can be used inside of the [StreamBaseMessageComposer] instead of the default `inputCenter`.
class MessageComposerRecordingStopped extends StatefulWidget {
  /// Creates a new instance of [MessageComposerRecordingStopped].
  /// [audioRecorderController] is the controller for the audio recorder.
  /// [feedback] is the feedback for the audio recorder.
  /// [messageComposerController] is the controller for the message composer.
  /// [sendMessageCallback] is the callback for when the message is sent automatically.
  const MessageComposerRecordingStopped({
    super.key,
    required this.audioRecorderController,
    required this.feedback,
    required this.messageComposerController,
    required this.sendMessageCallback,
    required this.recordingState,
  });

  /// The controller for the audio recorder.
  final StreamAudioRecorderController audioRecorderController;

  /// The feedback for the audio recorder.
  final AudioRecorderFeedback feedback;

  /// The controller for the message composer.
  final StreamMessageComposerController messageComposerController;

  /// The callback for when the message is sent automatically.
  /// This callback should be null when the message is not supposed to be sent automatically.
  final VoidCallback? sendMessageCallback;

  /// The state of the recording.
  final RecordStateStopped recordingState;

  Attachment get _audioRecording => recordingState.audioRecording;

  @override
  State<MessageComposerRecordingStopped> createState() => _MessageComposerRecordingStoppedState();
}

class _MessageComposerRecordingStoppedState extends State<MessageComposerRecordingStopped> {
  late final _controller = StreamAudioPlaylistController(
    widget._audioRecording.toPlaylist(),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  void didUpdateWidget(
    covariant MessageComposerRecordingStopped oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._audioRecording != widget._audioRecording) {
      // If the playlist have changed, update the playlist.
      _controller.updatePlaylist(widget._audioRecording.toPlaylist());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    const index = 0;

    final spacing = context.streamSpacing;

    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, state, child) {
        final track = state.tracks.firstOrNull;
        if (track == null) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AudioControlButton(
                  state: track.state,
                  style: StreamButtonStyle.secondary,
                  type: StreamButtonType.ghost,
                  size: StreamButtonSize.small,
                  onPlay: () {
                    if (state.currentIndex == index) {
                      // Play the track directly if it is already loaded.
                      _controller.play();
                    } else {
                      // Otherwise, load the track first and then play it.
                      _controller.skipToItem(index);
                    }
                  },
                  onPause: _controller.pause,
                ),
                AudioDurationText(
                  duration: track.duration,
                  position: track.position,
                  style: textTheme.captionEmphasis.copyWith(
                    color: colorScheme.textPrimary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: spacing.md),
                    height: _kDefaultWaveformHeight,
                    child: StreamAudioWaveformSlider(
                      limit: _kDefaultWaveformLimit,
                      waveform: sampling.resampleWaveformData(
                        track.waveform,
                        _kDefaultWaveformLimit,
                      ),
                      progress: track.progress,
                      // Only allow seeking if the current track is the one being
                      // interacted with.
                      onChangeStart: (_) async {
                        if (state.currentIndex != index) return;
                        return _controller.pause();
                      },
                      onChangeEnd: (_) async {
                        if (state.currentIndex != index) return;
                        return _controller.play();
                      },
                      onChanged: (progress) async {
                        if (state.currentIndex != index) return;

                        final duration = track.duration.inMicroseconds;
                        final seekPosition = (duration * progress).toInt();
                        final seekDuration = Duration(microseconds: seekPosition);

                        return _controller.seek(seekDuration);
                      },
                      isActive: track.state != TrackState.idle,
                    ),
                  ),
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
                  icon: Icon(icons.delete),
                  onPressed: widget.audioRecorderController.cancelRecord,
                ),
                if (widget.audioRecorderController.value is RecordStateRecording)
                  StreamButton.icon(
                    key: const ValueKey('stop-record-button'),
                    style: StreamButtonStyle.destructive,
                    type: StreamButtonType.outline,
                    size: StreamButtonSize.small,
                    icon: Icon(icons.stopFill),
                    onPressed: widget.audioRecorderController.stopRecord,
                  ),
                StreamButton.icon(
                  key: const ValueKey('finish-record-button'),
                  style: StreamButtonStyle.primary,
                  type: StreamButtonType.solid,
                  size: StreamButtonSize.small,
                  icon: Icon(icons.checkmark),
                  onPressed: () async {
                    await widget.feedback.onRecordFinish(context);
                    final audio = await widget.audioRecorderController.finishRecord();
                    if (audio != null) {
                      widget.messageComposerController.addAttachment(audio);
                    }

                    // Once the recording is finished, cancel the recorder.
                    widget.audioRecorderController.cancelRecord(discardTrack: false);

                    // Send the message if the user has enabled the option to
                    // send the voice recording automatically.
                    widget.sendMessageCallback?.call();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

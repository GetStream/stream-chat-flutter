import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/src/audio/audio_sampling.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_input/audio_recorder/audio_recorder_state.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/src/misc/audio_waveform.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template audioRecorderBuilder}
/// A builder function for constructing the audio recorder UI.
///
/// See also:
///   - [StreamAudioRecorderButton], which uses this builder function.
///   - [StreamAudioRecorderState], which provides the state of the recorder.
/// {@endtemplate}
typedef AudioRecorderBuilder = Widget Function(
  BuildContext,
  AudioRecorderState,
  Widget,
);

/// {@template streamAudioRecorderButton}
/// A configurable audio recording button with interactive states and gestures.
///
/// Manages different recording states: idle, recording, locked, and stopped.
/// Provides fine-grained control over recording interactions through callbacks.
///
/// {@tool snippet}
/// Basic usage example:
/// ```dart
/// StreamAudioRecorderButton(
///   recordState: _recordState,
///   onRecordStart: () => _startRecording(),
///   onRecordFinish: () => _finishRecording(),
/// )
/// ```
/// {@end-tool}
/// {@endtemplate}
class StreamAudioRecorderButton extends StatelessWidget {
  /// {@macro streamAudioRecorderButton}
  const StreamAudioRecorderButton({
    super.key,
    required this.recordState,
    this.onRecordStart,
    this.onRecordPause,
    this.onRecordResume,
    this.onRecordDragUpdate,
    this.onRecordCancel,
    this.onRecordLock,
    this.onRecordFinish,
    this.onRecordStop,
    this.onRecordStartCancel,
    this.lockRecordThreshold = 50,
    this.cancelRecordThreshold = 75,
  });

  /// The current state of the recorder.
  ///
  /// This is used to determine the icon and the behavior of the button.
  final AudioRecorderState recordState;

  /// The callback to call when the recording is started.
  final VoidCallback? onRecordStart;

  /// The callback to call when the recording is paused.
  final VoidCallback? onRecordPause;

  /// The callback to call when the recording is resumed.
  final VoidCallback? onRecordResume;

  /// The callback to call when the recording is canceled.
  final VoidCallback? onRecordCancel;

  /// The callback to call when the recording is locked.
  final VoidCallback? onRecordLock;

  /// The callback to call when the recording is finished.
  final VoidCallback? onRecordFinish;

  /// The callback to call when the recording is stopped.
  final VoidCallback? onRecordStop;

  /// The callback to call when the recorder will not end up starting.
  ///
  /// This is called when the recording is canceled before it starts.
  final VoidCallback? onRecordStartCancel;

  /// The callback to call when the recording drag is updated.
  final ValueSetter<Offset>? onRecordDragUpdate;

  /// The threshold to lock the recording.
  final double lockRecordThreshold;

  /// The threshold to cancel the recording.
  final double cancelRecordThreshold;

  @override
  Widget build(BuildContext context) {
    final isRecording = recordState is! RecordStateIdle;
    final isLocked = isRecording && recordState is! RecordStateRecordingHold;

    return GestureDetector(
      onLongPressStart: (_) {
        // Return if the recording is already started.
        if (isRecording) return;
        return onRecordStart?.call();
      },
      onLongPressEnd: (_) {
        // Return if the recording not yet started or already locked.
        if (!isRecording || isLocked) return;
        return onRecordFinish?.call();
      },
      onLongPressCancel: () {
        // Notify the parent that the recorder is canceled before it starts.
        return onRecordStartCancel?.call();
      },
      onLongPressMoveUpdate: (details) {
        // Return if the recording not yet started or already locked.
        if (!isRecording || isLocked) return;
        final dragOffset = details.offsetFromOrigin;

        // Lock recording if the drag offset is greater than the threshold.
        if (dragOffset.dy <= -lockRecordThreshold) {
          return onRecordLock?.call();
        }
        // Cancel recording if the drag offset is greater than the threshold.
        if (dragOffset.dx <= -cancelRecordThreshold) {
          return onRecordCancel?.call();
        }

        // Update the drag offset.
        return onRecordDragUpdate?.call(dragOffset);
      },
      child: StreamAudioRecorder(
        state: recordState,
        button: RecordButton(
          onPressed: () {}, // Allows showing ripple effect on tap.
          icon: const StreamSvgIcon(icon: StreamSvgIcons.mic),
        ),
        builder: (context, state, recordButton) => switch (state) {
          // Show only the record button if the recording is not in progress.
          RecordStateIdle() => RecordStateIdleContent(
              state: state,
              recordButton: recordButton,
            ),
          RecordStateRecordingHold() => RecordStateHoldRecordingContent(
              state: state,
              recordButton: recordButton,
              cancelThreshold: cancelRecordThreshold,
            ),
          RecordStateRecordingLocked() => RecordStateLockedRecordingContent(
              state: state,
              onRecordEnd: onRecordFinish,
              onRecordPause: onRecordPause,
              onRecordCancel: onRecordCancel,
              onRecordStop: onRecordStop,
            ),
          RecordStateStopped() => RecordStateStoppedContent(
              state: state,
              onRecordCancel: onRecordCancel,
              onRecordFinish: onRecordFinish,
            ),
        },
      ),
    );
  }
}

/// {@template recordButton}
/// A widget representing the record button for the audio recorder.
/// {@endtemplate}
class RecordButton extends StatelessWidget {
  /// {@macro recordButton}
  const RecordButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  /// The icon to display inside the button.
  final Widget icon;

  /// The callback that is called when the button is tapped or otherwise
  /// activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamMessageInputIconButton(
      onPressed: onPressed,
      icon: icon,
    );
  }
}

/// {@template recordStateIdleContent}
/// Represents the idle state content of the audio recorder.
///
/// Displays the record button and potentially an informational tooltip.
///
/// Used when no recording is in progress and the recorder is ready to start.
/// {@endtemplate}
class RecordStateIdleContent extends StatelessWidget {
  /// {@macro recordStateIdleContent}
  const RecordStateIdleContent({
    super.key,
    required this.state,
    required this.recordButton,
  });

  /// The record button widget to display.
  final Widget recordButton;

  /// The current state of the recorder.
  final RecordStateIdle state;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final child = IconTheme(
      data: IconThemeData(color: theme.colorTheme.textLowEmphasis),
      child: recordButton,
    );

    final info = state.message;
    if (info == null || info.isEmpty) return child;

    return PortalTarget(
      anchor: const Aligned(
        target: Alignment.topRight,
        follower: Alignment.bottomRight,
      ),
      portalFollower: HoldToRecordInfoTooltip(message: info),
      child: child,
    );
  }
}

/// {@template recordStateRecordingContent}
/// Represents the recording state when user is holding the record button.
///
/// Provides visual feedback during recording with timer and cancellation
/// indicators.
///
/// Manages the interactive state of recording while the button is being held.
/// Allows sliding to cancel or lock the recording.
/// {@endtemplate}
class RecordStateHoldRecordingContent extends StatelessWidget {
  /// {@macro recordStateRecordingContent}
  const RecordStateHoldRecordingContent({
    super.key,
    required this.state,
    required this.recordButton,
    this.cancelThreshold = 96,
  });

  /// The record button widget to display.
  final Widget recordButton;

  /// The threshold to cancel the recording.
  final double cancelThreshold;

  /// The current state of the recorder.
  final RecordStateRecordingHold state;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final recordingTime = state.duration;
    final dragOffset = Offset(
      math.min(state.dragOffset.dx, 0),
      math.min(state.dragOffset.dy, 0),
    );

    // Calculate the progress of the cancel threshold.
    final cancelProgress = (dragOffset.dx.abs() / cancelThreshold).clamp(0, 1);

    return PortalTarget(
      // Show the swipe to lock button once the recording starts.
      visible: recordingTime.inSeconds > 0,
      anchor: Aligned(
        offset: Offset(4, dragOffset.dy - 16),
        target: Alignment.topRight,
        follower: Alignment.bottomRight,
      ),
      portalFollower: const SlideTransitionWidget(
        begin: Offset(0, 0.7),
        end: Offset.zero,
        child: SwipeToLockButton(),
      ),
      child: Row(
        children: [
          IgnorePointer(
            child: PlaybackTimerIndicator(duration: recordingTime),
          ),
          Expanded(
            child: IgnorePointer(
              child: SlideToCancelIndicator(
                progress: cancelProgress.toDouble(),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorTheme.inputBg,
            ),
            child: IconTheme(
              data: IconThemeData(color: theme.colorTheme.accentPrimary),
              child: recordButton,
            ),
          ),
        ].insertBetween(const SizedBox(width: 8)),
      ),
    );
  }
}

/// {@template recordStateLockedRecordingContent}
/// Represents the locked recording state with full recording controls.
///
/// Provides options to pause, stop, or finish the recording after locking.
///
/// Activated when recording is locked, enabling advanced recording management.
/// {@endtemplate}
class RecordStateLockedRecordingContent extends StatelessWidget {
  /// {@macro recordStateLockedRecordingContent}
  const RecordStateLockedRecordingContent({
    super.key,
    required this.state,
    this.onRecordEnd,
    this.onRecordPause,
    this.onRecordCancel,
    this.onRecordStop,
  });

  /// The current state of the recorder.
  final RecordStateRecordingLocked state;

  /// The callback to call when the recording is finished.
  final VoidCallback? onRecordEnd;

  /// The callback to call when the recording is paused.
  final VoidCallback? onRecordPause;

  /// The callback to call when the recording is canceled.
  final VoidCallback? onRecordCancel;

  /// The callback to call when the recording is stopped.
  final VoidCallback? onRecordStop;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return PortalTarget(
      anchor: const Aligned(
        offset: Offset(4, -16),
        target: Alignment.topRight,
        follower: Alignment.bottomRight,
      ),
      portalFollower: const SwipeToLockButton(isLocked: true),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              PlaybackTimerText(
                duration: state.duration,
                style: theme.textTheme.headline.copyWith(
                  color: theme.colorTheme.textLowEmphasis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: kDefaultMessageInputIconSize,
                  child: StreamAudioWaveform(
                    limit: 50,
                    waveform: state.waveform,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamMessageInputIconButton(
                icon: const StreamSvgIcon(icon: StreamSvgIcons.delete),
                color: theme.colorTheme.accentPrimary,
                onPressed: onRecordCancel,
              ),
              StreamMessageInputIconButton(
                icon: const StreamSvgIcon(icon: StreamSvgIcons.stop),
                color: theme.colorTheme.accentError,
                onPressed: onRecordStop,
              ),
              StreamMessageInputIconButton(
                icon: const StreamSvgIcon(icon: StreamSvgIcons.checkSend),
                color: theme.colorTheme.accentPrimary,
                onPressed: onRecordEnd,
              )
            ],
          ),
        ],
      ),
    );
  }
}

/// {@template recordStateStoppedContent}
/// Manages the stopped recording state with audio preview and interaction
/// options.
///
/// Allows reviewing the recorded audio and provides actions to cancel or
/// finish.
///
/// Provides a UI for previewing and managing a completed audio recording.
/// {@endtemplate}
class RecordStateStoppedContent extends StatefulWidget {
  /// {@macro recordStateStoppedContent}
  const RecordStateStoppedContent({
    super.key,
    required this.state,
    this.onRecordFinish,
    this.onRecordCancel,
  });

  /// The current state of the recorder.
  final RecordStateStopped state;

  /// The callback to call when the recording is finished.
  final VoidCallback? onRecordCancel;

  /// The callback to call when the recording is canceled.
  final VoidCallback? onRecordFinish;

  @override
  State<RecordStateStoppedContent> createState() =>
      _RecordStateStoppedContentState();
}

class _RecordStateStoppedContentState extends State<RecordStateStoppedContent> {
  StreamAudioPlaylistController? _audioController;

  @override
  void initState() {
    super.initState();
    if (widget.state.audioRecording case final recording) {
      _audioController = StreamAudioPlaylistController(
        [recording].toPlaylist(),
      )..initialize();
    }
  }

  @override
  void dispose() {
    _audioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return PortalTarget(
      anchor: const Aligned(
        offset: Offset(4, -16),
        target: Alignment.topRight,
        follower: Alignment.bottomRight,
      ),
      portalFollower: const SwipeToLockButton(isLocked: true),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_audioController case final controller?)
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, _) {
                final track = state.tracks.firstOrNull;
                if (track == null) return const SizedBox.shrink();

                return Row(
                  children: [
                    PlaybackControlButton(
                      state: track.state,
                      onPause: _audioController?.pause,
                      onPlay: () async {
                        // Play the track directly if it is already loaded.
                        if (state.currentIndex != null) {
                          return _audioController?.play();
                        }

                        // Otherwise, load the track first and then play it.
                        return _audioController?.skipToItem(0);
                      },
                    ),
                    const SizedBox(width: 2),
                    PlaybackTimerText(
                      duration: track.duration,
                      position: track.position,
                      style: theme.textTheme.headline.copyWith(
                        color: theme.colorTheme.textLowEmphasis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 28,
                        child: StreamAudioWaveformSlider(
                          limit: 50,
                          progress: track.progress,
                          waveform: resampleWaveformData(track.waveform, 50),
                          // Only allow seeking if the current track is the one
                          // being interacted with.
                          onChangeStart: (_) async {
                            if (state.currentIndex == null) return;
                            return _audioController?.pause();
                          },
                          onChangeEnd: (_) async {
                            if (state.currentIndex == null) return;
                            return _audioController?.play();
                          },
                          onChanged: (progress) async {
                            if (state.currentIndex == null) return;

                            final duration = track.duration.inMicroseconds;
                            final seekPosition = (duration * progress).toInt();
                            final seekDuration = Duration(
                              microseconds: seekPosition,
                            );

                            return _audioController?.seek(seekDuration);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamMessageInputIconButton(
                icon: const StreamSvgIcon(icon: StreamSvgIcons.delete),
                color: theme.colorTheme.accentPrimary,
                onPressed: widget.onRecordCancel,
              ),
              StreamMessageInputIconButton(
                icon: const StreamSvgIcon(icon: StreamSvgIcons.checkSend),
                color: theme.colorTheme.accentPrimary,
                onPressed: widget.onRecordFinish,
              )
            ],
          ),
        ],
      ),
    );
  }
}

/// {@template swipeToLockButton}
/// Button indicating the ability to lock or unlock audio recording.
///
/// Provides a visual representation of the recording lock state.
///
/// Allows users to lock the recording mode, preventing accidental cancellation.
/// {@endtemplate}
class SwipeToLockButton extends StatelessWidget {
  /// {@macro swipeToLockButton}
  const SwipeToLockButton({
    super.key,
    this.isLocked = false,
  });

  /// Determines if the recording is locked.
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorTheme.inputBg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamSvgIcon(
            icon: StreamSvgIcons.lock,
            size: kDefaultMessageInputIconSize,
            color: switch (isLocked) {
              true => theme.colorTheme.accentPrimary,
              false => theme.colorTheme.textLowEmphasis,
            },
          ),
          if (!isLocked) ...[
            StreamSvgIcon(
              icon: StreamSvgIcons.up,
              color: theme.colorTheme.textLowEmphasis,
            ),
          ],
        ].insertBetween(const SizedBox(height: 8)),
      ),
    );
  }
}

/// {@template playbackControlButton}
/// Playback control button with state-based icon and interaction.
///
/// Supports different interactions based on current track state.
///
/// Provides a flexible button for controlling audio playback with multiple
/// states.
/// {@endtemplate}
class PlaybackControlButton extends StatelessWidget {
  /// {@macro playbackControlButton}
  const PlaybackControlButton({
    super.key,
    required this.state,
    this.onPlay,
    this.onPause,
    this.onReplay,
  });

  /// The current state of the track.
  final TrackState state;

  /// The callback to call when the track is played.
  final VoidCallback? onPlay;

  /// The callback to call when the track is paused.
  final VoidCallback? onPause;

  /// The callback to call when the track is replayed.
  final VoidCallback? onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return StreamMessageInputIconButton(
      color: theme.colorTheme.accentPrimary,
      onPressed: switch (state) {
        TrackState.loading => null,
        TrackState.idle => onPlay,
        TrackState.playing => onPause,
        TrackState.paused => onPlay,
      },
      icon: switch (state) {
        TrackState.loading => Builder(
            builder: (context) {
              final iconTheme = IconTheme.of(context);
              return SizedBox.fromSize(
                size: Size.square(iconTheme.size!),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorTheme.accentPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        TrackState.idle => const StreamSvgIcon(icon: StreamSvgIcons.play),
        TrackState.paused => const StreamSvgIcon(icon: StreamSvgIcons.play),
        TrackState.playing => const StreamSvgIcon(icon: StreamSvgIcons.pause),
      },
    );
  }
}

/// {@template playbackTimerIndicator}
/// Displays the current recording or playback duration.
///
/// Shows an icon and formatted time with low emphasis styling.
///
/// Provides a visual representation of recording or playback time.
/// {@endtemplate}
class PlaybackTimerIndicator extends StatelessWidget {
  /// {@macro playbackTimerIndicator}
  const PlaybackTimerIndicator({
    super.key,
    required this.duration,
  });

  /// The current duration of the recording or playback.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return Row(
      children: [
        StreamSvgIcon(
          icon: StreamSvgIcons.mic,
          size: kDefaultMessageInputIconSize,
          color: switch (duration.inSeconds) {
            > 0 => theme.colorTheme.accentError,
            _ => theme.colorTheme.textLowEmphasis,
          },
        ),
        const SizedBox(width: 8),
        PlaybackTimerText(
          duration: duration,
          style: theme.textTheme.headline.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
        ),
      ],
    );
  }
}

/// {@template playbackTimerText}
/// Displays the formatted time of the recording or playback.
///
/// Formats the time in minutes and seconds with tabular figures.
/// {@endtemplate}
class PlaybackTimerText extends StatelessWidget {
  /// {@macro playbackTimerText}
  const PlaybackTimerText({
    super.key,
    required this.duration,
    this.position = Duration.zero,
    this.style,
  });

  /// The total duration of the recording or playback.
  final Duration duration;

  /// The current position of the recording or playback.
  final Duration position;

  /// The text style to apply to the formatted time.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (position.inMilliseconds > 0) {
      return Text(
        position.toMinutesAndSeconds(),
        style: style?.copyWith(
          // Use mono space for each num character.
          fontFeatures: [const FontFeature.tabularFigures()],
        ),
      );
    }

    return Text(
      duration.toMinutesAndSeconds(),
      style: style?.copyWith(
        // Use mono space for each num character.
        fontFeatures: [const FontFeature.tabularFigures()],
      ),
    );
  }
}

/// {@template slideToCancelIndicator}
/// Indicator showing progress of sliding to cancel recording.
///
/// Provides visual feedback during recording cancellation gesture.
///
/// Visualizes the user's progress when attempting to cancel a recording.
/// {@endtemplate}
class SlideToCancelIndicator extends StatelessWidget {
  /// {@macro slideToCancelIndicator}
  const SlideToCancelIndicator({
    super.key,
    required this.progress,
  });

  /// The progress of the cancel threshold.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Opacity(
      opacity: 1 - progress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.translations.slideToCancelLabel,
            style: theme.textTheme.headline.copyWith(
              color: theme.colorTheme.textLowEmphasis,
            ),
          ),
          const SizedBox(width: 8),
          StreamSvgIcon(
            icon: StreamSvgIcons.left,
            color: theme.colorTheme.textLowEmphasis,
          ),
        ],
      ),
    );
  }
}

/// {@template streamAudioRecorder}
/// Builder widget for constructing audio recorder UI based on state.
///
/// Allows dynamic UI rendering depending on the current audio recorder state.
///
/// Provides a flexible mechanism for rendering audio recorder UI dynamically.
///
/// see also:
///  - [StreamAudioRecorderButton], which uses this builder function.
///  - [StreamAudioRecorderState], which provides the state of the recorder.
/// {@endtemplate}
class StreamAudioRecorder extends StatelessWidget {
  /// {@macro streamAudioRecorder}
  const StreamAudioRecorder({
    super.key,
    required this.state,
    required this.builder,
    required this.button,
  });

  /// The button widget to display.
  final Widget button;

  /// The current state of the audio recorder.
  final AudioRecorderState state;

  /// The builder function to construct the audio recorder UI.
  final AudioRecorderBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context, state, button);
}

/// {@template slideTransitionWidget}
/// Reusable widget for creating slide-based transitions.
///
/// Provides a configurable animation for sliding widgets in and out.
///
/// Enables smooth sliding transitions with customizable parameters.
/// {@endtemplate}
class SlideTransitionWidget extends StatefulWidget {
  /// {@macro slideTransitionWidget}
  const SlideTransitionWidget({
    super.key,
    required this.begin,
    required this.end,
    this.curve = Curves.easeOut,
    this.duration = const Duration(milliseconds: 300),
    required this.child,
  });

  /// The starting offset of the slide transition.
  final Offset begin;

  /// The ending offset of the slide transition.
  final Offset end;

  /// The duration of the slide transition.
  final Duration duration;

  /// The curve of the slide transition.
  final Curve curve;

  /// The child widget to slide.
  final Widget child;

  @override
  State<SlideTransitionWidget> createState() => _SlideTransitionWidgetState();
}

class _SlideTransitionWidgetState extends State<SlideTransitionWidget>
    with SingleTickerProviderStateMixin<SlideTransitionWidget> {
  late final _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = Tween<Offset>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    return SlideTransition(
      position: position,
      child: widget.child,
    );
  }
}

/// {@template holdToRecordInfoTooltip}
/// Tooltip to guide users on initiating audio recording.
///
/// Provides an informative message with a custom-painted arrow and styling.
///
/// Displays instructional information for audio recording interaction.
/// {@endtemplate}
class HoldToRecordInfoTooltip extends StatelessWidget {
  /// {@macro holdToRecordInfoTooltip}
  const HoldToRecordInfoTooltip({
    super.key,
    required this.message,
  });

  /// The message to show in the tooltip.
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    const recordButtonWidth = kDefaultMessageInputIconSize +
        kDefaultMessageInputIconPadding * 2; // right, left padding.

    const arrowSize = Size(recordButtonWidth / 2, 6);

    return Padding(
      padding: EdgeInsets.only(bottom: arrowSize.height),
      child: CustomPaint(
        painter: TooltipPainter(
          arrowSize: arrowSize,
          arrowMargin: arrowSize.width / 2,
          color: theme.colorTheme.textLowEmphasis,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            message,
            style: theme.textTheme.body.copyWith(
              color: theme.colorTheme.barsBg,
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template tooltipPainter}
/// Custom painter for creating tooltips with an arrow indicator.
///
/// Enables precise rendering of custom-shaped tooltips with configurable
/// styling.
///
/// Provides a flexible mechanism for painting custom-shaped tooltips.
/// {@endtemplate}
class TooltipPainter extends CustomPainter {
  /// {@macro tooltipPainter}
  const TooltipPainter({
    this.color = Colors.grey,
    this.arrowSize = const Size(16, 8),
    this.arrowMargin = 8,
    this.borderRadius = BorderRadius.zero,
  });

  /// The background color of the tooltip.
  final Color color;

  /// The size of the arrow indicator.
  final Size arrowSize;

  /// The margin between the arrow and the tooltip.
  final double arrowMargin;

  /// The border radius of the tooltip.
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    final rect = Rect.fromLTRB(0, 0, width, height);
    final outer = borderRadius.toRRect(rect);
    canvas.drawRRect(outer, paint);

    final arrowWidth = arrowSize.width;
    final arrowHeight = arrowSize.height;

    final arrowPath = Path()
      ..moveTo(width - arrowWidth - arrowMargin, height)
      ..lineTo(width - arrowWidth / 2 - arrowMargin, height + arrowHeight)
      ..lineTo(width, height / 2)
      ..close();

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

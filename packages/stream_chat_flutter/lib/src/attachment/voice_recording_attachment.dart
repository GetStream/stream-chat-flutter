import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/src/audio/audio_sampling.dart' as sampling;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

const _kDefaultWaveformLimit = 35;
const _kDefaultWaveformHeight = 20.0;

/// Signature for building trailing widgets in voice recording attachments.
///
/// Provides a flexible way to customize the trailing section of the
/// voice recording player based on the current track and playback state.
typedef StreamVoiceRecordingAttachmentTrailingWidgetBuilder =
    Widget Function(
      BuildContext context,
      PlaylistTrack track,
      PlaybackSpeed speed,
      ValueChanged<PlaybackSpeed>? onChangeSpeed,
    );

/// {@template streamVoiceRecordingAttachment}
/// An embedded audio player for voice recordings with comprehensive playback
/// controls.
///
/// Provides a rich audio message player with features including:
/// - Play/pause controls
/// - Waveform visualization
/// - Playback speed adjustment
/// - Optional title display
///
/// Supports customizable appearance and interaction through various parameters.
/// {@endtemplate}
class StreamVoiceRecordingAttachment extends StatelessWidget {
  /// {@macro streamVoiceRecordingAttachment}
  const StreamVoiceRecordingAttachment({
    super.key,
    required this.track,
    required this.speed,
    this.onTrackPause,
    this.onTrackPlay,
    this.onTrackReplay,
    this.onTrackSeekStart,
    this.onTrackSeekChanged,
    this.onTrackSeekEnd,
    this.onChangeSpeed,
    this.shape,
    this.constraints = const BoxConstraints(),
    this.showTitle = false,
    this.title,
    this.trailingBuilder = _defaultTrailingBuilder,
    this.onRemovePressed,
  });

  /// The audio track to display.
  final PlaylistTrack track;

  /// The current playback speed of the audio track.
  final PlaybackSpeed speed;

  /// Callback when the track is paused.
  final VoidCallback? onTrackPause;

  /// Callback when the track is played.
  final VoidCallback? onTrackPlay;

  /// Callback when the track is replayed.
  final VoidCallback? onTrackReplay;

  /// Callback when the track seek is started.
  final ValueChanged<double>? onTrackSeekStart;

  /// Callback when the track seek is changed.
  final ValueChanged<double>? onTrackSeekChanged;

  /// Callback when the track seek is ended.
  final ValueChanged<double>? onTrackSeekEnd;

  /// Callback when the playback speed is changed.
  final ValueChanged<PlaybackSpeed>? onChangeSpeed;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The constraints to use when displaying the voice recording.
  final BoxConstraints constraints;

  /// The title of the audio message to display when [showTitle] is `true`.
  /// If not provided, the [track.title] will be used.
  final String? title;

  /// Whether to show the title of the audio message.
  ///
  /// Defaults to `false`.
  final bool showTitle;

  /// The builder to use for the trailing widget.
  final StreamVoiceRecordingAttachmentTrailingWidgetBuilder trailingBuilder;

  /// Callback called when the remove button is pressed.
  /// If not provided, the remove button will not be shown.
  final VoidCallback? onRemovePressed;

  static Widget _defaultTrailingBuilder(
    BuildContext context,
    PlaylistTrack track,
    PlaybackSpeed speed,
    ValueChanged<PlaybackSpeed>? onChangeSpeed,
  ) {
    return SpeedControlButton(
      speed: speed,
      onChangeSpeed: onChangeSpeed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final theme = StreamVoiceRecordingAttachmentTheme.of(context);
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;

    return StreamMessageComposerAttachmentContainer(
      borderColor: colorScheme.borderDefault,
      onRemovePressed: onRemovePressed,
      backgroundColor: theme.backgroundColor,
      padding: EdgeInsets.all(spacing.sm),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          AudioControlButton(
            state: track.state,
            onPlay: onTrackPlay,
            onPause: onTrackPause,
            onReplay: onTrackReplay,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title ?? track.title case final title? when showTitle)
                  AudioTitleText(
                    title: title,
                    style: theme.titleTextStyle ?? textTheme.metadataEmphasis,
                  ),

                Row(
                  children: [
                    AudioDurationText(
                      duration: track.duration,
                      position: track.position,
                      style:
                          theme.durationTextStyle ??
                          textTheme.metadataEmphasis.copyWith(color: colorScheme.textSecondary),
                    ),
                    SizedBox(width: spacing.xs),
                    Expanded(
                      child: SizedBox(
                        height: _kDefaultWaveformHeight,
                        child: StreamAudioWaveformSlider(
                          limit: _kDefaultWaveformLimit,
                          waveform: sampling.resampleWaveformData(
                            track.waveform,
                            _kDefaultWaveformLimit,
                          ),
                          progress: track.progress,
                          onChangeStart: onTrackSeekStart,
                          onChanged: onTrackSeekChanged,
                          onChangeEnd: onTrackSeekEnd,
                          isActive: track.state != TrackState.idle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          trailingBuilder(context, track, speed, onChangeSpeed),
        ],
      ),
    );
  }
}

/// {@template audioTitleText}
/// A compact text widget for displaying audio file titles.
///
/// Renders the title with ellipsis truncation and optional styling.
/// {@endtemplate}
class AudioTitleText extends StatelessWidget {
  /// {@macro audioTitleText}
  const AudioTitleText({
    super.key,
    required this.title,
    this.style,
  });

  /// The title to display.
  final String title;

  /// The style to apply to the title.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// {@template audioDurationText}
/// Displays duration for audio playback with dynamic formatting.
///
/// Shows either current position or total duration based on playback state.
/// {@endtemplate}
class AudioDurationText extends StatelessWidget {
  /// {@macro audioDurationText}
  const AudioDurationText({
    super.key,
    required this.duration,
    required this.position,
    this.style,
  });

  /// The total duration of the audio track.
  final Duration duration;

  /// The current position of the audio track.
  final Duration position;

  /// The style to apply to the duration text.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      switch (position.inMilliseconds > 0) {
        true => position.toMinutesAndSeconds(),
        false => duration.toMinutesAndSeconds(),
      },
      style: style?.copyWith(
        // Use mono space for each num character.
        fontFeatures: [const FontFeature.tabularFigures()],
      ),
    );
  }
}

/// {@template audioControlButton}
/// A control button for managing audio playback state.
///
/// Adapts its icon and behavior based on the current track state:
/// - Loading: Shows a progress indicator
/// - Idle: Displays play icon
/// - Playing: Shows pause icon
/// - Paused: Shows play icon
/// {@endtemplate}
class AudioControlButton extends StatelessWidget {
  /// {@macro audioControlButton}
  const AudioControlButton({
    super.key,
    required this.state,
    this.onPlay,
    this.onPause,
    this.onReplay,
    this.style = .secondary,
    this.type = .outline,
    this.size = .medium,
  });

  /// The current state of the audio track.
  final TrackState state;

  /// Callback when the track is played.
  final VoidCallback? onPlay;

  /// Callback when the track is paused.
  final VoidCallback? onPause;

  /// Callback when the track is replayed.
  final VoidCallback? onReplay;

  /// The style of the button.
  final StreamButtonStyle style;

  /// The type of the button.
  final StreamButtonType type;

  /// The size of the button.
  final StreamButtonSize size;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return StreamButton.icon(
      style: style,
      type: type,
      size: size,
      icon: switch (state) {
        TrackState.loading => icons.playSolid,
        TrackState.idle => icons.playSolid,
        TrackState.playing => icons.pause,
        TrackState.paused => icons.playSolid,
      },
      onTap: switch (state) {
        TrackState.loading => null,
        TrackState.idle => onPlay,
        TrackState.playing => onPause,
        TrackState.paused => onPlay,
      },
    );
  }
}

/// {@template speedControlButton}
/// A button for controlling audio playback speed.
///
/// Allows cycling through predefined playback speeds when pressed.
/// {@endtemplate}
class SpeedControlButton extends StatelessWidget {
  /// {@macro speedControlButton}
  const SpeedControlButton({
    super.key,
    required this.speed,
    this.onChangeSpeed,
  });

  /// The current playback speed of the audio track.
  final PlaybackSpeed speed;

  /// Callback when the playback speed is changed.
  final ValueChanged<PlaybackSpeed>? onChangeSpeed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVoiceRecordingAttachmentTheme.of(context);
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final buttonStyle =
        theme.speedControlButtonStyle ??
        ElevatedButton.styleFrom(
          elevation: 2,
          textStyle: textTheme.metadataEmphasis,
          foregroundColor: colorScheme.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: Colors.white,
          shape: StadiumBorder(side: BorderSide(color: colorScheme.borderDefault)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(40, 28),
        );

    return TextButton(
      style: buttonStyle,
      onPressed: switch (onChangeSpeed) {
        final it? => () => it(speed.next),
        _ => null,
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 28),
        child: Text(
          'x${speed.speed.toString().replaceFirst('.0', '')}',
          style: textTheme.metadataEmphasis.copyWith(height: 1),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

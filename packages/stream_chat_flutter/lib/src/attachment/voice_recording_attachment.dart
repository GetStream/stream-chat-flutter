import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/src/audio/audio_sampling.dart' as sampling;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

const _kDefaultWaveformLimit = 35;
const _kDefaultWaveformHeight = 24.0;

/// An inline audio player for a voice recording attachment.
///
/// [StreamVoiceRecordingAttachment] displays a single voice recording with
/// playback controls, waveform visualization, and speed adjustment.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamVoiceRecordingAttachment(
///   track: track,
///   speed: playbackSpeed,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamVoiceRecordingAttachmentProps], which configures this widget.
///  * [DefaultStreamVoiceRecordingAttachment], the default implementation.
class StreamVoiceRecordingAttachment extends StatelessWidget {
  /// Creates a [StreamVoiceRecordingAttachment].
  StreamVoiceRecordingAttachment({
    super.key,
    required PlaylistTrack track,
    required StreamPlaybackSpeed speed,
    VoidCallback? onTrackPause,
    VoidCallback? onTrackPlay,
    VoidCallback? onTrackReplay,
    ValueChanged<double>? onTrackSeekStart,
    ValueChanged<double>? onTrackSeekChanged,
    ValueChanged<double>? onTrackSeekEnd,
    ValueChanged<StreamPlaybackSpeed>? onChangeSpeed,
    BoxConstraints constraints = const BoxConstraints(),
    bool showTitle = false,
    String? title,
  }) : props = .new(
         track: track,
         speed: speed,
         onTrackPause: onTrackPause,
         onTrackPlay: onTrackPlay,
         onTrackReplay: onTrackReplay,
         onTrackSeekStart: onTrackSeekStart,
         onTrackSeekChanged: onTrackSeekChanged,
         onTrackSeekEnd: onTrackSeekEnd,
         onChangeSpeed: onChangeSpeed,
         constraints: constraints,
         showTitle: showTitle,
         title: title,
       );

  /// The properties that configure this attachment.
  final StreamVoiceRecordingAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamVoiceRecordingAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamVoiceRecordingAttachment(props: props);
  }
}

/// Properties for configuring a [StreamVoiceRecordingAttachment].
///
/// This class holds all the configuration options for a voice recording
/// attachment, allowing them to be passed through the
/// [StreamComponentFactory].
///
/// See also:
///
///  * [StreamVoiceRecordingAttachment], which uses these properties.
///  * [DefaultStreamVoiceRecordingAttachment], the default implementation.
class StreamVoiceRecordingAttachmentProps {
  /// Creates properties for a voice recording attachment.
  const StreamVoiceRecordingAttachmentProps({
    required this.track,
    required this.speed,
    this.onTrackPause,
    this.onTrackPlay,
    this.onTrackReplay,
    this.onTrackSeekStart,
    this.onTrackSeekChanged,
    this.onTrackSeekEnd,
    this.onChangeSpeed,
    this.constraints = const BoxConstraints(),
    this.showTitle = false,
    this.title,
  });

  /// The audio track to display.
  final PlaylistTrack track;

  /// The current playback speed of the audio track.
  final StreamPlaybackSpeed speed;

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
  final ValueChanged<StreamPlaybackSpeed>? onChangeSpeed;

  /// The constraints to use when displaying the voice recording.
  final BoxConstraints constraints;

  /// The title of the audio message to display when [showTitle] is `true`.
  /// If not provided, the [track] title will be used.
  final String? title;

  /// Whether to show the title of the audio message.
  ///
  /// Defaults to `false`.
  final bool showTitle;
}

/// The default implementation of [StreamVoiceRecordingAttachment].
///
/// Renders an inline audio player with playback controls, waveform
/// visualization, and playback speed adjustment.
///
/// See also:
///
///  * [StreamVoiceRecordingAttachment], the public API widget.
///  * [StreamVoiceRecordingAttachmentProps], which configures this widget.
class DefaultStreamVoiceRecordingAttachment extends StatelessWidget {
  /// Creates a default Stream voice recording attachment.
  const DefaultStreamVoiceRecordingAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamVoiceRecordingAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;

    final theme = StreamVoiceRecordingAttachmentTheme.of(context);
    final defaults = _StreamVoiceRecordingAttachmentDefaults(context);

    final isActive = props.track.state != TrackState.idle;
    final isPlaying = props.track.state == TrackState.playing;

    final effectiveDurationTextStyle = theme.durationTextStyle ?? defaults.durationTextStyle;
    final effectiveActiveDurationTextStyle = theme.activeDurationTextStyle ?? defaults.activeDurationTextStyle;
    final effectiveSpeedToggleStyle = theme.speedToggleStyle ?? defaults.speedToggleStyle;
    final effectiveControlButtonStyle = theme.controlButtonStyle ?? defaults.controlButtonStyle;

    return Padding(
      padding: .all(spacing.xs),
      child: Row(
        spacing: spacing.xs,
        crossAxisAlignment: .center,
        children: [
          AudioControlButton(
            state: props.track.state,
            onPlay: props.onTrackPlay,
            onPause: props.onTrackPause,
            onReplay: props.onTrackReplay,
            themeStyle: effectiveControlButtonStyle,
          ),
          Expanded(
            child: Column(
              spacing: spacing.xxxs,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (props.title ?? props.track.title case final title? when props.showTitle)
                  AudioTitleText(
                    title: title,
                    style: theme.titleTextStyle ?? textTheme.metadataEmphasis,
                  ),
                Row(
                  spacing: spacing.sm,
                  children: [
                    AudioDurationText(
                      duration: props.track.duration,
                      position: props.track.position,
                      style: isPlaying ? effectiveActiveDurationTextStyle : effectiveDurationTextStyle,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: _kDefaultWaveformHeight,
                        child: StreamAudioWaveformSlider(
                          isActive: isActive,
                          limit: _kDefaultWaveformLimit,
                          waveform: sampling.resampleWaveformData(
                            props.track.waveform,
                            _kDefaultWaveformLimit,
                          ),
                          progress: props.track.progress,
                          onChangeStart: props.onTrackSeekStart,
                          onChanged: props.onTrackSeekChanged,
                          onChangeEnd: props.onTrackSeekEnd,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamPlaybackSpeedToggle(
            value: props.speed,
            onChanged: props.onChangeSpeed,
            style: effectiveSpeedToggleStyle,
          ),
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
/// Shows either remaining time or total duration based on playback state.
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
    final remaining = [duration - position, Duration.zero].max;
    return Text(
      remaining.toMinutesAndSeconds(),
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
    this.themeStyle,
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

  /// The optional style override for the button.
  final StreamButtonThemeStyle? themeStyle;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return StreamButton.icon(
      style: style,
      type: type,
      size: size,
      themeStyle: themeStyle,
      icon: switch (state) {
        TrackState.loading => Icon(icons.playFill),
        TrackState.idle => Icon(icons.playFill),
        TrackState.playing => Icon(icons.pauseFill),
        TrackState.paused => Icon(icons.playFill),
      },
      onPressed: switch (state) {
        TrackState.loading => null,
        TrackState.idle => onPlay,
        TrackState.playing => onPause,
        TrackState.paused => onPlay,
      },
    );
  }
}

// Default values for [StreamVoiceRecordingAttachmentThemeData] backed by stream design tokens.
class _StreamVoiceRecordingAttachmentDefaults extends StreamVoiceRecordingAttachmentThemeData {
  _StreamVoiceRecordingAttachmentDefaults(this._context);

  final BuildContext _context;

  late final StreamColorScheme _colorScheme = _context.streamColorScheme;
  late final StreamTextTheme _textTheme = _context.streamTextTheme;

  @override
  TextStyle get titleTextStyle => _textTheme.captionEmphasis.copyWith(color: _colorScheme.textPrimary);

  @override
  TextStyle get durationTextStyle => _textTheme.metadataEmphasis.copyWith(color: _colorScheme.textPrimary);

  @override
  TextStyle get activeDurationTextStyle => _textTheme.metadataEmphasis.copyWith(color: _colorScheme.accentPrimary);
}

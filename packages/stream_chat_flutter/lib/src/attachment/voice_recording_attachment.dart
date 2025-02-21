import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/src/audio/audio_sampling.dart' as sampling;
import 'package:stream_chat_flutter/src/misc/audio_waveform.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _kDefaultWaveformLimit = 35;
const _kDefaultWaveformHeight = 28.0;

/// Signature for building trailing widgets in voice recording attachments.
///
/// Provides a flexible way to customize the trailing section of the
/// voice recording player based on the current track and playback state.
typedef StreamVoiceRecordingAttachmentTrailingWidgetBuilder = Widget Function(
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
    this.trailingBuilder = _defaultTrailingBuilder,
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

  /// Whether to show the title of the audio message.
  ///
  /// Defaults to `false`.
  final bool showTitle;

  /// The builder to use for the trailing widget.
  final StreamVoiceRecordingAttachmentTrailingWidgetBuilder trailingBuilder;

  static Widget _defaultTrailingBuilder(
    BuildContext context,
    PlaylistTrack track,
    PlaybackSpeed speed,
    ValueChanged<PlaybackSpeed>? onChangeSpeed,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: switch (track.state.isPlaying) {
        true => SpeedControlButton(
            speed: speed,
            onChangeSpeed: onChangeSpeed,
          ),
        false => getFileTypeImage(track.title?.mediaType?.mimeType),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamVoiceRecordingAttachmentTheme.of(context);
    final waveformSliderTheme = theme.audioWaveformSliderTheme;
    final waveformTheme = waveformSliderTheme?.audioWaveformTheme;

    final shape = this.shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: StreamChatTheme.of(context).colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(14),
        );

    return Container(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: shape,
        color: theme.backgroundColor,
      ),
      child: Row(
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
                if (track.title case final title? when showTitle) ...[
                  AudioTitleText(
                    title: title,
                    style: theme.titleTextStyle,
                  ),
                  const SizedBox(height: 6),
                ],
                Row(
                  children: [
                    AudioDurationText(
                      duration: track.duration,
                      position: track.position,
                      style: theme.durationTextStyle,
                    ),
                    const SizedBox(width: 8),
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
                          color: waveformTheme?.color,
                          progressColor: waveformTheme?.progressColor,
                          minBarHeight: waveformTheme?.minBarHeight,
                          spacingRatio: waveformTheme?.spacingRatio,
                          heightScale: waveformTheme?.heightScale,
                          thumbColor: waveformSliderTheme?.thumbColor,
                          thumbBorderColor:
                              waveformSliderTheme?.thumbBorderColor,
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
  });

  /// The current state of the audio track.
  final TrackState state;

  /// Callback when the track is played.
  final VoidCallback? onPlay;

  /// Callback when the track is paused.
  final VoidCallback? onPause;

  /// Callback when the track is replayed.
  final VoidCallback? onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVoiceRecordingAttachmentTheme.of(context);

    return ElevatedButton(
      style: theme.audioControlButtonStyle,
      onPressed: switch (state) {
        TrackState.loading => null,
        TrackState.idle => onPlay,
        TrackState.playing => onPause,
        TrackState.paused => onPlay,
      },
      child: switch (state) {
        TrackState.loading => theme.loadingIndicator,
        TrackState.idle => theme.playIcon,
        TrackState.playing => theme.pauseIcon,
        TrackState.paused => theme.playIcon,
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

    return ElevatedButton(
      style: theme.speedControlButtonStyle,
      onPressed: switch (onChangeSpeed) {
        final it? => () => it(speed.next),
        _ => null,
      },
      child: Text('x${speed.speed}'),
    );
  }
}

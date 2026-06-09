import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'voice_recording_attachment_theme.g.theme.dart';

/// Applies a voice recording attachment theme to descendant
/// [StreamVoiceRecordingAttachment] widgets.
///
/// Wrap a subtree with [StreamVoiceRecordingAttachmentTheme] to override
/// voice recording styling. Access the merged theme using
/// [StreamVoiceRecordingAttachmentTheme.of].
///
/// {@tool snippet}
///
/// Override voice recording styling for a specific section:
///
/// ```dart
/// StreamVoiceRecordingAttachmentTheme(
///   data: StreamVoiceRecordingAttachmentThemeData(
///     durationTextStyle: TextStyle(fontWeight: FontWeight.w700),
///     activeDurationTextStyle: TextStyle(color: Colors.blue),
///   ),
///   child: StreamVoiceRecordingAttachment(
///     track: track,
///     speed: speed,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamVoiceRecordingAttachmentThemeData], which describes the voice
///    recording attachment theme.
///  * [StreamVoiceRecordingAttachment], the widget affected by this theme.
class StreamVoiceRecordingAttachmentTheme extends InheritedTheme {
  /// Creates a voice recording attachment theme that controls descendant
  /// widgets.
  const StreamVoiceRecordingAttachmentTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The voice recording attachment theme data for descendant widgets.
  final StreamVoiceRecordingAttachmentThemeData data;

  /// Returns the [StreamVoiceRecordingAttachmentThemeData] merged from local
  /// and global themes.
  ///
  /// Local values from the nearest [StreamVoiceRecordingAttachmentTheme]
  /// ancestor take precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides - for example, overriding only
  /// [StreamVoiceRecordingAttachmentThemeData.durationTextStyle] while
  /// inheriting other properties from the global theme.
  static StreamVoiceRecordingAttachmentThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamVoiceRecordingAttachmentTheme>();
    return StreamChatTheme.of(context).voiceRecordingAttachmentTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamVoiceRecordingAttachmentTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamVoiceRecordingAttachmentTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamVoiceRecordingAttachment] widgets.
///
/// {@tool snippet}
///
/// Customize voice recording attachment appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   voiceRecordingAttachmentTheme: StreamVoiceRecordingAttachmentThemeData(
///     durationTextStyle: TextStyle(fontWeight: FontWeight.w700),
///     speedToggleStyle: StreamPlaybackSpeedToggleStyle.from(
///       borderColor: Colors.grey,
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamVoiceRecordingAttachment], the widget that uses this theme data.
///  * [StreamVoiceRecordingAttachmentTheme], for overriding theme in a widget
///    subtree.
@themeGen
@immutable
class StreamVoiceRecordingAttachmentThemeData with _$StreamVoiceRecordingAttachmentThemeData {
  /// Creates voice recording attachment theme data with optional style
  /// overrides.
  const StreamVoiceRecordingAttachmentThemeData({
    this.titleTextStyle,
    this.durationTextStyle,
    this.activeDurationTextStyle,
    this.controlButtonStyle,
    this.speedToggleStyle,
    this.waveformStyle,
  });

  /// The text style for the audio file title.
  ///
  /// If null, defaults to [StreamTextTheme.metadataEmphasis].
  final TextStyle? titleTextStyle;

  /// The text style for the duration label in default/idle state.
  ///
  /// If null, defaults to [StreamTextTheme.metadataEmphasis] with
  /// [StreamColorScheme.textPrimary] color.
  final TextStyle? durationTextStyle;

  /// The text style for the duration label when actively playing.
  ///
  /// If null, defaults to [StreamTextTheme.metadataEmphasis] with
  /// [StreamColorScheme.accentPrimary] color.
  final TextStyle? activeDurationTextStyle;

  /// The visual styling for the play/pause/replay control button.
  ///
  /// If null, defaults to secondary outline [StreamButton] defaults with
  /// chat-specific border color.
  final StreamButtonThemeStyle? controlButtonStyle;

  /// The visual styling for the [StreamPlaybackSpeedToggle] (x1, x2, x0.5).
  ///
  /// If null, defaults to [StreamPlaybackSpeedToggle] defaults with
  /// chat-specific border color and disabled state styling.
  final StreamPlaybackSpeedToggleStyle? speedToggleStyle;

  /// The theme overrides for the waveform visualization.
  ///
  /// Chat-specific waveform colors for idle bars, playing bars, and thumb.
  /// If null, defaults to [StreamAudioWaveformTheme] defaults.
  final StreamAudioWaveformThemeData? waveformStyle;

  /// Linearly interpolate between two
  /// [StreamVoiceRecordingAttachmentThemeData] objects.
  static StreamVoiceRecordingAttachmentThemeData? lerp(
    StreamVoiceRecordingAttachmentThemeData? a,
    StreamVoiceRecordingAttachmentThemeData? b,
    double t,
  ) => _$StreamVoiceRecordingAttachmentThemeData.lerp(a, b, t);
}

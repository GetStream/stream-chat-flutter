import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/audio_waveform_slider_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamVoiceRecordingAttachmentTheme}
/// Overrides the default style of [StreamVoiceRecordingAttachment] descendants.
///
/// See also:
///
///  * [StreamVoiceRecordingAttachmentThemeData], which is used to configure
///  this theme.
/// {@endtemplate}
class StreamVoiceRecordingAttachmentTheme extends InheritedTheme {
  /// Creates a [StreamVoiceRecordingAttachmentTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamVoiceRecordingAttachmentTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamVoiceRecordingAttachmentThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamVoiceRecordingAttachmentTheme] widget,
  /// then [StreamVoiceRecordingAttachmentTheme.voiceRecordingTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// StreamVoiceRecordingAttachmentTheme theme =
  /// StreamVoiceRecordingAttachmentTheme.of(context);
  /// ```
  static StreamVoiceRecordingAttachmentThemeData of(BuildContext context) {
    final voiceRecordingTheme = context.dependOnInheritedWidgetOfExactType<
        StreamVoiceRecordingAttachmentTheme>();
    return voiceRecordingTheme?.data ??
        StreamChatTheme.of(context).voiceRecordingAttachmentTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamVoiceRecordingAttachmentTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamVoiceRecordingAttachmentTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template streamVoiceRecordingAttachmentThemeData}
/// A style that overrides the default appearance of
/// [StreamVoiceRecordingAttachment] widgets when used with
/// [StreamVoiceRecordingAttachmentTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.voiceRecordingAttachmentTheme].
/// {@endtemplate}
class StreamVoiceRecordingAttachmentThemeData with Diagnosticable {
  /// {@macro streamVoiceRecordingAttachmentThemeData}
  const StreamVoiceRecordingAttachmentThemeData({
    this.backgroundColor,
    this.playIcon,
    this.pauseIcon,
    this.loadingIndicator,
    this.audioControlButtonStyle,
    this.titleTextStyle,
    this.durationTextStyle,
    this.speedControlButtonStyle,
    this.audioWaveformSliderTheme,
  });

  /// The background color of the attachment.
  final Color? backgroundColor;

  /// The icon widget to show when the recording is playing.
  final Widget? playIcon;

  /// The icon widget to show when the recording is paused.
  final Widget? pauseIcon;

  /// The widget to show when the recording is loading.
  final Widget? loadingIndicator;

  /// The style for the audio control button.
  final ButtonStyle? audioControlButtonStyle;

  /// The text style for the title.
  final TextStyle? titleTextStyle;

  /// The text style for the duration.
  final TextStyle? durationTextStyle;

  /// The style for the speed control button.
  final ButtonStyle? speedControlButtonStyle;

  /// The theme for the audio waveform slider.
  final StreamAudioWaveformSliderThemeData? audioWaveformSliderTheme;

  /// A copy of [StreamVoiceRecordingAttachmentThemeData] with specified
  /// attributes overridden.
  StreamVoiceRecordingAttachmentThemeData copyWith({
    Color? backgroundColor,
    Widget? playIcon,
    Widget? pauseIcon,
    Widget? loadingIndicator,
    ButtonStyle? audioControlButtonStyle,
    TextStyle? titleTextStyle,
    TextStyle? durationTextStyle,
    ButtonStyle? speedControlButtonStyle,
    StreamAudioWaveformSliderThemeData? audioWaveformSliderTheme,
  }) =>
      StreamVoiceRecordingAttachmentThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        playIcon: playIcon ?? this.playIcon,
        pauseIcon: pauseIcon ?? this.pauseIcon,
        loadingIndicator: loadingIndicator ?? this.loadingIndicator,
        audioControlButtonStyle:
            audioControlButtonStyle ?? this.audioControlButtonStyle,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        durationTextStyle: durationTextStyle ?? this.durationTextStyle,
        speedControlButtonStyle:
            speedControlButtonStyle ?? this.speedControlButtonStyle,
        audioWaveformSliderTheme:
            audioWaveformSliderTheme ?? this.audioWaveformSliderTheme,
      );

  /// Merges this [StreamVoiceRecordingAttachmentThemeData] with the [other].
  StreamVoiceRecordingAttachmentThemeData merge(
    StreamVoiceRecordingAttachmentThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      playIcon: other.playIcon,
      pauseIcon: other.pauseIcon,
      loadingIndicator: other.loadingIndicator,
      audioControlButtonStyle: other.audioControlButtonStyle,
      titleTextStyle: other.titleTextStyle,
      durationTextStyle: other.durationTextStyle,
      speedControlButtonStyle: other.speedControlButtonStyle,
      audioWaveformSliderTheme: audioWaveformSliderTheme?.merge(
        other.audioWaveformSliderTheme,
      ),
    );
  }

  /// Linearly interpolate between two [StreamVoiceRecordingAttachmentThemeData]
  /// objects.
  static StreamVoiceRecordingAttachmentThemeData lerp(
    StreamVoiceRecordingAttachmentThemeData a,
    StreamVoiceRecordingAttachmentThemeData b,
    double t,
  ) {
    return StreamVoiceRecordingAttachmentThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      playIcon: t < 0.5 ? a.playIcon : b.playIcon,
      pauseIcon: t < 0.5 ? a.pauseIcon : b.pauseIcon,
      loadingIndicator: t < 0.5 ? a.loadingIndicator : b.loadingIndicator,
      audioControlButtonStyle: ButtonStyle.lerp(
          a.audioControlButtonStyle, b.audioControlButtonStyle, t),
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      durationTextStyle:
          TextStyle.lerp(a.durationTextStyle, b.durationTextStyle, t),
      speedControlButtonStyle: ButtonStyle.lerp(
          a.speedControlButtonStyle, b.speedControlButtonStyle, t),
      audioWaveformSliderTheme: StreamAudioWaveformSliderThemeData.lerp(
          a.audioWaveformSliderTheme!, b.audioWaveformSliderTheme!, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamVoiceRecordingAttachmentThemeData &&
          other.backgroundColor == backgroundColor &&
          other.playIcon == playIcon &&
          other.pauseIcon == pauseIcon &&
          other.loadingIndicator == loadingIndicator &&
          other.audioControlButtonStyle == audioControlButtonStyle &&
          other.titleTextStyle == titleTextStyle &&
          other.durationTextStyle == durationTextStyle &&
          other.speedControlButtonStyle == speedControlButtonStyle &&
          other.audioWaveformSliderTheme == audioWaveformSliderTheme;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      playIcon.hashCode ^
      pauseIcon.hashCode ^
      loadingIndicator.hashCode ^
      audioControlButtonStyle.hashCode ^
      titleTextStyle.hashCode ^
      durationTextStyle.hashCode ^
      speedControlButtonStyle.hashCode ^
      audioWaveformSliderTheme.hashCode;
}

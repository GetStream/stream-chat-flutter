import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The theme for audio message components
class AudioRecordingMessageTheme extends InheritedTheme {
  /// Creates a [AudioRecordingMessageTheme].
  ///
  /// The [data] parameter must not be null.
  const AudioRecordingMessageTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final AudioRecordingMessageThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [AudioRecordingMessageTheme] widget, then
  /// [StreamChatThemeData.audioRecordingMessageTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = AudioRecordingMessageTheme.of(context);
  /// ```
  static AudioRecordingMessageThemeData of(BuildContext context) {
    final audioRecordingMessageTheme = context
        .dependOnInheritedWidgetOfExactType<AudioRecordingMessageTheme>();
    return audioRecordingMessageTheme?.data ??
        StreamChatTheme.of(context).audioRecordingMessageTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      AudioRecordingMessageTheme(data: data, child: child);

  @override
  bool updateShouldNotify(AudioRecordingMessageTheme oldWidget) =>
      data != oldWidget.data;
}

/// The theme for audio message components
class AudioRecordingMessageThemeData with Diagnosticable {
  /// Creates a new instance of the audio message theme
  AudioRecordingMessageThemeData({
    this.audioButtonColor = const Color(0XFFFFFFFF),
    this.audioButtonBannerColor = const Color(0xFF747881),
    this.audioButtonPressedColor = const Color(0xFF015DFF),
    this.audioButtonPressedBackgroundColor = const Color(0xFFDBDDE1),
    this.lockButtonForegroundColor = const Color(0xFF747881),
    this.lockButtonBackgroundColor = const Color(0xFFDBDDE1),
    this.recordingIndicatorColorIdle = const Color(0xFF747881),
    this.recordingIndicatorColorActive = const Color(0xFFFF515A),
    this.cancelTextColor = const Color(0xFF747881),
  });

  /// The color of the audio button
  final Color audioButtonColor;

  /// The color of the audio button when pressed
  final Color audioButtonPressedColor;

  /// The background color of the audio button when pressed
  final Color audioButtonPressedBackgroundColor;

  /// The color of the audio button banner
  final Color audioButtonBannerColor;

  /// The color of the lock button foreground
  final Color lockButtonForegroundColor;

  /// The color of the lock button background
  final Color lockButtonBackgroundColor;

  /// The color of the recording indicator when idle
  final Color recordingIndicatorColorIdle;

  /// The color of the recording indicator when active
  final Color recordingIndicatorColorActive;

  /// The color of the cancel text
  final Color cancelTextColor;

  /// Creates a copy of this theme but with the given fields replaced
  /// with the new values.
  AudioRecordingMessageThemeData copyWith({
    Color? audioButtonColor,
    Color? audioButtonBannerColor,
    Color? audioButtonPressedColor,
    Color? audioButtonPressedBackgroundColor,
    Color? lockButtonForegroundColor,
    Color? lockButtonBackgroundColor,
    Color? recordingIndicatorColorIdle,
    Color? recordingIndicatorColorActive,
    Color? cancelTextColor,
  }) {
    return AudioRecordingMessageThemeData(
      audioButtonColor: audioButtonColor ?? this.audioButtonColor,
      audioButtonBannerColor:
          audioButtonBannerColor ?? this.audioButtonBannerColor,
      audioButtonPressedColor:
          audioButtonPressedColor ?? this.audioButtonPressedColor,
      audioButtonPressedBackgroundColor: audioButtonPressedBackgroundColor ??
          this.audioButtonPressedBackgroundColor,
      lockButtonForegroundColor:
          lockButtonForegroundColor ?? this.lockButtonForegroundColor,
      lockButtonBackgroundColor:
          lockButtonBackgroundColor ?? this.lockButtonBackgroundColor,
      recordingIndicatorColorIdle:
          recordingIndicatorColorIdle ?? this.recordingIndicatorColorIdle,
      recordingIndicatorColorActive:
          recordingIndicatorColorActive ?? this.recordingIndicatorColorActive,
      cancelTextColor: cancelTextColor ?? this.cancelTextColor,
    );
  }

  /// Linearly interpolate between two themes.
  AudioRecordingMessageThemeData lerp(
    covariant AudioRecordingMessageThemeData? other,
    double t,
  ) {
    if (other is! AudioRecordingMessageThemeData) {
      return this;
    }

    return AudioRecordingMessageThemeData(
      audioButtonColor:
          Color.lerp(audioButtonColor, other.audioButtonColor, t)!,
      audioButtonBannerColor:
          Color.lerp(audioButtonBannerColor, other.audioButtonBannerColor, t)!,
      audioButtonPressedColor: Color.lerp(
          audioButtonPressedColor, other.audioButtonPressedColor, t)!,
      audioButtonPressedBackgroundColor: Color.lerp(
          audioButtonPressedBackgroundColor,
          other.audioButtonPressedBackgroundColor,
          t)!,
      lockButtonForegroundColor: Color.lerp(
          lockButtonForegroundColor, other.lockButtonForegroundColor, t)!,
      lockButtonBackgroundColor: Color.lerp(
          lockButtonBackgroundColor, other.lockButtonBackgroundColor, t)!,
      recordingIndicatorColorIdle: Color.lerp(
          recordingIndicatorColorIdle, other.recordingIndicatorColorIdle, t)!,
      recordingIndicatorColorActive: Color.lerp(recordingIndicatorColorActive,
          other.recordingIndicatorColorActive, t)!,
      cancelTextColor: Color.lerp(cancelTextColor, other.cancelTextColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioRecordingMessageThemeData &&
        other.audioButtonColor == audioButtonColor &&
        other.audioButtonBannerColor == audioButtonBannerColor &&
        other.audioButtonPressedColor == audioButtonPressedColor &&
        other.audioButtonPressedBackgroundColor ==
            audioButtonPressedBackgroundColor &&
        other.lockButtonForegroundColor == lockButtonForegroundColor &&
        other.lockButtonBackgroundColor == lockButtonBackgroundColor &&
        other.recordingIndicatorColorIdle == recordingIndicatorColorIdle &&
        other.recordingIndicatorColorActive == recordingIndicatorColorActive &&
        other.cancelTextColor == cancelTextColor;
  }

  @override
  int get hashCode =>
      audioButtonColor.hashCode ^
      audioButtonBannerColor.hashCode ^
      audioButtonPressedColor.hashCode ^
      audioButtonPressedBackgroundColor.hashCode ^
      lockButtonForegroundColor.hashCode ^
      lockButtonBackgroundColor.hashCode ^
      recordingIndicatorColorIdle.hashCode ^
      recordingIndicatorColorActive.hashCode ^
      cancelTextColor.hashCode;

  /// Merges one [AudioRecordingMessageThemeData] with the another
  AudioRecordingMessageThemeData merge(AudioRecordingMessageThemeData? other) {
    if (other == null) return this;
    return copyWith(
      audioButtonColor: other.audioButtonColor,
      audioButtonBannerColor: other.audioButtonBannerColor,
      audioButtonPressedColor: other.audioButtonPressedColor,
      audioButtonPressedBackgroundColor:
          other.audioButtonPressedBackgroundColor,
      lockButtonForegroundColor: other.lockButtonForegroundColor,
      lockButtonBackgroundColor: other.lockButtonBackgroundColor,
      recordingIndicatorColorIdle: other.recordingIndicatorColorIdle,
      recordingIndicatorColorActive: other.recordingIndicatorColorActive,
      cancelTextColor: other.cancelTextColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('audioButtonColor', audioButtonColor))
      ..add(
          DiagnosticsProperty('audioButtonBannerColor', audioButtonBannerColor))
      ..add(DiagnosticsProperty(
          'audioButtonPressedColor', audioButtonPressedColor))
      ..add(DiagnosticsProperty('audioButtonPressedBackgroundColor',
          audioButtonPressedBackgroundColor))
      ..add(DiagnosticsProperty(
          'lockButtonForegroundColor', lockButtonForegroundColor))
      ..add(DiagnosticsProperty(
          'lockButtonBackgroundColor', lockButtonBackgroundColor))
      ..add(DiagnosticsProperty(
          'recordingIndicatorColorIdle', recordingIndicatorColorIdle))
      ..add(DiagnosticsProperty(
          'recordingIndicatorColorActive', recordingIndicatorColorActive))
      ..add(DiagnosticsProperty('cancelTextColor', cancelTextColor));
  }
}

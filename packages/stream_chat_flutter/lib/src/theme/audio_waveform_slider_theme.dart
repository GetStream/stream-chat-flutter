import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/audio_waveform_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamAudioWaveformSliderTheme}
/// Overrides the default style of [StreamAudioWaveformSlider] descendants.
///
/// See also:
///
///  * [StreamVoiceRecordingAttachmentThemeData], which is used to configure
///  this theme.
/// {@endtemplate}
class StreamAudioWaveformSliderTheme extends InheritedTheme {
  /// Creates a [StreamAudioWaveformSliderTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamAudioWaveformSliderTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamAudioWaveformSliderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamAudioWaveformSliderTheme] widget,
  /// then [StreamAudioWaveformSliderTheme.audioWaveformSliderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// StreamAudioWaveformSliderTheme theme =
  /// StreamAudioWaveformSliderTheme.of(context);
  /// ```
  static StreamAudioWaveformSliderThemeData of(BuildContext context) {
    final audioWaveformSliderTheme = context.dependOnInheritedWidgetOfExactType<StreamAudioWaveformSliderTheme>();
    return audioWaveformSliderTheme?.data ?? StreamChatTheme.of(context).audioWaveformSliderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamAudioWaveformSliderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamAudioWaveformSliderTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamAudioWaveformSliderThemeData}
/// A style that overrides the default appearance of
/// [StreamAudioWaveformSlider] widgets when used with
/// [StreamAudioWaveformSliderTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.audioWaveformSliderTheme].
/// {@endtemplate}
class StreamAudioWaveformSliderThemeData with Diagnosticable {
  /// {@macro streamVoiceRecordingAttachmentThemeData}
  const StreamAudioWaveformSliderThemeData({
    this.audioWaveformTheme,
    this.thumbColor,
    this.thumbBorderColor,
  });

  /// The theme of the audio waveform.
  final StreamAudioWaveformThemeData? audioWaveformTheme;

  /// The color of the thumb.
  final Color? thumbColor;

  /// The color of the thumb border.
  final Color? thumbBorderColor;

  /// A copy of [StreamAudioWaveformSliderThemeData] with specified attributes
  /// overridden.
  StreamAudioWaveformSliderThemeData copyWith({
    StreamAudioWaveformThemeData? audioWaveformTheme,
    Color? thumbColor,
    Color? thumbBorderColor,
  }) {
    return StreamAudioWaveformSliderThemeData(
      audioWaveformTheme: audioWaveformTheme ?? this.audioWaveformTheme,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbBorderColor: thumbBorderColor ?? this.thumbBorderColor,
    );
  }

  /// Merges this [StreamPollOptionsDialogThemeData] with the [other].
  StreamAudioWaveformSliderThemeData merge(
    StreamAudioWaveformSliderThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      audioWaveformTheme: other.audioWaveformTheme,
      thumbColor: other.thumbColor,
      thumbBorderColor: other.thumbBorderColor,
    );
  }

  /// Linearly interpolate between two [StreamPollOptionsDialogThemeData].
  static StreamAudioWaveformSliderThemeData lerp(
    StreamAudioWaveformSliderThemeData a,
    StreamAudioWaveformSliderThemeData b,
    double t,
  ) => StreamAudioWaveformSliderThemeData(
    audioWaveformTheme: StreamAudioWaveformThemeData.lerp(a.audioWaveformTheme!, b.audioWaveformTheme!, t),
    thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
    thumbBorderColor: Color.lerp(a.thumbBorderColor, b.thumbBorderColor, t),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamAudioWaveformSliderThemeData &&
          other.audioWaveformTheme == audioWaveformTheme &&
          other.thumbColor == thumbColor &&
          other.thumbBorderColor == thumbBorderColor;

  @override
  int get hashCode => audioWaveformTheme.hashCode ^ thumbColor.hashCode ^ thumbBorderColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<StreamAudioWaveformThemeData>('audioWaveformTheme', audioWaveformTheme))
      ..add(ColorProperty('thumbColor', thumbColor))
      ..add(ColorProperty('thumbBorderColor', thumbBorderColor));
  }
}

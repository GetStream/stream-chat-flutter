import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamAudioWaveformTheme}
/// Overrides the default style of [StreamAudioWaveform] descendants.
///
/// See also:
///
///  * [StreamVoiceRecordingAttachmentThemeData], which is used to configure
///  this theme.
/// {@endtemplate}
class StreamAudioWaveformTheme extends InheritedTheme {
  /// Creates a [StreamAudioWaveformTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamAudioWaveformTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamAudioWaveformThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamAudioWaveformTheme] widget,
  /// then [StreamAudioWaveformTheme.audioWaveformSliderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// StreamAudioWaveformTheme theme = StreamAudioWaveformTheme.of(context);
  /// ```
  static StreamAudioWaveformThemeData of(BuildContext context) {
    final audioWaveformTheme = context.dependOnInheritedWidgetOfExactType<StreamAudioWaveformTheme>();
    return audioWaveformTheme?.data ?? StreamChatTheme.of(context).audioWaveformTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamAudioWaveformTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamAudioWaveformTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamVoiceRecordingAttachmentThemeData}
/// A style that overrides the default appearance of
/// [StreamAudioWaveformSlider] widgets when used with
/// [StreamAudioWaveformTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.audioWaveformSliderTheme].
/// {@endtemplate}
class StreamAudioWaveformThemeData with Diagnosticable {
  /// {@macro streamAudioWaveformThemeData}
  const StreamAudioWaveformThemeData({
    this.color,
    this.progressColor,
    this.minBarHeight,
    this.spacingRatio,
    this.heightScale,
  });

  /// The color of the wave bars.
  final Color? color;

  /// The color of the progressed wave bars.
  final Color? progressColor;

  /// The minimum height of the bars.
  final double? minBarHeight;

  /// The ratio of the spacing between the bars.
  final double? spacingRatio;

  /// The scale of the height of the bars.
  final double? heightScale;

  /// A copy of [StreamAudioWaveformThemeData] with specified attributes
  /// overridden.
  StreamAudioWaveformThemeData copyWith({
    Color? color,
    Color? progressColor,
    double? minBarHeight,
    double? spacingRatio,
    double? heightScale,
  }) {
    return StreamAudioWaveformThemeData(
      color: color ?? this.color,
      progressColor: progressColor ?? this.progressColor,
      minBarHeight: minBarHeight ?? this.minBarHeight,
      spacingRatio: spacingRatio ?? this.spacingRatio,
      heightScale: heightScale ?? this.heightScale,
    );
  }

  /// Merges this [StreamPollOptionsDialogThemeData] with the [other].
  StreamAudioWaveformThemeData merge(
    StreamAudioWaveformThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      progressColor: other.progressColor,
      minBarHeight: other.minBarHeight,
      spacingRatio: other.spacingRatio,
      heightScale: other.heightScale,
    );
  }

  /// Linearly interpolate between two [StreamPollOptionsDialogThemeData].
  static StreamAudioWaveformThemeData lerp(
    StreamAudioWaveformThemeData a,
    StreamAudioWaveformThemeData b,
    double t,
  ) => StreamAudioWaveformThemeData(
    color: Color.lerp(a.color, b.color, t),
    progressColor: Color.lerp(a.progressColor, b.progressColor, t),
    minBarHeight: lerpDouble(a.minBarHeight, b.minBarHeight, t),
    spacingRatio: lerpDouble(a.spacingRatio, b.spacingRatio, t),
    heightScale: lerpDouble(a.heightScale, b.heightScale, t),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamAudioWaveformThemeData &&
          other.color == color &&
          other.progressColor == progressColor &&
          other.minBarHeight == minBarHeight &&
          other.spacingRatio == spacingRatio &&
          other.heightScale == heightScale;

  @override
  int get hashCode =>
      color.hashCode ^ progressColor.hashCode ^ minBarHeight.hashCode ^ spacingRatio.hashCode ^ heightScale.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(ColorProperty('progressColor', progressColor))
      ..add(DoubleProperty('minBarHeight', minBarHeight))
      ..add(DoubleProperty('spacingRatio', spacingRatio))
      ..add(DoubleProperty('heightScale', heightScale));
  }
}

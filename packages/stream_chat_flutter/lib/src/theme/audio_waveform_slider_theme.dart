import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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
    final audioWaveformSliderTheme = context
        .dependOnInheritedWidgetOfExactType<StreamAudioWaveformSliderTheme>();
    return audioWaveformSliderTheme?.data ??
        StreamChatTheme.of(context).audioWaveformSliderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamAudioWaveformSliderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamAudioWaveformSliderTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template streamVoiceRecordingAttachmentThemeData}
/// A style that overrides the default appearance of
/// [StreamAudioWaveformSlider] widgets when used with
/// [StreamAudioWaveformSliderTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.audioWaveformSliderTheme].
/// {@endtemplate}
class StreamAudioWaveformSliderThemeData with Diagnosticable {
  /// {@macro streamVoiceRecordingAttachmentThemeData}
  const StreamAudioWaveformSliderThemeData({
    this.color,
    this.progressColor,
    this.minBarHeight,
    this.spacingRatio,
    this.heightScale,
    this.thumbColor,
    this.thumbBorderColor,
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

  /// The color of the thumb.
  final Color? thumbColor;

  /// The color of the thumb border.
  final Color? thumbBorderColor;

  /// A copy of [StreamAudioWaveformSliderThemeData] with specified attributes
  /// overridden.
  StreamAudioWaveformSliderThemeData copyWith({
    Color? color,
    Color? progressColor,
    double? minBarHeight,
    double? spacingRatio,
    double? heightScale,
    Color? thumbColor,
    Color? thumbBorderColor,
  }) {
    return StreamAudioWaveformSliderThemeData(
      color: color ?? this.color,
      progressColor: progressColor ?? this.progressColor,
      minBarHeight: minBarHeight ?? this.minBarHeight,
      spacingRatio: spacingRatio ?? this.spacingRatio,
      heightScale: heightScale ?? this.heightScale,
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
      color: other.color,
      progressColor: other.progressColor,
      minBarHeight: other.minBarHeight,
      spacingRatio: other.spacingRatio,
      heightScale: other.heightScale,
      thumbColor: other.thumbColor,
      thumbBorderColor: other.thumbBorderColor,
    );
  }

  /// Linearly interpolate between two [StreamPollOptionsDialogThemeData].
  static StreamAudioWaveformSliderThemeData lerp(
    StreamAudioWaveformSliderThemeData a,
    StreamAudioWaveformSliderThemeData b,
    double t,
  ) =>
      StreamAudioWaveformSliderThemeData(
        color: Color.lerp(a.color, b.color, t),
        progressColor: Color.lerp(a.progressColor, b.progressColor, t),
        minBarHeight: lerpDouble(a.minBarHeight, b.minBarHeight, t),
        spacingRatio: lerpDouble(a.spacingRatio, b.spacingRatio, t),
        heightScale: lerpDouble(a.heightScale, b.heightScale, t),
        thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
        thumbBorderColor: Color.lerp(a.thumbBorderColor, b.thumbBorderColor, t),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamAudioWaveformSliderThemeData &&
          other.color == color &&
          other.progressColor == progressColor &&
          other.minBarHeight == minBarHeight &&
          other.spacingRatio == spacingRatio &&
          other.heightScale == heightScale &&
          other.thumbColor == thumbColor &&
          other.thumbBorderColor == thumbBorderColor;

  @override
  int get hashCode =>
      color.hashCode ^
      progressColor.hashCode ^
      minBarHeight.hashCode ^
      spacingRatio.hashCode ^
      heightScale.hashCode ^
      thumbColor.hashCode ^
      thumbBorderColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(ColorProperty('progressColor', progressColor))
      ..add(DoubleProperty('minBarHeight', minBarHeight))
      ..add(DoubleProperty('spacingRatio', spacingRatio))
      ..add(DoubleProperty('heightScale', heightScale))
      ..add(ColorProperty('thumbColor', thumbColor))
      ..add(ColorProperty('thumbBorderColor', thumbBorderColor));
  }
}

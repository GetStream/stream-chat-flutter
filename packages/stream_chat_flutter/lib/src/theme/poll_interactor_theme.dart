// ignore_for_file: parameter_assignments

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamPollInteractorTheme}
/// Overrides the default style of [StreamPollInteractorWidget] descendants.
///
/// See also:
///
///  * [StreamPollInteractorThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamPollInteractorTheme extends InheritedTheme {
  /// Creates a [StreamPollInteractorTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamPollInteractorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamPollInteractorThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamPollInteractorTheme] widget, then
  /// [StreamChatThemeData.pollInteractorTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// StreamPollInteractorTheme theme = StreamPollInteractorTheme.of(context);
  /// ```
  static StreamPollInteractorThemeData of(BuildContext context) {
    final pollInteractorTheme = context.dependOnInheritedWidgetOfExactType<StreamPollInteractorTheme>();
    return pollInteractorTheme?.data ?? StreamChatTheme.of(context).pollInteractorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollInteractorTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollInteractorTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamPollInteractorThemeData}
/// A style that overrides the default appearance of [StreamPollInteractor]
/// widget when used with [StreamPollCreatorTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.pollInteractorTheme].
/// {@endtemplate}
class StreamPollInteractorThemeData with Diagnosticable {
  /// {@macro streamPollInteractorThemeData}
  const StreamPollInteractorThemeData({
    this.pollTitleStyle,
    this.pollSubtitleStyle,
    this.pollOptionTextStyle,
    this.pollOptionVoteCountTextStyle,
    this.pollOptionCheckboxShape,
    this.pollOptionCheckboxCheckColor,
    this.pollOptionCheckboxActiveColor,
    this.pollOptionCheckboxBorderSide,
    this.pollOptionVotesProgressBarMinHeight,
    this.pollOptionVotesProgressBarTrackColor,
    this.pollOptionVotesProgressBarValueColor,
    this.pollOptionVotesProgressBarWinnerColor,
    this.pollOptionVotesProgressBarBorderRadius,
    this.pollActionButtonStyle,
    this.pollActionDialogTitleStyle,
    this.pollActionDialogTextFieldStyle,
    this.pollActionDialogTextFieldFillColor,
    this.pollActionDialogTextFieldBorderRadius,
  });

  /// The text style of the poll title.
  final TextStyle? pollTitleStyle;

  /// The text style of the poll subtitle.
  final TextStyle? pollSubtitleStyle;

  /// The text style of the poll option.
  final TextStyle? pollOptionTextStyle;

  /// The text style of the poll option vote count.
  final TextStyle? pollOptionVoteCountTextStyle;

  /// The shape of the poll option checkbox.
  final OutlinedBorder? pollOptionCheckboxShape;

  /// The color used for the poll option checkbox check.
  final Color? pollOptionCheckboxCheckColor;

  /// The color used for the checkbox when it's active.
  final Color? pollOptionCheckboxActiveColor;

  /// The border configuration of the poll option checkbox.
  final BorderSide? pollOptionCheckboxBorderSide;

  /// The minimum height of the poll option votes progress bar.
  final double? pollOptionVotesProgressBarMinHeight;

  /// The track color of the poll option votes progress bar.
  final Color? pollOptionVotesProgressBarTrackColor;

  /// The color of the poll option votes progress bar value.
  final Color? pollOptionVotesProgressBarValueColor;

  /// The color of the poll option votes progress bar value when it's the
  /// winner.
  final Color? pollOptionVotesProgressBarWinnerColor;

  /// The border radius of the poll option votes progress bar.
  final BorderRadius? pollOptionVotesProgressBarBorderRadius;

  /// The button style of the poll action buttons.
  final ButtonStyle? pollActionButtonStyle;

  /// The text style of the poll action dialog title.
  final TextStyle? pollActionDialogTitleStyle;

  /// The text style of the poll action dialog text field.
  final TextStyle? pollActionDialogTextFieldStyle;

  /// The fill color of the poll action dialog text field.
  final Color? pollActionDialogTextFieldFillColor;

  /// The border radius of the poll action dialog text field.
  final BorderRadius? pollActionDialogTextFieldBorderRadius;

  /// Copies this [StreamPollInteractorThemeData] with some new values.
  StreamPollInteractorThemeData copyWith({
    TextStyle? pollTitleStyle,
    TextStyle? pollSubtitleStyle,
    TextStyle? pollOptionTextStyle,
    TextStyle? pollOptionVoteCountTextStyle,
    OutlinedBorder? pollOptionCheckboxShape,
    Color? pollOptionCheckboxCheckColor,
    Color? pollOptionCheckboxActiveColor,
    BorderSide? pollOptionCheckboxBorderSide,
    double? pollOptionVotesProgressBarMinHeight,
    Color? pollOptionVotesProgressBarTrackColor,
    Color? pollOptionVotesProgressBarValueColor,
    Color? pollOptionVotesProgressBarWinnerColor,
    BorderRadius? pollOptionVotesProgressBarBorderRadius,
    ButtonStyle? pollActionButtonStyle,
    TextStyle? pollActionDialogTitleStyle,
    TextStyle? pollActionDialogTextFieldStyle,
    Color? pollActionDialogTextFieldFillColor,
    BorderRadius? pollActionDialogTextFieldBorderRadius,
  }) {
    return StreamPollInteractorThemeData(
      pollTitleStyle: pollTitleStyle ?? this.pollTitleStyle,
      pollSubtitleStyle: pollSubtitleStyle ?? this.pollSubtitleStyle,
      pollOptionTextStyle: pollOptionTextStyle ?? this.pollOptionTextStyle,
      pollOptionVoteCountTextStyle: pollOptionVoteCountTextStyle ?? this.pollOptionVoteCountTextStyle,
      pollOptionCheckboxShape: pollOptionCheckboxShape ?? this.pollOptionCheckboxShape,
      pollOptionCheckboxCheckColor: pollOptionCheckboxCheckColor ?? this.pollOptionCheckboxCheckColor,
      pollOptionCheckboxActiveColor: pollOptionCheckboxActiveColor ?? this.pollOptionCheckboxActiveColor,
      pollOptionCheckboxBorderSide: pollOptionCheckboxBorderSide ?? this.pollOptionCheckboxBorderSide,
      pollOptionVotesProgressBarMinHeight:
          pollOptionVotesProgressBarMinHeight ?? this.pollOptionVotesProgressBarMinHeight,
      pollOptionVotesProgressBarTrackColor:
          pollOptionVotesProgressBarTrackColor ?? this.pollOptionVotesProgressBarTrackColor,
      pollOptionVotesProgressBarValueColor:
          pollOptionVotesProgressBarValueColor ?? this.pollOptionVotesProgressBarValueColor,
      pollOptionVotesProgressBarWinnerColor:
          pollOptionVotesProgressBarWinnerColor ?? this.pollOptionVotesProgressBarWinnerColor,
      pollOptionVotesProgressBarBorderRadius:
          pollOptionVotesProgressBarBorderRadius ?? this.pollOptionVotesProgressBarBorderRadius,
      pollActionButtonStyle: pollActionButtonStyle ?? this.pollActionButtonStyle,
      pollActionDialogTitleStyle: pollActionDialogTitleStyle ?? this.pollActionDialogTitleStyle,
      pollActionDialogTextFieldStyle: pollActionDialogTextFieldStyle ?? this.pollActionDialogTextFieldStyle,
      pollActionDialogTextFieldFillColor: pollActionDialogTextFieldFillColor ?? this.pollActionDialogTextFieldFillColor,
      pollActionDialogTextFieldBorderRadius:
          pollActionDialogTextFieldBorderRadius ?? this.pollActionDialogTextFieldBorderRadius,
    );
  }

  /// Merges [this] [StreamPollInteractorThemeData] with the [other]
  StreamPollInteractorThemeData merge(StreamPollInteractorThemeData? other) {
    if (other == null) return this;
    return copyWith(
      pollTitleStyle: other.pollTitleStyle ?? pollTitleStyle,
      pollSubtitleStyle: other.pollSubtitleStyle ?? pollSubtitleStyle,
      pollOptionTextStyle: other.pollOptionTextStyle ?? pollOptionTextStyle,
      pollOptionVoteCountTextStyle: other.pollOptionVoteCountTextStyle ?? pollOptionVoteCountTextStyle,
      pollOptionCheckboxShape: other.pollOptionCheckboxShape ?? pollOptionCheckboxShape,
      pollOptionCheckboxCheckColor: other.pollOptionCheckboxCheckColor ?? pollOptionCheckboxCheckColor,
      pollOptionCheckboxActiveColor: other.pollOptionCheckboxActiveColor ?? pollOptionCheckboxActiveColor,
      pollOptionCheckboxBorderSide: other.pollOptionCheckboxBorderSide ?? pollOptionCheckboxBorderSide,
      pollOptionVotesProgressBarMinHeight:
          other.pollOptionVotesProgressBarMinHeight ?? pollOptionVotesProgressBarMinHeight,
      pollOptionVotesProgressBarTrackColor:
          other.pollOptionVotesProgressBarTrackColor ?? pollOptionVotesProgressBarTrackColor,
      pollOptionVotesProgressBarValueColor:
          other.pollOptionVotesProgressBarValueColor ?? pollOptionVotesProgressBarValueColor,
      pollOptionVotesProgressBarWinnerColor:
          other.pollOptionVotesProgressBarWinnerColor ?? pollOptionVotesProgressBarWinnerColor,
      pollOptionVotesProgressBarBorderRadius:
          other.pollOptionVotesProgressBarBorderRadius ?? pollOptionVotesProgressBarBorderRadius,
      pollActionButtonStyle: other.pollActionButtonStyle ?? pollActionButtonStyle,
      pollActionDialogTitleStyle: other.pollActionDialogTitleStyle ?? pollActionDialogTitleStyle,
      pollActionDialogTextFieldStyle: other.pollActionDialogTextFieldStyle ?? pollActionDialogTextFieldStyle,
      pollActionDialogTextFieldFillColor:
          other.pollActionDialogTextFieldFillColor ?? pollActionDialogTextFieldFillColor,
      pollActionDialogTextFieldBorderRadius:
          other.pollActionDialogTextFieldBorderRadius ?? pollActionDialogTextFieldBorderRadius,
    );
  }

  /// Linearly interpolate between two [StreamPollInteractorThemeData].
  StreamPollInteractorThemeData lerp(
    StreamPollInteractorThemeData a,
    StreamPollInteractorThemeData b,
    double t,
  ) {
    return StreamPollInteractorThemeData(
      pollTitleStyle: TextStyle.lerp(a.pollTitleStyle, b.pollTitleStyle, t),
      pollSubtitleStyle: TextStyle.lerp(a.pollSubtitleStyle, b.pollSubtitleStyle, t),
      pollOptionTextStyle: TextStyle.lerp(a.pollOptionTextStyle, b.pollOptionTextStyle, t),
      pollOptionVoteCountTextStyle: TextStyle.lerp(a.pollOptionVoteCountTextStyle, b.pollOptionVoteCountTextStyle, t),
      pollOptionCheckboxShape: OutlinedBorder.lerp(a.pollOptionCheckboxShape, b.pollOptionCheckboxShape, t),
      pollOptionCheckboxCheckColor: Color.lerp(a.pollOptionCheckboxCheckColor, b.pollOptionCheckboxCheckColor, t),
      pollOptionCheckboxActiveColor: Color.lerp(a.pollOptionCheckboxActiveColor, b.pollOptionCheckboxActiveColor, t),
      pollOptionCheckboxBorderSide: _lerpSides(a.pollOptionCheckboxBorderSide, b.pollOptionCheckboxBorderSide, t),
      pollOptionVotesProgressBarMinHeight: lerpDouble(
        a.pollOptionVotesProgressBarMinHeight,
        b.pollOptionVotesProgressBarMinHeight,
        t,
      ),
      pollOptionVotesProgressBarTrackColor: Color.lerp(
        a.pollOptionVotesProgressBarTrackColor,
        b.pollOptionVotesProgressBarTrackColor,
        t,
      ),
      pollOptionVotesProgressBarValueColor: Color.lerp(
        a.pollOptionVotesProgressBarValueColor,
        b.pollOptionVotesProgressBarValueColor,
        t,
      ),
      pollOptionVotesProgressBarWinnerColor: Color.lerp(
        a.pollOptionVotesProgressBarWinnerColor,
        b.pollOptionVotesProgressBarWinnerColor,
        t,
      ),
      pollOptionVotesProgressBarBorderRadius: BorderRadius.lerp(
        a.pollOptionVotesProgressBarBorderRadius,
        b.pollOptionVotesProgressBarBorderRadius,
        t,
      ),
      pollActionButtonStyle: ButtonStyle.lerp(a.pollActionButtonStyle, b.pollActionButtonStyle, t),
      pollActionDialogTitleStyle: TextStyle.lerp(a.pollActionDialogTitleStyle, b.pollActionDialogTitleStyle, t),
      pollActionDialogTextFieldStyle: TextStyle.lerp(
        a.pollActionDialogTextFieldStyle,
        b.pollActionDialogTextFieldStyle,
        t,
      ),
      pollActionDialogTextFieldFillColor: Color.lerp(
        a.pollActionDialogTextFieldFillColor,
        b.pollActionDialogTextFieldFillColor,
        t,
      ),
      pollActionDialogTextFieldBorderRadius: BorderRadius.lerp(
        a.pollActionDialogTextFieldBorderRadius,
        b.pollActionDialogTextFieldBorderRadius,
        t,
      ),
    );
  }

  // Special case because BorderSide.lerp() doesn't support null arguments
  static BorderSide? _lerpSides(BorderSide? a, BorderSide? b, double t) {
    if (a == null || b == null) return null;
    if (identical(a, b)) return a;

    if (a is WidgetStateBorderSide) {
      a = a.resolve(<WidgetState>{});
    }
    if (b is WidgetStateBorderSide) {
      b = b.resolve(<WidgetState>{});
    }

    return BorderSide.lerp(a!, b!, t);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamPollInteractorThemeData &&
          other.pollTitleStyle == pollTitleStyle &&
          other.pollSubtitleStyle == pollSubtitleStyle &&
          other.pollOptionTextStyle == pollOptionTextStyle &&
          other.pollOptionVoteCountTextStyle == pollOptionVoteCountTextStyle &&
          other.pollOptionCheckboxShape == pollOptionCheckboxShape &&
          other.pollOptionCheckboxCheckColor == pollOptionCheckboxCheckColor &&
          other.pollOptionCheckboxActiveColor == pollOptionCheckboxActiveColor &&
          other.pollOptionCheckboxBorderSide == pollOptionCheckboxBorderSide &&
          other.pollOptionVotesProgressBarMinHeight == pollOptionVotesProgressBarMinHeight &&
          other.pollOptionVotesProgressBarTrackColor == pollOptionVotesProgressBarTrackColor &&
          other.pollOptionVotesProgressBarValueColor == pollOptionVotesProgressBarValueColor &&
          other.pollOptionVotesProgressBarWinnerColor == pollOptionVotesProgressBarWinnerColor &&
          other.pollOptionVotesProgressBarBorderRadius == pollOptionVotesProgressBarBorderRadius &&
          other.pollActionButtonStyle == pollActionButtonStyle &&
          other.pollActionDialogTitleStyle == pollActionDialogTitleStyle &&
          other.pollActionDialogTextFieldStyle == pollActionDialogTextFieldStyle &&
          other.pollActionDialogTextFieldFillColor == pollActionDialogTextFieldFillColor &&
          other.pollActionDialogTextFieldBorderRadius == pollActionDialogTextFieldBorderRadius;

  @override
  int get hashCode =>
      pollTitleStyle.hashCode ^
      pollSubtitleStyle.hashCode ^
      pollOptionTextStyle.hashCode ^
      pollOptionVoteCountTextStyle.hashCode ^
      pollOptionCheckboxShape.hashCode ^
      pollOptionCheckboxCheckColor.hashCode ^
      pollOptionCheckboxActiveColor.hashCode ^
      pollOptionCheckboxBorderSide.hashCode ^
      pollOptionVotesProgressBarMinHeight.hashCode ^
      pollOptionVotesProgressBarTrackColor.hashCode ^
      pollOptionVotesProgressBarValueColor.hashCode ^
      pollOptionVotesProgressBarWinnerColor.hashCode ^
      pollOptionVotesProgressBarBorderRadius.hashCode ^
      pollActionButtonStyle.hashCode ^
      pollActionDialogTitleStyle.hashCode ^
      pollActionDialogTextFieldStyle.hashCode ^
      pollActionDialogTextFieldFillColor.hashCode ^
      pollActionDialogTextFieldBorderRadius.hashCode;
}

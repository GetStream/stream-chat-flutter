import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamPollOptionsDialogTheme}
/// Overrides the default style of [StreamPollOptionsDialog] descendants.
///
/// See also:
///
///  * [StreamPollResultsDialogThemeData], which is used to configure this
///  theme.
/// {@endtemplate}
class StreamPollOptionsDialogTheme extends InheritedTheme {
  /// Creates a [StreamPollOptionsDialogTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamPollOptionsDialogTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamPollOptionsDialogThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamPollOptionsDialogTheme] widget, then
  /// [StreamChatThemeData.pollOptionsDialogTheme] is used.
  static StreamPollOptionsDialogThemeData of(BuildContext context) {
    final pollOptionsDialogTheme = context
        .dependOnInheritedWidgetOfExactType<StreamPollOptionsDialogTheme>();
    return pollOptionsDialogTheme?.data ??
        StreamChatTheme.of(context).pollOptionsDialogTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamPollOptionsDialogTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollOptionsDialogTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template streamPollOptionsDialogThemeData}
/// A style that overrides the default appearance of [StreamPollOptionsDialog]
/// widgets when used with [StreamPollOptionsDialogTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.pollOptionsDialogTheme].
/// {@endtemplate}
class StreamPollOptionsDialogThemeData with Diagnosticable {
  /// {@macro streamPollOptionsDialogThemeData}
  const StreamPollOptionsDialogThemeData({
    this.backgroundColor,
    this.appBarElevation,
    this.appBarBackgroundColor,
    this.appBarTitleTextStyle,
    this.pollTitleTextStyle,
    this.pollTitleDecoration,
    this.pollOptionsListViewDecoration,
  });

  /// The background color of the dialog.
  final Color? backgroundColor;

  /// The elevation of the app bar.
  final double? appBarElevation;

  /// The background color of the app bar.
  final Color? appBarBackgroundColor;

  /// The text style of the app bar title.
  final TextStyle? appBarTitleTextStyle;

  /// The text style of the poll title.
  final TextStyle? pollTitleTextStyle;

  /// The decoration of the poll title.
  final Decoration? pollTitleDecoration;

  /// The decoration of the poll options list view.
  final Decoration? pollOptionsListViewDecoration;

  /// A copy of [StreamPollOptionsDialogThemeData] with specified attributes
  /// overridden.
  StreamPollOptionsDialogThemeData copyWith({
    Color? backgroundColor,
    double? appBarElevation,
    Color? appBarBackgroundColor,
    TextStyle? appBarTitleTextStyle,
    TextStyle? pollTitleTextStyle,
    Decoration? pollTitleDecoration,
    Decoration? pollOptionsListViewDecoration,
  }) =>
      StreamPollOptionsDialogThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        appBarElevation: appBarElevation ?? this.appBarElevation,
        appBarBackgroundColor:
            appBarBackgroundColor ?? this.appBarBackgroundColor,
        appBarTitleTextStyle: appBarTitleTextStyle ?? this.appBarTitleTextStyle,
        pollTitleTextStyle: pollTitleTextStyle ?? this.pollTitleTextStyle,
        pollTitleDecoration: pollTitleDecoration ?? this.pollTitleDecoration,
        pollOptionsListViewDecoration:
            pollOptionsListViewDecoration ?? this.pollOptionsListViewDecoration,
      );

  /// Merges this [StreamPollOptionsDialogThemeData] with the [other].
  StreamPollOptionsDialogThemeData merge(
    StreamPollOptionsDialogThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      appBarElevation: other.appBarElevation,
      appBarBackgroundColor: other.appBarBackgroundColor,
      appBarTitleTextStyle: other.appBarTitleTextStyle,
      pollTitleTextStyle: other.pollTitleTextStyle,
      pollTitleDecoration: other.pollTitleDecoration,
      pollOptionsListViewDecoration: other.pollOptionsListViewDecoration,
    );
  }

  /// Linearly interpolate between two [StreamPollOptionsDialogThemeData].
  StreamPollOptionsDialogThemeData lerp(
    StreamPollOptionsDialogThemeData a,
    StreamPollOptionsDialogThemeData b,
    double t,
  ) =>
      StreamPollOptionsDialogThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        appBarElevation: lerpDouble(a.appBarElevation, b.appBarElevation, t),
        appBarBackgroundColor:
            Color.lerp(a.appBarBackgroundColor, b.appBarBackgroundColor, t),
        appBarTitleTextStyle:
            TextStyle.lerp(a.appBarTitleTextStyle, b.appBarTitleTextStyle, t),
        pollTitleTextStyle:
            TextStyle.lerp(a.pollTitleTextStyle, b.pollTitleTextStyle, t),
        pollTitleDecoration:
            Decoration.lerp(a.pollTitleDecoration, b.pollTitleDecoration, t),
        pollOptionsListViewDecoration: Decoration.lerp(
          a.pollOptionsListViewDecoration,
          b.pollOptionsListViewDecoration,
          t,
        ),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamPollOptionsDialogThemeData &&
          other.backgroundColor == backgroundColor &&
          other.appBarElevation == appBarElevation &&
          other.appBarBackgroundColor == appBarBackgroundColor &&
          other.appBarTitleTextStyle == appBarTitleTextStyle &&
          other.pollTitleTextStyle == pollTitleTextStyle &&
          other.pollTitleDecoration == pollTitleDecoration &&
          other.pollOptionsListViewDecoration == pollOptionsListViewDecoration;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      appBarElevation.hashCode ^
      appBarBackgroundColor.hashCode ^
      appBarTitleTextStyle.hashCode ^
      pollTitleTextStyle.hashCode ^
      pollTitleDecoration.hashCode ^
      pollOptionsListViewDecoration.hashCode;
}

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamPollOptionVotesDialogTheme}
/// Overrides the default style of [StreamPollOptionVotesDialog] descendants.
///
/// See also:
///
///  * [StreamPollOptionVotesDialogThemeData], which is used to configure this
///    theme.
/// {@endtemplate}
class StreamPollOptionVotesDialogTheme extends InheritedTheme {
  /// Creates a [StreamPollOptionVotesDialogTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamPollOptionVotesDialogTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamPollOptionVotesDialogThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamPollOptionVotesDialogTheme] widget, then
  /// [StreamChatThemeData.pollOptionVotesDialogTheme] is used.
  static StreamPollOptionVotesDialogThemeData of(BuildContext context) {
    final pollCommentsDialogTheme = context
        .dependOnInheritedWidgetOfExactType<StreamPollOptionVotesDialogTheme>();
    return pollCommentsDialogTheme?.data ??
        StreamChatTheme.of(context).pollOptionVotesDialogTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamPollOptionVotesDialogTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollOptionVotesDialogTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template streamPollOptionVotesDialogThemeData}
/// A style that overrides the default appearance of
/// [StreamPollOptionVotesDialog] widgets when used with
/// [StreamPollCommentsDialogTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.pollOptionVotesDialogTheme].
/// {@endtemplate}
class StreamPollOptionVotesDialogThemeData with Diagnosticable {
  /// {@macro streamPollOptionVotesDialogThemeData}
  const StreamPollOptionVotesDialogThemeData({
    this.backgroundColor,
    this.appBarElevation,
    this.appBarBackgroundColor,
    this.appBarTitleTextStyle,
    this.pollOptionVoteCountTextStyle,
    this.pollOptionWinnerVoteCountTextStyle,
    this.pollOptionVoteItemBackgroundColor,
    this.pollOptionVoteItemBorderRadius,
  });

  /// The background color of the dialog.
  final Color? backgroundColor;

  /// The elevation of the app bar.
  final double? appBarElevation;

  /// The background color of the app bar.
  final Color? appBarBackgroundColor;

  /// The text style of the app bar title.
  final TextStyle? appBarTitleTextStyle;

  /// The text style of the poll option vote count.
  final TextStyle? pollOptionVoteCountTextStyle;

  /// The text style of the winner poll option vote count.
  final TextStyle? pollOptionWinnerVoteCountTextStyle;

  /// The background color of the poll option vote item.
  final Color? pollOptionVoteItemBackgroundColor;

  /// The border radius of the poll option vote item.
  final BorderRadius? pollOptionVoteItemBorderRadius;

  /// Copies this [StreamPollOptionVotesDialogThemeData] with some new values.
  StreamPollOptionVotesDialogThemeData copyWith({
    Color? backgroundColor,
    double? appBarElevation,
    Color? appBarBackgroundColor,
    TextStyle? appBarTitleTextStyle,
    TextStyle? pollOptionVoteCountTextStyle,
    TextStyle? pollOptionWinnerVoteCountTextStyle,
    Color? pollOptionVoteItemBackgroundColor,
    BorderRadius? pollOptionVoteItemBorderRadius,
  }) =>
      StreamPollOptionVotesDialogThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        appBarElevation: appBarElevation ?? this.appBarElevation,
        appBarBackgroundColor:
            appBarBackgroundColor ?? this.appBarBackgroundColor,
        appBarTitleTextStyle: appBarTitleTextStyle ?? this.appBarTitleTextStyle,
        pollOptionVoteCountTextStyle:
            pollOptionVoteCountTextStyle ?? this.pollOptionVoteCountTextStyle,
        pollOptionWinnerVoteCountTextStyle:
            pollOptionWinnerVoteCountTextStyle ??
                this.pollOptionWinnerVoteCountTextStyle,
        pollOptionVoteItemBackgroundColor: pollOptionVoteItemBackgroundColor ??
            this.pollOptionVoteItemBackgroundColor,
        pollOptionVoteItemBorderRadius: pollOptionVoteItemBorderRadius ??
            this.pollOptionVoteItemBorderRadius,
      );

  /// Merges this [StreamPollOptionVotesDialogThemeData] with the [other].
  StreamPollOptionVotesDialogThemeData merge(
    StreamPollOptionVotesDialogThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      appBarElevation: other.appBarElevation,
      appBarBackgroundColor: other.appBarBackgroundColor,
      appBarTitleTextStyle: other.appBarTitleTextStyle,
      pollOptionVoteCountTextStyle: other.pollOptionVoteCountTextStyle,
      pollOptionWinnerVoteCountTextStyle:
          other.pollOptionWinnerVoteCountTextStyle,
      pollOptionVoteItemBackgroundColor:
          other.pollOptionVoteItemBackgroundColor,
      pollOptionVoteItemBorderRadius: other.pollOptionVoteItemBorderRadius,
    );
  }

  /// Linearly interpolate between two poll option votes dialog themes.
  StreamPollOptionVotesDialogThemeData lerp(
    StreamPollOptionVotesDialogThemeData? a,
    StreamPollOptionVotesDialogThemeData? b,
    double t,
  ) {
    return StreamPollOptionVotesDialogThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      appBarElevation: lerpDouble(a?.appBarElevation, b?.appBarElevation, t),
      appBarBackgroundColor:
          Color.lerp(a?.appBarBackgroundColor, b?.appBarBackgroundColor, t),
      appBarTitleTextStyle:
          TextStyle.lerp(a?.appBarTitleTextStyle, b?.appBarTitleTextStyle, t),
      pollOptionVoteCountTextStyle: TextStyle.lerp(
        a?.pollOptionVoteCountTextStyle,
        b?.pollOptionVoteCountTextStyle,
        t,
      ),
      pollOptionWinnerVoteCountTextStyle: TextStyle.lerp(
        a?.pollOptionWinnerVoteCountTextStyle,
        b?.pollOptionWinnerVoteCountTextStyle,
        t,
      ),
      pollOptionVoteItemBackgroundColor: Color.lerp(
        a?.pollOptionVoteItemBackgroundColor,
        b?.pollOptionVoteItemBackgroundColor,
        t,
      ),
      pollOptionVoteItemBorderRadius: BorderRadiusGeometry.lerp(
        a?.pollOptionVoteItemBorderRadius,
        b?.pollOptionVoteItemBorderRadius,
        t,
      ) as BorderRadius?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamPollOptionVotesDialogThemeData &&
          other.backgroundColor == backgroundColor &&
          other.appBarElevation == appBarElevation &&
          other.appBarBackgroundColor == appBarBackgroundColor &&
          other.appBarTitleTextStyle == appBarTitleTextStyle &&
          other.pollOptionVoteCountTextStyle == pollOptionVoteCountTextStyle &&
          other.pollOptionWinnerVoteCountTextStyle ==
              pollOptionWinnerVoteCountTextStyle &&
          other.pollOptionVoteItemBackgroundColor ==
              pollOptionVoteItemBackgroundColor &&
          other.pollOptionVoteItemBorderRadius ==
              pollOptionVoteItemBorderRadius;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      appBarElevation.hashCode ^
      appBarBackgroundColor.hashCode ^
      appBarTitleTextStyle.hashCode ^
      pollOptionVoteCountTextStyle.hashCode ^
      pollOptionWinnerVoteCountTextStyle.hashCode ^
      pollOptionVoteItemBackgroundColor.hashCode ^
      pollOptionVoteItemBorderRadius.hashCode;
}

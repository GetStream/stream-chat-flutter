import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamPollResultsDialogTheme}
/// Overrides the default style of [StreamPollResultsDialog] descendants.
///
/// See also:
///
///  * [StreamPollResultsDialogThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamPollResultsDialogTheme extends InheritedTheme {
  /// Creates a [StreamPollResultsDialogTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamPollResultsDialogTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamPollResultsDialogThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamPollInteractorTheme] widget, then
  /// [StreamChatThemeData.pollInteractorTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// StreamPollCreatorTheme theme = StreamPollCreatorTheme.of(context);
  /// ```
  static StreamPollResultsDialogThemeData of(BuildContext context) {
    final pollResultsDialogTheme = context
        .dependOnInheritedWidgetOfExactType<StreamPollResultsDialogTheme>();
    return pollResultsDialogTheme?.data ??
        StreamChatTheme.of(context).pollResultsDialogTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamPollResultsDialogTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollResultsDialogTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template streamPollCreatorThemeData}
/// A style that overrides the default appearance of [StreamPollResultsDialog]
/// widgets when used with [StreamPollResultsDialogTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.pollResultsDialogTheme].
/// {@endtemplate}
class StreamPollResultsDialogThemeData with Diagnosticable {
  /// {@macro streamPollResultsDialogThemeData}
  const StreamPollResultsDialogThemeData({
    this.backgroundColor,
    this.appBarElevation,
    this.appBarBackgroundColor,
    this.appBarTitleTextStyle,
    this.pollTitleTextStyle,
    this.pollTitleDecoration,
    this.pollOptionsDecoration,
    this.pollOptionsWinnerDecoration,
    this.pollOptionsTextStyle,
    this.pollOptionsWinnerTextStyle,
    this.pollOptionsVoteCountTextStyle,
    this.pollOptionsWinnerVoteCountTextStyle,
    this.pollOptionsShowAllVotesButtonStyle,
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

  /// The decoration of the poll options.
  final Decoration? pollOptionsDecoration;

  /// The decoration of the winner poll option.
  final Decoration? pollOptionsWinnerDecoration;

  /// The text style of the poll options.
  final TextStyle? pollOptionsTextStyle;

  /// The text style of the winner poll options.
  final TextStyle? pollOptionsWinnerTextStyle;

  /// The text style of the poll options vote count.
  final TextStyle? pollOptionsVoteCountTextStyle;

  /// The text style of the winner poll options vote count.
  final TextStyle? pollOptionsWinnerVoteCountTextStyle;

  /// The style of the poll options show all votes button.
  final ButtonStyle? pollOptionsShowAllVotesButtonStyle;

  /// A copy of [StreamPollResultsDialogThemeData] with the given fields
  /// replaced with the new values.
  StreamPollResultsDialogThemeData copyWith({
    Color? backgroundColor,
    double? appBarElevation,
    Color? appBarBackgroundColor,
    TextStyle? appBarTitleTextStyle,
    TextStyle? pollTitleTextStyle,
    Decoration? pollTitleDecoration,
    Decoration? pollOptionsDecoration,
    Decoration? pollOptionsWinnerDecoration,
    TextStyle? pollOptionsTextStyle,
    TextStyle? pollOptionsWinnerTextStyle,
    TextStyle? pollOptionsVoteCountTextStyle,
    TextStyle? pollOptionsWinnerVoteCountTextStyle,
    ButtonStyle? pollOptionsShowAllVotesButtonStyle,
  }) {
    return StreamPollResultsDialogThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      appBarElevation: appBarElevation ?? this.appBarElevation,
      appBarBackgroundColor:
          appBarBackgroundColor ?? this.appBarBackgroundColor,
      appBarTitleTextStyle: appBarTitleTextStyle ?? this.appBarTitleTextStyle,
      pollTitleTextStyle: pollTitleTextStyle ?? this.pollTitleTextStyle,
      pollTitleDecoration: pollTitleDecoration ?? this.pollTitleDecoration,
      pollOptionsDecoration:
          pollOptionsDecoration ?? this.pollOptionsDecoration,
      pollOptionsWinnerDecoration:
          pollOptionsWinnerDecoration ?? this.pollOptionsWinnerDecoration,
      pollOptionsTextStyle: pollOptionsTextStyle ?? this.pollOptionsTextStyle,
      pollOptionsWinnerTextStyle:
          pollOptionsWinnerTextStyle ?? this.pollOptionsWinnerTextStyle,
      pollOptionsVoteCountTextStyle:
          pollOptionsVoteCountTextStyle ?? this.pollOptionsVoteCountTextStyle,
      pollOptionsWinnerVoteCountTextStyle:
          pollOptionsWinnerVoteCountTextStyle ??
              this.pollOptionsWinnerVoteCountTextStyle,
      pollOptionsShowAllVotesButtonStyle: pollOptionsShowAllVotesButtonStyle ??
          this.pollOptionsShowAllVotesButtonStyle,
    );
  }

  /// Merges [this] [StreamPollResultsDialogThemeData] with the [other]
  StreamPollResultsDialogThemeData merge(
    StreamPollResultsDialogThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      appBarElevation: other.appBarElevation,
      appBarBackgroundColor: other.appBarBackgroundColor,
      appBarTitleTextStyle: other.appBarTitleTextStyle,
      pollTitleTextStyle: other.pollTitleTextStyle,
      pollTitleDecoration: other.pollTitleDecoration,
      pollOptionsDecoration: other.pollOptionsDecoration,
      pollOptionsWinnerDecoration: other.pollOptionsWinnerDecoration,
      pollOptionsTextStyle: other.pollOptionsTextStyle,
      pollOptionsWinnerTextStyle: other.pollOptionsWinnerTextStyle,
      pollOptionsVoteCountTextStyle: other.pollOptionsVoteCountTextStyle,
      pollOptionsWinnerVoteCountTextStyle:
          other.pollOptionsWinnerVoteCountTextStyle,
      pollOptionsShowAllVotesButtonStyle:
          other.pollOptionsShowAllVotesButtonStyle,
    );
  }

  /// Linearly interpolate between two [StreamPollResultsDialogThemeData].
  StreamPollResultsDialogThemeData lerp(
    StreamPollResultsDialogThemeData a,
    StreamPollResultsDialogThemeData b,
    double t,
  ) {
    return StreamPollResultsDialogThemeData(
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
      pollOptionsDecoration:
          Decoration.lerp(a.pollOptionsDecoration, b.pollOptionsDecoration, t),
      pollOptionsWinnerDecoration: Decoration.lerp(
        a.pollOptionsWinnerDecoration,
        b.pollOptionsWinnerDecoration,
        t,
      ),
      pollOptionsTextStyle:
          TextStyle.lerp(a.pollOptionsTextStyle, b.pollOptionsTextStyle, t),
      pollOptionsWinnerTextStyle: TextStyle.lerp(
        a.pollOptionsWinnerTextStyle,
        b.pollOptionsWinnerTextStyle,
        t,
      ),
      pollOptionsVoteCountTextStyle: TextStyle.lerp(
        a.pollOptionsVoteCountTextStyle,
        b.pollOptionsVoteCountTextStyle,
        t,
      ),
      pollOptionsWinnerVoteCountTextStyle: TextStyle.lerp(
        a.pollOptionsWinnerVoteCountTextStyle,
        b.pollOptionsWinnerVoteCountTextStyle,
        t,
      ),
      pollOptionsShowAllVotesButtonStyle: ButtonStyle.lerp(
        a.pollOptionsShowAllVotesButtonStyle,
        b.pollOptionsShowAllVotesButtonStyle,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamPollResultsDialogThemeData &&
          other.backgroundColor == backgroundColor &&
          other.appBarElevation == appBarElevation &&
          other.appBarBackgroundColor == appBarBackgroundColor &&
          other.appBarTitleTextStyle == appBarTitleTextStyle &&
          other.pollTitleTextStyle == pollTitleTextStyle &&
          other.pollTitleDecoration == pollTitleDecoration &&
          other.pollOptionsDecoration == pollOptionsDecoration &&
          other.pollOptionsWinnerDecoration == pollOptionsWinnerDecoration &&
          other.pollOptionsTextStyle == pollOptionsTextStyle &&
          other.pollOptionsWinnerTextStyle == pollOptionsWinnerTextStyle &&
          other.pollOptionsVoteCountTextStyle ==
              pollOptionsVoteCountTextStyle &&
          other.pollOptionsWinnerVoteCountTextStyle ==
              pollOptionsWinnerVoteCountTextStyle &&
          other.pollOptionsShowAllVotesButtonStyle ==
              pollOptionsShowAllVotesButtonStyle;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      appBarElevation.hashCode ^
      appBarBackgroundColor.hashCode ^
      appBarTitleTextStyle.hashCode ^
      pollTitleTextStyle.hashCode ^
      pollTitleDecoration.hashCode ^
      pollOptionsDecoration.hashCode ^
      pollOptionsWinnerDecoration.hashCode ^
      pollOptionsTextStyle.hashCode ^
      pollOptionsWinnerTextStyle.hashCode ^
      pollOptionsVoteCountTextStyle.hashCode ^
      pollOptionsWinnerVoteCountTextStyle.hashCode ^
      pollOptionsShowAllVotesButtonStyle.hashCode;
}

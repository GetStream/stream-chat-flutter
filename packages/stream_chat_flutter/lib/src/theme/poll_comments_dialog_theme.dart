import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamPollCommentsDialogTheme}
/// Overrides the default style of [StreamPollCommentsDialog] descendants.
///
/// See also:
///
///  * [StreamPollCommentsDialogThemeData], which is used to configure this
///    theme.
/// {@endtemplate}
class StreamPollCommentsDialogTheme extends InheritedTheme {
  /// Creates a [StreamPollCommentsDialogTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamPollCommentsDialogTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamPollCommentsDialogThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamPollCommentsDialogTheme] widget, then
  /// [StreamChatThemeData.pollCommentsDialogTheme] is used.
  static StreamPollCommentsDialogThemeData of(BuildContext context) {
    final pollCommentsDialogTheme = context.dependOnInheritedWidgetOfExactType<StreamPollCommentsDialogTheme>();
    return pollCommentsDialogTheme?.data ?? StreamChatTheme.of(context).pollCommentsDialogTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollCommentsDialogTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollCommentsDialogTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamPollCommentsDialogThemeData}
/// A style that overrides the default appearance of [StreamPollCommentsDialog]
/// widgets when used with [StreamPollCommentsDialogTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.pollCommentsDialogTheme].
/// {@endtemplate}
class StreamPollCommentsDialogThemeData with Diagnosticable {
  /// {@macro streamPollCommentsDialogThemeData}
  const StreamPollCommentsDialogThemeData({
    this.backgroundColor,
    this.appBarElevation,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.appBarTitleTextStyle,
    this.pollCommentItemBackgroundColor,
    this.pollCommentItemBorderRadius,
    this.updateYourCommentButtonStyle,
  });

  /// The background color of the dialog.
  final Color? backgroundColor;

  /// The elevation of the app bar.
  final double? appBarElevation;

  /// The background color of the app bar.
  final Color? appBarBackgroundColor;

  /// The foreground color of the app bar (icon and text color).
  final Color? appBarForegroundColor;

  /// The text style of the app bar title.
  final TextStyle? appBarTitleTextStyle;

  /// The background color of the poll comment item.
  final Color? pollCommentItemBackgroundColor;

  /// The border radius of the poll comment item.
  final BorderRadius? pollCommentItemBorderRadius;

  /// The button style for the update your comment button.
  final ButtonStyle? updateYourCommentButtonStyle;

  /// Copies this [StreamPollCommentsDialogThemeData] with some new values.
  StreamPollCommentsDialogThemeData copyWith({
    Color? backgroundColor,
    double? appBarElevation,
    Color? appBarBackgroundColor,
    Color? appBarForegroundColor,
    TextStyle? appBarTitleTextStyle,
    Color? pollCommentItemBackgroundColor,
    BorderRadius? pollCommentItemBorderRadius,
    ButtonStyle? updateYourCommentButtonStyle,
  }) => StreamPollCommentsDialogThemeData(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    appBarElevation: appBarElevation ?? this.appBarElevation,
    appBarBackgroundColor: appBarBackgroundColor ?? this.appBarBackgroundColor,
    appBarForegroundColor: appBarForegroundColor ?? this.appBarForegroundColor,
    appBarTitleTextStyle: appBarTitleTextStyle ?? this.appBarTitleTextStyle,
    pollCommentItemBackgroundColor: pollCommentItemBackgroundColor ?? this.pollCommentItemBackgroundColor,
    pollCommentItemBorderRadius: pollCommentItemBorderRadius ?? this.pollCommentItemBorderRadius,
    updateYourCommentButtonStyle: updateYourCommentButtonStyle ?? this.updateYourCommentButtonStyle,
  );

  /// Merges this [StreamPollCommentsDialogThemeData] with the [other].
  StreamPollCommentsDialogThemeData merge(
    StreamPollCommentsDialogThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      appBarElevation: other.appBarElevation,
      appBarBackgroundColor: other.appBarBackgroundColor,
      appBarForegroundColor: other.appBarForegroundColor,
      appBarTitleTextStyle: other.appBarTitleTextStyle,
      pollCommentItemBackgroundColor: other.pollCommentItemBackgroundColor,
      pollCommentItemBorderRadius: other.pollCommentItemBorderRadius,
      updateYourCommentButtonStyle: other.updateYourCommentButtonStyle,
    );
  }

  /// Linearly interpolate between two [StreamPollCommentsDialogThemeData].
  StreamPollCommentsDialogThemeData lerp(
    StreamPollCommentsDialogThemeData? a,
    StreamPollCommentsDialogThemeData? b,
    double t,
  ) {
    return StreamPollCommentsDialogThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      appBarElevation: lerpDouble(a?.appBarElevation, b?.appBarElevation, t),
      appBarBackgroundColor: Color.lerp(a?.appBarBackgroundColor, b?.appBarBackgroundColor, t),
      appBarForegroundColor: Color.lerp(a?.appBarForegroundColor, b?.appBarForegroundColor, t),
      appBarTitleTextStyle: TextStyle.lerp(a?.appBarTitleTextStyle, b?.appBarTitleTextStyle, t),
      pollCommentItemBackgroundColor: Color.lerp(
        a?.pollCommentItemBackgroundColor,
        b?.pollCommentItemBackgroundColor,
        t,
      ),
      pollCommentItemBorderRadius: BorderRadius.lerp(
        a?.pollCommentItemBorderRadius,
        b?.pollCommentItemBorderRadius,
        t,
      ),
      updateYourCommentButtonStyle: ButtonStyle.lerp(
        a?.updateYourCommentButtonStyle,
        b?.updateYourCommentButtonStyle,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamPollCommentsDialogThemeData &&
          other.backgroundColor == backgroundColor &&
          other.appBarElevation == appBarElevation &&
          other.appBarBackgroundColor == appBarBackgroundColor &&
          other.appBarForegroundColor == appBarForegroundColor &&
          other.appBarTitleTextStyle == appBarTitleTextStyle &&
          other.pollCommentItemBackgroundColor == pollCommentItemBackgroundColor &&
          other.pollCommentItemBorderRadius == pollCommentItemBorderRadius &&
          other.updateYourCommentButtonStyle == updateYourCommentButtonStyle;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      appBarElevation.hashCode ^
      appBarBackgroundColor.hashCode ^
      appBarForegroundColor.hashCode ^
      appBarTitleTextStyle.hashCode ^
      pollCommentItemBackgroundColor.hashCode ^
      pollCommentItemBorderRadius.hashCode ^
      updateYourCommentButtonStyle.hashCode;
}

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template streamPollCreatorTheme}
/// Overrides the default style of [StreamPollCreatorWidget] descendants.
///
/// See also:
///
///  * [StreamPollCreatorThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamPollCreatorTheme extends InheritedTheme {
  /// Creates a [StreamPollCreatorTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamPollCreatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamPollCreatorThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamPollCreatorTheme] widget, then
  /// [StreamChatThemeData.pollCreatorTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// StreamPollCreatorTheme theme = StreamPollCreatorTheme.of(context);
  /// ```
  static StreamPollCreatorThemeData of(BuildContext context) {
    final pollCreatorTheme = context.dependOnInheritedWidgetOfExactType<StreamPollCreatorTheme>();
    return pollCreatorTheme?.data ?? StreamChatTheme.of(context).pollCreatorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollCreatorTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollCreatorTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamPollCreatorThemeData}
/// A style that overrides the default appearance of [StreamPollCreator] widget
/// when used with [StreamPollCreatorTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.pollCreatorTheme].
/// {@endtemplate}
class StreamPollCreatorThemeData with Diagnosticable {
  /// {@macro streamPollCreatorThemeData}
  const StreamPollCreatorThemeData({
    this.backgroundColor,
    this.appBarTitleStyle,
    this.appBarElevation,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.questionTextFieldFillColor,
    this.questionHeaderStyle,
    this.questionTextFieldStyle,
    this.questionTextFieldErrorStyle,
    this.questionTextFieldBorderRadius,
    this.optionsHeaderStyle,
    this.optionsTextFieldStyle,
    this.optionsTextFieldFillColor,
    this.optionsTextFieldErrorStyle,
    this.optionsTextFieldBorderRadius,
    this.switchListTileFillColor,
    this.switchListTileTitleStyle,
    this.switchListTileErrorStyle,
    this.switchListTileBorderRadius,
    this.actionDialogTitleStyle,
    this.actionDialogContentStyle,
  });

  /// The background color of the poll creator.
  final Color? backgroundColor;

  /// The text style of the appBar title.
  final TextStyle? appBarTitleStyle;

  /// The elevation of the appBar.
  final double? appBarElevation;

  /// The background color of the appBar.
  final Color? appBarBackgroundColor;

  /// The foreground color of the appBar (icon and text color).
  final Color? appBarForegroundColor;

  /// The fill color of the question text field.
  final Color? questionTextFieldFillColor;

  /// The style of the question header text.
  final TextStyle? questionHeaderStyle;

  /// The text style of the question text field.
  final TextStyle? questionTextFieldStyle;

  /// The text style of the question error text when the question is invalid.
  final TextStyle? questionTextFieldErrorStyle;

  /// The border radius of the question text field.
  final BorderRadius? questionTextFieldBorderRadius;

  /// The fill color of the options text field.
  final Color? optionsTextFieldFillColor;

  /// The style of the options header text.
  final TextStyle? optionsHeaderStyle;

  /// The text style of the options text field.
  final TextStyle? optionsTextFieldStyle;

  /// The text style of the options error text when the options are invalid.
  final TextStyle? optionsTextFieldErrorStyle;

  /// The border radius of the options text field.
  final BorderRadius? optionsTextFieldBorderRadius;

  /// The fill color of the switch list tile.
  final Color? switchListTileFillColor;

  /// The text style of the switch list tile title.
  final TextStyle? switchListTileTitleStyle;

  /// The text style of the switch list tile error text when the switch list
  /// tile is invalid.
  final TextStyle? switchListTileErrorStyle;

  /// The border radius of the switch list tile.
  final BorderRadius? switchListTileBorderRadius;

  /// The text style of the action dialog title.
  final TextStyle? actionDialogTitleStyle;

  /// The text style of the action dialog content.
  final TextStyle? actionDialogContentStyle;

  /// Copies this [StreamPollCreatorThemeData] with some new values.
  StreamPollCreatorThemeData copyWith({
    Color? backgroundColor,
    TextStyle? appBarTitleStyle,
    double? appBarElevation,
    Color? appBarBackgroundColor,
    Color? appBarForegroundColor,
    Color? questionTextFieldFillColor,
    TextStyle? questionHeaderStyle,
    TextStyle? questionTextFieldStyle,
    TextStyle? questionTextFieldErrorStyle,
    BorderRadius? questionTextFieldBorderRadius,
    Color? optionsTextFieldFillColor,
    TextStyle? optionsHeaderStyle,
    TextStyle? optionsTextFieldStyle,
    TextStyle? optionsTextFieldErrorStyle,
    BorderRadius? optionsTextFieldBorderRadius,
    Color? switchListTileFillColor,
    TextStyle? switchListTileTitleStyle,
    TextStyle? switchListTileErrorStyle,
    BorderRadius? switchListTileBorderRadius,
    TextStyle? actionDialogTitleStyle,
    TextStyle? actionDialogContentStyle,
  }) {
    return StreamPollCreatorThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      appBarTitleStyle: appBarTitleStyle ?? this.appBarTitleStyle,
      appBarElevation: appBarElevation ?? this.appBarElevation,
      appBarBackgroundColor: appBarBackgroundColor ?? this.appBarBackgroundColor,
      appBarForegroundColor: appBarForegroundColor ?? this.appBarForegroundColor,
      questionTextFieldFillColor: questionTextFieldFillColor ?? this.questionTextFieldFillColor,
      questionHeaderStyle: questionHeaderStyle ?? this.questionHeaderStyle,
      questionTextFieldStyle: questionTextFieldStyle ?? this.questionTextFieldStyle,
      questionTextFieldErrorStyle: questionTextFieldErrorStyle ?? this.questionTextFieldErrorStyle,
      questionTextFieldBorderRadius: questionTextFieldBorderRadius ?? this.questionTextFieldBorderRadius,
      optionsTextFieldFillColor: optionsTextFieldFillColor ?? this.optionsTextFieldFillColor,
      optionsHeaderStyle: optionsHeaderStyle ?? this.optionsHeaderStyle,
      optionsTextFieldStyle: optionsTextFieldStyle ?? this.optionsTextFieldStyle,
      optionsTextFieldErrorStyle: optionsTextFieldErrorStyle ?? this.optionsTextFieldErrorStyle,
      optionsTextFieldBorderRadius: optionsTextFieldBorderRadius ?? this.optionsTextFieldBorderRadius,
      switchListTileFillColor: switchListTileFillColor ?? this.switchListTileFillColor,
      switchListTileTitleStyle: switchListTileTitleStyle ?? this.switchListTileTitleStyle,
      switchListTileErrorStyle: switchListTileErrorStyle ?? this.switchListTileErrorStyle,
      switchListTileBorderRadius: switchListTileBorderRadius ?? this.switchListTileBorderRadius,
      actionDialogTitleStyle: actionDialogTitleStyle ?? this.actionDialogTitleStyle,
      actionDialogContentStyle: actionDialogContentStyle ?? this.actionDialogContentStyle,
    );
  }

  /// Merges [this] [StreamPollCreatorThemeData] with the [other]
  StreamPollCreatorThemeData merge(StreamPollCreatorThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      appBarTitleStyle: other.appBarTitleStyle ?? appBarTitleStyle,
      appBarElevation: other.appBarElevation ?? appBarElevation,
      appBarBackgroundColor: other.appBarBackgroundColor ?? appBarBackgroundColor,
      appBarForegroundColor: other.appBarForegroundColor ?? appBarForegroundColor,
      questionTextFieldFillColor: other.questionTextFieldFillColor ?? questionTextFieldFillColor,
      questionHeaderStyle: other.questionHeaderStyle ?? questionHeaderStyle,
      questionTextFieldStyle: other.questionTextFieldStyle ?? questionTextFieldStyle,
      questionTextFieldErrorStyle: other.questionTextFieldErrorStyle ?? questionTextFieldErrorStyle,
      questionTextFieldBorderRadius: other.questionTextFieldBorderRadius ?? questionTextFieldBorderRadius,
      optionsTextFieldFillColor: other.optionsTextFieldFillColor ?? optionsTextFieldFillColor,
      optionsHeaderStyle: other.optionsHeaderStyle ?? optionsHeaderStyle,
      optionsTextFieldStyle: other.optionsTextFieldStyle ?? optionsTextFieldStyle,
      optionsTextFieldErrorStyle: other.optionsTextFieldErrorStyle ?? optionsTextFieldErrorStyle,
      optionsTextFieldBorderRadius: other.optionsTextFieldBorderRadius ?? optionsTextFieldBorderRadius,
      switchListTileFillColor: other.switchListTileFillColor ?? switchListTileFillColor,
      switchListTileTitleStyle: other.switchListTileTitleStyle ?? switchListTileTitleStyle,
      switchListTileErrorStyle: other.switchListTileErrorStyle ?? switchListTileErrorStyle,
      switchListTileBorderRadius: other.switchListTileBorderRadius ?? switchListTileBorderRadius,
      actionDialogTitleStyle: other.actionDialogTitleStyle ?? actionDialogTitleStyle,
      actionDialogContentStyle: other.actionDialogContentStyle ?? actionDialogContentStyle,
    );
  }

  /// Linearly interpolate between two [StreamPollCreatorThemeData].
  StreamPollCreatorThemeData lerp(
    StreamPollCreatorThemeData a,
    StreamPollCreatorThemeData b,
    double t,
  ) {
    return StreamPollCreatorThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      appBarTitleStyle: TextStyle.lerp(a.appBarTitleStyle, b.appBarTitleStyle, t),
      appBarElevation: lerpDouble(a.appBarElevation, b.appBarElevation, t),
      appBarBackgroundColor: Color.lerp(a.appBarBackgroundColor, b.appBarBackgroundColor, t),
      appBarForegroundColor: Color.lerp(a.appBarForegroundColor, b.appBarForegroundColor, t),
      questionTextFieldFillColor: Color.lerp(a.questionTextFieldFillColor, b.questionTextFieldFillColor, t),
      questionHeaderStyle: TextStyle.lerp(a.questionHeaderStyle, b.questionHeaderStyle, t),
      questionTextFieldStyle: TextStyle.lerp(a.questionTextFieldStyle, b.questionTextFieldStyle, t),
      questionTextFieldErrorStyle: TextStyle.lerp(a.questionTextFieldErrorStyle, b.questionTextFieldErrorStyle, t),
      questionTextFieldBorderRadius: BorderRadius.lerp(
        a.questionTextFieldBorderRadius,
        b.questionTextFieldBorderRadius,
        t,
      ),
      optionsTextFieldFillColor: Color.lerp(a.optionsTextFieldFillColor, b.optionsTextFieldFillColor, t),
      optionsHeaderStyle: TextStyle.lerp(a.optionsHeaderStyle, b.optionsHeaderStyle, t),
      optionsTextFieldStyle: TextStyle.lerp(a.optionsTextFieldStyle, b.optionsTextFieldStyle, t),
      optionsTextFieldErrorStyle: TextStyle.lerp(a.optionsTextFieldErrorStyle, b.optionsTextFieldErrorStyle, t),
      optionsTextFieldBorderRadius: BorderRadius.lerp(
        a.optionsTextFieldBorderRadius,
        b.optionsTextFieldBorderRadius,
        t,
      ),
      switchListTileFillColor: Color.lerp(a.switchListTileFillColor, b.switchListTileFillColor, t),
      switchListTileTitleStyle: TextStyle.lerp(a.switchListTileTitleStyle, b.switchListTileTitleStyle, t),
      switchListTileErrorStyle: TextStyle.lerp(a.switchListTileErrorStyle, b.switchListTileErrorStyle, t),
      switchListTileBorderRadius: BorderRadius.lerp(a.switchListTileBorderRadius, b.switchListTileBorderRadius, t),
      actionDialogTitleStyle: TextStyle.lerp(a.actionDialogTitleStyle, b.actionDialogTitleStyle, t),
      actionDialogContentStyle: TextStyle.lerp(a.actionDialogContentStyle, b.actionDialogContentStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamPollCreatorThemeData &&
          other.backgroundColor == backgroundColor &&
          other.appBarTitleStyle == appBarTitleStyle &&
          other.appBarElevation == appBarElevation &&
          other.appBarBackgroundColor == appBarBackgroundColor &&
          other.appBarForegroundColor == appBarForegroundColor &&
          other.questionTextFieldFillColor == questionTextFieldFillColor &&
          other.questionHeaderStyle == questionHeaderStyle &&
          other.questionTextFieldStyle == questionTextFieldStyle &&
          other.questionTextFieldErrorStyle == questionTextFieldErrorStyle &&
          other.questionTextFieldBorderRadius == questionTextFieldBorderRadius &&
          other.optionsTextFieldFillColor == optionsTextFieldFillColor &&
          other.optionsHeaderStyle == optionsHeaderStyle &&
          other.optionsTextFieldStyle == optionsTextFieldStyle &&
          other.optionsTextFieldErrorStyle == optionsTextFieldErrorStyle &&
          other.optionsTextFieldBorderRadius == optionsTextFieldBorderRadius &&
          other.switchListTileFillColor == switchListTileFillColor &&
          other.switchListTileTitleStyle == switchListTileTitleStyle &&
          other.switchListTileErrorStyle == switchListTileErrorStyle &&
          other.switchListTileBorderRadius == switchListTileBorderRadius &&
          other.actionDialogTitleStyle == actionDialogTitleStyle &&
          other.actionDialogContentStyle == actionDialogContentStyle;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      appBarTitleStyle.hashCode ^
      appBarElevation.hashCode ^
      appBarBackgroundColor.hashCode ^
      appBarForegroundColor.hashCode ^
      questionTextFieldFillColor.hashCode ^
      questionHeaderStyle.hashCode ^
      questionTextFieldStyle.hashCode ^
      questionTextFieldErrorStyle.hashCode ^
      questionTextFieldBorderRadius.hashCode ^
      optionsTextFieldFillColor.hashCode ^
      optionsHeaderStyle.hashCode ^
      optionsTextFieldStyle.hashCode ^
      optionsTextFieldErrorStyle.hashCode ^
      optionsTextFieldBorderRadius.hashCode ^
      switchListTileFillColor.hashCode ^
      switchListTileTitleStyle.hashCode ^
      switchListTileErrorStyle.hashCode ^
      switchListTileBorderRadius.hashCode ^
      actionDialogTitleStyle.hashCode ^
      actionDialogContentStyle.hashCode;
}

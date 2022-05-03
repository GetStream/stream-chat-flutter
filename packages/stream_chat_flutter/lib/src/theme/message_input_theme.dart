import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro message_input_theme}
@Deprecated("Use 'StreamMessageInputTheme' instead")
typedef MessageInputTheme = StreamMessageInputTheme;

/// {@template message_input_theme}
/// Overrides the default style of [MessageInput] descendants.
///
/// See also:
///
///  * [StreamMessageInputThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamMessageInputTheme extends InheritedTheme {
  /// Creates a [StreamMessageInputTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamMessageInputTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final StreamMessageInputThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamMessageInputTheme] widget, then
  /// [StreamChatThemeData.messageInputTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = MessageInputTheme.of(context);
  /// ```
  static StreamMessageInputThemeData of(BuildContext context) {
    final messageInputTheme =
        context.dependOnInheritedWidgetOfExactType<StreamMessageInputTheme>();
    return messageInputTheme?.data ??
        StreamChatTheme.of(context).messageInputTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamMessageInputTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessageInputTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro message_input_theme_data}
@Deprecated("Use 'StreamMessageInputThemeData' instead")
typedef MessageInputThemeData = StreamMessageInputThemeData;

/// {@template message_input_theme_data}
/// A style that overrides the default appearance of [MessageInput] widgets
/// when used with [StreamMessageInputTheme]
/// or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.messageInputTheme].
/// {@endtemplate}
class StreamMessageInputThemeData with Diagnosticable {
  /// Creates a [StreamMessageInputThemeData].
  const StreamMessageInputThemeData({
    this.sendAnimationDuration,
    this.actionButtonColor,
    this.sendButtonColor,
    this.actionButtonIdleColor,
    this.sendButtonIdleColor,
    this.inputBackgroundColor,
    this.inputTextStyle,
    this.inputDecoration,
    this.activeBorderGradient,
    this.idleBorderGradient,
    this.borderRadius,
    this.expandButtonColor,
    this.linkHighlightColor,
    this.enableSafeArea,
    this.elevation,
    this.shadow,
  });

  /// Duration of the [MessageInput] send button animation
  final Duration? sendAnimationDuration;

  /// Background color of [MessageInput] send button
  final Color? sendButtonColor;

  /// Color of a link
  final Color? linkHighlightColor;

  /// Background color of [MessageInput] action buttons
  final Color? actionButtonColor;

  /// Background color of [MessageInput] send button
  final Color? sendButtonIdleColor;

  /// Background color of [MessageInput] action buttons
  final Color? actionButtonIdleColor;

  /// Background color of [MessageInput] expand button
  final Color? expandButtonColor;

  /// Background color of [MessageInput]
  final Color? inputBackgroundColor;

  /// TextStyle of [MessageInput]
  final TextStyle? inputTextStyle;

  /// InputDecoration of [MessageInput]
  final InputDecoration? inputDecoration;

  /// Border gradient when the [MessageInput] is not focused
  final Gradient? idleBorderGradient;

  /// Border gradient when the [MessageInput] is focused
  final Gradient? activeBorderGradient;

  /// Border radius of [MessageInput]
  final BorderRadius? borderRadius;

  /// Wrap [MessageInput] with a [SafeArea widget]
  final bool? enableSafeArea;

  /// Elevation of the [MessageInput]
  final double? elevation;

  /// Shadow for the [MessageInput] widget
  final BoxShadow? shadow;

  /// Returns a new [StreamMessageInputThemeData]
  /// replacing some of its properties
  StreamMessageInputThemeData copyWith({
    Duration? sendAnimationDuration,
    Color? inputBackgroundColor,
    Color? actionButtonColor,
    Color? sendButtonColor,
    Color? actionButtonIdleColor,
    Color? linkHighlightColor,
    Color? sendButtonIdleColor,
    Color? expandButtonColor,
    TextStyle? inputTextStyle,
    InputDecoration? inputDecoration,
    Gradient? activeBorderGradient,
    Gradient? idleBorderGradient,
    BorderRadius? borderRadius,
    bool? enableSafeArea,
    double? elevation,
    BoxShadow? shadow,
  }) =>
      StreamMessageInputThemeData(
        sendAnimationDuration:
            sendAnimationDuration ?? this.sendAnimationDuration,
        inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
        actionButtonColor: actionButtonColor ?? this.actionButtonColor,
        sendButtonColor: sendButtonColor ?? this.sendButtonColor,
        actionButtonIdleColor:
            actionButtonIdleColor ?? this.actionButtonIdleColor,
        expandButtonColor: expandButtonColor ?? this.expandButtonColor,
        inputTextStyle: inputTextStyle ?? this.inputTextStyle,
        sendButtonIdleColor: sendButtonIdleColor ?? this.sendButtonIdleColor,
        inputDecoration: inputDecoration ?? this.inputDecoration,
        activeBorderGradient: activeBorderGradient ?? this.activeBorderGradient,
        idleBorderGradient: idleBorderGradient ?? this.idleBorderGradient,
        borderRadius: borderRadius ?? this.borderRadius,
        linkHighlightColor: linkHighlightColor ?? this.linkHighlightColor,
        enableSafeArea: enableSafeArea ?? this.enableSafeArea,
        elevation: elevation ?? this.elevation,
        shadow: shadow ?? this.shadow,
      );

  /// Linearly interpolate from one [StreamMessageInputThemeData] to another.
  StreamMessageInputThemeData lerp(
    StreamMessageInputThemeData a,
    StreamMessageInputThemeData b,
    double t,
  ) =>
      StreamMessageInputThemeData(
        actionButtonColor:
            Color.lerp(a.actionButtonColor, b.actionButtonColor, t),
        actionButtonIdleColor:
            Color.lerp(a.actionButtonIdleColor, b.actionButtonIdleColor, t),
        activeBorderGradient:
            Gradient.lerp(a.activeBorderGradient, b.activeBorderGradient, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
        expandButtonColor:
            Color.lerp(a.expandButtonColor, b.expandButtonColor, t),
        idleBorderGradient:
            Gradient.lerp(a.idleBorderGradient, b.idleBorderGradient, t),
        inputBackgroundColor:
            Color.lerp(a.inputBackgroundColor, b.inputBackgroundColor, t),
        inputTextStyle: TextStyle.lerp(a.inputTextStyle, b.inputTextStyle, t),
        sendButtonColor: Color.lerp(a.sendButtonColor, b.sendButtonColor, t),
        sendButtonIdleColor:
            Color.lerp(a.sendButtonIdleColor, b.sendButtonIdleColor, t),
        sendAnimationDuration: a.sendAnimationDuration,
        inputDecoration: a.inputDecoration,
        linkHighlightColor:
            Color.lerp(a.linkHighlightColor, b.linkHighlightColor, t),
        enableSafeArea: a.enableSafeArea,
        elevation: lerpDouble(a.elevation, b.elevation, t),
        shadow: BoxShadow.lerp(a.shadow, b.shadow, t),
      );

  /// Merges [this] [StreamMessageInputThemeData] with the [other]
  StreamMessageInputThemeData merge(StreamMessageInputThemeData? other) {
    if (other == null) return this;
    return copyWith(
      sendAnimationDuration: other.sendAnimationDuration,
      inputBackgroundColor: other.inputBackgroundColor,
      actionButtonColor: other.actionButtonColor,
      actionButtonIdleColor: other.actionButtonIdleColor,
      sendButtonColor: other.sendButtonColor,
      sendButtonIdleColor: other.sendButtonIdleColor,
      inputTextStyle:
          inputTextStyle?.merge(other.inputTextStyle) ?? other.inputTextStyle,
      inputDecoration: inputDecoration?.merge(other.inputDecoration) ??
          other.inputDecoration,
      activeBorderGradient: other.activeBorderGradient,
      idleBorderGradient: other.idleBorderGradient,
      borderRadius: other.borderRadius,
      expandButtonColor: other.expandButtonColor,
      linkHighlightColor: other.linkHighlightColor,
      enableSafeArea: other.enableSafeArea,
      elevation: other.elevation,
      shadow: other.shadow,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamMessageInputThemeData &&
          runtimeType == other.runtimeType &&
          sendAnimationDuration == other.sendAnimationDuration &&
          sendButtonColor == other.sendButtonColor &&
          actionButtonColor == other.actionButtonColor &&
          sendButtonIdleColor == other.sendButtonIdleColor &&
          actionButtonIdleColor == other.actionButtonIdleColor &&
          expandButtonColor == other.expandButtonColor &&
          inputBackgroundColor == other.inputBackgroundColor &&
          inputTextStyle == other.inputTextStyle &&
          inputDecoration == other.inputDecoration &&
          idleBorderGradient == other.idleBorderGradient &&
          activeBorderGradient == other.activeBorderGradient &&
          borderRadius == other.borderRadius &&
          linkHighlightColor == other.linkHighlightColor &&
          enableSafeArea == other.enableSafeArea &&
          elevation == other.elevation &&
          shadow == other.shadow;

  @override
  int get hashCode =>
      sendAnimationDuration.hashCode ^
      sendButtonColor.hashCode ^
      actionButtonColor.hashCode ^
      sendButtonIdleColor.hashCode ^
      actionButtonIdleColor.hashCode ^
      expandButtonColor.hashCode ^
      inputBackgroundColor.hashCode ^
      inputTextStyle.hashCode ^
      inputDecoration.hashCode ^
      idleBorderGradient.hashCode ^
      activeBorderGradient.hashCode ^
      borderRadius.hashCode ^
      linkHighlightColor.hashCode ^
      elevation.hashCode ^
      shadow.hashCode ^
      enableSafeArea.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('sendAnimationDuration', sendAnimationDuration))
      ..add(ColorProperty('inputBackgroundColor', inputBackgroundColor))
      ..add(ColorProperty('actionButtonColor', actionButtonColor))
      ..add(ColorProperty('actionButtonIdleColor', actionButtonIdleColor))
      ..add(ColorProperty('sendButtonColor', sendButtonColor))
      ..add(ColorProperty('sendButtonIdleColor', sendButtonIdleColor))
      ..add(DiagnosticsProperty('inputTextStyle', inputTextStyle))
      ..add(DiagnosticsProperty('inputDecoration', inputDecoration))
      ..add(DiagnosticsProperty('activeBorderGradient', activeBorderGradient))
      ..add(DiagnosticsProperty('idleBorderGradient', idleBorderGradient))
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(ColorProperty('expandButtonColor', expandButtonColor))
      ..add(ColorProperty('linkHighlightColor', linkHighlightColor))
      ..add(DiagnosticsProperty('elevation', elevation))
      ..add(DiagnosticsProperty('shadow', shadow))
      ..add(DiagnosticsProperty('enableSafeArea', enableSafeArea));
  }
}

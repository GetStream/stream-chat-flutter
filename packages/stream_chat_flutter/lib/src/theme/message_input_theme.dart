import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';

/// Defines the theme dedicated to the [MessageInput] widget
class MessageInputThemeData with Diagnosticable {
  /// Returns a new [MessageInputThemeData]
  const MessageInputThemeData({
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
  });

  /// Duration of the [MessageInput] send button animation
  final Duration? sendAnimationDuration;

  /// Background color of [MessageInput] send button
  final Color? sendButtonColor;

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

  /// Returns a new [MessageInputThemeData] replacing some of its properties
  MessageInputThemeData copyWith({
    Duration? sendAnimationDuration,
    Color? inputBackgroundColor,
    Color? actionButtonColor,
    Color? sendButtonColor,
    Color? actionButtonIdleColor,
    Color? sendButtonIdleColor,
    Color? expandButtonColor,
    TextStyle? inputTextStyle,
    InputDecoration? inputDecoration,
    Gradient? activeBorderGradient,
    Gradient? idleBorderGradient,
    BorderRadius? borderRadius,
  }) =>
      MessageInputThemeData(
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
      );

  /// Linearly interpolate from one [MessageInputThemeData] to another.
  MessageInputThemeData lerp(
    MessageInputThemeData a,
    MessageInputThemeData b,
    double t,
  ) =>
      MessageInputThemeData(
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
      );

  /// Merges [this] [MessageInputThemeData] with the [other]
  MessageInputThemeData merge(MessageInputThemeData? other) {
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
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageInputThemeData &&
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
          borderRadius == other.borderRadius;

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
      borderRadius.hashCode;

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
      ..add(ColorProperty('expandButtonColor', expandButtonColor));
  }
}

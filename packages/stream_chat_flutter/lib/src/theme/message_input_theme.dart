import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';

/// Defines the theme dedicated to the [MessageInput] widget
class MessageInputTheme {
  /// Returns a new [MessageInputTheme]
  const MessageInputTheme({
    this.sendAnimationDuration,
    this.actionButtonColor,
    this.sendButtonColor,
    this.actionButtonIdleColor,
    this.sendButtonIdleColor,
    this.inputBackground,
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
  final Color? inputBackground;

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

  /// Returns a new [MessageInputTheme] replacing some of its properties
  MessageInputTheme copyWith({
    Duration? sendAnimationDuration,
    Color? inputBackground,
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
      MessageInputTheme(
        sendAnimationDuration:
        sendAnimationDuration ?? this.sendAnimationDuration,
        inputBackground: inputBackground ?? this.inputBackground,
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

  /// Merges [this] [MessageInputTheme] with the [other]
  MessageInputTheme merge(MessageInputTheme? other) {
    if (other == null) return this;
    return copyWith(
      sendAnimationDuration: other.sendAnimationDuration,
      inputBackground: other.inputBackground,
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
}
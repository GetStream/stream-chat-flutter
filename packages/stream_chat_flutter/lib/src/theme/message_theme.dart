import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// Class for getting message theme
// ignore: prefer-match-file-name
class MessageThemeData with Diagnosticable {
  /// Creates a [MessageThemeData].
  const MessageThemeData({
    this.repliesStyle,
    this.messageTextStyle,
    this.messageAuthorStyle,
    this.messageLinksStyle,
    this.messageBackgroundColor,
    this.messageBorderColor,
    this.reactionsBackgroundColor,
    this.reactionsBorderColor,
    this.reactionsMaskColor,
    this.avatarTheme,
    this.createdAtStyle,
  });

  /// Text style for message text
  final TextStyle? messageTextStyle;

  /// Text style for message author
  final TextStyle? messageAuthorStyle;

  /// Text style for message links
  final TextStyle? messageLinksStyle;

  /// Text style for created at text
  final TextStyle? createdAtStyle;

  /// Text style for replies
  final TextStyle? repliesStyle;

  /// Color for messageBackgroundColor
  final Color? messageBackgroundColor;

  /// Color for message border color
  final Color? messageBorderColor;

  /// Color for reactions
  final Color? reactionsBackgroundColor;

  /// Colors reaction border
  final Color? reactionsBorderColor;

  /// Color for reaction mask
  final Color? reactionsMaskColor;

  /// Theme of the avatar
  final AvatarThemeData? avatarTheme;

  /// Copy with a theme
  MessageThemeData copyWith({
    TextStyle? messageTextStyle,
    TextStyle? messageAuthorStyle,
    TextStyle? messageLinksStyle,
    TextStyle? createdAtStyle,
    TextStyle? repliesStyle,
    Color? messageBackgroundColor,
    Color? messageBorderColor,
    AvatarThemeData? avatarTheme,
    Color? reactionsBackgroundColor,
    Color? reactionsBorderColor,
    Color? reactionsMaskColor,
  }) =>
      MessageThemeData(
        messageTextStyle: messageTextStyle ?? this.messageTextStyle,
        messageAuthorStyle: messageAuthorStyle ?? this.messageAuthorStyle,
        messageLinksStyle: messageLinksStyle ?? this.messageLinksStyle,
        createdAtStyle: createdAtStyle ?? this.createdAtStyle,
        messageBackgroundColor:
            messageBackgroundColor ?? this.messageBackgroundColor,
        messageBorderColor: messageBorderColor ?? this.messageBorderColor,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        repliesStyle: repliesStyle ?? this.repliesStyle,
        reactionsBackgroundColor:
            reactionsBackgroundColor ?? this.reactionsBackgroundColor,
        reactionsBorderColor: reactionsBorderColor ?? this.reactionsBorderColor,
        reactionsMaskColor: reactionsMaskColor ?? this.reactionsMaskColor,
      );

  /// Linearly interpolate from one [MessageThemeData] to another.
  MessageThemeData lerp(MessageThemeData a, MessageThemeData b, double t) =>
      MessageThemeData(
        avatarTheme:
            const AvatarThemeData().lerp(a.avatarTheme!, b.avatarTheme!, t),
        createdAtStyle: TextStyle.lerp(a.createdAtStyle, b.createdAtStyle, t),
        messageAuthorStyle:
            TextStyle.lerp(a.messageAuthorStyle, b.messageAuthorStyle, t),
        messageBackgroundColor:
            Color.lerp(a.messageBackgroundColor, b.messageBackgroundColor, t),
        messageBorderColor:
            Color.lerp(a.messageBorderColor, b.messageBorderColor, t),
        messageLinksStyle:
            TextStyle.lerp(a.messageLinksStyle, b.messageLinksStyle, t),
        messageTextStyle:
            TextStyle.lerp(a.messageTextStyle, b.messageTextStyle, t),
        reactionsBackgroundColor: Color.lerp(
            a.reactionsBackgroundColor, b.reactionsBackgroundColor, t,),
        reactionsBorderColor:
            Color.lerp(a.messageBorderColor, b.reactionsBorderColor, t),
        reactionsMaskColor:
            Color.lerp(a.reactionsMaskColor, b.reactionsMaskColor, t),
        repliesStyle: TextStyle.lerp(a.repliesStyle, b.repliesStyle, t),
      );

  /// Merge with a theme
  MessageThemeData merge(MessageThemeData? other) {
    if (other == null) return this;
    return copyWith(
      messageTextStyle: messageTextStyle?.merge(other.messageTextStyle) ??
          other.messageTextStyle,
      messageAuthorStyle: messageAuthorStyle?.merge(other.messageAuthorStyle) ??
          other.messageAuthorStyle,
      messageLinksStyle: messageLinksStyle?.merge(other.messageLinksStyle) ??
          other.messageLinksStyle,
      createdAtStyle:
          createdAtStyle?.merge(other.createdAtStyle) ?? other.createdAtStyle,
      repliesStyle:
          repliesStyle?.merge(other.repliesStyle) ?? other.repliesStyle,
      messageBackgroundColor: other.messageBackgroundColor,
      messageBorderColor: other.messageBorderColor,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      reactionsBackgroundColor: other.reactionsBackgroundColor,
      reactionsBorderColor: other.reactionsBorderColor,
      reactionsMaskColor: other.reactionsMaskColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageThemeData &&
          runtimeType == other.runtimeType &&
          messageTextStyle == other.messageTextStyle &&
          messageAuthorStyle == other.messageAuthorStyle &&
          messageLinksStyle == other.messageLinksStyle &&
          createdAtStyle == other.createdAtStyle &&
          repliesStyle == other.repliesStyle &&
          messageBackgroundColor == other.messageBackgroundColor &&
          messageBorderColor == other.messageBorderColor &&
          reactionsBackgroundColor == other.reactionsBackgroundColor &&
          reactionsBorderColor == other.reactionsBorderColor &&
          reactionsMaskColor == other.reactionsMaskColor &&
          avatarTheme == other.avatarTheme;

  @override
  int get hashCode =>
      messageTextStyle.hashCode ^
      messageAuthorStyle.hashCode ^
      messageLinksStyle.hashCode ^
      createdAtStyle.hashCode ^
      repliesStyle.hashCode ^
      messageBackgroundColor.hashCode ^
      messageBorderColor.hashCode ^
      reactionsBackgroundColor.hashCode ^
      reactionsBorderColor.hashCode ^
      reactionsMaskColor.hashCode ^
      avatarTheme.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('messageTextStyle', messageTextStyle))
      ..add(DiagnosticsProperty('messageAuthorStyle', messageAuthorStyle))
      ..add(DiagnosticsProperty('messageLinksStyle', messageLinksStyle))
      ..add(DiagnosticsProperty('createdAtStyle', createdAtStyle))
      ..add(DiagnosticsProperty('repliesStyle', repliesStyle))
      ..add(ColorProperty('messageBackgroundColor', messageBackgroundColor))
      ..add(ColorProperty('messageBorderColor', messageBorderColor))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme))
      ..add(ColorProperty('reactionsBackgroundColor', reactionsBackgroundColor))
      ..add(ColorProperty('reactionsBorderColor', reactionsBorderColor))
      ..add(ColorProperty('reactionsMaskColor', reactionsMaskColor));
  }
}

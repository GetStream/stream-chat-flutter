import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// Class for getting message theme
class MessageTheme {
  /// Constructor into [MessageTheme]
  const MessageTheme({
    this.replies,
    this.messageText,
    this.messageAuthor,
    this.messageLinks,
    this.messageBackgroundColor,
    this.messageBorderColor,
    this.reactionsBackgroundColor,
    this.reactionsBorderColor,
    this.reactionsMaskColor,
    this.avatarTheme,
    this.createdAt,
  });

  /// Text style for message text
  final TextStyle? messageText;

  /// Text style for message author
  final TextStyle? messageAuthor;

  /// Text style for message links
  final TextStyle? messageLinks;

  /// Text style for created at text
  final TextStyle? createdAt;

  /// Text style for replies
  final TextStyle? replies;

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
  final AvatarTheme? avatarTheme;

  /// Copy with a theme
  MessageTheme copyWith({
    TextStyle? messageText,
    TextStyle? messageAuthor,
    TextStyle? messageLinks,
    TextStyle? createdAt,
    TextStyle? replies,
    Color? messageBackgroundColor,
    Color? messageBorderColor,
    AvatarTheme? avatarTheme,
    Color? reactionsBackgroundColor,
    Color? reactionsBorderColor,
    Color? reactionsMaskColor,
  }) =>
      MessageTheme(
        messageText: messageText ?? this.messageText,
        messageAuthor: messageAuthor ?? this.messageAuthor,
        messageLinks: messageLinks ?? this.messageLinks,
        createdAt: createdAt ?? this.createdAt,
        messageBackgroundColor:
            messageBackgroundColor ?? this.messageBackgroundColor,
        messageBorderColor: messageBorderColor ?? this.messageBorderColor,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        replies: replies ?? this.replies,
        reactionsBackgroundColor:
            reactionsBackgroundColor ?? this.reactionsBackgroundColor,
        reactionsBorderColor: reactionsBorderColor ?? this.reactionsBorderColor,
        reactionsMaskColor: reactionsMaskColor ?? this.reactionsMaskColor,
      );

  /// Merge with a theme
  MessageTheme merge(MessageTheme? other) {
    if (other == null) return this;
    return copyWith(
      messageText: messageText?.merge(other.messageText) ?? other.messageText,
      messageAuthor:
          messageAuthor?.merge(other.messageAuthor) ?? other.messageAuthor,
      messageLinks:
          messageLinks?.merge(other.messageLinks) ?? other.messageLinks,
      createdAt: createdAt?.merge(other.createdAt) ?? other.createdAt,
      replies: replies?.merge(other.replies) ?? other.replies,
      messageBackgroundColor: other.messageBackgroundColor,
      messageBorderColor: other.messageBorderColor,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      reactionsBackgroundColor: other.reactionsBackgroundColor,
      reactionsBorderColor: other.reactionsBorderColor,
      reactionsMaskColor: other.reactionsMaskColor,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// Theme for channel preview
class ChannelPreviewTheme {
  /// Constructor for creating [ChannelPreviewTheme]
  const ChannelPreviewTheme({
    this.titleStyle,
    this.subtitleStyle,
    this.lastMessageAt,
    this.avatarTheme,
    this.unreadCounterColor,
    this.indicatorIconSize,
  });

  /// Theme for title
  final TextStyle? titleStyle;

  /// Theme for subtitle
  final TextStyle? subtitleStyle;

  /// Theme of last message at
  final TextStyle? lastMessageAt;

  /// Avatar theme
  final AvatarThemeData? avatarTheme;

  /// Unread counter color
  final Color? unreadCounterColor;

  /// Indicator icon size
  final double? indicatorIconSize;

  /// Copy with theme
  ChannelPreviewTheme copyWith({
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? lastMessageAt,
    AvatarThemeData? avatarTheme,
    Color? unreadCounterColor,
    double? indicatorIconSize,
  }) =>
      ChannelPreviewTheme(
        titleStyle: title ?? this.titleStyle,
        subtitleStyle: subtitle ?? this.subtitleStyle,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        unreadCounterColor: unreadCounterColor ?? this.unreadCounterColor,
        indicatorIconSize: indicatorIconSize ?? this.indicatorIconSize,
      );

  /// Merge with theme
  ChannelPreviewTheme merge(ChannelPreviewTheme? other) {
    if (other == null) return this;
    return copyWith(
      title: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      subtitle:
          subtitleStyle?.merge(other.subtitleStyle) ?? other.subtitleStyle,
      lastMessageAt:
          lastMessageAt?.merge(other.lastMessageAt) ?? other.lastMessageAt,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      unreadCounterColor: other.unreadCounterColor,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// Theme for [ChannelHeader]
class ChannelHeaderTheme {
  /// Constructor for creating a [ChannelHeaderTheme]
  const ChannelHeaderTheme({
    this.title,
    this.subtitle,
    this.avatarTheme,
    this.color,
  });

  /// Theme for title
  final TextStyle? title;

  /// Theme for subtitle
  final TextStyle? subtitle;

  /// Theme for avatar
  final AvatarTheme? avatarTheme;

  /// Color for [ChannelHeaderTheme]
  final Color? color;

  /// Copy with theme
  ChannelHeaderTheme copyWith({
    TextStyle? title,
    TextStyle? subtitle,
    AvatarTheme? avatarTheme,
    Color? color,
  }) =>
      ChannelHeaderTheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Merge with other [ChannelHeaderTheme]
  ChannelHeaderTheme merge(ChannelHeaderTheme? other) {
    if (other == null) return this;
    return copyWith(
      title: title?.merge(other.title) ?? other.title,
      subtitle: subtitle?.merge(other.subtitle) ?? other.subtitle,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }
}
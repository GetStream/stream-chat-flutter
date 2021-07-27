import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// Theme dedicated to the [ChannelListHeader]
class ChannelListHeaderTheme {
  /// Returns a new [ChannelListHeaderTheme]
  const ChannelListHeaderTheme({
    this.title,
    this.avatarTheme,
    this.color,
  });

  /// Style of the title text
  final TextStyle? title;

  /// Theme dedicated to the userAvatar
  final AvatarThemeData? avatarTheme;

  /// Background color of the appbar
  final Color? color;

  /// Returns a new [ChannelListHeaderTheme] replacing some of its properties
  ChannelListHeaderTheme copyWith({
    TextStyle? title,
    AvatarThemeData? avatarTheme,
    Color? color,
  }) =>
      ChannelListHeaderTheme(
        title: title ?? this.title,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Merges [this] [ChannelListHeaderTheme] with the [other]
  ChannelListHeaderTheme merge(ChannelListHeaderTheme? other) {
    if (other == null) return this;
    return copyWith(
      title: title?.merge(other.title) ?? other.title,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }
}
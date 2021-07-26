import 'package:stream_chat_flutter/src/theme/channel_header_theme.dart';

/// Channel theme data
class ChannelTheme {
  /// Constructor for creating [ChannelTheme]
  ChannelTheme({
    required this.channelHeaderTheme,
  });

  /// Theme of the [ChannelHeader] widget
  final ChannelHeaderTheme channelHeaderTheme;

  /// Creates a copy of [ChannelTheme] with specified attributes overridden.
  ChannelTheme copyWith({
    ChannelHeaderTheme? channelHeaderTheme,
  }) =>
      ChannelTheme(
        channelHeaderTheme: channelHeaderTheme ?? this.channelHeaderTheme,
      );

  /// Merge with theme
  ChannelTheme merge(ChannelTheme? other) {
    if (other == null) return this;
    return copyWith(
      channelHeaderTheme: channelHeaderTheme.merge(other.channelHeaderTheme),
    );
  }
}

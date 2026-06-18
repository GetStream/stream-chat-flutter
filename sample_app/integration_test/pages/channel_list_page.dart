import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Selectors for the channel list screen. Mirrors the Android `ChannelListPage`.
abstract final class ChannelListPage {
  /// Channel rows render as [StreamChannelListTile]; match by type.
  static const Type channelTile = StreamChannelListTile;
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mock_server/data_types.dart';
import 'message_list_page.dart';

abstract final class ChannelListPage {
  static const Type channelTile = StreamChannelListTile;

  static const channel = _ChannelPreview();

  /// Every channel row currently built by the list.
  ///
  /// Scoped to [StreamChannelListItem] rather than [channelTile] because only
  /// the item carries the channel it was built from, so rows can be told apart
  /// by identity.
  static Finder get channels => find.byType(StreamChannelListItem);
}

/// The parts of a single channel row. Each finder is unscoped — the asserts
/// narrow it to one row with `find.descendant`.
final class _ChannelPreview {
  const _ChannelPreview();

  /// The channel avatar at the leading edge of the row.
  Finder get avatar => find.byType(StreamChannelAvatar);

  /// The row's subtitle, which hosts either the last message preview, the
  /// typing indicator, or the "no messages" placeholder.
  Finder get preview => find.byType(ChannelListTileSubtitle);

  /// The single [Text] the [preview] renders. It is a `Text.rich` for an actual
  /// message and a plain [Text] for the empty-channel placeholder.
  Finder get previewText => find.descendant(of: preview, matching: find.byType(Text));

  /// The last-message timestamp. [ChannelLastMessageDate] renders nothing while
  /// the channel has no message to preview, so the widget's presence *is* the
  /// "timestamp is shown" signal.
  Finder get timestamp => find.byType(StreamTimestamp);

  /// The delivery-status icon shown in front of the current user's own last
  /// message. The channel list reuses [StreamSendingIndicator], so the status
  /// matching is shared with the message list.
  Finder sendingStatus(MessageDeliveryStatus status) => MessageListPage.list.sendingStatus(status);

  /// Any delivery-status icon at all. The SDK only builds the indicator for the
  /// current user's own messages, so a row previewing someone else's message
  /// has none — which is how [MessageDeliveryStatus.nil] is asserted here.
  Finder get anySendingStatus => find.byType(StreamSendingIndicator);
}

import 'package:e2e_app/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  /// The channel row titled [name].
  static Finder channelNamed(String name) => find.descendant(of: find.byType(channelTile), matching: find.text(name));

  /// A channel row whose unread badge reads [count] (none when 0).
  static Finder channelWithUnreadCount(int count) => find.byWidgetPredicate(
    (it) => it is StreamChannelListTile && it.unreadCount == count,
    description: 'channel row with $count unread',
  );

  /// The swipe actions revealed behind a channel row: "more" (which opens the
  /// detail sheet) first, then mute / unmute.
  static Finder swipeAction(int index) => find.byType(CustomSlidableAction).at(index);

  /// The confirm button ([label]) of the app's leave / delete dialog.
  static Finder dialogButton(String label) => find.descendant(of: find.byType(AlertDialog), matching: find.text(label));

  /// The search field above the channel list.
  static Finder get searchField => find.descendant(of: find.byType(SearchTextField), matching: find.byType(TextField));

  static Finder get searchResults => find.byType(StreamMessageSearchListTile);

  /// The chip choosing what the search field searches: 'Messages' or 'Channels'.
  static Finder searchScope(String label) => find.widgetWithText(ChoiceChip, label);

  /// A row of the channel detail sheet opened by long-pressing a channel.
  static Finder channelAction(String label) => find.text(label);
}

/// The app's channel info screen and the pinned messages screen it
/// lead to.
abstract final class ChannelInfoPage {
  static Finder get pinnedMessagesOption => find.text('Pinned Messages');

  static Finder get pinnedMessagesTitle => find.text('Pinned Messages');

  static Finder get pinnedMessages => find.byType(StreamMessageSearchListTile);

  static Finder get pinnedMessagesEmpty => find.text('No pinned messages');

  static Finder get groupInfoTitle => find.text('Group Info');
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

  /// The "… is typing" text the subtitle shows in place of the last message.
  Finder get typingIndicator => find.descendant(of: preview, matching: find.textContaining('typing'));

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

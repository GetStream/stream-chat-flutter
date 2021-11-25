import 'package:stream_chat/stream_chat.dart' show Event;
import 'package:stream_chat_flutter/src/v4/channel_list_view/stream_channel_list_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Handles [EventType.channelDeleted] event.
///
/// This event is fired when a channel is deleted.
///
/// By default, this removes the channel from the list of channels.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onChannelDeleted: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onChannelDeleted(
  Event event,
  StreamChannelListController controller,
) {
  final channels = [...controller.currentItems];

  final updatedChannels = channels
    ..removeWhere(
      (it) => it.cid == (event.cid ?? event.channel?.cid),
    );

  controller.channels = updatedChannels;
}

/// Handles [EventType.channelHidden] event.
///
/// This event is fired when a channel is hidden.
///
/// By default, this removes the channel from the list of channels.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onChannelHidden: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onChannelHidden(
  Event event,
  StreamChannelListController controller,
) {
  onChannelDeleted(event, controller);
}

/// Handles [EventType.channelTruncated] event.
///
/// This event is fired when a channel is truncated.
///
/// By default, this refreshes the whole channel list.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onChannelTruncated: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onChannelTruncated(
  Event event,
  StreamChannelListController controller,
) {
  controller.refresh();
}

/// Handles [EventType.channelUpdated] event.
///
/// This event is fired when a channel is updated.
///
/// By default, this updates the channel received in the event.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onChannelUpdated: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onChannelUpdated(
  Event event,
  StreamChannelListController controller,
) {
  final eventChannel = event.channel;
  if (eventChannel == null) return;

  final channels = [...controller.currentItems];
  final channelIndex = channels.indexWhere(
    (it) => it.cid == (event.cid ?? eventChannel.cid),
  );

  if (channelIndex >= 0) {
    final channelState = ChannelState(channel: eventChannel);
    channels[channelIndex].state?.updateChannelState(channelState);
  }

  controller.channels = channels;
}

/// Handles [EventType.channelVisible] event.
///
/// This event is fired when a channel is made visible.
///
/// By default, this adds the channel to the list of channels.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onChannelVisible: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onChannelVisible(
  Event event,
  StreamChannelListController controller,
) async {
  final channelId = event.channelId;
  final channelType = event.channelType;

  if (channelId == null || channelType == null) return;

  final channel = await controller.getChannel(
    id: channelId,
    type: channelType,
  );

  final currentChannels = [...controller.currentItems];

  final updatedChannels = [
    channel,
    ...currentChannels..removeWhere((it) => it.cid == channel.cid),
  ];

  controller.channels = updatedChannels;
}

/// Handles [EventType.connectionRecovered] event.
///
/// This event is fired when the client web-socket connection recovers.
///
/// By default, this refreshes the whole channel list.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onConnectionRecovered: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onConnectionRecovered(
  Event event,
  StreamChannelListController controller,
) {
  controller.refresh();
}

/// Handles [EventType.messageNew] event.
///
/// This event is fired when a new message is created in one of the channels
/// we are currently watching.
///
/// By default, this moves the channel to the top of the list.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onMessageNew: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onMessageNew(
  Event event,
  StreamChannelListController controller,
) {
  final channelCid = event.cid;
  if (channelCid == null) return;

  final channels = [...controller.currentItems];

  final channelIndex = channels.indexWhere((it) => it.cid == channelCid);
  if (channelIndex <= 0) return;

  final channel = channels.removeAt(channelIndex);
  channels.insert(0, channel);

  controller.channels = [...channels];
}

/// Handles [EventType.notificationAddedToChannel] event.
///
/// This event is fired when a channel is added which we are not watching.
///
/// By default, this adds the channel and moves it to the top of list.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onNotificationAddedToChannel: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onNotificationAddedToChannel(
  Event event,
  StreamChannelListController controller,
) {
  onChannelVisible(event, controller);
}

/// Handles [EventType.notificationMessageNew] event.
///
/// This event is fired when a new message is created in a channel which we are
/// not currently watching.
///
/// By default, this adds the channel and moves it to the top of list.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onNotificationMessageNew: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onNotificationMessageNew(
  Event event,
  StreamChannelListController controller,
) {
  onChannelVisible(event, controller);
}

/// Handles [EventType.notificationRemovedFromChannel] event.
///
/// This event is fired when a user is removed from a channel which we are
/// not currently watching.
///
/// By default, this removes the event channel from the list.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onNotificationRemovedFromChannel: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onNotificationRemovedFromChannel(
  Event event,
  StreamChannelListController controller,
) {
  final channels = [...controller.currentItems];
  final updatedChannels = channels.where((it) => it.cid != event.channel?.cid);
  final listChanged = channels.length != updatedChannels.length;

  if (!listChanged) return;

  controller.channels = [...updatedChannels];
}

/// Handles 'user.presence.changed' and [EventType.userUpdated] event.
///
/// This event is fired when a user's presence changes or gets updated.
///
/// By default, this updates the channel member with the event user.
///
/// ```dart
/// StreamChannelListController(
///   client: client,
///   onUserPresenceChanged: (event, controller) {
///     // Do something
///   },
/// );
/// ```
void onUserPresenceChanged(
  Event event,
  StreamChannelListController controller,
) {
  final user = event.user;
  if (user == null) return;

  final channels = [...controller.currentItems];

  final updatedChannels = channels.map((channel) {
    final members = [...channel.state!.members];
    final memberIndex = members.indexWhere(
      (it) => user.id == (it.userId ?? it.user?.id),
    );

    if (memberIndex < 0) return channel;

    members[memberIndex] = members[memberIndex].copyWith(user: user);
    final updatedState = ChannelState(members: [...members]);
    channel.state!.updateChannelState(updatedState);

    return channel;
  });

  controller.channels = [...updatedChannels];
}

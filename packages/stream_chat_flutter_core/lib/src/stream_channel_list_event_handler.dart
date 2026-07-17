import 'package:stream_chat/stream_chat.dart' show Event, Member;
import 'package:stream_chat_flutter_core/src/stream_channel_list_controller.dart';

/// Contains handlers that are called from [StreamChannelListController] for
/// certain [Event]s.
///
/// This class can be mixed in or extended to create custom overrides.
mixin class StreamChannelListEventHandler {
  /// Function which gets called for the event
  /// [EventType.channelDeleted].
  ///
  /// This event is fired when a channel is deleted.
  ///
  /// By default, this removes the channel from the list of channels.
  void onChannelDeleted(Event event, StreamChannelListController controller) {
    final channels = [...controller.currentItems];

    final updatedChannels = channels
      ..removeWhere(
        (it) => it.cid == (event.cid ?? event.channel?.cid),
      );

    controller.channels = updatedChannels;
  }

  /// Function which gets called for the event
  /// [EventType.channelHidden].
  ///
  /// This event is fired when a channel is hidden.
  ///
  /// By default, this removes the channel from the list of channels.
  void onChannelHidden(Event event, StreamChannelListController controller) {
    onChannelDeleted(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.channelTruncated].
  ///
  /// This event is fired when a channel is truncated.
  ///
  /// By default, this refreshes the whole channel list.
  void onChannelTruncated(Event event, StreamChannelListController controller) {
    controller.refresh();
  }

  /// Function which gets called for the event
  /// [EventType.channelUpdated].
  ///
  /// This event is fired when a channel is updated.
  ///
  /// By default, this re-sorts the list when the updated channel is present in
  /// it, and does nothing otherwise.
  void onChannelUpdated(Event event, StreamChannelListController controller) {
    final cid = event.cid ?? event.channel?.cid;
    final channels = controller.currentItems;
    if (!channels.any((it) => it.cid == cid)) return;
    controller.channels = [...channels];
  }

  /// Function which gets called for the event
  /// [EventType.memberUpdated].
  ///
  /// This event is fired when a member is updated.
  ///
  /// By default, this re-sorts the list when the member's channel is present in
  /// it, and does nothing otherwise.
  void onMemberUpdated(Event event, StreamChannelListController controller) {
    final cid = event.cid ?? event.channel?.cid;
    final channels = controller.currentItems;
    if (!channels.any((it) => it.cid == cid)) return;
    controller.channels = [...channels];
  }

  /// Function which gets called for the event
  /// [EventType.channelVisible].
  ///
  /// This event is fired when a channel is made visible.
  ///
  /// By default, this adds the channel to the list of channels.
  void onChannelVisible(
    Event event,
    StreamChannelListController controller,
  ) async {
    final channelId = event.channelId;
    final channelType = event.channelType;

    if (channelId == null || channelType == null) return;

    final currentChannels = [...controller.currentItems];

    final channel = await controller.getChannel(
      id: channelId,
      type: channelType,
    );

    final updatedChannels = [
      channel,
      ...currentChannels..removeWhere((it) => it.cid == channel.cid),
    ];

    controller.channels = updatedChannels;
  }

  /// Function which gets called for the event
  /// [EventType.connectionRecovered].
  ///
  /// This event is fired when the client web-socket connection recovers.
  ///
  /// By default, this refreshes the whole channel list.
  void onConnectionRecovered(
    Event event,
    StreamChannelListController controller,
  ) {
    controller.refresh();
  }

  /// Function which gets called for the event [EventType.messageNew].
  ///
  /// This event is fired when a new message is created in one of the channels
  /// we are currently watching.
  ///
  /// By default, this moves the channel to the top of the list.
  void onMessageNew(Event event, StreamChannelListController controller) async {
    final channelCid = event.cid;
    if (channelCid == null) return;

    final channels = [...controller.currentItems];

    final channelIndex = channels.indexWhere((it) => it.cid == channelCid);
    if (channelIndex < 0) {
      // If the channel is not in the list, It might be hidden.
      // So, we just refresh the list.
      await controller.refresh(resetValue: false);
      return;
    }

    final channel = channels.removeAt(channelIndex);
    channels.insert(0, channel);

    controller.channels = [...channels];
  }

  /// Function which gets called for the event
  /// [EventType.notificationAddedToChannel].
  ///
  /// This event is fired when a channel is added which we are not watching.
  ///
  /// By default, this adds the channel and moves it to the top of list.
  void onNotificationAddedToChannel(
    Event event,
    StreamChannelListController controller,
  ) {
    onChannelVisible(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.notificationMessageNew].
  ///
  /// This event is fired when a new message is created in a channel
  /// which we are not currently watching.
  ///
  /// By default, this adds the channel and moves it to the top of list.
  void onNotificationMessageNew(
    Event event,
    StreamChannelListController controller,
  ) {
    onChannelVisible(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.notificationRemovedFromChannel].
  ///
  /// This event is fired when a user is removed from a channel which we are
  /// not currently watching.
  ///
  /// By default, this removes the event channel from the list.
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

  /// Function which gets called for the event
  /// [EventType.userPresenceChanged] and [EventType.userUpdated].
  ///
  /// This event is fired when a user's presence changes or gets updated.
  ///
  /// By default, this updates the event user in every listed channel they are a
  /// member of, then re-sorts the list. Does nothing when the user is not a
  /// member of any listed channel.
  void onUserPresenceChanged(
    Event event,
    StreamChannelListController controller,
  ) {
    final user = event.user;
    if (user == null) return;

    final channels = [...controller.currentItems];

    var updated = false;
    for (final channel in channels) {
      final existingMembership = channel.membership;
      final existingMembers = [...channel.state!.members];

      // Leave channels untouched where the user is not an existing member.
      if (!existingMembers.any((m) => m.userId == user.id)) continue;

      Member? maybeUpdateMemberUser(Member? existingMember) {
        if (existingMember == null) return null;
        if (existingMember.userId == user.id) {
          return existingMember.copyWith(user: user);
        }
        return existingMember;
      }

      channel.state!.updateChannelState(
        channel.state!.channelState.copyWith(
          membership: maybeUpdateMemberUser(existingMembership),
          members: [...existingMembers.map(maybeUpdateMemberUser).nonNulls],
        ),
      );

      updated = true;
    }

    // Skip the re-sort when no listed channel contained the user.
    if (!updated) return;

    controller.channels = [...channels];
  }
}

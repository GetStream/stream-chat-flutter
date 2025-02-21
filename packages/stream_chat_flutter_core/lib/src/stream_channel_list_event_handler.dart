import 'package:collection/collection.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

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
  /// By default, this updates the channel received in the event.
  // ignore: no-empty-block
  void onChannelUpdated(
    Event event,
    StreamChannelListController controller, {
    Filter? filter,
  }) => onChannelVisible(event, controller, filter: filter);

  /// Function which gets called for the event
  /// [EventType.channelVisible].
  ///
  /// This event is fired when a channel is made visible.
  ///
  /// By default, this adds the channel to the list of channels.
  void onChannelVisible(
    Event event,
    StreamChannelListController controller, {
    Filter? filter,
  }) async {
    final channelId = event.channelId;
    final channelType = event.channelType;

    if (channelId == null || channelType == null) return;

    final channel = await controller.getChannel(
      id: channelId,
      type: channelType,
    );

    final currentItems = [...controller.currentItems];

    final updatedChannels = [
      ...currentItems..removeWhere((it) => it.cid == channel.cid),
    ];

    if (filter != null) {
      final filterType = filterChannelType(channel, filter);
      final filterStatus = filterChannelStatus(filter, channel: event.channel);
      final filterIsMember = filterMember(channel, filter);
      if (filterType != true ||
          filterStatus != true ||
          filterIsMember != true) {
        controller.channels = updatedChannels;
        return;
      }
    }

    updatedChannels.insert(0, channel);
    controller.channels = updatedChannels;
  }

  /// Function which gets called to check if member in filter is in the channel
  bool? filterMember(
    Channel channel,
    Filter filter,
  ) {
    final filterList = filter.value as List;
    final filterMembers = filterList
        .firstWhereOrNull((filter) => filter.key == 'members') as Filter?;
    if (filterMembers == null) return true;
    final channelMembers = channel.state?.members;
    final isMember = channelMembers?.firstWhereOrNull((member) =>
        (filterMembers.value as List?)?.contains(member.userId) == true);
    return isMember != null;
  }

  /// Function which gets called to check if the channel type is in the filter
  bool? filterChannelType(Channel channel, Filter filter) {
    var passedFilter = false;
    final filterList = filter.value as List;
    final filterType =
        filterList.firstWhereOrNull((filter) => filter.key == 'type') as Filter?;
    if (filterType == null) return true;
    if (filterType.value == channel.type) {
      passedFilter = true;
    }
    return passedFilter;
  }

  /// Function which gets called to check if the channel status
  /// contain in the filter
  bool? filterChannelStatus(Filter filter, {ChannelModel? channel}) {
    final filterList = filter.value as List;
    final filterType = filterList
        .firstWhereOrNull((filter) => filter.key == 'status') as Filter?;
    if (channel == null) return false;
    if (filterType == null) return true;
    final passedFilter =
        (filterType.value as List).contains(channel.extraData['status']) ==
            true;
    return passedFilter;
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
    StreamChannelListController controller, {
    Filter? filter,
  }) {
    onChannelVisible(event, controller, filter: filter);
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
    StreamChannelListController controller, {
    Filter? filter,
  }) {
    onChannelVisible(event, controller, filter: filter);
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
    StreamChannelListController controller, {
    Filter? filter,
  }) {
    onChannelVisible(event, controller, filter: filter);
  }

  /// Function which gets called for the event
  /// 'user.presence.changed' and [EventType.userUpdated].
  ///
  /// This event is fired when a user's presence changes or gets updated.
  ///
  /// By default, this updates the channel member with the event user.
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
}

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter/src/v4/channel_list_view/stream_channel_list_controller.dart';
import 'package:stream_chat_flutter/src/v4/channel_list_view/stream_channel_list_event_handler.dart'
    as event_handler;

/// Contains methods that are called for certain [Event]s. These methods are
/// called from the [StreamChannelListController].
///
/// This class can be mixed in or extended to create custom overrides.
class ChannelEvents {
  /// Function which gets called for the event
  /// [EventType.channelDeleted].
  ///
  /// By default, calls [event_handler.onChannelDeleted]
  /// with the [Event] and the [StreamChannelListController].
  void onChannelDeleted(Event event, StreamChannelListController controller) {
    event_handler.onChannelDeleted(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.channelHidden].
  ///
  /// By default, calls [event_handler.onChannelHidden]
  /// with the [Event] and the [StreamChannelListController].
  void onChannelHidden(Event event, StreamChannelListController controller) {
    event_handler.onChannelHidden(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.channelTruncated].
  ///
  /// By default, calls [event_handler.onChannelTruncated]
  /// with the [Event] and the [StreamChannelListController].
  void onChannelTruncated(Event event, StreamChannelListController controller) {
    event_handler.onChannelTruncated(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.channelUpdated].
  ///
  /// By default, calls [event_handler.onChannelUpdated]
  /// with the [Event] and the [StreamChannelListController].
  void onChannelUpdated(Event event, StreamChannelListController controller) {
    event_handler.onChannelUpdated(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.channelVisible].
  ///
  /// By default, calls [event_handler.onChannelVisible]
  /// with the [Event] and the [StreamChannelListController].
  void onChannelVisible(Event event, StreamChannelListController controller) {
    event_handler.onChannelVisible(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.connectionRecovered].
  ///
  /// By default, calls [event_handler.onConnectionRecovered]
  /// with the [Event] and the [StreamChannelListController].
  void onConnectionRecovered(
    Event event,
    StreamChannelListController controller,
  ) {
    event_handler.onConnectionRecovered(event, controller);
  }

  /// Function which gets called for the event [EventType.messageNew].
  ///
  /// By default, calls [event_handler.onMessageNew]
  /// with the [Event] and the [StreamChannelListController].
  void onMessageNew(Event event, StreamChannelListController controller) {
    event_handler.onMessageNew(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.notificationAddedToChannel].
  ///
  /// By default, calls [event_handler.onNotificationAddedToChannel]
  /// with the [Event] and the [StreamChannelListController].
  void onNotificationAddedToChannel(
    Event event,
    StreamChannelListController controller,
  ) {
    event_handler.onNotificationAddedToChannel(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.notificationMessageNew].
  ///
  /// By default, calls [event_handler.onNotificationMessageNew]
  /// with the [Event] and the [StreamChannelListController].
  void onNotificationMessageNew(
    Event event,
    StreamChannelListController controller,
  ) {
    event_handler.onNotificationMessageNew(event, controller);
  }

  /// Function which gets called for the event
  /// [EventType.notificationRemovedFromChannel].
  ///
  /// By default, calls [event_handler.onNotificationRemovedFromChannel]
  /// with the [Event] and the [StreamChannelListController].
  void onNotificationRemovedFromChannel(
    Event event,
    StreamChannelListController controller,
  ) {
    event_handler.onNotificationRemovedFromChannel(event, controller);
  }

  /// Function which gets called for the event
  /// 'user.presence.changed' and [EventType.userUpdated].
  ///
  /// By default, calls [event_handler.onUserPresenceChanged]
  /// with the [Event] and the [StreamChannelListController].
  void onUserPresenceChanged(
    Event event,
    StreamChannelListController controller,
  ) {
    event_handler.onUserPresenceChanged(event, controller);
  }
}

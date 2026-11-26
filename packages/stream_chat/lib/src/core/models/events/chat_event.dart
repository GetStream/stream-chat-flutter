import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart' show StreamEvent;

import '../../../../stream_chat.dart';

part 'chat_event.freezed.dart';

/// Something that happened in chat, such as a new message or a user starting
/// to type.
///
/// Every event has a [type], a [createdAt] time and the [custom] data it was
/// sent with. Each kind of event is its own class carrying the data that kind
/// of event has, such as [MessageNewEvent] with its message, so a listener can
/// match on the class:
///
/// ```dart
/// client.on<MessageNewEvent>().listen((event) {
///   print('${event.user?.name}: ${event.message.text}');
/// });
/// ```
///
/// An event the SDK does not model, including a custom event sent with
/// [StreamChatClient.sendEvent], arrives as an [UnknownEvent]. New kinds of
/// event can be added over time, so a `switch` over events needs a default
/// case.
///
/// See also:
///
///  * [StreamChatClient.on] and [Channel.on], which deliver events.
///  * [EventType], which names the type of each event.
abstract base class ChatEvent implements StreamEvent {
  /// Creates a [ChatEvent].
  const ChatEvent();

  /// The type of the event, such as [EventType.messageNew].
  String get type;

  /// When the event happened.
  DateTime get createdAt;

  /// The custom data the event was sent with.
  ///
  /// Empty when the event carries none.
  Map<String, Object?> get custom;

  /// Whether this client made the event rather than receiving it.
  ///
  /// False for the events received over the connection. True for the events the
  /// client emits itself, such as a [ConnectionChangedEvent] or a
  /// scheduled-message event for a change it has not heard back about yet, and
  /// by default for an event created in app code.
  bool get isLocal;
}

/// An event that belongs to a channel.
///
/// [Channel.on] delivers the ones whose [cid] names its channel.
base mixin HasCid on ChatEvent {
  /// The cid (`type:id`) of the channel the event belongs to.
  ///
  /// Null when the event does not belong to a channel.
  String? get cid;
}

/// An event that concerns a user, such as the sender of a new message.
base mixin HasUser on ChatEvent {
  /// The user the event concerns, as they are at the time of the event.
  User? get user;
}

/// An event that carries the channel it concerns.
base mixin HasChannel on ChatEvent {
  /// The channel as it is after the event.
  ChannelModel? get channel;
}

/// An event that carries the message it concerns.
base mixin HasMessage on ChatEvent {
  /// The message as it is after the event.
  Message? get message;
}

/// An event that carries a vote on a poll, and the poll.
base mixin HasPollVote on ChatEvent {
  /// The poll as it is after the event.
  Poll get poll;

  /// The vote as it is after the event.
  PollVote get pollVote;
}

/// An event that carries the current user.
base mixin HasOwnUser on ChatEvent {
  /// The current user after the event, including their mutes and unread
  /// counts.
  OwnUser get me;
}

/// An event that carries the current user's unread counts.
base mixin HasUnreadCounts on ChatEvent {
  /// The current user's total number of unread messages after the event.
  int? get totalUnreadCount;

  /// The number of channels with unread messages for the current user after
  /// the event.
  int? get unreadChannels;
}

/// An event that carries the current user's unread thread count.
base mixin HasUnreadThreadCount on ChatEvent {
  /// The number of threads with unread replies for the current user after the
  /// event.
  int? get unreadThreads;
}

/// An event that carries the member and message counts of its channel.
base mixin HasChannelCounts on ChatEvent {
  /// The number of members in the channel after the event.
  int? get channelMemberCount;

  /// The number of messages in the channel after the event.
  int? get channelMessageCount;
}

/// An event the SDK does not model.
///
/// Carries custom events sent with [StreamChatClient.sendEvent] and kinds of
/// event this version of the SDK has no class for. Match them by [type]:
///
/// ```dart
/// client.on<UnknownEvent>().where((event) => event.type == 'party_started');
/// ```
///
/// [Channel.on] delivers one to the channel it names. It leaves the client's
/// state as it was, and everything it carries beyond its [custom] data, such
/// as its channel or user, is in [rawData].
@freezed
final class UnknownEvent extends ChatEvent with _$UnknownEvent {
  /// Creates an [UnknownEvent] of the given [type].
  UnknownEvent({
    required this.type,
    this.rawData = const {},
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  /// The type of the event, such as a custom type sent with
  /// [StreamChatClient.sendEvent].
  @override
  final String type;

  /// The event as it was received, including the data the SDK does not model.
  @override
  final Map<String, Object?> rawData;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

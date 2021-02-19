import 'package:json_annotation/json_annotation.dart';

import '../models/read.dart';
import '../models/user.dart';
import 'channel_model.dart';
import 'member.dart';
import 'message.dart';

part 'channel_state.g.dart';

/// The class that contains the information about a command
@JsonSerializable()
class ChannelState {
  /// The channel to which this state belongs
  final ChannelModel channel;

  /// A paginated list of channel messages
  final List<Message> messages;

  /// A paginated list of channel members
  final List<Member> members;

  /// A paginated list of pinned messages
  final List<Message> pinnedMessages;

  /// The count of users watching the channel
  final int watcherCount;

  /// A paginated list of users watching the channel
  final List<User> watchers;

  /// The list of channel reads
  final List<Read> read;

  /// Constructor used for json serialization
  ChannelState({
    this.channel,
    this.messages = const [],
    this.members = const [],
    this.pinnedMessages = const [],
    this.watcherCount,
    this.watchers = const [],
    this.read = const [],
  });

  /// Create a new instance from a json
  static ChannelState fromJson(Map<String, dynamic> json) =>
      _$ChannelStateFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelStateToJson(this);

  /// Creates a copy of [ChannelState] with specified attributes overridden.
  ChannelState copyWith({
    ChannelModel channel,
    List<Message> messages,
    List<Member> members,
    List<Message> pinnedMessages,
    int watcherCount,
    List<User> watchers,
    List<Read> read,
  }) =>
      ChannelState(
        channel: channel ?? this.channel,
        messages: messages ?? this.messages,
        members: members ?? this.members,
        pinnedMessages: pinnedMessages ?? this.pinnedMessages,
        watcherCount: watcherCount ?? this.watcherCount,
        watchers: watchers ?? this.watchers,
        read: read ?? this.read,
      );
}

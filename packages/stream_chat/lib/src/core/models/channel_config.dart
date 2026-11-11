/// @docImport '../error/stream_chat_error.dart';
library;

import 'package:json_annotation/json_annotation.dart';
import 'chat_preferences.dart';
import 'command.dart';
import 'converters/duration_in_seconds_converter.dart';
import 'push_level.dart';

part 'channel_config.g.dart';

/// The class that contains the information about the configuration of a channel
@JsonSerializable()
class ChannelConfig {
  /// Constructor used for json serialization
  ChannelConfig({
    this.automod = 'flag',
    this.commands = const [],
    this.connectEvents = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.maxMessageLength = 0,
    this.messageRetention = '',
    this.mutes = false,
    this.reactions = false,
    this.readEvents = false,
    this.replies = false,
    this.search = false,
    this.polls = false,
    this.pushLevel,
    this.pushNotifications = true,
    this.chatPreferences,
    this.typingEvents = false,
    this.uploads = false,
    this.urlEnrichment = false,
    this.skipLastMsgUpdateForSystemMsgs = false,
    this.userMessageReminders = false,
    this.markMessagesPending = false,
    this.deliveryEvents = false,
    this.sharedLocations = false,
    this.scheduledMessagesMaxPerChannel,
    this.scheduledMessagesMaxPerUser,
    this.scheduledMessagesMinLeadTime,
    this.scheduledMessagesMaxLeadTime,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory ChannelConfig.fromJson(Map<String, dynamic> json) => _$ChannelConfigFromJson(json);

  /// Moderation configuration
  final String automod;

  /// List of available commands
  final List<Command> commands;

  /// True if the channel should send connect events
  final bool connectEvents;

  /// Date of channel creation
  final DateTime createdAt;

  /// Date of last channel update
  final DateTime updatedAt;

  /// Max channel message length
  final int maxMessageLength;

  /// Duration of message retention
  final String messageRetention;

  /// True if users can be muted
  final bool mutes;

  /// True if reaction are active for this channel
  final bool reactions;

  /// True if readEvents are active for this channel
  final bool readEvents;

  /// True if reply message are active for this channel
  final bool replies;

  /// True if it's possible to perform a search in this channel
  final bool search;

  /// True if polls are active for this channel
  final bool polls;

  /// The push level for this channel.
  ///
  /// Mutually exclusive with [chatPreferences] — when [chatPreferences] is set
  /// on the backend, the coarse level is cleared and vice versa.
  final PushLevel? pushLevel;

  /// True if this channel type supports push notifications.
  ///
  /// Channel-type feature flag. When `false`, push notifications are disabled
  /// for the entire channel type regardless of [pushLevel] or
  /// [chatPreferences].
  final bool pushNotifications;

  /// Granular per-category push preferences for this channel.
  ///
  /// Mutually exclusive with [pushLevel] — when set, takes precedence over
  /// the coarse level.
  final ChatPreferences? chatPreferences;

  /// True if typing events should be sent for this channel
  final bool typingEvents;

  /// True if it's possible to upload files to this channel
  final bool uploads;

  /// True if urls appears as attachments
  final bool urlEnrichment;

  /// If true the last message at date will not be updated when a system message
  /// is added.
  ///
  /// This is useful for scenarios where you want to track the last time a user
  /// message was added to the channel.
  final bool skipLastMsgUpdateForSystemMsgs;

  /// True if the user can set reminders for messages in this channel.
  final bool userMessageReminders;

  /// Whether pending messages are enabled for this channel.
  final bool markMessagesPending;

  /// Whether delivery events are enabled for this channel.
  final bool deliveryEvents;

  /// True if shared locations are enabled for this channel.
  final bool sharedLocations;

  /// The limit on the current user's scheduled messages in each channel.
  ///
  /// Only scheduled and sending ones count toward it.
  ///
  /// Null when scheduled messages are not enabled.
  final int? scheduledMessagesMaxPerChannel;

  /// The limit on the current user's scheduled messages across all channels.
  ///
  /// Only scheduled and sending ones count toward it.
  ///
  /// Null when scheduled messages are not enabled.
  final int? scheduledMessagesMaxPerUser;

  /// The least time ahead of now a message is scheduled for.
  ///
  /// A sooner time is moved to the first whole minute at least this far ahead.
  ///
  /// Null when scheduled messages are not enabled.
  @JsonKey(name: 'scheduled_messages_min_lead_time_seconds')
  @DurationInSecondsConverter()
  final Duration? scheduledMessagesMinLeadTime;

  /// The most time ahead of now a message can be scheduled for.
  ///
  /// A later time is refused with
  /// [ScheduledMessageErrorReason.scheduledAtTooFar].
  ///
  /// Null when scheduled messages are not enabled.
  @JsonKey(name: 'scheduled_messages_max_lead_time_seconds')
  @DurationInSecondsConverter()
  final Duration? scheduledMessagesMaxLeadTime;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelConfigToJson(this);
}

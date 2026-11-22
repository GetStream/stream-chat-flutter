/// @docImport '../error/stream_chat_exception.dart';
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../db/data_serializable.dart';
import 'chat_preferences.dart';
import 'command.dart';
import 'converters/duration_in_seconds_converter.dart';
import 'push_level.dart';

part 'channel_config.freezed.dart';
part 'channel_config.g.dart';

/// The class that contains the information about the configuration of a channel
@freezed
// TODO(openapi-migration): remove in group 10
@DataSerializable()
class ChannelConfig with _$ChannelConfig {
  /// Creates a channel configuration.
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

  /// Creates a [ChannelConfig] from the offline-database format written by
  /// [toData].
  ///
  /// It is not a codec for API payloads.
  factory ChannelConfig.fromData(Map<String, dynamic> json) => _$ChannelConfigFromJson(json);

  /// Moderation configuration
  @override
  final String automod;

  /// List of available commands
  @override
  final List<Command> commands;

  /// True if the channel should send connect events
  @override
  final bool connectEvents;

  /// Date of channel creation
  @override
  final DateTime createdAt;

  /// Date of last channel update
  @override
  final DateTime updatedAt;

  /// Max channel message length
  @override
  final int maxMessageLength;

  /// Duration of message retention
  @override
  final String messageRetention;

  /// True if users can be muted
  @override
  final bool mutes;

  /// True if reaction are active for this channel
  @override
  final bool reactions;

  /// True if readEvents are active for this channel
  @override
  final bool readEvents;

  /// True if reply message are active for this channel
  @override
  final bool replies;

  /// True if it's possible to perform a search in this channel
  @override
  final bool search;

  /// True if polls are active for this channel
  @override
  final bool polls;

  /// The push level for this channel.
  ///
  /// Mutually exclusive with [chatPreferences] — when [chatPreferences] is set,
  /// the coarse level is cleared and vice versa.
  @override
  final PushLevel? pushLevel;

  /// True if this channel type supports push notifications.
  ///
  /// Channel-type feature flag. When `false`, push notifications are disabled
  /// for the entire channel type regardless of [pushLevel] or
  /// [chatPreferences].
  @override
  final bool pushNotifications;

  /// Granular per-category push preferences for this channel.
  ///
  /// Mutually exclusive with [pushLevel] — when set, takes precedence over
  /// the coarse level.
  @override
  final ChatPreferences? chatPreferences;

  /// True if typing events should be sent for this channel
  @override
  final bool typingEvents;

  /// True if it's possible to upload files to this channel
  @override
  final bool uploads;

  /// True if urls appears as attachments
  @override
  final bool urlEnrichment;

  /// If true the last message at date will not be updated when a system message
  /// is added.
  ///
  /// This is useful for scenarios where you want to track the last time a user
  /// message was added to the channel.
  @override
  final bool skipLastMsgUpdateForSystemMsgs;

  /// True if the user can set reminders for messages in this channel.
  @override
  final bool userMessageReminders;

  /// Whether pending messages are enabled for this channel.
  @override
  final bool markMessagesPending;

  /// Whether delivery events are enabled for this channel.
  @override
  final bool deliveryEvents;

  /// True if shared locations are enabled for this channel.
  @override
  final bool sharedLocations;

  /// The limit on the current user's scheduled messages in each channel.
  ///
  /// Only scheduled and sending ones count toward it.
  ///
  /// Null when scheduled messages are not enabled.
  @override
  final int? scheduledMessagesMaxPerChannel;

  /// The limit on the current user's scheduled messages across all channels.
  ///
  /// Only scheduled and sending ones count toward it.
  ///
  /// Null when scheduled messages are not enabled.
  @override
  final int? scheduledMessagesMaxPerUser;

  /// The least time ahead of now a message is scheduled for.
  ///
  /// A sooner time is moved to the first whole minute at least this far ahead.
  ///
  /// Null when scheduled messages are not enabled.
  @override
  @JsonKey(name: 'scheduled_messages_min_lead_time_seconds')
  @DurationInSecondsConverter()
  final Duration? scheduledMessagesMinLeadTime;

  /// The most time ahead of now a message can be scheduled for.
  ///
  /// A later time is refused with
  /// [ScheduledMessageErrorReason.scheduledAtTooFar].
  ///
  /// Null when scheduled messages are not enabled.
  @override
  @JsonKey(name: 'scheduled_messages_max_lead_time_seconds')
  @DurationInSecondsConverter()
  final Duration? scheduledMessagesMaxLeadTime;

  /// Serializes this configuration to the format `stream_chat_persistence`
  /// stores.
  ///
  /// It is not a codec for API payloads.
  Map<String, dynamic> toData() => _$ChannelConfigToJson(this);
}

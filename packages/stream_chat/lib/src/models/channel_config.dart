import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/command.dart';
part 'channel_config.g.dart';

/// The class that contains the information about the configuration of a channel
@JsonSerializable()
class ChannelConfig {
  /// Constructor used for json serialization
  ChannelConfig({
    this.automod,
    this.commands,
    this.connectEvents,
    this.createdAt,
    this.updatedAt,
    this.maxMessageLength,
    this.messageRetention,
    this.mutes,
    this.name,
    this.reactions,
    this.readEvents,
    this.replies,
    this.search,
    this.typingEvents,
    this.uploads,
    this.urlEnrichment,
  });

  /// Create a new instance from a json
  factory ChannelConfig.fromJson(Map<String, dynamic> json) =>
      _$ChannelConfigFromJson(json);

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

  /// Name of the channel
  final String name;

  /// True if reaction are active for this channel
  final bool reactions;

  /// True if readEvents are active for this channel
  final bool readEvents;

  /// True if reply message are active for this channel
  final bool replies;

  /// True if it's possible to perform a search in this channel
  final bool search;

  /// True if typing events should be sent for this channel
  final bool typingEvents;

  /// True if it's possible to upload files to this channel
  final bool uploads;

  /// True if urls appears as attachments
  final bool urlEnrichment;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelConfigToJson(this);
}

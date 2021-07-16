import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/command.dart';

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
    this.typingEvents = false,
    this.uploads = false,
    this.urlEnrichment = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory ChannelConfig.fromJson(Map<String, dynamic> json) =>
      _$ChannelConfigFromJson(json);

  /// Moderation configuration
  @JsonKey(defaultValue: 'flag')
  final String automod;

  /// List of available commands
  @JsonKey(defaultValue: [])
  final List<Command> commands;

  /// True if the channel should send connect events
  @JsonKey(defaultValue: false)
  final bool connectEvents;

  /// Date of channel creation
  final DateTime createdAt;

  /// Date of last channel update
  final DateTime updatedAt;

  /// Max channel message length
  @JsonKey(defaultValue: 0)
  final int maxMessageLength;

  /// Duration of message retention
  @JsonKey(defaultValue: '')
  final String messageRetention;

  /// True if users can be muted
  @JsonKey(defaultValue: false)
  final bool mutes;

  /// True if reaction are active for this channel
  @JsonKey(defaultValue: false)
  final bool reactions;

  /// True if readEvents are active for this channel
  @JsonKey(defaultValue: false)
  final bool readEvents;

  /// True if reply message are active for this channel
  @JsonKey(defaultValue: false)
  final bool replies;

  /// True if it's possible to perform a search in this channel
  @JsonKey(defaultValue: false)
  final bool search;

  /// True if typing events should be sent for this channel
  @JsonKey(defaultValue: false)
  final bool typingEvents;

  /// True if it's possible to upload files to this channel
  @JsonKey(defaultValue: false)
  final bool uploads;

  /// True if urls appears as attachments
  @JsonKey(defaultValue: false)
  final bool urlEnrichment;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelConfigToJson(this);
}

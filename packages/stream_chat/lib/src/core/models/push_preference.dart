import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_preference.g.dart';

/// Chat level push preference type
enum ChatLevelPushPreference {
  /// All messages
  @JsonValue('all')
  all,

  /// No messages
  @JsonValue('none')
  none,

  /// Only mentions
  @JsonValue('mentions')
  mentions,

  /// Use default system setting
  @JsonValue('default')
  defaultValue,
}

/// Call level push preference type
enum CallLevelPushPreference {
  /// All calls
  @JsonValue('all')
  all,

  /// No calls
  @JsonValue('none')
  none,

  /// Use default system setting
  @JsonValue('default')
  defaultValue,
}

/// Input for push preferences, used for creating or updating preferences
/// for a user or a specific channel.
@JsonSerializable(createFactory: false, includeIfNull: false)
class PushPreferenceInput {
  /// Creates a new push preference input
  const PushPreferenceInput({
    this.callLevel,
    this.chatLevel,
    this.disabledUntil,
    this.removeDisable,
  }) : channelCid = null;

  /// Creates a new push preference input for a specific channel
  /// with the given [channelCid].
  const PushPreferenceInput.channel({
    required String this.channelCid,
    this.callLevel,
    this.chatLevel,
    this.disabledUntil,
    this.removeDisable,
  });

  /// If not null, creates a push preference for a specific channel
  final String? channelCid;

  /// Push preference for calls
  final CallLevelPushPreference? callLevel;

  /// Push preference for chat messages
  final ChatLevelPushPreference? chatLevel;

  /// Disabled until this date (snooze functionality)
  final DateTime? disabledUntil;

  /// Temporary flag for resetting disabledUntil
  final bool? removeDisable;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$PushPreferenceInputToJson(this);
}

/// The class that contains push preferences for a user
@JsonSerializable(includeIfNull: false)
class PushPreference extends Equatable {
  const PushPreference({
    this.callLevel,
    this.chatLevel,
    this.disabledUntil,
  });

  /// Create a new instance from a json
  factory PushPreference.fromJson(Map<String, dynamic> json) =>
      _$PushPreferenceFromJson(json);

  /// Push preference for calls
  final CallLevelPushPreference? callLevel;

  /// Push preference for chat messages
  final ChatLevelPushPreference? chatLevel;

  /// Disabled until this date (snooze functionality)
  final DateTime? disabledUntil;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$PushPreferenceToJson(this);

  @override
  List<Object?> get props => [callLevel, chatLevel, disabledUntil];
}

/// The class that contains push preferences for a specific channel
@JsonSerializable(includeIfNull: false)
class ChannelPushPreference extends Equatable {
  const ChannelPushPreference({
    this.chatLevel,
    this.disabledUntil,
  });

  /// Create a new instance from a json
  factory ChannelPushPreference.fromJson(Map<String, dynamic> json) =>
      _$ChannelPushPreferenceFromJson(json);

  /// Push preference for chat messages
  final ChatLevelPushPreference? chatLevel;

  /// Disabled until this date (snooze functionality)
  final DateTime? disabledUntil;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$ChannelPushPreferenceToJson(this);

  @override
  List<Object?> get props => [chatLevel, disabledUntil];
}

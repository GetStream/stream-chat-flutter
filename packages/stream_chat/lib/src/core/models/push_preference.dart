import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_preference.g.dart';

/// Chat level push preference type
extension type const ChatLevel(String rawType) implements String {
  /// All messages
  static const all = ChatLevel('all');

  /// No messages
  static const none = ChatLevel('none');

  /// Only mentions
  static const mentions = ChatLevel('mentions');

  /// Use default system setting
  static const defaultValue = ChatLevel('default');
}

/// Call level push preference type
extension type const CallLevel(String rawType) implements String {
  /// All calls
  static const all = CallLevel('all');

  /// No calls
  static const none = CallLevel('none');

  /// Use default system setting
  static const defaultValue = CallLevel('default');
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
  final CallLevel? callLevel;

  /// Push preference for chat messages
  final ChatLevel? chatLevel;

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
  /// Creates a new push preference instance
  const PushPreference({
    this.callLevel,
    this.chatLevel,
    this.disabledUntil,
  });

  /// Create a new instance from a json
  factory PushPreference.fromJson(Map<String, dynamic> json) =>
      _$PushPreferenceFromJson(json);

  /// Push preference for calls
  final CallLevel? callLevel;

  /// Push preference for chat messages
  final ChatLevel? chatLevel;

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
  /// Creates a new channel push preference instance
  const ChannelPushPreference({
    this.chatLevel,
    this.disabledUntil,
  });

  /// Create a new instance from a json
  factory ChannelPushPreference.fromJson(Map<String, dynamic> json) =>
      _$ChannelPushPreferenceFromJson(json);

  /// Push preference for chat messages
  final ChatLevel? chatLevel;

  /// Disabled until this date (snooze functionality)
  final DateTime? disabledUntil;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$ChannelPushPreferenceToJson(this);

  @override
  List<Object?> get props => [chatLevel, disabledUntil];
}

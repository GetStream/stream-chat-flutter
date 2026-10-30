import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'chat_preferences.dart';

part 'push_preference.g.dart';

/// Chat level push preference type
extension type const ChatLevel(String _) implements String {
  /// All messages
  static const all = ChatLevel('all');

  /// Only direct or indirect mentions
  /// (`@username`, `@channel`, `@here`, group, or role).
  static const allMentions = ChatLevel('all_mentions');

  /// Only direct mentions (`@username`).
  static const directMentions = ChatLevel('direct_mentions');

  /// Only mentions
  @Deprecated('Use directMentions instead')
  static const mentions = ChatLevel('mentions');

  /// No messages
  static const none = ChatLevel('none');

  /// Fall through to the next preference tier
  /// (member → user → channel config).
  static const defaultValue = ChatLevel('default');
}

/// Call level push preference type
extension type const CallLevel(String _) implements String {
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
    this.chatPreferences,
    this.disabledUntil,
    this.removeDisable,
    this.schedule,
    this.removeSchedule,
  }) : channelCid = null;

  /// Creates a new push preference input for a specific channel
  /// with the given [channelCid].
  const PushPreferenceInput.channel({
    required String this.channelCid,
    this.callLevel,
    this.chatLevel,
    this.chatPreferences,
    this.disabledUntil,
    this.removeDisable,
  }) : schedule = null,
       removeSchedule = null;

  /// If not null, creates a push preference for a specific channel
  final String? channelCid;

  /// Push preference for calls
  final CallLevel? callLevel;

  /// Push preference for chat messages
  final ChatLevel? chatLevel;

  /// Granular per-category push preferences for chat messages.
  ///
  /// Mutually exclusive with [chatLevel].
  final ChatPreferences? chatPreferences;

  /// Disabled until this date (snooze functionality)
  final DateTime? disabledUntil;

  /// Temporary flag for resetting disabledUntil
  final bool? removeDisable;

  /// Recurring quiet hours that replace the user's current schedule.
  ///
  /// Cannot be set together with [disabledUntil] on the same input, and is
  /// always null for a channel input.
  final PushSchedule? schedule;

  /// Whether to clear the user's quiet-hours schedule.
  ///
  /// Always null for a channel input.
  final bool? removeSchedule;

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
    this.chatPreferences,
    this.disabledUntil,
    this.schedule,
  });

  /// Create a new instance from a json
  factory PushPreference.fromJson(Map<String, dynamic> json) => _$PushPreferenceFromJson(json);

  /// Push preference for calls
  final CallLevel? callLevel;

  /// Push preference for chat messages
  final ChatLevel? chatLevel;

  /// Granular per-category push preferences for chat messages.
  ///
  /// Mutually exclusive with [chatLevel].
  final ChatPreferences? chatPreferences;

  /// Disabled until this date (snooze functionality)
  final DateTime? disabledUntil;

  /// Recurring quiet hours during which the user gets no push notifications.
  final PushSchedule? schedule;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$PushPreferenceToJson(this);

  @override
  List<Object?> get props => [callLevel, chatLevel, chatPreferences, disabledUntil, schedule];
}

/// The class that contains push preferences for a specific channel
@JsonSerializable(includeIfNull: false)
class ChannelPushPreference extends Equatable {
  /// Creates a new channel push preference instance
  const ChannelPushPreference({
    this.chatLevel,
    this.chatPreferences,
    this.disabledUntil,
  });

  /// Create a new instance from a json
  factory ChannelPushPreference.fromJson(Map<String, dynamic> json) => _$ChannelPushPreferenceFromJson(json);

  /// Push preference for chat messages
  final ChatLevel? chatLevel;

  /// Granular per-category push preferences for chat messages.
  ///
  /// Mutually exclusive with [chatLevel].
  final ChatPreferences? chatPreferences;

  /// Disabled until this date (snooze functionality)
  final DateTime? disabledUntil;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$ChannelPushPreferenceToJson(this);

  @override
  List<Object?> get props => [chatLevel, chatPreferences, disabledUntil];
}

/// Recurring quiet hours during which a user gets no push notifications.
///
/// Notifications that fall inside a quiet window are dropped, not delayed.
@JsonSerializable(includeIfNull: false)
class PushSchedule extends Equatable {
  /// Creates quiet hours in [timezone] from one or more [quietHours] rules.
  const PushSchedule({
    required this.timezone,
    required this.quietHours,
  });

  /// Creates a [PushSchedule] from [json].
  factory PushSchedule.fromJson(Map<String, dynamic> json) => _$PushScheduleFromJson(json);

  /// The IANA time zone the rules are read in, such as `Europe/Amsterdam`.
  ///
  /// Fixed offsets such as `+02:00` are not accepted.
  final String timezone;

  /// The quiet windows, from one to seven rules.
  ///
  /// Notifications are silenced while any rule is active.
  final List<QuietHoursRule> quietHours;

  /// Serializes this to JSON.
  Map<String, dynamic> toJson() => _$PushScheduleToJson(this);

  @override
  List<Object?> get props => [timezone, quietHours];
}

/// A daily quiet window from [start] to [end], on the given [days].
///
/// Times are 24-hour `HH:mm` in the schedule's time zone. A window belongs to
/// the day it opens on: a Friday rule from `22:00` to `07:00` lasts until
/// Saturday morning.
@JsonSerializable(includeIfNull: false)
class QuietHoursRule extends Equatable {
  /// Creates a quiet window from [start] to [end] on [days].
  const QuietHoursRule({
    required this.start,
    required this.end,
    this.days = const [],
  });

  /// Creates a [QuietHoursRule] from [json].
  factory QuietHoursRule.fromJson(Map<String, dynamic> json) => _$QuietHoursRuleFromJson(json);

  /// When the window opens, from `00:00` to `23:59`.
  final String start;

  /// When the window closes, from `00:00` to `24:00`, and never equal to
  /// [start].
  ///
  /// The window ends just before [end], so `24:00` runs to the end of the day.
  /// An [end] earlier than [start] wraps past midnight.
  final String end;

  /// The days the window opens on, or every day when empty.
  @JsonKey(defaultValue: <QuietHoursDay>[])
  final List<QuietHoursDay> days;

  /// Serializes this to JSON.
  Map<String, dynamic> toJson() => _$QuietHoursRuleToJson(this);

  @override
  List<Object?> get props => [start, end, days];
}

/// A day of the week a [QuietHoursRule] opens on.
extension type const QuietHoursDay(String _) implements String {
  /// Monday.
  static const monday = QuietHoursDay('mon');

  /// Tuesday.
  static const tuesday = QuietHoursDay('tue');

  /// Wednesday.
  static const wednesday = QuietHoursDay('wed');

  /// Thursday.
  static const thursday = QuietHoursDay('thu');

  /// Friday.
  static const friday = QuietHoursDay('fri');

  /// Saturday.
  static const saturday = QuietHoursDay('sat');

  /// Sunday.
  static const sunday = QuietHoursDay('sun');

  /// Every day of the week, from Monday to Sunday.
  static const values = [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
}

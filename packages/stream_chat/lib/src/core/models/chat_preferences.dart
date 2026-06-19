import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_preferences.g.dart';

/// Per-category preference value used inside [ChatPreferences].
///
/// A category left unset (omitted from the JSON payload) falls back to
/// [ChatPreferences.defaultPreference].
extension type const ChatPreferenceLevel(String rawType) implements String {
  /// Always send a push notification for this category.
  static const all = ChatPreferenceLevel('all');

  /// Never send a push notification for this category.
  static const none = ChatPreferenceLevel('none');
}

/// Granular push-notification preferences split by mention category.
///
/// Set on a [ChannelConfig], a user-level push preference, or a per-channel
/// push preference. Mutually exclusive with the coarse `chatLevel` /
/// `pushLevel` field at the same tier — setting one clears the other on the
/// backend.
@JsonSerializable(includeIfNull: false)
class ChatPreferences extends Equatable {
  /// Creates a new chat preferences instance.
  const ChatPreferences({
    this.channelMentions,
    this.defaultPreference,
    this.directMentions,
    this.groupMentions,
    this.hereMentions,
    this.roleMentions,
    this.threadReplies,
  });

  /// Create a new instance from a json
  factory ChatPreferences.fromJson(Map<String, dynamic> json) => _$ChatPreferencesFromJson(json);

  /// Preference for `@channel` mentions.
  final ChatPreferenceLevel? channelMentions;

  /// Baseline preference applied when no category-specific value matches.
  final ChatPreferenceLevel? defaultPreference;

  /// Preference for direct mentions (`@username`).
  final ChatPreferenceLevel? directMentions;

  /// Preference for group mentions.
  final ChatPreferenceLevel? groupMentions;

  /// Preference for `@here` mentions.
  final ChatPreferenceLevel? hereMentions;

  /// Preference for role mentions.
  final ChatPreferenceLevel? roleMentions;

  /// Preference for thread replies.
  final ChatPreferenceLevel? threadReplies;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$ChatPreferencesToJson(this);

  @override
  List<Object?> get props => [
    channelMentions,
    defaultPreference,
    directMentions,
    groupMentions,
    hereMentions,
    roleMentions,
    threadReplies,
  ];
}

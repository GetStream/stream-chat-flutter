import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'privacy_settings.g.dart';

/// The privacy settings of the current user.
@JsonSerializable()
class PrivacySettings extends Equatable {
  /// Create a new instance of [PrivacySettings].
  const PrivacySettings(
    this.typingIndicators,
    this.readReceipts,
  );

  /// Create a new instance from json.
  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return _$PrivacySettingsFromJson(json);
  }

  /// The settings for typing indicator events.
  final TypingIndicatorPrivacySettings? typingIndicators;

  /// The settings for the read receipt events.
  final ReadReceiptsPrivacySettings? readReceipts;

  @override
  List<Object?> get props => [typingIndicators, readReceipts];
}

/// The settings for typing indicator events.
@JsonSerializable()
class TypingIndicatorPrivacySettings extends Equatable {
  /// Create a new instance of [TypingIndicatorPrivacySettings].
  const TypingIndicatorPrivacySettings({
    this.enabled = true,
  });

  /// Create a new instance from json.
  factory TypingIndicatorPrivacySettings.fromJson(Map<String, dynamic> json) {
    return _$TypingIndicatorPrivacySettingsFromJson(json);
  }

  /// Whether the typing indicator events are enabled for the user.
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

/// The settings for the read receipt events.
@JsonSerializable()
class ReadReceiptsPrivacySettings extends Equatable {
  /// Create a new instance of [ReadReceiptsPrivacySettings].
  const ReadReceiptsPrivacySettings({
    this.enabled = true,
  });

  /// Create a new instance from json.
  factory ReadReceiptsPrivacySettings.fromJson(Map<String, dynamic> json) {
    return _$ReadReceiptsPrivacySettingsFromJson(json);
  }

  /// Whether the read receipt events are enabled for the user.
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

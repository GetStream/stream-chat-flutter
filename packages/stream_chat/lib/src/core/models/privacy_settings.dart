import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'privacy_settings.g.dart';

/// The privacy settings of the current user.
@JsonSerializable(includeIfNull: false)
class PrivacySettings extends Equatable {
  /// Create a new instance of [PrivacySettings].
  const PrivacySettings({
    this.typingIndicators,
    this.readReceipts,
    this.deliveryReceipts,
  });

  /// Create a new instance from json.
  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return _$PrivacySettingsFromJson(json);
  }

  /// The settings for typing indicator events.
  final TypingIndicators? typingIndicators;

  /// The settings for the read receipt events.
  final ReadReceipts? readReceipts;

  /// The settings for the delivery receipt events.
  final DeliveryReceipts? deliveryReceipts;

  /// Serialize to json.
  Map<String, dynamic> toJson() => _$PrivacySettingsToJson(this);

  @override
  List<Object?> get props => [typingIndicators, readReceipts, deliveryReceipts];
}

/// The settings for typing indicator events.
@JsonSerializable(includeIfNull: false)
class TypingIndicators extends Equatable {
  /// Create a new instance of [TypingIndicators].
  const TypingIndicators({
    this.enabled = true,
  });

  /// Create a new instance from json.
  factory TypingIndicators.fromJson(Map<String, dynamic> json) {
    return _$TypingIndicatorsFromJson(json);
  }

  /// Whether the typing indicator events are enabled for the user.
  ///
  /// If False, the user typing events will not be sent to other users.
  final bool enabled;

  /// Serialize to json.
  Map<String, dynamic> toJson() => _$TypingIndicatorsToJson(this);

  @override
  List<Object?> get props => [enabled];
}

/// The settings for the read receipt events.
@JsonSerializable(includeIfNull: false)
class ReadReceipts extends Equatable {
  /// Create a new instance of [ReadReceipts].
  const ReadReceipts({
    this.enabled = true,
  });

  /// Create a new instance from json.
  factory ReadReceipts.fromJson(Map<String, dynamic> json) {
    return _$ReadReceiptsFromJson(json);
  }

  /// Whether the read receipt events are enabled for the user.
  ///
  /// If False, the user read events will not be sent to other users, along
  /// with the user's read state.
  final bool enabled;

  /// Serialize to json.
  Map<String, dynamic> toJson() => _$ReadReceiptsToJson(this);

  @override
  List<Object?> get props => [enabled];
}

/// The settings for the delivery receipt events.
@JsonSerializable(includeIfNull: false)
class DeliveryReceipts extends Equatable {
  /// Create a new instance of [DeliveryReceipts].
  const DeliveryReceipts({
    this.enabled = true,
  });

  /// Create a new instance from json.
  factory DeliveryReceipts.fromJson(Map<String, dynamic> json) {
    return _$DeliveryReceiptsFromJson(json);
  }

  /// Whether the delivery receipt events are enabled for the user.
  ///
  /// If False, the user delivery events will not be sent to other users, along
  /// with the user's delivery state.
  final bool enabled;

  /// Serialize to json.
  Map<String, dynamic> toJson() => _$DeliveryReceiptsToJson(this);

  @override
  List<Object?> get props => [enabled];
}

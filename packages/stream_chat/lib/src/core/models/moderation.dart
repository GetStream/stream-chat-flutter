import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moderation.g.dart';

/// {@template moderation}
/// Model holding data for a message moderated by Moderation V1-V2.
/// {@endtemplate}
@JsonSerializable()
class Moderation extends Equatable {
  /// {@macro moderation}
  const Moderation({
    required this.action,
    required this.originalText,
    this.textHarms,
    this.imageHarms,
    this.blocklistMatched,
    this.semanticFilterMatched,
    this.platformCircumvented = false,
  });

  /// Create a new instance from a json
  factory Moderation.fromJson(Map<String, dynamic> json) =>
      _$ModerationFromJson(json);

  /// The action taken by the moderation system.
  @JsonKey(
    toJson: ModerationAction.toJson,
    fromJson: ModerationAction.fromJson,
  )
  final ModerationAction action;

  /// The original text of the message.
  final String originalText;

  /// The list of harmful text detected in the message.
  final List<String>? textHarms;

  /// The list of harmful images detected in the message.
  final List<String>? imageHarms;

  /// The blocklist matched by the message.
  final String? blocklistMatched;

  /// The semantic filter matched by the message.
  final String? semanticFilterMatched;

  /// true/false if the message triggered the platform circumvention model.
  final bool platformCircumvented;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ModerationToJson(this);

  @override
  List<Object?> get props => [
        action,
        originalText,
        textHarms,
        imageHarms,
        blocklistMatched,
        semanticFilterMatched,
        platformCircumvented,
      ];
}

/// The moderation action performed over the message.
extension type const ModerationAction(String action) implements String {
  /// Action 'bounce' - the message needs to be rephrased and sent again.
  static const ModerationAction bounce = ModerationAction('bounce');

  /// Action 'flag' - the message was sent for review in the dashboard but was
  /// still published.
  static const ModerationAction flag = ModerationAction('flag');

  /// Action 'remove' - the message was removed by moderation policies.
  static const ModerationAction remove = ModerationAction('remove');

  /// Action 'shadow' - the message was filtered but still visible to the
  /// sender.
  static const ModerationAction shadow = ModerationAction('shadow');

  /// Create a new instance from a json string.
  static ModerationAction fromJson(String action) {
    return switch (action) {
      // Backward compatibility with v1 moderation actions.
      'MESSAGE_RESPONSE_ACTION_FLAG' => ModerationAction.flag,
      'MESSAGE_RESPONSE_ACTION_BOUNCE' => ModerationAction.bounce,
      'MESSAGE_RESPONSE_ACTION_BLOCK' => ModerationAction.remove,
      _ => ModerationAction(action),
    };
  }

  /// Serialize to json string.
  static String toJson(ModerationAction action) => action.action;
}

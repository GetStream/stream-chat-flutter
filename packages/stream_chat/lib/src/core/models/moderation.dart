import 'package:freezed_annotation/freezed_annotation.dart';

part 'moderation.freezed.dart';

/// The outcome of running a message through the moderation system.
@freezed
class Moderation with _$Moderation {
  /// Creates a new [Moderation].
  const Moderation({
    required this.action,
    required this.originalText,
    this.textHarms,
    this.imageHarms,
    this.blocklistMatched,
    this.semanticFilterMatched,
    this.platformCircumvented = false,
  });

  /// The action taken by the moderation system.
  @override
  final ModerationAction action;

  /// The original text of the message.
  @override
  final String originalText;

  /// The list of harmful text detected in the message.
  @override
  final List<String>? textHarms;

  /// The list of harmful images detected in the message.
  @override
  final List<String>? imageHarms;

  /// The blocklist matched by the message.
  @override
  final String? blocklistMatched;

  /// The semantic filter matched by the message.
  @override
  final String? semanticFilterMatched;

  /// Whether the message triggered the platform circumvention model.
  @override
  final bool platformCircumvented;
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

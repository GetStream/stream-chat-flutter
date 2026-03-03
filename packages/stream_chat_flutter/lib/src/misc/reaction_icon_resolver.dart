import 'package:flutter/material.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template reactionIconResolver}
/// Resolves reaction types to emoji codes and provides the list of
/// available reactions.
///
/// Consumers can query supported reactions, default quick-pick reactions,
/// and map reaction types to emoji characters — all from a single source
/// of truth.
/// {@endtemplate}
abstract class ReactionIconResolver {
  /// {@macro reactionIconResolver}
  const ReactionIconResolver();

  /// A small set of commonly used reaction types shown for quick
  /// access in the reaction picker bar.
  Set<String> get defaultReactions;

  /// All supported reaction types, in display order.
  ///
  /// Iteration order of this set is used as reaction display order in
  /// default components. Implementations should use a
  /// [LinkedHashSet] or equivalent to preserve insertion order.
  Set<String> get supportedReactions;

  /// Returns the emoji code for the given reaction [type], or null
  /// if the type is not supported.
  String? emojiCode(String type);

  /// Resolves the given reaction [type] into a widget for display.
  Widget resolve(BuildContext context, String type);
}

/// {@template defaultReactionIconResolver}
/// Default implementation of [ReactionIconResolver].
///
/// Uses [streamSupportedEmojis] from `stream_core_flutter` to resolve
/// reaction types to emoji characters.
///
/// Resolution chain for [resolve]:
/// 1. [emojiCode] lookup by type -> render as emoji text
/// 2. Fallback -> render type string as text
///
/// Override [buildEmojiReaction] to customize emoji rendering
/// (e.g., Twemoji images).
/// Override [buildFallbackReaction] to customize the fallback.
/// {@endtemplate}
class DefaultReactionIconResolver extends ReactionIconResolver {
  /// {@macro defaultReactionIconResolver}
  const DefaultReactionIconResolver();

  static const _defaultQuickReactions = {'like', 'haha', 'love', 'wow', 'sad'};

  @override
  Set<String> get defaultReactions => _defaultQuickReactions;

  @override
  Set<String> get supportedReactions => streamSupportedEmojis.keys.toSet();

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  Widget resolve(BuildContext context, String type) {
    if (emojiCode(type) case final emoji?) {
      return buildEmojiReaction(context, emoji);
    }

    return buildFallbackReaction(context, type);
  }

  /// Builds a widget for a resolved emoji character.
  @protected
  Widget buildEmojiReaction(BuildContext context, String emoji) => Text(emoji);

  /// Builds a fallback widget when no emoji could be resolved.
  @protected
  Widget buildFallbackReaction(BuildContext context, String type) => const Text('❓');
}

import 'package:stream_core_flutter/chat.dart';

/// Maps reaction type strings to [StreamEmojiContent] models.
///
/// [ReactionIconResolver] provides the set of supported and default reactions
/// and resolves each type into a content model that [StreamEmoji] can render.
/// The resolver returns pure data; the SDK owns rendering.
///
/// See also:
///
///  * [DefaultReactionIconResolver], the built-in implementation.
///  * [StreamEmojiContent], the sealed content model returned by [resolve].
///  * [StreamChatConfigurationData.reactionIconResolver], where the resolver
///    is configured.
abstract class ReactionIconResolver {
  /// Creates a [ReactionIconResolver].
  const ReactionIconResolver();

  /// A small set of commonly used reaction types shown for quick access
  /// in the reaction picker bar.
  Set<String> get defaultReactions;

  /// All supported reaction types, in display order.
  ///
  /// Iteration order is used as the reaction display order in default
  /// components. Implementations should use a [LinkedHashSet] or
  /// equivalent to preserve insertion order.
  Set<String> get supportedReactions;

  /// Returns the emoji code for the given reaction [type], or `null`
  /// if the type is not supported.
  String? emojiCode(String type);

  /// Resolves the given reaction [type] into a content model.
  ///
  /// Override to return [StreamImageEmoji] for custom emoji.
  StreamEmojiContent resolve(String type);
}

/// Default [ReactionIconResolver] backed by [streamSupportedEmojis].
///
/// {@tool snippet}
///
/// Use custom image emoji (e.g. Twemoji) by extending and overriding
/// [resolve]:
///
/// ```dart
/// class TwemojiReactionResolver extends DefaultReactionIconResolver {
///   @override
///   StreamEmojiContent resolve(String type) {
///     if (emojiCode(type) != null) {
///       return StreamImageEmoji(
///         url: Uri.parse('https://cdn.example.com/twemoji/$type.png'),
///       );
///     }
///     return super.resolve(type);
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ReactionIconResolver], the abstract contract.
///  * [streamSupportedEmojis], the emoji catalog used by this resolver.
class DefaultReactionIconResolver extends ReactionIconResolver {
  /// Creates a [DefaultReactionIconResolver].
  const DefaultReactionIconResolver();

  static const _defaultQuickReactions = {'like', 'haha', 'love', 'wow', 'sad'};

  @override
  Set<String> get defaultReactions => _defaultQuickReactions;

  @override
  Set<String> get supportedReactions => streamSupportedEmojis.keys.toSet();

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  StreamEmojiContent resolve(String type) {
    if (emojiCode(type) case final emoji?) {
      return StreamUnicodeEmoji(emoji);
    }

    return const StreamUnicodeEmoji('❓');
  }
}

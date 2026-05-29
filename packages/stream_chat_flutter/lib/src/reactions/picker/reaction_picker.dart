import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template onReactionPicked}
/// Callback called when a reaction is picked.
/// {@endtemplate}
typedef OnReactionPicked = ValueSetter<Reaction>;

/// {@template streamMessageReactionPicker}
/// A chat-specific reaction picker that bridges [StreamReactionPicker] with
/// chat domain models.
///
/// Resolves reaction icons via [ReactionIconResolver], tracks the current
/// user's own reactions on the [Message], and wires the "add reaction" button
/// to [StreamEmojiPickerSheet].
///
/// Visual customisation is controlled through [StreamReactionPickerTheme] in
/// the widget tree.
///
/// See also:
///
///  * [StreamReactionPicker], the domain-agnostic core picker.
///  * [ReactionIconResolver], which maps reaction types to emoji content models.
///  * [StreamReactionPickerTheme], for customising the picker appearance.
/// {@endtemplate}
class StreamMessageReactionPicker extends StatelessWidget {
  /// {@macro streamMessageReactionPicker}
  const StreamMessageReactionPicker({
    super.key,
    required this.message,
    this.onReactionPicked,
  });

  /// The message to attach the reaction to.
  final Message message;

  /// {@macro onReactionPicked}
  final OnReactionPicked? onReactionPicked;

  @override
  Widget build(BuildContext context) {
    final config = StreamChatConfiguration.of(context);
    final resolver = config.reactionIconResolver;
    final reactionTypes = resolver.defaultReactions;

    final ownReactions = [...?message.ownReactions];
    final ownReactionsMap = {for (final it in ownReactions) it.type: it};

    final items = [
      ...reactionTypes.map(
        (type) => StreamReactionPickerItem(
          key: type,
          emoji: resolver.resolve(type),
          // If the reaction is present in ownReactions, it is selected.
          isSelected: ownReactionsMap[type] != null,
        ),
      ),
    ];

    void onItemPicked(StreamReactionPickerItem item) {
      final reactionEmojiCode = resolver.emojiCode(item.key);
      final pickedReaction = switch (ownReactionsMap[item.key]) {
        final reaction? => reaction,
        _ => Reaction(type: item.key, emojiCode: reactionEmojiCode),
      };

      return onReactionPicked?.call(pickedReaction);
    }

    return StreamReactionPicker(
      items: items,
      onReactionPicked: onItemPicked,
      onAddReactionTap: () async {
        final selectedReactions = ownReactionsMap.keys.toSet();
        final supportedEmojis = resolver.supportedReactions.map((type) => streamSupportedEmojis[type]).nonNulls;
        final emoji = await StreamEmojiPickerSheet.show(
          context: context,
          emojis: supportedEmojis,
          selectedReactions: selectedReactions,
        );

        if (!context.mounted || emoji == null) return;

        final reaction = Reaction(type: emoji.shortName, emojiCode: emoji.emoji);
        return onReactionPicked?.call(reaction);
      },
    );
  }
}

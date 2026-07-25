import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template onReactionPicked}
/// Callback called when a reaction is picked.
/// {@endtemplate}
typedef OnReactionPicked = ValueSetter<Reaction>;

/// {@template onReactionSelected}
/// Callback called when a reaction is selected.
///
/// The provided [BuildContext] can be used for navigation or showing dialogs.
/// {@endtemplate}
typedef OnReactionSelected =
    void Function(
      BuildContext context,
      Reaction reaction,
    );

/// {@template streamMessageReactionPicker}
/// A chat-specific reaction picker that bridges [StreamReactionPicker] with
/// chat domain models.
///
/// Resolves reaction icons via [ReactionIconResolver], tracks the current
/// user's reactions on the [Message], and presents [StreamEmojiPickerSheet]
/// when the add reaction button is tapped.
///
/// The [onReactionSelected] callback provides the [BuildContext] associated
/// with the picker, allowing navigation or overlays to use the correct
/// navigator, especially in nested navigation scenarios.
///
/// Visual customization is controlled through
/// [StreamReactionPickerTheme] in the widget tree.
///
/// See also:
///
///  * [StreamReactionPicker], the domain-agnostic core picker.
///  * [ReactionIconResolver], which maps reaction types to emoji content models.
///  * [StreamReactionPickerTheme], for customizing the picker appearance.
/// {@endtemplate}
class StreamMessageReactionPicker extends StatelessWidget {
  /// {@macro streamMessageReactionPicker}
  const StreamMessageReactionPicker({
    super.key,
    required this.message,
    this.onReactionPicked,
    this.onReactionSelected,
  });

  /// The message to attach the reaction to.
  final Message message;

  /// {@macro onReactionPicked}
  @Deprecated(
    'Use onReactionSelected instead. '
    'onReactionSelected provides the BuildContext required for nested navigation.',
  )
  final OnReactionPicked? onReactionPicked;

  /// {@macro onReactionSelected}
  final OnReactionSelected? onReactionSelected;

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

      onReactionPicked?.call(pickedReaction);
      onReactionSelected?.call(context, pickedReaction);
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
        onReactionPicked?.call(reaction);
        onReactionSelected?.call(context, reaction);
      },
    );
  }
}

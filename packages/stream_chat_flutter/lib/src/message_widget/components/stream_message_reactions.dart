import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Displays reaction groups for a message as emoji chips overlaid on, or
/// placed beneath, the [child] widget.
///
/// Reaction icons are resolved through the
/// [StreamChatConfigurationData.reactionIconResolver]. Groups are sorted
/// using [sorting] (defaults to [ReactionSorting.byFirstReactionAt]).
///
/// See also:
///
///  * [StreamMessageScaffold], which hosts this widget around the bubble.
///  * [StreamChatConfigurationData.reactionIconResolver], which maps reaction
///    type strings to emoji content models.
class StreamMessageReactions extends StatelessWidget {
  /// Creates a message reactions widget for the given [message].
  const StreamMessageReactions({
    super.key,
    required this.message,
    this.type,
    this.position,
    this.sorting,
    this.onPressed,
    this.child,
  });

  /// The message whose reactions to display.
  final Message message;

  /// The visual type of the reactions display.
  ///
  /// Defaults to [core.StreamReactionsType.segmented] when null.
  final core.StreamReactionsType? type;

  /// Where the reactions appear relative to the message bubble.
  ///
  /// Defaults to [core.StreamReactionsPosition.header] when null.
  ///
  /// Overlap is derived from this: [core.StreamReactionsPosition.header]
  /// always overlaps the bubble edge; [core.StreamReactionsPosition.footer]
  /// never overlaps.
  final core.StreamReactionsPosition? position;

  /// Controls how reaction groups are sorted when displayed.
  ///
  /// Defaults to [ReactionSorting.byFirstReactionAt] when null.
  final Comparator<ReactionGroup>? sorting;

  /// Called when the reactions area is pressed.
  ///
  /// If null, pressing the reactions area has no effect.
  final VoidCallback? onPressed;

  /// The child widget (typically the message bubble) that reactions are
  /// displayed on.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final config = StreamChatConfiguration.of(context);
    final resolver = config.reactionIconResolver;

    final effectiveType = type ?? config.reactionType ?? core.StreamReactionsType.segmented;
    final effectivePosition = position ?? config.reactionPosition ?? core.StreamReactionsPosition.header;
    final effectiveOverlap = effectivePosition == core.StreamReactionsPosition.header;

    final reactionGroups = message.reactionGroups?.entries;
    final effectiveReactionSorting = sorting ?? ReactionSorting.byFirstReactionAt;
    final sortedReactionGroups = reactionGroups?.sortedByCompare((it) => it.value, effectiveReactionSorting);

    final items = sortedReactionGroups?.map(
      (group) => core.StreamReactionsItem(
        count: group.value.count,
        emoji: resolver.resolve(group.key),
      ),
    );

    return core.StreamReactions(
      type: effectiveType,
      position: effectivePosition,
      overlap: effectiveOverlap,
      onPressed: onPressed,
      items: [...?items],
      child: child,
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/reactions/indicator/reaction_indicator_icon_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamReactionIndicator}
/// A widget that displays a horizontal list of reaction icons that users have
/// reacted with on a message.
///
/// This widget is typically used to show the reactions on a message in a
/// compact way, allowing users to see which reactions have been added
/// to a message without opening a full user reactions view.
/// {@endtemplate}
class StreamReactionIndicator extends StatelessWidget {
  /// {@macro streamReactionIndicator}
  const StreamReactionIndicator({
    super.key,
    this.onTap,
    required this.message,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.scrollable = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(26)),
    this.reactionSorting = ReactionSorting.byFirstReactionAt,
  });

  /// Message to attach the reaction to.
  final Message message;

  /// Callback triggered when the reaction indicator is tapped.
  final VoidCallback? onTap;

  /// Background color for the reaction indicator.
  final Color? backgroundColor;

  /// Padding around the reaction picker.
  ///
  /// Defaults to `EdgeInsets.all(8)`.
  final EdgeInsets padding;

  /// Whether the reaction picker should be scrollable.
  ///
  /// Defaults to `true`.
  final bool scrollable;

  /// Border radius for the reaction picker.
  ///
  /// Defaults to a circular border with a radius of 26.
  final BorderRadius? borderRadius;

  /// Sorting strategy for the reaction.
  ///
  /// Defaults to sorting by the first reaction at.
  final Comparator<ReactionGroup> reactionSorting;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final config = StreamChatConfiguration.of(context);
    final reactionIcons = config.reactionIcons;

    final ownReactions = {...?message.ownReactions?.map((it) => it.type)};
    final indicatorIcons = message.reactionGroups?.entries
        .sortedByCompare((it) => it.value, reactionSorting)
        .map((group) {
      final reactionIcon = reactionIcons.firstWhere(
        (it) => it.type == group.key,
        orElse: () => const StreamReactionIcon.unknown(),
      );

      return ReactionIndicatorIcon(
        type: reactionIcon.type,
        builder: reactionIcon.builder,
        isSelected: ownReactions.contains(reactionIcon.type),
      );
    });

    final isSingleIndicatorIcon = indicatorIcons?.length == 1;
    final extraPadding = switch (isSingleIndicatorIcon) {
      true => EdgeInsets.zero,
      false => const EdgeInsets.symmetric(horizontal: 4),
    };

    final indicator = ReactionIndicatorIconList(
      indicatorIcons: [...?indicatorIcons],
    );

    return Material(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      color: backgroundColor ?? theme.colorTheme.barsBg,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding.add(extraPadding),
          child: switch (scrollable) {
            true => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: indicator,
              ),
            false => indicator,
          },
        ),
      ),
    );
  }
}

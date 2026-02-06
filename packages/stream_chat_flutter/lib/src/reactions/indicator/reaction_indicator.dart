import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template reactionIndicatorBuilder}
/// Signature for a function that builds a custom reaction indicator widget.
///
/// This allows users to customize how reactions are displayed on messages,
/// including showing reaction counts alongside emojis.
///
/// Parameters:
/// - [context]: The build context.
/// - [message]: The message containing the reactions to display.
/// - [onTap]: An optional callback triggered when the reaction indicator
///   is tapped.
/// {@endtemplate}
typedef ReactionIndicatorBuilder =
    Widget Function(
      BuildContext context,
      Message message,
      VoidCallback? onTap,
    );

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
    required this.reactionIcons,
    this.reactionIconBuilder,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.scrollable = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(26)),
    this.reactionSorting = ReactionSorting.byFirstReactionAt,
  });

  /// Creates a [StreamReactionIndicator] using the default reaction icons
  /// provided by the [StreamChatConfiguration].
  ///
  /// This is the recommended way to create a reaction indicator
  /// as it ensures that the icons are consistent with the rest of the app.
  ///
  /// The [onTap] callback is optional and can be used to handle
  /// when the reaction indicator is tapped.
  factory StreamReactionIndicator.builder(
    BuildContext context,
    Message message,
    VoidCallback? onTap,
  ) {
    final config = StreamChatConfiguration.of(context);
    final reactionIcons = config.reactionIcons;

    final currentUser = StreamChat.maybeOf(context)?.currentUser;
    final isMyMessage = message.user?.id == currentUser?.id;

    final theme = StreamChatTheme.of(context);
    final messageTheme = theme.getMessageTheme(reverse: isMyMessage);

    return StreamReactionIndicator(
      onTap: onTap,
      message: message,
      reactionIcons: reactionIcons,
      backgroundColor: messageTheme.reactionsBackgroundColor,
    );
  }

  /// Callback triggered when the reaction indicator is tapped.
  final VoidCallback? onTap;

  /// Message to attach the reaction to.
  final Message message;

  /// The list of available reaction icons.
  final List<StreamReactionIcon> reactionIcons;

  /// Optional custom builder for reaction indicator icons.
  final ReactionIndicatorIconBuilder? reactionIconBuilder;

  /// Background color for the reaction indicator.
  final Color? backgroundColor;

  /// Padding around the reaction indicator.
  ///
  /// Defaults to `EdgeInsets.all(8)`.
  final EdgeInsets padding;

  /// Whether the reaction indicator should be scrollable.
  ///
  /// Defaults to `true`.
  final bool scrollable;

  /// Border radius for the reaction indicator.
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

    final ownReactions = {...?message.ownReactions?.map((it) => it.type)};
    final reactionIcons = {for (final it in this.reactionIcons) it.type: it};

    final sortedReactionGroups = message.reactionGroups?.entries.sortedByCompare((it) => it.value, reactionSorting);

    final indicatorIcons = sortedReactionGroups?.map(
      (group) {
        final reactionType = group.key;
        final reactionIcon = switch (reactionIcons[reactionType]) {
          final icon? => icon,
          _ => const StreamReactionIcon.unknown(),
        };

        return ReactionIndicatorIcon(
          type: reactionType,
          builder: reactionIcon.builder,
          isSelected: ownReactions.contains(reactionType),
        );
      },
    );

    final reactionIndicator = ReactionIndicatorIconList(
      iconBuilder: reactionIconBuilder,
      indicatorIcons: [...?indicatorIcons],
    );

    final isSingleIndicatorIcon = indicatorIcons?.length == 1;
    final extraPadding = switch (isSingleIndicatorIcon) {
      true => EdgeInsets.zero,
      false => const EdgeInsets.symmetric(horizontal: 4),
    };

    return Material(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      color: backgroundColor ?? theme.colorTheme.barsBg,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding.add(extraPadding),
          child: switch (scrollable) {
            false => reactionIndicator,
            true => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: reactionIndicator,
            ),
          },
        ),
      ),
    );
  }
}

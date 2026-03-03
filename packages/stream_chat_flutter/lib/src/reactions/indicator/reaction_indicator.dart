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
typedef ReactionIndicatorBuilder = Widget Function(BuildContext context, Message message, VoidCallback? onTap);

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
    this.padding,
    this.borderRadius,
    this.reactionSorting,
  });

  /// Creates a [StreamReactionIndicator] using the default configuration.
  ///
  /// This is the recommended way to create a reaction indicator
  /// as it ensures that the icons are consistent with the rest of the app.
  factory StreamReactionIndicator.builder(
    BuildContext _,
    Message message,
    VoidCallback? onTap,
  ) {
    return StreamReactionIndicator(onTap: onTap, message: message);
  }

  /// Callback triggered when the reaction indicator is tapped.
  final VoidCallback? onTap;

  /// Message to attach the reaction to.
  final Message message;

  /// Background color for the reaction indicator.
  final Color? backgroundColor;

  /// Padding around the reaction indicator.
  ///
  /// Defaults to `EdgeInsets.all(8)`.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the reaction indicator.
  ///
  /// Defaults to a circular border with a radius of 26.
  final BorderRadiusGeometry? borderRadius;

  /// Sorting strategy for the reaction.
  ///
  /// Defaults to sorting by the first reaction at.
  final Comparator<ReactionGroup>? reactionSorting;

  @override
  Widget build(BuildContext context) {
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    final effectivePadding = padding ?? .symmetric(horizontal: spacing.xs, vertical: spacing.xxs);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.all(radius.max);
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.backgroundElevation3;

    final side = BorderSide(color: colorScheme.borderDefault);
    final shape = RoundedSuperellipseBorder(borderRadius: effectiveBorderRadius, side: side);

    final config = StreamChatConfiguration.of(context);
    final resolver = config.reactionIconResolver;

    final reactionGroups = message.reactionGroups?.entries;
    final effectiveReactionSorting = reactionSorting ?? ReactionSorting.byFirstReactionAt;
    final sortedReactionGroups = reactionGroups?.sortedByCompare((it) => it.value, effectiveReactionSorting);

    final indicatorIcons = sortedReactionGroups?.map(
      (group) => StreamEmoji(
        size: StreamEmojiSize.sm,
        emoji: resolver.resolve(context, group.key),
      ),
    );

    final indicatorContent = Row(
      mainAxisSize: .min,
      spacing: spacing.xxs,
      children: [...?indicatorIcons],
    );

    return Material(
      shape: shape,
      elevation: 3,
      clipBehavior: .antiAlias,
      color: effectiveBackgroundColor,
      child: InkWell(
        onTap: onTap,
        child: SingleChildScrollView(
          padding: effectivePadding,
          scrollDirection: .horizontal,
          child: indicatorContent,
        ),
      ),
    );
  }
}

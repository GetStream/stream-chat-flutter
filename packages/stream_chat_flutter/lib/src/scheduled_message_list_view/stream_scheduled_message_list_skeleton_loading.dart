import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:stream_core_flutter/chat.dart';

/// A shimmer loading placeholder for the scheduled message list view.
@internal
class StreamScheduledMessageListSkeletonLoading extends StatelessWidget {
  /// Creates a scheduled message list loading placeholder.
  const StreamScheduledMessageListSkeletonLoading({
    super.key,
    this.itemCount = 6,
    this.padding,
  });

  /// The number of skeleton items to display.
  final int itemCount;

  /// Padding around the skeleton list.
  ///
  /// When null, the list insets itself from the screen's safe area.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return StreamSkeletonLoading(
      child: ListView.separated(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) => Divider(height: 1, color: colorScheme.borderSubtle),
        itemBuilder: (context, index) => const _StreamScheduledMessageListItemSkeleton(),
      ),
    );
  }
}

class _StreamScheduledMessageListItemSkeleton extends StatelessWidget {
  const _StreamScheduledMessageListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final barRadius = BorderRadius.all(context.streamRadius.max);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
      child: StreamSafeArea(
        top: false,
        bottom: false,
        minimum: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: .start,
          spacing: spacing.xs,
          children: [
            StreamSkeletonBox(width: 120, height: 12, borderRadius: barRadius),
            Row(
              crossAxisAlignment: .start,
              spacing: spacing.sm,
              children: [
                const StreamSkeletonBox.circular(radius: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: spacing.xs,
                    children: [
                      StreamSkeletonBox(width: 96, height: 12, borderRadius: barRadius),
                      StreamSkeletonBox(width: 260, height: 16, borderRadius: barRadius),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

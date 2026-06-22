import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart';

/// A shimmer loading placeholder for the channel list view.
///
/// Displays a skeleton UI with shimmer animation using
/// [StreamSkeletonLoading] and [StreamSkeletonBox] from the core package.
class StreamChannelListSkeletonLoading extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListSkeletonLoading].
  const StreamChannelListSkeletonLoading({
    super.key,
    this.itemCount = 7,
  });

  /// The number of skeleton items to display.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return StreamSkeletonLoading(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 1),
        itemBuilder: (context, index) => const _StreamChannelListItemSkeleton(),
      ),
    );
  }
}

class _StreamChannelListItemSkeleton extends StatelessWidget {
  const _StreamChannelListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: spacing.md,
        children: [
          const StreamSkeletonBox.circular(radius: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing.xs,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StreamSkeletonBox(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.all(context.streamRadius.max),
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    StreamSkeletonBox(
                      width: 48,
                      height: 16,
                      borderRadius: BorderRadius.all(context.streamRadius.max),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: StreamSkeletonBox(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.all(context.streamRadius.max),
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

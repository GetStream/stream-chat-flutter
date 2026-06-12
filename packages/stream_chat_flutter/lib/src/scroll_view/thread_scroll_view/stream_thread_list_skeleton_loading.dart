import 'package:flutter/material.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A shimmer loading placeholder for the thread list view.
///
/// Displays a skeleton UI with shimmer animation using
/// [StreamSkeletonLoading] and [StreamSkeletonBox] from the core package.
class StreamThreadListSkeletonLoading extends StatelessWidget {
  /// Creates a new instance of [StreamThreadListSkeletonLoading].
  const StreamThreadListSkeletonLoading({
    super.key,
    this.itemCount = 6,
  });

  /// The number of skeleton items to display.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return StreamSkeletonLoading(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 1),
        itemBuilder: (context, index) => const _StreamThreadListItemSkeleton(),
      ),
    );
  }
}

class _StreamThreadListItemSkeleton extends StatelessWidget {
  const _StreamThreadListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.streamSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StreamSkeletonBox.circular(radius: 24),
          SizedBox(width: context.streamSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: StreamSkeletonBox(
                        width: double.infinity,
                        height: 12,
                        borderRadius: BorderRadius.all(context.streamRadius.max),
                      ),
                    ),
                    SizedBox(width: context.streamSpacing.sm),
                    const Spacer(
                      flex: 2,
                    ),
                    StreamSkeletonBox(
                      width: 48,
                      height: 16,
                      borderRadius: BorderRadius.all(context.streamRadius.max),
                    ),
                  ],
                ),
                SizedBox(height: context.streamSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: StreamSkeletonBox(
                        width: double.infinity,
                        height: 20,
                        borderRadius: BorderRadius.all(context.streamRadius.max),
                      ),
                    ),
                    SizedBox(width: context.streamSpacing.sm),
                    const SizedBox(width: 48),
                  ],
                ),
                SizedBox(height: context.streamSpacing.xs),
                Row(
                  children: [
                    const StreamSkeletonBox.circular(radius: 12),
                    SizedBox(width: context.streamSpacing.xs),
                    StreamSkeletonBox(
                      width: 64,
                      height: 12,
                      borderRadius: BorderRadius.all(context.streamRadius.max),
                    ),
                    SizedBox(width: context.streamSpacing.xs),
                    StreamSkeletonBox(
                      width: 64,
                      height: 12,
                      borderRadius: BorderRadius.all(context.streamRadius.max),
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

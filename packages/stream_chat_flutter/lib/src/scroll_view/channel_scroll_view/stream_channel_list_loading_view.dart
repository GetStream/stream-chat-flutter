import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A shimmer loading placeholder for the channel list view.
///
/// Displays a skeleton UI with shimmer animation
class StreamChannelListLoadingView extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListLoadingView].
  const StreamChannelListLoadingView({
    super.key,
    this.itemCount = 6,
  });

  /// The number of skeleton items to display.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.streamColorScheme;

    return Shimmer.fromColors(
      baseColor: colorTheme.skeletonLoadingBase,
      highlightColor: colorTheme.skeletonLoadingHighlight,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 1),
        itemBuilder: (context, index) => const _ChannelListItemSkeleton(),
      ),
    );
  }
}

class _ChannelListItemSkeleton extends StatelessWidget {
  const _ChannelListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.streamSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonBox(
            width: 48,
            height: 48,
            shape: BoxShape.circle,
          ),
          SizedBox(width: context.streamSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: _SkeletonBox(width: double.infinity, height: 12),
                    ),
                    SizedBox(width: context.streamSpacing.sm),
                    _SkeletonBox(
                      width: 48,
                      height: 16,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
                SizedBox(height: context.streamSpacing.xs),
                Row(
                  children: [
                    const Expanded(
                      child: _SkeletonBox(width: double.infinity, height: 20),
                    ),
                    SizedBox(width: context.streamSpacing.sm),
                    const SizedBox(width: 48),
                  ],
                ),
                SizedBox(height: context.streamSpacing.xs),
                Row(
                  children: [
                    const _SkeletonBox(
                      width: 24,
                      height: 24,
                      shape: BoxShape.circle,
                    ),
                    SizedBox(width: context.streamSpacing.xs),
                    _SkeletonBox(
                      width: 64,
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    SizedBox(width: context.streamSpacing.xs),
                    _SkeletonBox(
                      width: 64,
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
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

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? (borderRadius ?? BorderRadius.circular(8)) : null,
      ),
    );
  }
}

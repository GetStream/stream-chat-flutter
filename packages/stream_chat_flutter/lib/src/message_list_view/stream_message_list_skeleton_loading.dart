import 'package:flutter/material.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A shimmer loading placeholder for the message list view.
///
/// Displays a skeleton UI with shimmer animation that mimics a chat
/// conversation with incoming (left-aligned) and outgoing (right-aligned)
/// message bubbles using [StreamSkeletonLoading] and [StreamSkeletonBox].
class StreamMessageListSkeletonLoading extends StatelessWidget {
  /// Creates a new instance of [StreamMessageListSkeletonLoading].
  const StreamMessageListSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return StreamSkeletonLoading(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              children: [
                _IncomingBubble(),
                SizedBox(height: spacing.lg),
                _OutgoingBubble(),
                SizedBox(height: spacing.lg),
                _IncomingBubble(),
                SizedBox(height: spacing.lg),
                _OutgoingBubble(),
                SizedBox(height: spacing.lg),
                _IncomingBubble(),
                SizedBox(height: spacing.md),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _IncomingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const StreamSkeletonBox.circular(radius: 16),
        SizedBox(width: spacing.xs),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamSkeletonBox(
                height: 56,
                borderRadius: BorderRadius.only(
                  topRight: context.streamRadius.xl,
                  bottomRight: context.streamRadius.xl,
                  topLeft: context.streamRadius.xl,
                ),
              ),
              SizedBox(height: spacing.xs),
              StreamSkeletonBox(
                width: 56,
                height: 12,
                borderRadius: BorderRadius.all(context.streamRadius.max),
              ),
              SizedBox(height: spacing.xs),
            ],
          ),
        ),
        const Spacer(
          flex: 1,
        ),
      ],
    );
  }
}

class _OutgoingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Row(
      children: [
        const Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StreamSkeletonBox(
                height: 56,
                borderRadius: BorderRadius.all(
                  context.streamRadius.xl,
                ),
              ),
              SizedBox(height: spacing.xs),
              StreamSkeletonBox(
                width: 56,
                height: 12,
                borderRadius: BorderRadius.all(context.streamRadius.max),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

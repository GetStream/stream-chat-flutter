import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A bottom sheet that displays delivery and read receipt information
/// for a message, similar to popular messaging apps like WhatsApp.
class MessageInfoSheet extends StatelessWidget {
  /// Creates a new [MessageInfoSheet].
  const MessageInfoSheet({
    super.key,
    required this.message,
    this.scrollController,
  });

  /// The message to display info for.
  final Message message;
  final ScrollController? scrollController;

  /// Shows the message info sheet as a modal bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required Message message,
  }) {
    return showStreamSheet<void>(
      context: context,
      isDismissible: true,
      builder: (_, scrollController) => StreamChannel.value(
        channel: StreamChannel.of(context).channel,
        child: MessageInfoSheet(
          message: message,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;

    final channel = StreamChannel.of(context).channel;

    return Column(
      children: [
        StreamSheetHeader(title: const Text('Message Info')),
        // Delivery and read receipts
        Expanded(
          child: BetterStreamBuilder<List<Read>>(
            stream: channel.state?.readStream,
            initialData: channel.state?.read,
            noDataBuilder: (context) => Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(colorScheme.accentPrimary),
              ),
            ),
            builder: (context, reads) {
              final readBy = reads.readsOf(message: message);
              final deliveredTo = reads.deliveriesOf(message: message);

              // Empty state
              if (readBy.isEmpty && deliveredTo.isEmpty) {
                return Center(
                  child: Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 56,
                        color: colorScheme.textSecondary,
                      ),
                      Text(
                        'No delivery information available',
                        style: textTheme.bodyDefault.copyWith(
                          color: colorScheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                controller: scrollController,
                padding: .symmetric(horizontal: spacing.xxs, vertical: spacing.md),
                children: [
                  // Read section
                  if (readBy.isNotEmpty) ...[
                    _buildSection(
                      context,
                      title: 'READ BY',
                      reads: readBy,
                      itemBuilder: (_, read) => _UserReadTile(
                        read: read,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Delivered section
                  if (deliveredTo.isNotEmpty) ...[
                    _buildSection(
                      context,
                      title: 'DELIVERED TO',
                      reads: deliveredTo,
                      itemBuilder: (_, read) => _UserReadTile(
                        read: read,
                        isDelivered: true,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Read> reads,
    required Widget Function(BuildContext context, Read item) itemBuilder,
  }) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;

    return Column(
      spacing: spacing.xxs,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: .only(left: spacing.sm, right: spacing.sm, bottom: spacing.xs),
          child: Text(
            title,
            style: textTheme.captionDefault.copyWith(
              color: colorScheme.textSecondary,
            ),
          ),
        ),
        for (final read in reads) itemBuilder(context, read),
      ],
    );
  }
}

/// Tile displaying a user's read/delivery status
class _UserReadTile extends StatelessWidget {
  const _UserReadTile({
    required this.read,
    this.isDelivered = false,
  });

  final Read read;
  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return StreamListTileTheme(
      data: StreamListTileThemeData(
        minTileHeight: 44, // Matches the design's tap target size
        contentPadding: .symmetric(horizontal: spacing.sm),
      ),
      child: StreamListTile(
        leading: StreamUserAvatar(user: read.user),
        title: Text(read.user.name, maxLines: 1, overflow: .ellipsis),
        trailing: Icon(
          context.streamIcons.checks,
          size: 18,
          color: switch (isDelivered) {
            true => context.streamColorScheme.textSecondary,
            false => context.streamColorScheme.accentPrimary,
          },
        ),
      ),
    );
  }
}

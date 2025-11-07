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
    final theme = StreamChatTheme.of(context);
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: theme.colorTheme.appBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) => StreamChannel(
        channel: StreamChannel.of(context).channel,
        child: DraggableScrollableSheet(
          snap: true,
          expand: false,
          snapSizes: const [0.5, 1],
          builder: (context, controller) => MessageInfoSheet(
            message: message,
            scrollController: controller,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;
    final textTheme = theme.textTheme;

    final channel = StreamChannel.of(context).channel;

    return Column(
      children: [
        // Header
        _buildHeader(context),

        // Delivery and read receipts
        Expanded(
          child: BetterStreamBuilder<List<Read>>(
            stream: channel.state?.readStream,
            initialData: channel.state?.read,
            noDataBuilder: (context) => Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(colorTheme.accentPrimary),
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
                        color: colorTheme.textLowEmphasis,
                      ),
                      Text(
                        'No delivery information available',
                        style: textTheme.body.copyWith(
                          color: colorTheme.textLowEmphasis,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
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

  Widget _buildHeader(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorTheme.borders,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Message Info',
            style: textTheme.headlineBold,
          ),
          IconButton(
            iconSize: 32,
            icon: const StreamSvgIcon(icon: StreamSvgIcons.close),
            onPressed: Navigator.of(context).maybePop,
            color: colorTheme.textHighEmphasis,
            padding: const EdgeInsets.all(4),
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: WidgetStateProperty.all(const Size.square(32)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Read> reads,
    required Widget Function(BuildContext context, Read item) itemBuilder,
  }) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;
    final textTheme = theme.textTheme;

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          title,
          style: textTheme.footnote.copyWith(
            color: colorTheme.textLowEmphasis,
          ),
        ),

        // List of items
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorTheme.barsBg,
            ),
            child: MediaQuery.removePadding(
              context: context,
              // Workaround for the bottom padding issue.
              // Link: https://github.com/flutter/flutter/issues/156149
              removeTop: true,
              removeBottom: true,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: reads.length,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: theme.colorTheme.borders,
                ),
                itemBuilder: (_, index) => itemBuilder(
                  context,
                  reads[index],
                ),
              ),
            ),
          ),
        ),
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
    final theme = StreamChatTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [
          // User avatar
          StreamUserAvatar(
            user: read.user,
            constraints: const BoxConstraints.tightFor(
              height: 40,
              width: 40,
            ),
          ),

          const SizedBox(width: 12),

          // User name
          Expanded(
            child: Text(
              read.user.name,
              style: theme.textTheme.bodyBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Status icon
          StreamSvgIcon(
            size: 18,
            icon: StreamSvgIcons.checkAll,
            color: switch (isDelivered) {
              true => theme.colorTheme.textLowEmphasis,
              false => theme.colorTheme.accentPrimary,
            },
          ),
        ],
      ),
    );
  }
}

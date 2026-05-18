import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Lists every photo + video shared in the enclosing channel as a 3-up
/// grid. Tapping a tile opens [StreamMediaGalleryPreview].
///
/// Matches Figma frames `8833:437788` (grid), `13495:418984` (scrolled),
/// and `8833:437329` (empty).
class ChannelMediaDisplayScreen extends StatefulWidget {
  /// Creates a [ChannelMediaDisplayScreen].
  const ChannelMediaDisplayScreen({super.key});

  @override
  State<ChannelMediaDisplayScreen> createState() => _ChannelMediaDisplayScreenState();
}

class _ChannelMediaDisplayScreenState extends State<ChannelMediaDisplayScreen> {
  late final StreamMessageSearchListController _controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('cid', [StreamChannel.of(context).channel.cid!]),
    messageFilter: Filter.in_('attachments.type', const ['image', 'video']),
    sort: const [SortOption.asc('created_at')],
    limit: 20,
  );

  @override
  void initState() {
    super.initState();
    _controller.doInitialLoad();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(title: Text(context.translations.photosAndVideosLabel)),
      body: ValueListenableBuilder<PagedValue<String, GetMessageResponse>>(
        valueListenable: _controller,
        builder: (context, value, _) => value.when(
          (items, nextPageKey, _) {
            // Flatten messages → individual image/video attachments.
            // Excludes link previews (`ogScrapeUrl != null`) so we don't
            // render every shared URL's thumbnail in the grid.
            final attachments = <StreamMediaGalleryAttachment>[
              for (final response in items)
                ...response.message.toMediaGalleryAttachments(
                  filter: (a) =>
                      (a.type == AttachmentType.image || a.type == AttachmentType.video) && a.ogScrapeUrl == null,
                ),
            ];

            if (attachments.isEmpty) return const Center(child: _EmptyState());

            return LazyLoadScrollView(
              onEndOfPage: () async {
                if (nextPageKey != null) await _controller.loadMore(nextPageKey);
              },
              child: StreamMediaGallery(
                attachments: attachments,
                onItemTap: (index) => _openPreview(context, attachments, index),
              ),
            );
          },
          loading: () => const Center(child: StreamScrollViewLoadingWidget()),
          error: (_) => Center(
            child: StreamScrollViewErrorWidget(
              errorTitle: const Text('Failed to load media'),
              onRetryPressed: _controller.refresh,
            ),
          ),
        ),
      ),
    );
  }

  void _openPreview(
    BuildContext context,
    List<StreamMediaGalleryAttachment> attachments,
    int index,
  ) {
    final channel = StreamChannel.of(context).channel;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StreamChannel(
          channel: channel,
          child: StreamMediaGalleryPreview(
            attachments: attachments,
            initialIndex: index,
          ),
        ),
      ),
    );
  }
}

/// Empty state for [ChannelMediaDisplayScreen] — image icon, "No photos
/// or videos" headline, and a centered subtitle ("Share a photo or
/// video to see it here").
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            context.streamIcons.image,
            size: 32,
            color: colorScheme.textTertiary,
          ),
          SizedBox(height: spacing.sm),
          Text(
            'No photos or videos',
            style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
          ),
          SizedBox(height: spacing.xxs),
          Text(
            'Share a photo or video to see it here',
            style: textTheme.captionDefault.copyWith(color: colorScheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

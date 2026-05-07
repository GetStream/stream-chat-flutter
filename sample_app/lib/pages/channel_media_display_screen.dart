import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Lists every photo + video shared in the enclosing channel as a 3-up
/// grid. Tapping a tile opens the [StreamFullScreenMedia] gallery.
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
      appBar: StreamAppBar(title: const Text('Photos & Videos')),
      body: ValueListenableBuilder<PagedValue<String, GetMessageResponse>>(
        valueListenable: _controller,
        builder: (context, value, _) => value.when(
          (items, nextPageKey, _) {
            // Flatten messages → individual image/video attachments.
            // Excludes link previews (`ogScrapeUrl != null`) so we don't
            // render every shared URL's thumbnail in the grid.
            final media = <_MediaItem>[
              for (final response in items)
                for (final attachment in response.message.attachments)
                  if ((attachment.type == 'image' || attachment.type == 'video') && attachment.ogScrapeUrl == null)
                    _MediaItem(attachment, response.message),
            ];

            if (media.isEmpty) return const Center(child: _EmptyState());

            return LazyLoadScrollView(
              onEndOfPage: () async {
                if (nextPageKey != null) await _controller.loadMore(nextPageKey);
              },
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: media.length,
                itemBuilder: (context, index) => _MediaTile(
                  index: index,
                  items: media,
                ),
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
}

/// Single attachment + its enclosing message — paired so the full-screen
/// gallery can show sender / timestamp metadata when opened.
class _MediaItem {
  const _MediaItem(this.attachment, this.message);

  final Attachment attachment;
  final Message message;
}

/// One cell in the photo grid. Renders the attachment's thumbnail
/// (image or video) via [StreamNetworkImage]; videos overlay a
/// [StreamVideoPlayIndicator]. Tapping opens the full-screen gallery
/// at this index — every other media item in the channel is wired up
/// as a swipeable sibling.
class _MediaTile extends StatelessWidget {
  const _MediaTile({required this.index, required this.items});

  final int index;
  final List<_MediaItem> items;

  @override
  Widget build(BuildContext context) {
    final item = items[index];
    final attachment = item.attachment;
    final isVideo = attachment.type == 'video';
    final thumbUrl = attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl;

    return GestureDetector(
      onTap: () => _open(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbUrl != null)
            StreamNetworkImage(thumbUrl, fit: BoxFit.cover)
          else
            ColoredBox(color: context.streamColorScheme.backgroundSurfaceCard),
          if (isVideo) const Center(child: StreamVideoPlayIndicator()),
        ],
      ),
    );
  }

  void _open(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StreamChannel(
          channel: channel,
          child: StreamFullScreenMedia(
            mediaAttachmentPackages: [
              for (final m in items) StreamAttachmentPackage(attachment: m.attachment, message: m.message),
            ],
            startIndex: index,
            userName: items[index].message.user?.name ?? '',
            onShowMessage: (message, _) async {
              final router = GoRouter.of(context);
              if (channel.state == null) await channel.watch();
              router.pushNamed(
                Routes.CHANNEL_PAGE.name,
                pathParameters: Routes.CHANNEL_PAGE.params(channel),
                queryParameters: Routes.CHANNEL_PAGE.queryParams(message),
              );
            },
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

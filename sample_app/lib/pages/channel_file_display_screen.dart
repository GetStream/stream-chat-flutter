import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Lists every file shared in the enclosing channel, grouped by the
/// month each file was sent.
///
/// Matches Figma frames `8833:437706` (with content) and `8833:437407`
/// (empty). Built on the same [StreamMessageSearchListController] the
/// legacy implementation used, filtered to `attachments.type == 'file'`.
class ChannelFileDisplayScreen extends StatefulWidget {
  /// Creates a [ChannelFileDisplayScreen].
  const ChannelFileDisplayScreen({super.key});

  @override
  State<ChannelFileDisplayScreen> createState() => _ChannelFileDisplayScreenState();
}

class _ChannelFileDisplayScreenState extends State<ChannelFileDisplayScreen> {
  late final StreamMessageSearchListController _controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('cid', [StreamChannel.of(context).channel.cid!]),
    messageFilter: Filter.in_('attachments.type', const ['file']),
    sort: const [SortOption.desc('created_at')],
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
    return StreamScaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Files')),
      body: ValueListenableBuilder<PagedValue<String, GetMessageResponse>>(
        valueListenable: _controller,
        builder: (context, value, _) {
          final topInset = StreamScaffoldInsets.maybeOf(context)?.topPadding ?? 0.0;
          return value.when(
            (items, nextPageKey, _) {
              // Flatten messages → individual file attachments paired with
              // the message timestamp we'll bucket on.
              final entries = <_FileEntry>[
                for (final response in items)
                  for (final attachment in response.message.attachments)
                    if (attachment.type == 'file')
                      _FileEntry(
                        attachment: attachment,
                        sentAt: response.message.createdAt,
                      ),
              ];

              if (entries.isEmpty) return const Center(child: _EmptyState());

              // Pre-build a flat row list — interleave a header row above
              // each month bucket so a single ListView.builder can render
              // both kinds of rows without a CustomScrollView + slivers.
              final rows = _buildRows(entries);

              return LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) await _controller.loadMore(nextPageKey);
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(top: topInset),
                  itemCount: rows.length,
                  itemBuilder: (context, index) => rows[index].build(context),
                ),
              );
            },
            loading: () => const Center(child: StreamScrollViewLoadingWidget()),
            error: (_) => Center(
              child: StreamScrollViewErrorWidget(
                errorTitle: const Text('Failed to load files'),
                onRetryPressed: _controller.refresh,
              ),
            ),
          );
        },
      ),
    );
  }

  List<_Row> _buildRows(List<_FileEntry> entries) {
    final rows = <_Row>[];
    DateTime? currentBucket;
    for (final entry in entries) {
      final bucket = entry.sentAt == null ? null : DateTime(entry.sentAt!.year, entry.sentAt!.month);
      if (bucket != currentBucket) {
        currentBucket = bucket;
        rows.add(_HeaderRow(bucket));
      }
      rows.add(_FileRow(entry.attachment));
    }
    return rows;
  }
}

/// Single file attachment paired with the message timestamp used to
/// bucket it under a month header.
class _FileEntry {
  const _FileEntry({required this.attachment, required this.sentAt});

  final Attachment attachment;
  final DateTime? sentAt;
}

/// Row shape interface — the [ListView.builder] doesn't care whether it
/// renders a section header or a file row, only that both can build
/// themselves.
sealed class _Row {
  Widget build(BuildContext context);
}

/// Section header above each month bucket — light surface background,
/// bold "Month YYYY" caption (or "Earlier" for entries with no
/// timestamp).
class _HeaderRow implements _Row {
  const _HeaderRow(this.bucket);

  final DateTime? bucket;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final label = bucket == null ? 'Earlier' : Jiffy.parseFromDateTime(bucket!).format(pattern: 'MMMM yyyy');

    return Container(
      color: colorScheme.backgroundSurfaceCard,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      width: double.infinity,
      child: Text(
        label,
        style: textTheme.captionEmphasis.copyWith(color: colorScheme.textPrimary),
      ),
    );
  }
}

/// Single file row — leading [StreamFileTypeIcon], filename title,
/// human-readable file size subtitle. Pure preview; tapping doesn't
/// open the file (mirrors the legacy implementation).
class _FileRow implements _Row {
  const _FileRow(this.attachment);

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return StreamListTile(
      leading: StreamFileTypeIcon.fromMimeType(
        mimeType: attachment.mimeType,
        size: StreamFileTypeIconSize.lg,
      ),
      title: Text(
        attachment.title ?? 'Untitled',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(_humanizeBytes(attachment.fileSize)),
    );
  }
}

/// Empty state for [ChannelFileDisplayScreen] — folder icon, "No files"
/// headline, and a textSecondary subtitle ("Share a file to see it
/// here").
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
            context.streamIcons.folder,
            size: 32,
            color: colorScheme.textTertiary,
          ),
          SizedBox(height: spacing.sm),
          Text(
            'No files',
            style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
          ),
          SizedBox(height: spacing.xxs),
          Text(
            'Share a file to see it here',
            style: textTheme.captionDefault.copyWith(color: colorScheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Pretty-prints a byte count as `B` / `KB` / `MB` / `GB`. Returns an
/// empty string when [bytes] is null so the subtitle row collapses
/// rather than showing a noisy placeholder.
String _humanizeBytes(int? bytes) {
  if (bytes == null) return '';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  // Whole-number formatting once we're past kilobytes — matches the
  // Figma's "4 MB" / "5 MB" style. Bytes / KB are rare enough in
  // practice that the extra precision isn't useful.
  final formatted = size >= 10 || unit == 0 ? size.toStringAsFixed(0) : size.toStringAsFixed(1);
  return '$formatted ${units[unit]}';
}

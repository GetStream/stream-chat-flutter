import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Lists every pinned message in the enclosing channel.
///
/// Matches Figma frame `8833:437280` (and `8833:437021` for the empty
/// state). The search-list controller is filtered by `pinned: true` on
/// the channel's `cid` — same data source the legacy implementation used,
/// rendered via the SDK's `StreamMessageSearchListView` so the row
/// styling stays in sync with the rest of the app.
class PinnedMessagesScreen extends StatefulWidget {
  /// Creates a [PinnedMessagesScreen].
  const PinnedMessagesScreen({super.key});

  @override
  State<PinnedMessagesScreen> createState() => _PinnedMessagesScreenState();
}

class _PinnedMessagesScreenState extends State<PinnedMessagesScreen> {
  late final StreamMessageSearchListController _controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('cid', [StreamChannel.of(context).channel.cid!]),
    messageFilter: Filter.equal('pinned', true),
    sort: const [SortOption.asc('created_at')],
    limit: 20,
  );

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
      appBar: StreamAppBar(title: const Text('Pinned Messages')),
      body: StreamMessageSearchListView(
        controller: _controller,
        emptyBuilder: (_) => const Center(child: _EmptyState()),
        onMessageTap: _openMessage,
      ),
    );
  }

  Future<void> _openMessage(GetMessageResponse response) async {
    final client = StreamChat.of(context).client;
    final router = GoRouter.of(context);
    final message = response.message;
    final channel = client.channel(
      response.channel!.type,
      id: response.channel!.id,
    );
    if (channel.state == null) await channel.watch();
    router.goNamed(
      Routes.CHANNEL_PAGE.name,
      pathParameters: Routes.CHANNEL_PAGE.params(channel),
      queryParameters: Routes.CHANNEL_PAGE.queryParams(message),
    );
  }
}

/// Empty state for [PinnedMessagesScreen] — pin icon, "No pinned
/// messages" headline, and a centered subtitle that nudges the user
/// toward the long-press flow that creates one.
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
            context.streamIcons.pin,
            size: 32,
            color: colorScheme.textTertiary,
          ),
          SizedBox(height: spacing.sm),
          Text(
            'No pinned messages',
            style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
          ),
          SizedBox(height: spacing.xxs),
          Text(
            'Long-press a message to pin it to the chat',
            style: textTheme.captionDefault.copyWith(color: colorScheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

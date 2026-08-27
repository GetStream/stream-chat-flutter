import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../auth/auth_controller.dart';
import '../routes/routes.dart';
import '../utils/app_config.dart';
import 'channel_detail_sheet.dart';
import 'search_text_field.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});

  @override
  State<ChannelList> createState() => _ChannelList();
}

class _ChannelList extends State<ChannelList> {
  final ScrollController _scrollController = ScrollController();
  late StreamChatState _streamChat;

  late final TextEditingController _controller = TextEditingController()..addListener(_channelQueryListener);

  bool _isSearchActive = false;
  bool _controllersAreInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _streamChat = StreamChat.of(context);
    _initControllers();
    _controllersAreInitialized = true;
  }

  void _initControllers() {
    // Preserve any active search query so recreating the controllers (e.g. on a
    // dependency change) keeps the visible results in sync with the search field
    // instead of leaving the UI in active-search mode with an empty query.
    final searchQuery = _controller.text;

    if (_controllersAreInitialized) {
      _messageSearchListController.dispose();
      _channelListController.dispose();
    }

    _messageSearchListController = StreamMessageSearchListController(
      client: _streamChat.client,
      filter: Filter.in_('members', [_streamChat.currentUser!.id]),
      limit: 5,
      searchQuery: searchQuery,
      sort: [
        const SortOption.desc(ChannelSortKey.pinnedAt),
        const SortOption.asc(ChannelSortKey.createdAt),
      ],
    );
    if (searchQuery.isNotEmpty) _messageSearchListController.search(searchQuery);
    // The predefined filter is a saved query living on the demo Stream app, so
    // it 404s against any other backend. Anyone who pointed the app elsewhere
    // gets the equivalent client-side filter instead.
    final userId = _streamChat.currentUser!.id;
    final predefinedFilter = authController.usingCustomBackend ? null : kChannelListPredefinedFilter;
    _channelListController = StreamChannelListController(
      client: _streamChat.client,
      filter: predefinedFilter == null ? Filter.in_('members', [userId]) : null,
      predefinedFilter: predefinedFilter,
      filterValues: predefinedFilter == null ? null : {'user_id': userId},
      limit: 30,
    );
  }

  void _channelQueryListener() {
    final query = _controller.text;
    setState(() => _isSearchActive = query.isNotEmpty);
    if (query.isEmpty) return _messageSearchListController.clearResults();
    return _messageSearchListController.search(query);
  }

  late StreamMessageSearchListController _messageSearchListController;
  late StreamChannelListController _channelListController;

  @override
  void dispose() {
    _controller.removeListener(_channelQueryListener);
    _controller.dispose();
    _scrollController.dispose();
    _messageSearchListController.dispose();
    _channelListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isSearchActive == false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _controller.clear();
        setState(() => _isSearchActive = false);
      },
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
            FocusScope.of(context).unfocus();
          }
          return true;
        },
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, __) => [
            SliverSafeArea(
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: SearchTextField(
                  controller: _controller,
                  hintText: 'Search',
                ),
              ),
            ),
          ],
          // The header already handled the top inset; strip it so the body
          // lists (null padding) only re-add the bottom, clearing the bottom bar.
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: switch (_isSearchActive) {
              true => _ChannelListSearch(_messageSearchListController),
              false => _ChannelListDefault(_channelListController),
            },
          ),
        ),
      ),
    );
  }
}

class _ChannelListDefault extends StatelessWidget {
  const _ChannelListDefault(this.channelListController);

  final StreamChannelListController channelListController;

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: RefreshIndicator(
        onRefresh: channelListController.refresh,
        child: StreamChannelListView(
          controller: channelListController,
          itemBuilder: (context, channels, index, defaultWidget) {
            final channel = channels[index];

            final icons = context.streamIcons;
            final colorScheme = context.streamColorScheme;

            return Slidable(
              groupTag: 'channels-actions',
              endActionPane: ActionPane(
                extentRatio: 0.4,
                motion: const BehindMotion(),
                children: [
                  CustomSlidableAction(
                    foregroundColor: colorScheme.textPrimary,
                    backgroundColor: colorScheme.backgroundSurface,
                    onPressed: (_) => _openChannelDetailSheet(context, channel),
                    child: Icon(icons.more, size: 20),
                  ),
                  BetterStreamBuilder<bool>(
                    stream: channel.isMutedStream,
                    initialData: channel.isMuted,
                    builder: (context, isMuted) => CustomSlidableAction(
                      foregroundColor: colorScheme.textOnAccent,
                      backgroundColor: colorScheme.accentPrimary,
                      onPressed: (_) {
                        if (isMuted) return channel.unmute().ignore();
                        return channel.mute().ignore();
                      },
                      child: Icon(isMuted ? icons.audio : icons.mute, size: 20),
                    ),
                  ),
                ],
              ),
              child: defaultWidget,
            );
          },
          onChannelTap: (channel) => _openChannelPage(context, channel),
          onChannelLongPress: (channel) => _openChannelDetailSheet(context, channel),
        ),
      ),
    );
  }
}

// Pushes the channel page for [channel] via [GoRouter].
Future<void> _openChannelPage(BuildContext context, Channel channel) {
  return GoRouter.of(context).pushNamed(
    Routes.CHANNEL_PAGE.name,
    pathParameters: Routes.CHANNEL_PAGE.params(channel),
  );
}

// Opens the channel detail sheet and dispatches on the user's selection.
//
// The sheet pops itself with a [ChannelDetailAction] subtype; this function
// awaits that result and routes to the matching handler.
Future<void> _openChannelDetailSheet(
  BuildContext context,
  Channel channel,
) async {
  final action = await showChannelDetailSheet(context: context, channel: channel);

  if (action == null || !context.mounted) return;
  return _onChannelDetailAction(context, channel, action).ignore();
}

// Switches on a [ChannelDetailAction] and dispatches to the per-action
// handler.
Future<void> _onChannelDetailAction(
  BuildContext context,
  Channel channel,
  ChannelDetailAction action,
) async {
  final client = StreamChat.of(context).client;
  return switch (action) {
    ViewChannelInfo(:final user) => _pushChannelInfo(context, channel, user),
    PinChannel() => channel.pin(),
    UnpinChannel() => channel.unpin(),
    MuteChannelMember(:final user) => client.muteUser(user.id),
    UnmuteChannelMember(:final user) => client.unmuteUser(user.id),
    BlockChannelMember(:final user) => client.blockUser(user.id),
    LeaveChannel() => _maybeLeaveChannel(context, channel),
    DeleteChannel() => _maybeDeleteChannel(context, channel),
  };
}

// Pushes the chat / group info screen depending on whether [user] was
// resolved. 1-1 channels pass the other member here (forwarded as `extra`
// to the chat-info route); group channels pass `null` and route to the
// group info screen.
Future<void> _pushChannelInfo(BuildContext context, Channel channel, User? user) {
  final router = GoRouter.of(context);

  if (user != null) {
    return router.pushNamed(
      Routes.CHAT_INFO_SCREEN.name,
      pathParameters: Routes.CHAT_INFO_SCREEN.params(channel),
      extra: user,
    );
  }

  return router.pushNamed(
    Routes.GROUP_INFO_SCREEN.name,
    pathParameters: Routes.GROUP_INFO_SCREEN.params(channel),
  );
}

// Shows a confirmation dialog before removing the current user from the
// channel. Leave is only surfaced for group channels in the detail sheet,
// so the copy is group-specific here.
Future<void> _maybeLeaveChannel(BuildContext context, Channel channel) async {
  final currentUserId = StreamChat.of(context).currentUser?.id;
  if (currentUserId == null) return;

  final confirmed = await _showConfirmationDialog(
    context: context,
    title: 'Leave group',
    content: 'Are you sure you want to leave this group?',
    confirmLabel: 'Leave',
  );

  if (confirmed != true) return;
  await channel.removeMembers([currentUserId]);
}

// Shows a confirmation dialog before deleting the channel. On success, pops
// the channel page if currently visible (e.g. when invoked from inside a
// channel route).
Future<void> _maybeDeleteChannel(BuildContext context, Channel channel) async {
  final router = GoRouter.of(context);
  final subject = channel.isOneToOne ? 'conversation' : 'group';

  final confirmed = await _showConfirmationDialog(
    context: context,
    title: 'Delete ${subject.toLowerCase()}',
    content: 'Are you sure you want to delete this $subject?',
    confirmLabel: 'Delete',
  );

  if (confirmed != true) return;
  await channel.delete();
  if (router.canPop()) router.pop();
}

class _ChannelListSearch extends StatelessWidget {
  const _ChannelListSearch(this.messageSearchListController);

  final StreamMessageSearchListController messageSearchListController;

  @override
  Widget build(BuildContext context) {
    return StreamMessageSearchListView(
      controller: messageSearchListController,
      emptyBuilder: (_) {
        return LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Icon(
                          context.streamIcons.search,
                          size: 96,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        'No results...',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      itemBuilder: (context, messageResponses, index, defaultWidget) {
        final messageResponse = messageResponses[index];

        return defaultWidget.copyWith(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final client = StreamChat.of(context).client;
            final router = GoRouter.of(context);
            final message = messageResponse.message;
            final channel = client.channel(
              messageResponse.channel!.type,
              id: messageResponse.channel!.id,
            );
            if (channel.state == null) {
              await channel.watch();
            }
            router.pushNamed(
              Routes.CHANNEL_PAGE.name,
              pathParameters: Routes.CHANNEL_PAGE.params(channel),
              queryParameters: Routes.CHANNEL_PAGE.queryParams(message),
            );
          },
        );
      },
    );
  }
}

// Shows a Stream-styled confirmation [AlertDialog] with a destructive
// primary action — used by the leave / delete handlers above.
//
// Resolves to `true` when the user taps confirm, `false` when they tap
// cancel, and `null` if the dialog is dismissed without a choice.
Future<bool?> _showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmLabel,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => _ConfirmationDialog(
      title: title,
      content: content,
      confirmLabel: confirmLabel,
    ),
  );
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
  });

  final String title;
  final String content;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.backgroundElevation1,
      title: Text(title),
      content: Text(content),
      actions: [
        StreamButton(
          type: .ghost,
          style: .secondary,
          size: .small,
          onPressed: () => Navigator.of(context).maybePop(false),
          child: Text(context.translations.cancelLabel),
        ),
        StreamButton(
          type: .solid,
          style: .destructive,
          size: .small,
          onPressed: () => Navigator.of(context).maybePop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/pages/chat_info_screen.dart';
import 'package:sample_app/pages/group_info_screen.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:sample_app/widgets/search_text_field.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});

  @override
  State<ChannelList> createState() => _ChannelList();
}

class _ChannelList extends State<ChannelList> {
  final ScrollController _scrollController = ScrollController();

  late final StreamMessageSearchListController _messageSearchListController = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
    limit: 5,
    searchQuery: '',
    sort: [
      const SortOption.desc(ChannelSortKey.pinnedAt),
      const SortOption.asc(ChannelSortKey.createdAt),
    ],
  );

  late final TextEditingController _controller = TextEditingController()..addListener(_channelQueryListener);

  bool _isSearchActive = false;

  Timer? _debounce;

  void _channelQueryListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        _messageSearchListController.searchQuery = _controller.text;
        setState(() {
          _isSearchActive = _controller.text.isNotEmpty;
        });
        if (_isSearchActive) _messageSearchListController.doInitialLoad();
      }
    });
  }

  late final _channelListController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
    channelStateSort: [
      const SortOption.desc(
        ChannelSortKey.pinnedAt,
        nullOrdering: NullOrdering.nullsLast,
      ),
      const SortOption.desc(ChannelSortKey.lastUpdated),
    ],
    limit: 30,
  );

  @override
  void dispose() {
    _controller.removeListener(_channelQueryListener);
    _controller.dispose();
    _scrollController.dispose();
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
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: SearchTextField(
                controller: _controller,
                showCloseButton: _isSearchActive,
                hintText: AppLocalizations.of(context).search,
              ),
            ),
          ],
          body: _isSearchActive
              ? _ChannelListSearch(_messageSearchListController)
              : _ChannelListDefault(_channelListController),
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
            final chatTheme = StreamChatTheme.of(context);
            final channel = channels[index];
            final backgroundColor = chatTheme.colorTheme.inputBg;
            final canDeleteChannel = channel.canDeleteChannel;
            return Slidable(
              groupTag: 'channels-actions',
              endActionPane: ActionPane(
                extentRatio: canDeleteChannel ? 0.40 : 0.20,
                motion: const BehindMotion(),
                children: [
                  CustomSlidableAction(
                    backgroundColor: backgroundColor,
                    onPressed: (_) {
                      showChannelInfoModalBottomSheet(
                        context: context,
                        channel: channel,
                        onViewInfoTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                final isOneToOne = channel.memberCount == 2 && channel.isDistinct;
                                return StreamChannel(
                                  channel: channel,
                                  child: isOneToOne
                                      ? ChatInfoScreen(
                                          messageTheme: chatTheme.ownMessageTheme,
                                          user: channel.state!.members
                                              .where((m) => m.userId != channel.client.state.currentUser!.id)
                                              .first
                                              .user,
                                        )
                                      : GroupInfoScreen(
                                          messageTheme: chatTheme.ownMessageTheme,
                                        ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.more_horiz),
                  ),
                  if (canDeleteChannel)
                    CustomSlidableAction(
                      backgroundColor: backgroundColor,
                      child: StreamSvgIcon(
                        icon: StreamSvgIcons.delete,
                        color: chatTheme.colorTheme.accentError,
                      ),
                      onPressed: (_) async {
                        final res = await showConfirmationBottomSheet(
                          context,
                          title: 'Delete Conversation',
                          question: 'Are you sure you want to delete this conversation?',
                          okText: 'Delete',
                          cancelText: 'Cancel',
                          icon: StreamSvgIcon(
                            icon: StreamSvgIcons.delete,
                            color: chatTheme.colorTheme.accentError,
                          ),
                        );
                        if (res == true) {
                          await channelListController.deleteChannel(channel);
                        }
                      },
                    ),
                ],
              ),
              child: ColoredBox(
                color: channel.isPinned ? chatTheme.colorTheme.highlight : Colors.transparent,
                child: defaultWidget,
              ),
            );
          },
          onChannelTap: (channel) {
            GoRouter.of(context).pushNamed(
              Routes.CHANNEL_PAGE.name,
              pathParameters: Routes.CHANNEL_PAGE.params(channel),
            );
          },
          emptyBuilder: (_) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamScrollViewEmptyWidget(
                  emptyIcon: StreamSvgIcon(
                    icon: StreamSvgIcons.message,
                    size: 148,
                    color: StreamChatTheme.of(context).colorTheme.disabled,
                  ),
                  emptyTitle: TextButton(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(Routes.NEW_CHAT.name);
                    },
                    child: Text(
                      'Start a chat',
                      style: StreamChatTheme.of(context).textTheme.bodyBold.copyWith(
                        color: StreamChatTheme.of(context).colorTheme.accentPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
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
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: StreamSvgIcon(
                          icon: StreamSvgIcons.search,
                          size: 96,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).noResults,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      itemBuilder:
          (
            context,
            messageResponses,
            index,
            defaultWidget,
          ) {
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

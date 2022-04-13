import 'dart:async';

import 'package:example/localizations.dart';
import 'package:example/routes/routes.dart';
import 'package:example/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';
import 'chat_info_screen.dart';
import 'group_info_screen.dart';

class ChannelList extends StatefulWidget {
  @override
  _ChannelList createState() => _ChannelList();
}

class _ChannelList extends State<ChannelList> {
  ScrollController _scrollController = ScrollController();

  TextEditingController? _controller;

  String _channelQuery = '';

  bool _isSearchActive = false;

  Timer? _debounce;

  void _channelQueryListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _channelQuery = _controller!.text;
          _isSearchActive = _channelQuery.isNotEmpty;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_channelQueryListener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_channelQueryListener);
    _controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).currentUser;
    return WillPopScope(
      onWillPop: () async {
        if (_isSearchActive) {
          _controller!.clear();
          setState(() => _isSearchActive = false);
          return false;
        }
        return true;
      },
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            FocusScope.of(context).unfocus();
          }
          return true;
        },
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: false,
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
              ? StreamMessageSearchListView(
                  showErrorTile: true,
                  messageQuery: _channelQuery,
                  filters: Filter.in_('members', [user!.id]),
                  sortOptions: [
                    SortOption(
                      'created_at',
                      direction: SortOption.ASC,
                    ),
                  ],
                  pullToRefresh: false,
                  limit: 30,
                  emptyBuilder: (_) {
                    return LayoutBuilder(
                      builder: (context, viewportConstraints) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: StreamSvgIcon.search(
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
                  onItemTap: (messageResponse) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final client = StreamChat.of(context).client;
                    final message = messageResponse.message;
                    final channel = client.channel(
                      messageResponse.channel!.type,
                      id: messageResponse.channel!.id,
                    );
                    if (channel.state == null) {
                      await channel.watch();
                    }
                    Navigator.pushNamed(
                      context,
                      Routes.CHANNEL_PAGE,
                      arguments: ChannelPageArgs(
                        channel: channel,
                        initialMessage: message,
                      ),
                    );
                  },
                )
              : ChannelListView(
                  onChannelTap: (channel, _) {
                    Navigator.pushNamed(
                      context,
                      Routes.CHANNEL_PAGE,
                      arguments: ChannelPageArgs(
                        channel: channel,
                      ),
                    );
                  },
                  onStartChatPressed: () {
                    Navigator.pushNamed(context, Routes.NEW_CHAT);
                  },
                  swipeToAction: true,
                  filter: Filter.in_('members', [user!.id]),
                  presence: true,
                  limit: 30,
                  onViewInfoTap: (channel) {
                    Navigator.pop(context);
                    if (channel.memberCount == 2 && channel.isDistinct) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamChannel(
                            channel: channel,
                            child: ChatInfoScreen(
                              messageTheme:
                                  StreamChatTheme.of(context).ownMessageTheme,
                              user: channel.state!.members
                                  .where((m) =>
                                      m.userId !=
                                      channel.client.state.currentUser!.id)
                                  .first
                                  .user,
                            ),
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamChannel(
                            channel: channel,
                            child: GroupInfoScreen(
                              messageTheme:
                                  StreamChatTheme.of(context).ownMessageTheme,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'chips_input_text_field.dart';
import 'main.dart';
import 'new_group_chat_screen.dart';
import 'routes/routes.dart';

class NewChatScreen extends StatefulWidget {
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _chipInputTextFieldStateKey =
      GlobalKey<ChipInputTextFieldState<User>>();

  TextEditingController _controller;

  ChipInputTextFieldState get _chipInputTextFieldState =>
      _chipInputTextFieldStateKey.currentState;

  String _userNameQuery = '';

  final _selectedUsers = <User>{};

  final _searchFocusNode = FocusNode();
  final _messageInputFocusNode = FocusNode();

  bool _isSearchActive = false;

  Channel channel;

  Timer _debounce;

  bool _showUserList = true;

  bool _channelExisted = false;

  void _userNameListener() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted)
        setState(() {
          _userNameQuery = _controller.text;
          _isSearchActive = _userNameQuery.isNotEmpty;
        });
    });
  }

  @override
  void initState() {
    super.initState();
    channel = StreamChat.of(context).client.channel('messaging');
    _controller = TextEditingController()..addListener(_userNameListener);

    _searchFocusNode.addListener(() async {
      if (_searchFocusNode.hasFocus && !_showUserList) {
        setState(() {
          _showUserList = true;
        });
      }
    });

    _messageInputFocusNode.addListener(() async {
      if (_messageInputFocusNode.hasFocus && _selectedUsers.isNotEmpty) {
        final chatState = StreamChat.of(context);

        final res = await chatState.client.queryChannels(
          options: {
            'state': false,
            'watch': false,
          },
          filter: {
            'members': [
              ..._selectedUsers.map((e) => e.id),
              chatState.user.id,
            ],
            'distinct': true,
          },
          messageLimit: 0,
          paginationParams: PaginationParams(
            limit: 1,
          ),
        );

        final _channelExisted = res.length == 1;
        if (_channelExisted) {
          channel = res.first;
          await channel.watch();
        } else {
          channel = chatState.client.channel(
            'messaging',
            extraData: {
              'members': [
                ..._selectedUsers.map((e) => e.id),
                chatState.user.id,
              ],
            },
          );
        }

        setState(() {
          _showUserList = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _messageInputFocusNode.dispose();
    _controller?.clear();
    _controller?.removeListener(_userNameListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(252, 252, 252, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const StreamBackButton(),
        title: Text(
          'New Chat',
          style: StreamChatTheme.of(context)
              .textTheme
              .headlineBold
              .copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: StreamChannel(
        showLoading: false,
        channel: channel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChipsInputTextField<User>(
              key: _chipInputTextFieldStateKey,
              controller: _controller,
              focusNode: _searchFocusNode,
              chipBuilder: (context, user) {
                return GestureDetector(
                  onTap: () {
                    _chipInputTextFieldState.removeItem(user);
                    _searchFocusNode.requestFocus();
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.only(left: 24),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                          child: Text(
                            user.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: .8,
                        child: UserAvatar(
                          showOnlineStatus: false,
                          user: user,
                          constraints: BoxConstraints.tightFor(
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                      Positioned(
                        child: StreamSvgIcon.close(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
              onChipAdded: (user) {
                setState(() => _selectedUsers.add(user));
              },
              onChipRemoved: (user) {
                setState(() => _selectedUsers.remove(user));
              },
            ),
            if (!_isSearchActive && !_selectedUsers.isNotEmpty)
              Container(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.NEW_GROUP_CHAT,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        StreamNeumorphicButton(
                          child: Center(
                            child: StreamSvgIcon.contacts(
                              color: Color(0xFF006CFF),
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Create a Group',
                          style: StreamChatTheme.of(context).textTheme.bodyBold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_showUserList)
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.02),
                      Colors.white.withOpacity(0.05),
                    ],
                    stops: [0, 1],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Text(
                      _isSearchActive
                          ? "Matches for \"$_userNameQuery\""
                          : 'On the platform',
                      style: StreamChatTheme.of(context)
                          .textTheme
                          .footnote
                          .copyWith(color: Colors.black.withOpacity(.5))),
                ),
              ),
            Expanded(
              child: _showUserList
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanDown: (_) => FocusScope.of(context).unfocus(),
                      child: UsersBloc(
                        child: UserListView(
                          selectedUsers: _selectedUsers,
                          groupAlphabetically: _isSearchActive ? false : true,
                          onUserTap: (user, _) {
                            _controller.clear();
                            if (!_selectedUsers.contains(user)) {
                              _chipInputTextFieldState
                                ..addItem(user)
                                ..pauseItemAddition();
                            } else {
                              _chipInputTextFieldState.removeItem(user);
                            }
                          },
                          pagination: PaginationParams(
                            limit: 25,
                          ),
                          filter: {
                            if (_userNameQuery.isNotEmpty)
                              'name': {
                                r'$autocomplete': _userNameQuery,
                              },
                            'id': {
                              r'$ne': StreamChat.of(context).user.id,
                            },
                          },
                          sort: [
                            SortOption(
                              'name',
                              direction: 1,
                            ),
                          ],
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
                                            'No user matches these keywords...',
                                            style: StreamChatTheme.of(context)
                                                .textTheme
                                                .footnote
                                                .copyWith(
                                                    color: Colors.black
                                                        .withOpacity(.5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                  : FutureBuilder<bool>(
                      future: channel.initialized,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return MessageListView();
                        }

                        return Center(
                          child: Text(
                            'No chats here yet...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            MessageInput(
              focusNode: _messageInputFocusNode,
              preMessageSending: (message) async {
                await channel.watch();
                return message;
              },
              onMessageSent: (m) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.CHANNEL_PAGE,
                  ModalRoute.withName(Routes.HOME),
                  arguments: ChannelPageArgs(channel: channel),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:example/localizations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';
import 'chips_input_text_field.dart';
import 'routes/routes.dart';

class NewChatScreen extends StatefulWidget {
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _chipInputTextFieldStateKey =
      GlobalKey<ChipInputTextFieldState<User>>();

  late TextEditingController _controller;

  ChipInputTextFieldState? get _chipInputTextFieldState =>
      _chipInputTextFieldStateKey.currentState;

  String _userNameQuery = '';

  final _selectedUsers = <User>{};

  final _searchFocusNode = FocusNode();
  final _messageInputFocusNode = FocusNode();

  bool _isSearchActive = false;

  Channel? channel;

  Timer? _debounce;

  bool _showUserList = true;

  void _userNameListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
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

        final res = await chatState.client.queryChannelsOnline(
          state: false,
          watch: false,
          filter: Filter.raw(value: {
            'members': [
              ..._selectedUsers.map((e) => e.id),
              chatState.currentUser!.id,
            ],
            'distinct': true,
          }),
          messageLimit: 0,
          paginationParams: PaginationParams(
            limit: 1,
          ),
        );

        final _channelExisted = res.length == 1;
        if (_channelExisted) {
          channel = res.first;
          await channel!.watch();
        } else {
          channel = chatState.client.channel(
            'messaging',
            extraData: {
              'members': [
                ..._selectedUsers.map((e) => e.id),
                chatState.currentUser!.id,
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
    _controller.clear();
    _controller.removeListener(_userNameListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
        leading: const StreamBackButton(),
        title: Text(
          AppLocalizations.of(context).newChat,
          style: StreamChatTheme.of(context).textTheme.headlineBold.copyWith(
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis),
        ),
        centerTitle: true,
      ),
      body: ConnectionStatusBuilder(
        statusBuilder: (context, status) {
          String statusString = '';
          bool showStatus = true;

          switch (status) {
            case ConnectionStatus.connected:
              statusString = AppLocalizations.of(context).connected;
              showStatus = false;
              break;
            case ConnectionStatus.connecting:
              statusString = AppLocalizations.of(context).reconnecting;
              break;
            case ConnectionStatus.disconnected:
              statusString = AppLocalizations.of(context).disconnected;
              break;
          }
          return InfoTile(
            showMessage: showStatus,
            tileAnchor: Alignment.topCenter,
            childAnchor: Alignment.topCenter,
            message: statusString,
            child: StreamChannel(
              showLoading: false,
              channel: channel!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChipsInputTextField<User>(
                    key: _chipInputTextFieldStateKey,
                    controller: _controller,
                    focusNode: _searchFocusNode,
                    hint: AppLocalizations.of(context).typeANameHint,
                    chipBuilder: (context, user) {
                      return GestureDetector(
                        onTap: () {
                          _chipInputTextFieldState?.removeItem(user);
                          _searchFocusNode.requestFocus();
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .disabled,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.only(left: 24),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                                child: Text(
                                  user.name,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: StreamChatTheme.of(context)
                                        .colorTheme
                                        .textHighEmphasis,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              foregroundDecoration: BoxDecoration(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .overlay,
                                shape: BoxShape.circle,
                              ),
                              child: UserAvatar(
                                showOnlineStatus: false,
                                user: user,
                                constraints: BoxConstraints.tightFor(
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                            ),
                            StreamSvgIcon.close(),
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
                                    color: StreamChatTheme.of(context)
                                        .colorTheme
                                        .accentPrimary,
                                    size: 24,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context).createAGroup,
                                style: StreamChatTheme.of(context)
                                    .textTheme
                                    .bodyBold,
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
                        gradient:
                            StreamChatTheme.of(context).colorTheme.bgGradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Text(
                            _isSearchActive
                                ? '${AppLocalizations.of(context).matchesFor} "$_userNameQuery"'
                                : AppLocalizations.of(context).onThePlatorm,
                            style: StreamChatTheme.of(context)
                                .textTheme
                                .footnote
                                .copyWith(
                                    color: StreamChatTheme.of(context)
                                        .colorTheme
                                        .textHighEmphasis
                                        .withOpacity(.5))),
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
                                groupAlphabetically:
                                    _isSearchActive ? false : true,
                                onUserTap: (user, _) {
                                  _controller.clear();
                                  if (!_selectedUsers.contains(user)) {
                                    _chipInputTextFieldState
                                      ?..addItem(user)
                                      ..pauseItemAddition();
                                  } else {
                                    _chipInputTextFieldState!.removeItem(user);
                                  }
                                },
                                limit: 25,
                                filter: Filter.and([
                                  if (_userNameQuery.isNotEmpty)
                                    Filter.autoComplete('name', _userNameQuery),
                                  Filter.notEqual('id',
                                      StreamChat.of(context).currentUser!.id),
                                ]),
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
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight:
                                                viewportConstraints.maxHeight,
                                          ),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(24),
                                                  child: StreamSvgIcon.search(
                                                    size: 96,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .noUserMatchesTheseKeywords,
                                                  style: StreamChatTheme.of(
                                                          context)
                                                      .textTheme
                                                      .footnote
                                                      .copyWith(
                                                          color: StreamChatTheme
                                                                  .of(context)
                                                              .colorTheme
                                                              .textHighEmphasis
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
                            future: channel!.initialized,
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return MessageListView();
                              }

                              return Center(
                                child: Text(
                                  AppLocalizations.of(context).noChatsHereYet,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: StreamChatTheme.of(context)
                                        .colorTheme
                                        .textHighEmphasis
                                        .withOpacity(.5),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  MessageInput(
                    focusNode: _messageInputFocusNode,
                    preMessageSending: (message) async {
                      await channel!.watch();
                      return message;
                    },
                    onMessageSent: (m) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.CHANNEL_PAGE,
                        ModalRoute.withName(Routes.CHANNEL_LIST_PAGE),
                        arguments: ChannelPageArgs(channel: channel),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

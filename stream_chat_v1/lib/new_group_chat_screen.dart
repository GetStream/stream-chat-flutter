import 'dart:async';

import 'package:example/localizations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'routes/routes.dart';
import 'search_text_field.dart';

class NewGroupChatScreen extends StatefulWidget {
  @override
  _NewGroupChatScreenState createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends State<NewGroupChatScreen> {
  TextEditingController? _controller;

  String _userNameQuery = '';

  final _selectedUsers = <User>{};

  bool _isSearchActive = false;

  Timer? _debounce;

  late final userListController = StreamUserListController(
    client: StreamChat.of(context).client,
    sort: [
      SortOption(
        'name',
        direction: 1,
      ),
    ],
    limit: 25,
    filter: Filter.and([
      Filter.notEqual('id', StreamChat.of(context).currentUser!.id),
    ]),
  );

  void _userNameListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _userNameQuery = _controller!.text;
          _isSearchActive = _userNameQuery.isNotEmpty;
        });
        userListController.filter = Filter.and([
          if (_userNameQuery.isNotEmpty)
            Filter.autoComplete('name', _userNameQuery),
          Filter.notEqual('id', StreamChat.of(context).currentUser!.id),
        ]);
        userListController.doInitialLoad();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_userNameListener);
  }

  @override
  void dispose() {
    _controller?.clear();
    _controller?.removeListener(_userNameListener);
    _controller?.dispose();
    userListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
        leading: const StreamBackButton(),
        title: Text(
          AppLocalizations.of(context).addGroupMembers,
          style: TextStyle(
            color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedUsers.isNotEmpty)
            IconButton(
              icon: StreamSvgIcon.arrowRight(
                color: StreamChatTheme.of(context).colorTheme.accentPrimary,
              ),
              onPressed: () async {
                final updatedList = await Navigator.pushNamed(
                  context,
                  Routes.NEW_GROUP_CHAT_DETAILS,
                  arguments: _selectedUsers.toList(growable: false),
                );
                if (updatedList != null) {
                  setState(() {
                    _selectedUsers
                      ..clear()
                      ..addAll(updatedList as Iterable<User>);
                  });
                }
              },
            )
        ],
      ),
      body: StreamConnectionStatusBuilder(
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
          return StreamInfoTile(
            showMessage: showStatus,
            tileAnchor: Alignment.topCenter,
            childAnchor: Alignment.topCenter,
            message: statusString,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: SearchTextField(
                      controller: _controller,
                      hintText: AppLocalizations.of(context).search,
                    ),
                  ),
                  if (_selectedUsers.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 104,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedUsers.length,
                          padding: const EdgeInsets.all(8),
                          separatorBuilder: (_, __) => SizedBox(width: 16),
                          itemBuilder: (_, index) {
                            final user = _selectedUsers.elementAt(index);
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    StreamUserAvatar(
                                      onlineIndicatorAlignment:
                                          Alignment(0.9, 0.9),
                                      user: user,
                                      showOnlineStatus: true,
                                      borderRadius: BorderRadius.circular(32),
                                      constraints: BoxConstraints.tightFor(
                                        height: 64,
                                        width: 64,
                                      ),
                                    ),
                                    Positioned(
                                      top: -4,
                                      right: -4,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_selectedUsers.contains(user)) {
                                            setState(() =>
                                                _selectedUsers.remove(user));
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: StreamChatTheme.of(context)
                                                .colorTheme
                                                .appBg,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: StreamChatTheme.of(context)
                                                  .colorTheme
                                                  .appBg,
                                            ),
                                          ),
                                          child: StreamSvgIcon.close(
                                            color: StreamChatTheme.of(context)
                                                .colorTheme
                                                .textHighEmphasis,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user.name.split(' ')[0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _HeaderDelegate(
                      height: 30,
                      child: Container(
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
                                ? '${AppLocalizations.of(context).matchesFor} \"$_userNameQuery\"'
                                : AppLocalizations.of(context).onThePlatorm,
                            style: TextStyle(
                              color: StreamChatTheme.of(context)
                                  .colorTheme
                                  .textLowEmphasis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) => FocusScope.of(context).unfocus(),
                child: StreamUserListView(
                  controller: userListController,
                  // groupAlphabetically: _isSearchActive ? false : true,
                  itemBuilder: (context, items, index, defaultWidget) {
                    return defaultWidget.copyWith(
                      selected: _selectedUsers.contains(items[index]),
                    );
                  },
                  onUserTap: (user) {
                    if (!_selectedUsers.contains(user)) {
                      setState(() {
                        _selectedUsers.add(user);
                      });
                    } else {
                      setState(() {
                        _selectedUsers.remove(user);
                      });
                    }
                  },
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
                                      color: StreamChatTheme.of(context)
                                          .colorTheme
                                          .textLowEmphasis,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .noUserMatchesTheseKeywords,
                                    style: StreamChatTheme.of(context)
                                        .textTheme
                                        .footnote
                                        .copyWith(
                                          color: StreamChatTheme.of(context)
                                              .colorTheme
                                              .textLowEmphasis,
                                        ),
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
            ),
          );
        },
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _HeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: StreamChatTheme.of(context).colorTheme.barsBg,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) => true;
}

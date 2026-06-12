import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/new_group_chat_state.dart';
import 'package:sample_app/widgets/search_text_field.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NewGroupChatScreen extends StatefulWidget {
  const NewGroupChatScreen({super.key});

  @override
  State<NewGroupChatScreen> createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends State<NewGroupChatScreen> {
  late final TextEditingController _controller = TextEditingController()..addListener(_userNameListener);

  String _userNameQuery = '';

  final groupChatState = NewGroupChatState();

  bool _isSearchActive = false;

  Timer? _debounce;

  late final userListController = StreamUserListController(
    client: StreamChat.of(context).client,
    sort: [const SortOption.asc('name')],
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
          _userNameQuery = _controller.text;
          _isSearchActive = _userNameQuery.isNotEmpty;
        });
        userListController.filter = Filter.and([
          if (_userNameQuery.isNotEmpty) Filter.autoComplete('name', _userNameQuery),
          Filter.notEqual('id', StreamChat.of(context).currentUser!.id),
        ]);
        userListController.doInitialLoad();
      }
    });
  }

  @override
  void dispose() {
    _controller.clear();
    _controller.removeListener(_userNameListener);
    _controller.dispose();
    userListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: groupChatState,
      builder: (context, child) {
        final state = groupChatState;
        return StreamScaffold(
          backgroundColor: context.streamColorScheme.backgroundApp,
          appBar: StreamAppBar(
            title: const Text('Add Group Members'),
            trailing: switch (state.users.isNotEmpty) {
              true => StreamButton.icon(
                icon: Icon(context.streamIcons.arrowRight),
                onPressed: () async {
                  GoRouter.of(context).pushNamed(
                    Routes.NEW_GROUP_CHAT_DETAILS.name,
                    extra: state,
                  );
                },
              ),
              false => null,
            },
          ),
          body: StreamConnectionStatusBuilder(
            statusBuilder: (context, status) {
              var statusString = '';
              var showStatus = true;

              switch (status) {
                case ConnectionStatus.connected:
                  statusString = 'Connected';
                  showStatus = false;
                  break;
                case ConnectionStatus.connecting:
                  statusString = 'Reconnecting...';
                  break;
                case ConnectionStatus.disconnected:
                  statusString = 'Disconnected';
                  break;
              }
              return StreamInfoTile(
                showMessage: showStatus,
                tileAnchor: Alignment.topCenter,
                childAnchor: Alignment.topCenter,
                message: statusString,
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    final topInset = StreamScaffoldInsets.maybeOf(context)?.topPadding ?? 0.0;
                    return <Widget>[
                      if (topInset > 0) SliverToBoxAdapter(child: SizedBox(height: topInset)),
                      SliverToBoxAdapter(
                        child: SearchTextField(
                          controller: _controller,
                          hintText: 'Search',
                        ),
                      ),
                      if (state.users.isNotEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 104,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.users.length,
                              padding: const EdgeInsets.all(8),
                              separatorBuilder: (_, __) => const SizedBox(width: 16),
                              itemBuilder: (_, index) {
                                final user = state.users.elementAt(index);
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        StreamUserAvatar(
                                          size: .xl,
                                          user: user,
                                        ),
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: GestureDetector(
                                            onTap: () {
                                              groupChatState.removeUser(user);
                                            },
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: context.streamColorScheme.backgroundApp,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: context.streamColorScheme.backgroundApp,
                                                ),
                                              ),
                                              child: Icon(
                                                context.streamIcons.xmark,
                                                color: context.streamColorScheme.textPrimary,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.name.split(' ')[0],
                                      style: const TextStyle(
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
                          height: 32,
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: context.streamColorScheme.backgroundElevation1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: Text(
                                _isSearchActive ? 'Matches for "$_userNameQuery"' : 'On the platform',
                                style: TextStyle(
                                  color: context.streamColorScheme.textSecondary,
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
                      itemBuilder: (context, items, index, defaultWidget) {
                        return defaultWidget.copyWith(
                          selected: state.users.contains(items[index]),
                        );
                      },
                      onUserTap: groupChatState.addOrRemoveUser,
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
                                          color: context.streamColorScheme.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        'No user matches these keywords...',
                                        style: context.streamTextTheme.captionDefault.copyWith(
                                          color: context.streamColorScheme.textSecondary,
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
      },
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HeaderDelegate({
    required this.child,
    required this.height,
  });
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: context.streamColorScheme.backgroundElevation1,
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

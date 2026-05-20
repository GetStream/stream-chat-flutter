// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/new_group_chat_state.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GroupChatDetailsScreen extends StatefulWidget {
  const GroupChatDetailsScreen({
    super.key,
    required this.groupChatState,
  });
  final NewGroupChatState groupChatState;

  @override
  State<GroupChatDetailsScreen> createState() => _GroupChatDetailsScreenState();
}

class _GroupChatDetailsScreenState extends State<GroupChatDetailsScreen> {
  late final TextEditingController _groupNameController = TextEditingController()..addListener(_groupNameListener);

  bool _isGroupNameEmpty = true;

  int get _totalUsers => widget.groupChatState.users.length;

  void _groupNameListener() {
    final name = _groupNameController.text;
    if (mounted) {
      setState(() {
        _isGroupNameEmpty = name.isEmpty;
      });
    }
  }

  @override
  void dispose() {
    _groupNameController.removeListener(_groupNameListener);
    _groupNameController.clear();
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        GoRouter.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: context.streamColorScheme.backgroundApp,
        appBar: StreamAppBar(
          title: const Text('Name of Group Chat'),
          trailing: StreamButton.icon(
            icon: Icon(context.streamIcons.checkmark),
            onPressed: _isGroupNameEmpty
                ? null
                : () async {
                    try {
                      final groupName = _groupNameController.text;
                      final client = StreamChat.of(context).client;
                      final router = GoRouter.of(context);
                      final channel = client.channel(
                        'messaging',
                        id: const Uuid().v4(),
                        extraData: {
                          'members': [
                            client.state.currentUser!.id,
                            ...widget.groupChatState.users.map((e) => e.id),
                          ],
                          'name': groupName,
                        },
                      );
                      await channel.watch();
                      router.goNamed(
                        Routes.CHANNEL_PAGE.name,
                        pathParameters: Routes.CHANNEL_PAGE.params(channel),
                      );
                    } catch (err) {
                      _showErrorAlert();
                    }
                  },
          ),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Name'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: context.streamColorScheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _groupNameController,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Choose a group chat name',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: context.streamColorScheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                        '$_totalUsers ${_totalUsers > 1 ? 'Members' : 'Member'}',
                        style: TextStyle(
                          color: context.streamColorScheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: widget.groupChatState,
                    builder: (context, child) {
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanDown: (_) => FocusScope.of(context).unfocus(),
                          child: ListView.separated(
                            itemCount: widget.groupChatState.users.length + 1,
                            separatorBuilder: (_, __) => Container(
                              height: 1,
                              color: context.streamColorScheme.borderDefault,
                            ),
                            itemBuilder: (_, index) {
                              if (index == widget.groupChatState.users.length) {
                                return Container(
                                  height: 1,
                                  color: context.streamColorScheme.borderDefault,
                                );
                              }
                              final user = widget.groupChatState.users.elementAt(index);
                              return ListTile(
                                key: ObjectKey(user),
                                leading: StreamUserAvatar(
                                  size: .lg,
                                  user: user,
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: context.streamColorScheme.textPrimary,
                                  ),
                                  padding: EdgeInsets.zero,
                                  splashRadius: 24,
                                  onPressed: () {
                                    widget.groupChatState.removeUser(user);
                                    if (widget.groupChatState.users.isEmpty) {
                                      GoRouter.of(context).pop();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showErrorAlert() {
    showModalBottomSheet(
      backgroundColor: context.streamColorScheme.backgroundElevation1,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 26,
            ),
            Icon(
              context.streamIcons.exclamationCircleFill,
              color: context.streamColorScheme.accentError,
              size: 24,
            ),
            const SizedBox(
              height: 26,
            ),
            Text(
              'Something went wrong',
              style: context.streamTextTheme.headingMd,
            ),
            const SizedBox(
              height: 7,
            ),
            const Text("The operation couldn't be completed."),
            const SizedBox(
              height: 36,
            ),
            Container(
              color: context.streamColorScheme.textPrimary.withOpacity(.08),
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: GoRouter.of(context).pop,
                  child: Text(
                    'OK',
                    style: context.streamTextTheme.bodyEmphasis.copyWith(
                      color: context.streamColorScheme.accentPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

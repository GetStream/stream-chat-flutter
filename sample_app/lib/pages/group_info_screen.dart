// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/pages/channel_file_display_screen.dart';
import 'package:sample_app/pages/channel_media_display_screen.dart';
import 'package:sample_app/pages/pinned_messages_screen.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({
    super.key,
    required this.messageTheme,
  });
  final StreamMessageThemeData messageTheme;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  late final TextEditingController _nameController = TextEditingController.fromValue(
    TextEditingValue(text: (channel.extraData['name'] as String?) ?? ''),
  );

  late final TextEditingController _searchController = TextEditingController()..addListener(_userNameListener);

  String _userNameQuery = '';

  Timer? _debounce;
  Function? modalSetStateCallback;

  final FocusNode _focusNode = FocusNode();

  bool listExpanded = false;

  late ValueNotifier<bool?> mutedBool = ValueNotifier(channel.isMuted);

  late ValueNotifier<bool?> isPinned = ValueNotifier(channel.isPinned);

  late ValueNotifier<bool?> isArchived = ValueNotifier(channel.isArchived);

  late final channel = StreamChannel.of(context).channel;

  late StreamUserListController _userListController;

  void _userNameListener() {
    if (_searchController.text == _userNameQuery) {
      return;
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        _userNameQuery = _searchController.text;
        _userListController.filter = Filter.and(
          [
            if (_searchController.text.isNotEmpty) Filter.autoComplete('name', _userNameQuery),
            Filter.notIn('id', [
              StreamChat.of(context).currentUser!.id,
              ...channel.state!.members.map<String?>((e) => e.userId).whereType<String>(),
            ]),
          ],
        );
        _userListController.doInitialLoad();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      setState(() {});
    });
    mutedBool = ValueNotifier(channel.isMuted);
  }

  @override
  void didChangeDependencies() {
    _userListController = StreamUserListController(
      client: StreamChat.of(context).client,
      limit: 25,
      filter: Filter.and(
        [
          if (_searchController.text.isNotEmpty) Filter.autoComplete('name', _userNameQuery),
          Filter.notIn('id', [
            StreamChat.of(context).currentUser!.id,
            ...channel.state!.members.map<String?>((e) => e.userId).whereType<String>(),
          ]),
        ],
      ),
      sort: [
        const SortOption.asc(UserSortKey.name),
      ],
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    _userListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Member>>(
      stream: channel.state!.membersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ColoredBox(
            color: StreamChatTheme.of(context).colorTheme.disabled,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
          appBar: AppBar(
            elevation: 1,
            toolbarHeight: 56,
            backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
            leading: const StreamBackButton(),
            title: Column(
              children: [
                StreamBuilder<ChannelState>(
                  stream: channel.state?.channelStateStream,
                  builder: (context, state) {
                    if (!state.hasData) {
                      return Text(
                        AppLocalizations.of(context).loading,
                        style: TextStyle(
                          color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }

                    return Text(
                      _getChannelName(
                        2 * MediaQuery.of(context).size.width / 3,
                        members: snapshot.data,
                        extraData: state.data!.channel!.extraData,
                        maxFontSize: 16,
                      )!,
                      style: TextStyle(
                        color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  '${channel.memberCount} ${AppLocalizations.of(context).members}, ${snapshot.data?.where((e) => e.user!.online).length ?? 0} ${AppLocalizations.of(context).online}',
                  style: TextStyle(
                    color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              if (channel.canUpdateChannelMembers)
                StreamNeumorphicButton(
                  child: InkWell(
                    onTap: () {
                      _buildAddUserModal(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: StreamSvgIcon(
                        icon: StreamSvgIcons.userAdd,
                        color: StreamChatTheme.of(context).colorTheme.accentPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: ListView(
            children: [
              _buildMembers(snapshot.data!),
              Container(
                height: 8,
                color: StreamChatTheme.of(context).colorTheme.disabled,
              ),
              if (channel.canUpdateChannel) _buildNameTile(),
              _buildOptionListTiles(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembers(List<Member> members) {
    final groupMembers = members
      ..sort((prev, curr) {
        if (curr.userId == channel.createdBy?.id) return 1;
        return 0;
      });

    int groupMembersLength;

    if (listExpanded) {
      groupMembersLength = groupMembers.length;
    } else {
      groupMembersLength = groupMembers.length > 6 ? 6 : groupMembers.length;
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groupMembersLength,
          itemBuilder: (context, index) {
            final member = groupMembers[index];
            return Material(
              color: StreamChatTheme.of(context).colorTheme.appBg,
              child: InkWell(
                onTap: () {
                  final userMember = groupMembers.firstWhereOrNull(
                    (e) => e.user!.id == StreamChat.of(context).currentUser!.id,
                  );
                  _showUserInfoModal(member.user, userMember?.userId == channel.createdBy?.id);
                },
                child: SizedBox(
                  height: 65,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            child: StreamUserAvatar(
                              user: member.user!,
                              constraints: const BoxConstraints.tightFor(
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  member.user!.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  _getLastSeen(member.user!),
                                  style: TextStyle(
                                    color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              member.userId == channel.createdBy?.id ? AppLocalizations.of(context).owner : '',
                              style: TextStyle(
                                color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: StreamChatTheme.of(context).colorTheme.disabled,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (groupMembersLength != groupMembers.length)
          InkWell(
            onTap: () {
              setState(() {
                listExpanded = true;
              });
            },
            child: Material(
              color: StreamChatTheme.of(context).colorTheme.appBg,
              child: SizedBox(
                height: 65,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                            child: StreamSvgIcon(
                              icon: StreamSvgIcons.down,
                              color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${members.length - groupMembersLength} ${AppLocalizations.of(context).more}',
                                  style: TextStyle(color: StreamChatTheme.of(context).colorTheme.textLowEmphasis),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: StreamChatTheme.of(context).colorTheme.disabled,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNameTile() {
    final channelName = (channel.extraData['name'] as String?) ?? '';

    return Material(
      color: StreamChatTheme.of(context).colorTheme.appBg,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                AppLocalizations.of(context).name.toUpperCase(),
                style: StreamChatTheme.of(context).textTheme.footnote.copyWith(
                  color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Expanded(
              child: TextField(
                enabled: channel.canUpdateChannel,
                focusNode: _focusNode,
                controller: _nameController,
                cursorColor: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.of(context).addAGroupName,
                  hintStyle: StreamChatTheme.of(context).textTheme.bodyBold.copyWith(
                    color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                  ),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 0.82,
                ),
              ),
            ),
            if (channelName != _nameController.text.trim())
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
                    onPressed: () {
                      setState(() {
                        _nameController.text = _getChannelName(
                          2 * MediaQuery.of(context).size.width / 3,
                          members: channel.state!.members,
                          extraData: channel.extraData,
                          maxFontSize: 16,
                        )!;
                        _focusNode.unfocus();
                      });
                    },
                  ),
                  IconButton(
                    color: StreamChatTheme.of(context).colorTheme.accentPrimary,
                    icon: const StreamSvgIcon(icon: StreamSvgIcons.check),
                    onPressed: () {
                      try {
                        channel.update({
                          'name': _nameController.text.trim(),
                        });
                      } catch (_) {
                        setState(() {
                          _nameController.text = channelName;
                          _focusNode.unfocus();
                        });
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionListTiles() {
    return Column(
      children: [
        if (channel.canMuteChannel)
          _GroupInfoToggle(
            title: AppLocalizations.of(context).muteGroup,
            icon: StreamSvgIcons.mute,
            channelStream: channel.isMutedStream,
            localNotifier: mutedBool,
            onTurnOff: channel.unmute,
            onTurnOn: channel.mute,
          ),
        _GroupInfoToggle(
          title: AppLocalizations.of(context).pinGroup,
          icon: StreamSvgIcons.pin,
          channelStream: channel.isPinnedStream,
          localNotifier: isPinned,
          onTurnOff: channel.unpin,
          onTurnOn: channel.pin,
        ),
        _GroupInfoToggle(
          title: AppLocalizations.of(context).archiveGroup,
          icon: StreamSvgIcons.save,
          channelStream: channel.isArchivedStream,
          localNotifier: isArchived,
          onTurnOff: channel.unarchive,
          onTurnOn: channel.archive,
        ),
        _GroupInfoListTile(
          title: AppLocalizations.of(context).pinnedMessages,
          icon: StreamSvgIcons.pin,
          iconSize: 24,
          iconPadding: 16,
          onTap: () {
            final channel = StreamChannel.of(context).channel;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  channel: channel,
                  child: const PinnedMessagesScreen(),
                ),
              ),
            );
          },
        ),
        _GroupInfoListTile(
          title: AppLocalizations.of(context).photosAndVideos,
          icon: StreamSvgIcons.pictures,
          iconSize: 32,
          iconPadding: 12,
          onTap: () {
            final channel = StreamChannel.of(context).channel;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  channel: channel,
                  child: ChannelMediaDisplayScreen(
                    messageTheme: widget.messageTheme,
                  ),
                ),
              ),
            );
          },
        ),
        _GroupInfoListTile(
          title: AppLocalizations.of(context).files,
          icon: StreamSvgIcons.files,
          iconSize: 32,
          iconPadding: 12,
          onTap: () {
            final channel = StreamChannel.of(context).channel;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  channel: channel,
                  child: ChannelFileDisplayScreen(
                    messageTheme: widget.messageTheme,
                  ),
                ),
              ),
            );
          },
        ),
        if (!channel.isDistinct && channel.canLeaveChannel)
          StreamOptionListTile(
            tileColor: StreamChatTheme.of(context).colorTheme.appBg,
            separatorColor: StreamChatTheme.of(context).colorTheme.disabled,
            title: AppLocalizations.of(context).leaveGroup,
            titleTextStyle: StreamChatTheme.of(context).textTheme.body,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamSvgIcon(
                icon: StreamSvgIcons.userRemove,
                size: 24,
                color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
              ),
            ),
            trailing: const SizedBox(
              height: 24,
              width: 24,
            ),
            onTap: () async {
              final streamChannel = StreamChannel.of(context);
              final streamChat = StreamChat.of(context);
              final router = GoRouter.of(context);
              final res = await showConfirmationBottomSheet(
                context,
                title: AppLocalizations.of(context).leaveConversation,
                okText: AppLocalizations.of(context).leave.toUpperCase(),
                question: AppLocalizations.of(context).leaveConversationAreYouSure,
                cancelText: AppLocalizations.of(context).cancel.toUpperCase(),
                icon: StreamSvgIcon(
                  icon: StreamSvgIcons.userRemove,
                  color: StreamChatTheme.of(context).colorTheme.accentError,
                ),
              );
              if (res == true) {
                final channel = streamChannel.channel;
                await channel.removeMembers([streamChat.currentUser!.id]);
                router.pop();
              }
            },
          ),
      ],
    );
  }

  void _buildAddUserModal(context) {
    showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: StreamChatTheme.of(context).colorTheme.overlay,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildTextInputSection(),
                  ),
                  Expanded(
                    child: StreamUserGridView(
                      controller: _userListController,
                      onUserTap: (user) async {
                        _searchController.clear();
                        final navigator = Navigator.of(context);

                        await channel.addMembers([user.id]);
                        navigator.pop();
                        setState(() {});
                      },
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
                                        child: StreamSvgIcon(
                                          icon: StreamSvgIcons.search,
                                          size: 96,
                                          color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                                        ),
                                      ),
                                      Text(AppLocalizations.of(context).noUserMatchesTheseKeywords),
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
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _searchController.clear();
    });
  }

  Widget _buildTextInputSection() {
    final theme = StreamChatTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _searchController,
              cursorColor: theme.colorTheme.textHighEmphasis,
              autofocus: true,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).search,
                hintStyle: theme.textTheme.body.copyWith(
                  color: theme.colorTheme.textLowEmphasis,
                ),
                prefixIconConstraints: BoxConstraints.tight(const Size(40, 24)),
                prefixIcon: StreamSvgIcon(
                  icon: StreamSvgIcons.search,
                  color: theme.colorTheme.textHighEmphasis,
                  size: 24,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: theme.colorTheme.borders,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: theme.colorTheme.borders,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
          color: theme.colorTheme.textHighEmphasis,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _showUserInfoModal(User? user, bool isUserAdmin) {
    final color = StreamChatTheme.of(context).colorTheme.barsBg;

    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      backgroundColor: color,
      builder: (context) {
        return SafeArea(
          child: StreamChannel(
            channel: channel,
            child: Material(
              color: color,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Text(
                      user!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildConnectedTitleState(user)!,
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: StreamUserAvatar(
                        user: user,
                        constraints: const BoxConstraints.tightFor(
                          height: 64,
                          width: 64,
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  if (StreamChat.of(context).currentUser!.id != user.id)
                    _buildModalListTile(
                      context,
                      StreamSvgIcon(
                        color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                        size: 24,
                        icon: StreamSvgIcons.user,
                      ),
                      AppLocalizations.of(context).viewInfo,
                      () async {
                        final client = StreamChat.of(context).client;
                        final router = GoRouter.of(context);

                        final c = client.channel(
                          'messaging',
                          extraData: {
                            'members': [
                              user.id,
                              StreamChat.of(context).currentUser!.id,
                            ],
                          },
                        );

                        await c.watch();

                        router.pushNamed(
                          Routes.CHAT_INFO_SCREEN.name,
                          pathParameters: Routes.CHAT_INFO_SCREEN.params(c),
                          extra: user,
                        );
                      },
                    ),
                  if (StreamChat.of(context).currentUser!.id != user.id)
                    _buildModalListTile(
                      context,
                      StreamSvgIcon(
                        color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                        size: 24,
                        icon: StreamSvgIcons.message,
                      ),
                      AppLocalizations.of(context).message,
                      () async {
                        final client = StreamChat.of(context).client;
                        final router = GoRouter.of(context);

                        final c = client.channel(
                          'messaging',
                          extraData: {
                            'members': [
                              user.id,
                              StreamChat.of(context).currentUser!.id,
                            ],
                          },
                        );

                        await c.watch();

                        router.pushNamed(
                          Routes.CHANNEL_PAGE.name,
                          pathParameters: Routes.CHANNEL_PAGE.params(c),
                        );
                      },
                    ),
                  if (!channel.isDistinct && StreamChat.of(context).currentUser!.id != user.id && isUserAdmin)
                    _buildModalListTile(
                      context,
                      StreamSvgIcon(
                        color: StreamChatTheme.of(context).colorTheme.accentError,
                        size: 24,
                        icon: StreamSvgIcons.userRemove,
                      ),
                      AppLocalizations.of(context).removeFromGroup,
                      () async {
                        final router = GoRouter.of(context);
                        final res = await showConfirmationBottomSheet(
                          context,
                          title: AppLocalizations.of(context).removeMember,
                          okText: AppLocalizations.of(context).remove.toUpperCase(),
                          question: AppLocalizations.of(context).removeMemberAreYouSure,
                          cancelText: AppLocalizations.of(context).cancel.toUpperCase(),
                        );

                        if (res == true) {
                          await channel.removeMembers([user.id]);
                        }
                        router.pop();
                      },
                      color: StreamChatTheme.of(context).colorTheme.accentError,
                    ),
                  _buildModalListTile(
                    context,
                    StreamSvgIcon(
                      color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                      size: 24,
                      icon: StreamSvgIcons.closeSmall,
                    ),
                    AppLocalizations.of(context).cancel,
                    () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
  }

  Widget? _buildConnectedTitleState(User? user) {
    late Text alternativeWidget;

    final otherMember = user;

    if (otherMember != null) {
      if (otherMember.online) {
        alternativeWidget = Text(
          AppLocalizations.of(context).online,
          style: TextStyle(color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5)),
        );
      } else {
        alternativeWidget = Text(
          '${AppLocalizations.of(context).lastSeen} ${Jiffy.parseFromDateTime(otherMember.lastActive!).fromNow()}',
          style: TextStyle(color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5)),
        );
      }
    }

    return alternativeWidget;
  }

  Widget _buildModalListTile(BuildContext context, Widget leading, String title, VoidCallback onTap, {Color? color}) {
    color ??= StreamChatTheme.of(context).colorTheme.textHighEmphasis;

    return Material(
      color: StreamChatTheme.of(context).colorTheme.barsBg,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 1,
              color: StreamChatTheme.of(context).colorTheme.disabled,
            ),
            SizedBox(
              height: 64,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: leading,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getChannelName(
    double width, {
    List<Member>? members,
    required Map extraData,
    double? maxFontSize,
  }) {
    String? title;
    final client = StreamChat.of(context);
    if (extraData['name'] == null) {
      final otherMembers = members!.where((member) => member.user!.id != client.currentUser!.id);
      if (otherMembers.isNotEmpty) {
        final maxWidth = width;
        final maxChars = maxWidth / maxFontSize!;
        var currentChars = 0;
        final currentMembers = <Member>[];
        for (final element in otherMembers) {
          final newLength = currentChars + element.user!.name.length;
          if (newLength < maxChars) {
            currentChars = newLength;
            currentMembers.add(element);
          }
        }

        final exceedingMembers = otherMembers.length - currentMembers.length;
        title =
            '${currentMembers.map((e) => e.user!.name).join(', ')} ${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
      } else {
        title = AppLocalizations.of(context).noTitle;
      }
    } else {
      title = extraData['name'];
    }
    return title;
  }

  String _getLastSeen(User user) {
    if (user.online) {
      return AppLocalizations.of(context).online;
    } else {
      if (user.lastActive == null) {
        return '';
      }

      return '${AppLocalizations.of(context).lastSeen} ${Jiffy.parseFromDateTime(user.lastActive!).fromNow()}';
    }
  }
}

class _GroupInfoToggle extends StatelessWidget {
  const _GroupInfoToggle({
    required this.title,
    required this.icon,
    required this.channelStream,
    required this.localNotifier,
    required this.onTurnOff,
    required this.onTurnOn,
  });

  final String title;
  final StreamSvgIconData icon;
  final Stream<bool> channelStream;
  final ValueNotifier<bool?> localNotifier;
  final VoidCallback onTurnOff;
  final VoidCallback onTurnOn;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: channelStream,
      builder: (context, snapshot) {
        localNotifier.value = snapshot.data;

        return StreamOptionListTile(
          tileColor: StreamChatTheme.of(context).colorTheme.appBg,
          separatorColor: StreamChatTheme.of(context).colorTheme.disabled,
          title: title,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamSvgIcon(
              icon: icon,
              size: 24,
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
          trailing: snapshot.data == null
              ? const CircularProgressIndicator()
              : ValueListenableBuilder<bool?>(
                  valueListenable: localNotifier,
                  builder: (context, value, _) {
                    return CupertinoSwitch(
                      value: value!,
                      onChanged: (val) {
                        localNotifier.value = val;
                        if (snapshot.data!) {
                          onTurnOff();
                        } else {
                          onTurnOn();
                        }
                      },
                    );
                  },
                ),
          onTap: () {},
        );
      },
    );
  }
}

class _GroupInfoListTile extends StatelessWidget {
  const _GroupInfoListTile({
    required this.title,
    required this.icon,
    required this.iconSize,
    required this.iconPadding,
    required this.onTap,
  });

  final String title;
  final StreamSvgIconData icon;
  final double iconSize;
  final double iconPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return StreamOptionListTile(
      title: title,
      tileColor: StreamChatTheme.of(context).colorTheme.appBg,
      titleTextStyle: StreamChatTheme.of(context).textTheme.body,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: iconPadding),
        child: StreamSvgIcon(
          icon: icon,
          size: iconSize,
          color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
        ),
      ),
      trailing: StreamSvgIcon(
        icon: StreamSvgIcons.right,
        color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
      ),
      onTap: onTap,
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/pages/channel_file_display_screen.dart';
import 'package:sample_app/pages/channel_media_display_screen.dart';
import 'package:sample_app/pages/pinned_messages_screen.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Detail screen for a 1:1 chat correspondence
class ChatInfoScreen extends StatefulWidget {
  const ChatInfoScreen({
    super.key,
    required this.messageTheme,
    this.user,
  });

  /// User in consideration
  final User? user;

  final StreamMessageThemeData messageTheme;

  @override
  State<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  ValueNotifier<bool?> mutedBool = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    mutedBool = ValueNotifier(StreamChannel.of(context).channel.isMuted);
  }

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      body: ListView(
        children: [
          _buildUserHeader(),
          Container(
            height: 8,
            color: StreamChatTheme.of(context).colorTheme.disabled,
          ),
          _buildOptionListTiles(),
          Container(
            height: 8,
            color: StreamChatTheme.of(context).colorTheme.disabled,
          ),
          if (channel.canDeleteChannel) _buildDeleteListTile(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Material(
      color: StreamChatTheme.of(context).colorTheme.appBg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: StreamUserAvatar(
                    size: .xl,
                    user: widget.user!,
                    showOnlineIndicator: false,
                  ),
                ),
                Text(
                  widget.user!.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 7),
                _buildConnectedTitleState(),
                const SizedBox(height: 15),
                StreamOptionListTile(
                  title: '@${widget.user!.id}',
                  tileColor: StreamChatTheme.of(context).colorTheme.appBg,
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.user!.name,
                      style: TextStyle(
                        color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const Positioned(
              top: 0,
              left: 0,
              width: 58,
              child: StreamBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionListTiles() {
    final channel = StreamChannel.of(context);

    return Column(
      children: [
        StreamBuilder<bool>(
          stream: StreamChannel.of(context).channel.isMutedStream,
          builder: (context, snapshot) {
            mutedBool.value = snapshot.data;

            return StreamOptionListTile(
              tileColor: StreamChatTheme.of(context).colorTheme.appBg,
              title: AppLocalizations.of(context).muteUser,
              titleTextStyle: StreamChatTheme.of(context).textTheme.body,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: StreamSvgIcon(
                  icon: StreamSvgIcons.mute,
                  size: 24,
                  color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                ),
              ),
              trailing: snapshot.data == null
                  ? const CircularProgressIndicator()
                  : ValueListenableBuilder<bool?>(
                      valueListenable: mutedBool,
                      builder: (context, value, _) {
                        return CupertinoSwitch(
                          value: value!,
                          onChanged: (val) {
                            mutedBool.value = val;

                            if (snapshot.data!) {
                              channel.channel.unmute();
                            } else {
                              channel.channel.mute();
                            }
                          },
                        );
                      },
                    ),
              onTap: () {},
            );
          },
        ),
        StreamOptionListTile(
          title: AppLocalizations.of(context).pinnedMessages,
          tileColor: StreamChatTheme.of(context).colorTheme.appBg,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: StreamSvgIcon(
              icon: StreamSvgIcons.pin,
              size: 24,
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon(
            icon: StreamSvgIcons.right,
            color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
          ),
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
        StreamOptionListTile(
          title: AppLocalizations.of(context).photosAndVideos,
          tileColor: StreamChatTheme.of(context).colorTheme.appBg,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamSvgIcon(
              icon: StreamSvgIcons.pictures,
              size: 36,
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon(
            icon: StreamSvgIcons.right,
            color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
          ),
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
        StreamOptionListTile(
          title: AppLocalizations.of(context).files,
          tileColor: StreamChatTheme.of(context).colorTheme.appBg,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: StreamSvgIcon(
              icon: StreamSvgIcons.files,
              size: 32,
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon(
            icon: StreamSvgIcons.right,
            color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
          ),
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
        StreamOptionListTile(
          title: AppLocalizations.of(context).sharedGroups,
          tileColor: StreamChatTheme.of(context).colorTheme.appBg,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: StreamSvgIcon(
              icon: StreamSvgIcons.group,
              size: 24,
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon(
            icon: StreamSvgIcons.right,
            color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _SharedGroupsScreen(StreamChat.of(context).currentUser, widget.user),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeleteListTile() {
    return StreamOptionListTile(
      title: 'Delete Conversation',
      tileColor: StreamChatTheme.of(context).colorTheme.appBg,
      titleTextStyle: StreamChatTheme.of(context).textTheme.body.copyWith(
        color: StreamChatTheme.of(context).colorTheme.accentError,
      ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: StreamSvgIcon(
          icon: StreamSvgIcons.delete,
          size: 24,
          color: StreamChatTheme.of(context).colorTheme.accentError,
        ),
      ),
      onTap: _showDeleteDialog,
      titleColor: StreamChatTheme.of(context).colorTheme.accentError,
    );
  }

  void _showDeleteDialog() async {
    final streamChannel = StreamChannel.of(context);
    final res = await showConfirmationBottomSheet(
      context,
      title: AppLocalizations.of(context).deleteConversationTitle,
      okText: AppLocalizations.of(context).delete.toUpperCase(),
      question: AppLocalizations.of(context).deleteConversationAreYouSure,
      cancelText: AppLocalizations.of(context).cancel.toUpperCase(),
      icon: StreamSvgIcon(
        icon: StreamSvgIcons.delete,
        color: StreamChatTheme.of(context).colorTheme.accentError,
      ),
    );
    final channel = streamChannel.channel;
    if (res == true) {
      await channel.delete().then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  Widget _buildConnectedTitleState() {
    late Text alternativeWidget;

    final otherMember = widget.user;

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.user!.online)
          Material(
            type: MaterialType.circle,
            color: StreamChatTheme.of(context).colorTheme.barsBg,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              constraints: const BoxConstraints.tightFor(
                width: 24,
                height: 12,
              ),
              child: Material(
                shape: const CircleBorder(),
                color: StreamChatTheme.of(context).colorTheme.accentInfo,
              ),
            ),
          ),
        alternativeWidget,
        if (widget.user!.online)
          const SizedBox(
            width: 24,
          ),
      ],
    );
  }
}

class _SharedGroupsScreen extends StatefulWidget {
  const _SharedGroupsScreen(this.mainUser, this.otherUser);
  final User? mainUser;
  final User? otherUser;

  @override
  __SharedGroupsScreenState createState() => __SharedGroupsScreenState();
}

class __SharedGroupsScreenState extends State<_SharedGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    final chat = StreamChat.of(context);

    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).sharedGroups,
          style: TextStyle(color: StreamChatTheme.of(context).colorTheme.textHighEmphasis, fontSize: 16),
        ),
        leading: const StreamBackButton(),
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
      ),
      body: StreamBuilder<List<Channel>>(
        stream: chat.client.queryChannels(
          filter: Filter.and([
            Filter.in_('members', [widget.otherUser!.id]),
            Filter.in_('members', [widget.mainUser!.id]),
          ]),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamSvgIcon(
                    icon: StreamSvgIcons.message,
                    size: 136,
                    color: StreamChatTheme.of(context).colorTheme.disabled,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).noSharedGroups,
                    style: TextStyle(
                      fontSize: 14,
                      color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).groupSharedWithUserAppearHere,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          final channels = snapshot.data!
              .where(
                (c) =>
                    c.state!.members.any((m) => m.userId != widget.mainUser!.id && m.userId != widget.otherUser!.id) ||
                    !c.isDistinct,
              )
              .toList();

          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, position) {
              return StreamChannel(
                channel: channels[position],
                child: _buildListTile(channels[position]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildListTile(Channel channel) {
    final extraData = channel.extraData;
    final members = channel.state!.members;

    const textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    return SizedBox(
      height: 64,
      child: LayoutBuilder(
        builder: (context, constraints) {
          String? title;
          if (extraData['name'] == null) {
            final otherMembers = members.where((member) => member.userId != StreamChat.of(context).currentUser!.id);
            if (otherMembers.isNotEmpty) {
              final maxWidth = constraints.maxWidth;
              final maxChars = maxWidth / textStyle.fontSize!;
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
              title = 'No title';
            }
          } else {
            title = extraData['name']! as String;
          }

          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: StreamChannelAvatar(
                        size: .lg,
                        channel: channel,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: textStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${channel.memberCount} ${AppLocalizations.of(context).members.toLowerCase()}',
                        style: TextStyle(
                          color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(.08),
              ),
            ],
          );
        },
      ),
    );
  }
}

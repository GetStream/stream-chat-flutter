import 'package:example/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_file_display_screen.dart';
import 'channel_media_display_screen.dart';
import 'pinned_messages_screen.dart';

/// Detail screen for a 1:1 chat correspondence
class ChatInfoScreen extends StatefulWidget {
  /// User in consideration
  final User? user;

  final StreamMessageThemeData messageTheme;

  const ChatInfoScreen({
    Key? key,
    required this.messageTheme,
    this.user,
  }) : super(key: key);

  @override
  _ChatInfoScreenState createState() => _ChatInfoScreenState();
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
            height: 8.0,
            color: StreamChatTheme.of(context).colorTheme.disabled,
          ),
          _buildOptionListTiles(),
          Container(
            height: 8.0,
            color: StreamChatTheme.of(context).colorTheme.disabled,
          ),
          if (channel.ownCapabilities.contains(PermissionType.deleteChannel))
            _buildDeleteListTile(),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamUserAvatar(
                    user: widget.user!,
                    constraints: BoxConstraints.tightFor(
                      width: 72.0,
                      height: 72.0,
                    ),
                    borderRadius: BorderRadius.circular(36.0),
                    showOnlineStatus: false,
                  ),
                ),
                Text(
                  widget.user!.name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7.0),
                _buildConnectedTitleState(),
                SizedBox(height: 15.0),
                StreamOptionListTile(
                  title: '@${widget.user!.id}',
                  tileColor: StreamChatTheme.of(context).colorTheme.appBg,
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.user!.name,
                      style: TextStyle(
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .textHighEmphasis
                              .withOpacity(0.5),
                          fontSize: 16.0),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            Positioned(
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
    var channel = StreamChannel.of(context);

    return Column(
      children: [
        // _OptionListTile(
        //   title: 'Notifications',
        //   leading: StreamSvgIcon.Icon_notification(
        //     size: 24.0,
        //     color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
        //   ),
        //   trailing: CupertinoSwitch(
        //     value: true,
        //     onChanged: (val) {},
        //   ),
        //   onTap: () {},
        // ),
        StreamBuilder<bool>(
            stream: StreamChannel.of(context).channel.isMutedStream,
            builder: (context, snapshot) {
              mutedBool.value = snapshot.data;

              return StreamOptionListTile(
                tileColor: StreamChatTheme.of(context).colorTheme.appBg,
                title: AppLocalizations.of(context).muteUser,
                titleTextStyle: StreamChatTheme.of(context).textTheme.body,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: StreamSvgIcon.mute(
                    size: 24.0,
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .textHighEmphasis
                        .withOpacity(0.5),
                  ),
                ),
                trailing: snapshot.data == null
                    ? CircularProgressIndicator()
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
                        }),
                onTap: () {},
              );
            }),
        // _OptionListTile(
        //   title: 'Block User',
        //   leading: StreamSvgIcon.Icon_user_delete(
        //     size: 24.0,
        //     color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(0.5),
        //   ),
        //   trailing: CupertinoSwitch(
        //     value: widget.user.banned,
        //     onChanged: (val) {
        //       if (widget.user.banned) {
        //         channel.channel.shadowBan(widget.user.id, {});
        //       } else {
        //         channel.channel.unbanUser(widget.user.id);
        //       }
        //     },
        //   ),
        //   onTap: () {},
        // ),
        StreamOptionListTile(
          title: AppLocalizations.of(context).pinnedMessages,
          tileColor: StreamChatTheme.of(context).colorTheme.appBg,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: StreamSvgIcon.pin(
              size: 24.0,
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon.right(
            color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
          ),
          onTap: () {
            final channel = StreamChannel.of(context).channel;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  channel: channel,
                  child: PinnedMessagesScreen(),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamSvgIcon.pictures(
              size: 36.0,
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon.right(
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
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: StreamSvgIcon.files(
              size: 32.0,
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon.right(
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
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: StreamSvgIcon.iconGroup(
              size: 24.0,
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon.right(
            color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _SharedGroupsScreen(
                        StreamChat.of(context).currentUser, widget.user)));
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
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: StreamSvgIcon.delete(
          color: StreamChatTheme.of(context).colorTheme.accentError,
          size: 24.0,
        ),
      ),
      onTap: () {
        _showDeleteDialog();
      },
      titleColor: StreamChatTheme.of(context).colorTheme.accentError,
    );
  }

  void _showDeleteDialog() async {
    final res = await showConfirmationBottomSheet(
      context,
      title: AppLocalizations.of(context).deleteConversationTitle,
      okText: AppLocalizations.of(context).delete.toUpperCase(),
      question: AppLocalizations.of(context).deleteConversationAreYouSure,
      cancelText: AppLocalizations.of(context).cancel.toUpperCase(),
      icon: StreamSvgIcon.delete(
        color: StreamChatTheme.of(context).colorTheme.accentError,
      ),
    );
    var channel = StreamChannel.of(context).channel;
    if (res == true) {
      await channel.delete().then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  Widget _buildConnectedTitleState() {
    var alternativeWidget;

    final otherMember = widget.user;

    if (otherMember != null) {
      if (otherMember.online) {
        alternativeWidget = Text(
          AppLocalizations.of(context).online,
          style: TextStyle(
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(0.5)),
        );
      } else {
        alternativeWidget = Text(
          '${AppLocalizations.of(context).lastSeen} ${Jiffy(otherMember.lastActive).fromNow()}',
          style: TextStyle(
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(0.5)),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.user!.online)
          Material(
            type: MaterialType.circle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              constraints: BoxConstraints.tightFor(
                width: 24,
                height: 12,
              ),
              child: Material(
                shape: CircleBorder(),
                color: StreamChatTheme.of(context).colorTheme.accentInfo,
              ),
            ),
            color: StreamChatTheme.of(context).colorTheme.barsBg,
          ),
        alternativeWidget,
        if (widget.user!.online)
          SizedBox(
            width: 24.0,
          ),
      ],
    );
  }
}

class _SharedGroupsScreen extends StatefulWidget {
  final User? mainUser;
  final User? otherUser;

  _SharedGroupsScreen(this.mainUser, this.otherUser);

  @override
  __SharedGroupsScreenState createState() => __SharedGroupsScreenState();
}

class __SharedGroupsScreenState extends State<_SharedGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    var chat = StreamChat.of(context);

    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).sharedGroups,
          style: TextStyle(
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
              fontSize: 16.0),
        ),
        leading: StreamBackButton(),
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamSvgIcon.message(
                    size: 136.0,
                    color: StreamChatTheme.of(context).colorTheme.disabled,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    AppLocalizations.of(context).noSharedGroups,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .textHighEmphasis,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    AppLocalizations.of(context).groupSharedWithUserAppearHere,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .textHighEmphasis
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          final channels = snapshot.data!
              .where((c) =>
                  c.state!.members.any((m) =>
                      m.userId != widget.mainUser!.id &&
                      m.userId != widget.otherUser!.id) ||
                  !c.isDistinct)
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
    var extraData = channel.extraData;
    var members = channel.state!.members;

    var textStyle = TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

    return Container(
      height: 64.0,
      child: LayoutBuilder(builder: (context, constraints) {
        String? title;
        if (extraData['name'] == null) {
          final otherMembers = members.where((member) =>
              member.userId != StreamChat.of(context).currentUser!.id);
          if (otherMembers.isNotEmpty) {
            final maxWidth = constraints.maxWidth;
            final maxChars = maxWidth / textStyle.fontSize!;
            var currentChars = 0;
            final currentMembers = <Member>[];
            otherMembers.forEach((element) {
              final newLength = currentChars + element.user!.name.length;
              if (newLength < maxChars) {
                currentChars = newLength;
                currentMembers.add(element);
              }
            });

            final exceedingMembers =
                otherMembers.length - currentMembers.length;
            title =
                '${currentMembers.map((e) => e.user!.name).join(', ')} ${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
          } else {
            title = 'No title';
          }
        } else {
          title = extraData['name'] as String;
        }

        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamChannelAvatar(
                      channel: channel,
                      constraints:
                          BoxConstraints(maxWidth: 40.0, maxHeight: 40.0),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    title,
                    style: textStyle,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${channel.memberCount} ${AppLocalizations.of(context).members.toLowerCase()}',
                      style: TextStyle(
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .textHighEmphasis
                              .withOpacity(0.5)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(.08),
            ),
          ],
        );
      }),
    );
  }
}

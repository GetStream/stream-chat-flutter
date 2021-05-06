import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/channel_info.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Bottom Sheet with options
class ChannelBottomSheet extends StatefulWidget {
  /// Constructor for creating bottom sheet
  const ChannelBottomSheet({Key? key, this.onViewInfoTap}) : super(key: key);

  /// Callback when 'View Info' is tapped
  final VoidCallback? onViewInfoTap;

  @override
  _ChannelBottomSheetState createState() => _ChannelBottomSheetState();
}

class _ChannelBottomSheetState extends State<ChannelBottomSheet> {
  bool _showActions = true;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    final members = channel.state?.members ?? [];

    final userAsMember = members
        .firstWhere((e) => e.user?.id == StreamChat.of(context).user?.id);
    final isOwner = userAsMember.role == 'owner';

    return Material(
      color: StreamChatTheme.of(context).colorTheme.white,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: !_showActions
          ? const SizedBox()
          : ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ChannelName(
                      textStyle:
                          StreamChatTheme.of(context).textTheme.headlineBold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: ChannelInfo(
                    showTypingIndicator: false,
                    channel: StreamChannel.of(context).channel,
                    textStyle: StreamChatTheme.of(context)
                        .channelPreviewTheme
                        .subtitle,
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                if (channel.isDistinct && channel.memberCount == 2)
                  Column(
                    children: [
                      UserAvatar(
                        user: members
                            .firstWhere(
                                (e) => e.user?.id != userAsMember.user?.id)
                            .user!,
                        constraints: const BoxConstraints(
                          maxHeight: 64,
                          maxWidth: 64,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        onlineIndicatorConstraints:
                            BoxConstraints.tight(const Size(12, 12)),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        members
                                .firstWhere(
                                    (e) => e.user?.id != userAsMember.user?.id)
                                .user
                                ?.name ??
                            '',
                        style:
                            StreamChatTheme.of(context).textTheme.footnoteBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                if (!(channel.isDistinct && channel.memberCount == 2))
                  Container(
                    height: 94,
                    alignment: Alignment.center,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: members.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            UserAvatar(
                              user: members[index].user!,
                              constraints: const BoxConstraints.tightFor(
                                height: 64,
                                width: 64,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              onlineIndicatorConstraints:
                                  BoxConstraints.tight(const Size(12, 12)),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              members[index].user?.name ?? '',
                              style: StreamChatTheme.of(context)
                                  .textTheme
                                  .footnoteBold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 24,
                ),
                OptionListTile(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamSvgIcon.user(
                      color: StreamChatTheme.of(context).colorTheme.grey,
                    ),
                  ),
                  title: 'View Info',
                  onTap: widget.onViewInfoTap,
                ),
                if (!channel.isDistinct)
                  OptionListTile(
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StreamSvgIcon.userRemove(
                        color: StreamChatTheme.of(context).colorTheme.grey,
                      ),
                    ),
                    title: 'Leave Group',
                    onTap: () async {
                      setState(() {
                        _showActions = false;
                      });
                      await _showLeaveDialog();
                      setState(() {
                        _showActions = true;
                      });
                    },
                  ),
                if (isOwner)
                  OptionListTile(
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StreamSvgIcon.delete(
                        color: StreamChatTheme.of(context).colorTheme.accentRed,
                      ),
                    ),
                    title: 'Delete Conversation',
                    titleColor:
                        StreamChatTheme.of(context).colorTheme.accentRed,
                    onTap: () async {
                      setState(() {
                        _showActions = false;
                      });
                      await _showDeleteDialog();
                      setState(() {
                        _showActions = true;
                      });
                    },
                  ),
                OptionListTile(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamSvgIcon.closeSmall(
                      color: StreamChatTheme.of(context).colorTheme.grey,
                    ),
                  ),
                  title: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
    );
  }

  Future<void> _showDeleteDialog() async {
    final res = await showConfirmationDialog(
      context,
      title: 'Delete Conversation',
      okText: 'DELETE',
      question: 'Are you sure you want to delete this conversation?',
      cancelText: 'CANCEL',
      icon: StreamSvgIcon.delete(
        color: StreamChatTheme.of(context).colorTheme.accentRed,
      ),
    );
    final channel = StreamChannel.of(context).channel;
    if (res == true) {
      await channel.delete();
      Navigator.pop(context);
    }
  }

  Future<void> _showLeaveDialog() async {
    final res = await showConfirmationDialog(
      context,
      title: 'Leave conversation',
      okText: 'LEAVE',
      question: 'Are you sure you want to leave this conversation?',
      cancelText: 'CANCEL',
      icon: StreamSvgIcon.userRemove(
        color: StreamChatTheme.of(context).colorTheme.accentRed,
      ),
    );
    if (res == true) {
      final channel = StreamChannel.of(context).channel;
      final user = StreamChat.of(context).user;
      if (user != null) {
        await channel.removeMembers([user.id]);
      }
      Navigator.pop(context);
    }
  }
}

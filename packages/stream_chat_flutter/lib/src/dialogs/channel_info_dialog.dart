import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template channelInfoDialog}
/// A dialog for showing information about a channel on desktop & web platforms.
/// {@endtemplate}
class ChannelInfoDialog extends StatelessWidget {
  /// {@macro channelInfoDialog}
  const ChannelInfoDialog({
    super.key,
    required this.channel,
  });

  /// The channel to display information about.
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final streamTheme = StreamChatTheme.of(context);
    final members = channel.state?.members ?? [];

    final userAsMember = members.firstWhere(
      (e) => e.user?.id == StreamChat.of(context).currentUser?.id,
    );
    return StreamChannel(
      channel: channel,
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: streamTheme.colorTheme.appBg,
        title: Text(
          channel.name ?? channel.id!,
          style: StreamChatTheme.of(context).textTheme.headlineBold,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamChannelInfo(
                channel: channel,
                textStyle: StreamChatTheme.of(context)
                    .channelPreviewTheme
                    .subtitleStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (channel.isDistinct && channel.memberCount == 2)
            Column(
              children: [
                StreamUserAvatar(
                  user: members
                      .firstWhere(
                        (e) => e.user?.id != userAsMember.user?.id,
                      )
                      .user!,
                  constraints: const BoxConstraints(
                    maxHeight: 64,
                    maxWidth: 64,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  onlineIndicatorConstraints:
                      BoxConstraints.tight(const Size(12, 12)),
                ),
                const SizedBox(height: 6),
                Text(
                  members
                          .firstWhere(
                            (e) => e.user?.id != userAsMember.user?.id,
                          )
                          .user
                          ?.name ??
                      '',
                  style: StreamChatTheme.of(context).textTheme.footnoteBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

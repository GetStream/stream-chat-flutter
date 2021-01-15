import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';

import 'channel_image.dart';
import 'channel_name_text.dart';
import 'stream_channel.dart';
import 'stream_chat.dart';

class ChannelPreview extends StatelessWidget {
  final void Function(Channel) onTap;

  const ChannelPreview({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);
    return _buildChannelPreview(
      context,
      streamChannel,
    );
  }

  StreamChannel _buildChannelPreview(
    BuildContext context,
    StreamChannelState streamChannel,
  ) {
    final channelClient = StreamChat.of(context)
        .client
        .state
        .channels
        .firstWhere((c) => c.cid == streamChannel.channel.cid);
    return StreamChannel(
      channelClient: channelClient,
      child: ListTile(
        onTap: () {
          onTap(channelClient);
        },
        leading: ChannelImage(
          channel: streamChannel.channel,
        ),
        title: ChannelNameText(
          channel: streamChannel.channel,
        ),
        subtitle: _buildSubtitle(
          streamChannel,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildDate(context, streamChannel.channel.lastMessageAt),
          ],
        ),
      ),
    );
  }

  Text _buildDate(BuildContext context, DateTime lastMessageAt) {
    String stringDate;
    final now = DateTime.now();

    if (now.year != lastMessageAt.year ||
        now.month != lastMessageAt.month ||
        now.day != lastMessageAt.day) {
      stringDate = Jiffy(lastMessageAt.toLocal()).format('dd/MM/yyyy');
    } else {
      stringDate = Jiffy(lastMessageAt.toLocal()).format('HH:mm');
    }

    return Text(
      stringDate,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _buildSubtitle(
    StreamChannelState streamChannel,
  ) {
    return StreamBuilder<List<User>>(
        stream: streamChannel.channelClient.state.typingEventsStream,
        initialData: [],
        builder: (context, snapshot) {
          final typings = snapshot.data;
          final opacity =
              streamChannel.channelClient.state.unreadCount > .0 ? 1.0 : 0.5;
          return typings.isNotEmpty
              ? _buildTypings(typings, context, opacity)
              : _buildLastMessage(context, streamChannel, opacity);
        });
  }

  Widget _buildLastMessage(
      BuildContext context, StreamChannelState streamChannel, double opacity) {
    final lastMessage = streamChannel.channel.state.messages.isNotEmpty
        ? streamChannel.channel.state.messages.last
        : null;
    if (lastMessage == null) {
      return SizedBox.fromSize(
        size: Size.zero,
      );
    }

    final prefix = lastMessage.attachments
        .map((e) {
          if (e.type == 'image') {
            return '📷';
          } else if (e.type == 'video') {
            return '🎬';
          }
          return null;
        })
        .where((e) => e != null)
        .join(' ');

    return Text(
      '$prefix ${lastMessage.text ?? ''}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.caption.copyWith(
            color: Colors.black.withOpacity(opacity),
          ),
    );
  }

  Text _buildTypings(List<User> typings, BuildContext context, double opacity) {
    return Text(
      '${typings.map((u) => u.extraData.containsKey('name') ? u.extraData['name'] : u.id).join(',')} ${typings.length == 1 ? 'is' : 'are'} typing...',
      maxLines: 1,
      style: Theme.of(context).textTheme.caption.copyWith(
            color: Colors.black.withOpacity(opacity),
          ),
    );
  }
}

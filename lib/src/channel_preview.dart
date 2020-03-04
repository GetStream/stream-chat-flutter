import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

import '../stream_chat_flutter.dart';
import 'channel_name.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_preview.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_preview_paint.png)
///
/// It shows the current [Channel] preview.
///
/// The widget uses a [StreamBuilder] to render the channel information image as soon as it updates.
///
/// Usually you don't use this widget as it's the default channel preview used by [ChannelListView].
///
/// The widget renders the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class ChannelPreview extends StatelessWidget {
  /// Function called when tapping this widget
  final void Function(Channel) onTap;

  /// Channel displayed
  final Channel channel;

  ChannelPreview({
    @required this.channel,
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap(channel);
      },
      leading: ChannelImage(
        channel: channel,
      ),
      title: ChannelName(
        textStyle: StreamChatTheme.of(context).channelPreviewTheme.title,
        channel: channel,
      ),
      subtitle: _buildSubtitle(),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _buildDate(context),
        ],
      ),
    );
  }

  Widget _buildDate(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, snapshot) {
        final lastMessageAt = snapshot.data.toLocal();

        String stringDate;
        final now = DateTime.now();

        if (now.year != lastMessageAt.year ||
            now.month != lastMessageAt.month ||
            now.day != lastMessageAt.day) {
          stringDate =
              '${lastMessageAt.day}/${lastMessageAt.month}/${lastMessageAt.year}';
          stringDate = formatDate(lastMessageAt, [dd, '/', mm, '/', yyyy]);
        } else {
          stringDate = '${lastMessageAt.hour}:${lastMessageAt.minute}';
          stringDate = formatDate(lastMessageAt, [HH, ':', nn]);
        }

        return Text(
          stringDate,
          style: StreamChatTheme.of(context).channelPreviewTheme.lastMessageAt,
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return StreamBuilder<List<User>>(
        stream: channel.state.typingEventsStream,
        initialData: channel.state.typingEvents,
        builder: (context, snapshot) {
          final typings = snapshot.data;
          final opacity = channel.state.unreadCount > 0 ? 1.0 : 0.5;
          return typings.isNotEmpty
              ? _buildTypings(typings, context, opacity)
              : _buildLastMessage(context, opacity);
        });
  }

  Widget _buildLastMessage(BuildContext context, double opacity) {
    return StreamBuilder<List<Message>>(
      stream: channel.state.messagesStream,
      initialData: channel.state.messages,
      builder: (context, snapshot) {
        final messages = snapshot.data;
        final lastMessage = messages.isNotEmpty ? messages.last : null;
        if (lastMessage == null) {
          return SizedBox();
        }

        String text;
        if (lastMessage.type == 'deleted') {
          text = 'This message was deleted.';
        } else {
          final prefix = lastMessage.attachments
              .map((e) {
                if (e.type == 'image') {
                  return '📷';
                } else if (e.type == 'video') {
                  return '🎬';
                } else if (e.type == 'giphy') {
                  return 'GIF';
                }
                return null;
              })
              .where((e) => e != null)
              .join(' ');

          text = '$prefix ${lastMessage.text ?? ''}';
        }

        return Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              StreamChatTheme.of(context).channelPreviewTheme.subtitle.copyWith(
                    color: StreamChatTheme.of(context)
                        .channelPreviewTheme
                        .subtitle
                        .color
                        .withOpacity(opacity),
                  ),
        );
      },
    );
  }

  Text _buildTypings(List<User> typings, BuildContext context, double opacity) {
    return Text(
      '${typings.map((u) => u.extraData.containsKey('name') ? u.extraData['name'] : u.id).join(',')} ${typings.length == 1 ? 'is' : 'are'} typing...',
      maxLines: 1,
      style: StreamChatTheme.of(context).channelPreviewTheme.subtitle.copyWith(
            color: StreamChatTheme.of(context)
                .channelPreviewTheme
                .subtitle
                .color
                .withOpacity(opacity),
          ),
    );
  }
}

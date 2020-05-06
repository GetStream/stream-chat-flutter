import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/unread_indicator.dart';

import '../stream_chat_flutter.dart';
import 'channel_name.dart';
import 'typing_indicator.dart';

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

  /// Function called when long pressing this widget
  final void Function(Channel) onLongPress;

  /// Channel displayed
  final Channel channel;

  /// The function called when the image is tapped
  final VoidCallback onImageTap;

  ChannelPreview({
    @required this.channel,
    Key key,
    this.onTap,
    this.onLongPress,
    this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) {
          onTap(channel);
        }
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress(channel);
        }
      },
      leading: ChannelImage(
        onTap: onImageTap,
      ),
      title: ChannelName(
        textStyle: StreamChatTheme.of(context).channelPreviewTheme.title,
      ),
      subtitle: _buildSubtitle(context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildDate(context),
          if (channel.state.unreadCount > 0)
            UnreadIndicator(
              channel: channel,
            ),
        ],
      ),
    );
  }

  Widget _buildDate(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }
        final lastMessageAt = snapshot.data.toLocal();

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
          style: StreamChatTheme.of(context).channelPreviewTheme.lastMessageAt,
        );
      },
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final opacity = channel.state.unreadCount > 0 ? 1.0 : 0.5;
    return TypingIndicator(
      channel: channel,
      alternativeWidget: _buildLastMessage(context, opacity),
      style: StreamChatTheme.of(context).channelPreviewTheme.subtitle.copyWith(
            color: StreamChatTheme.of(context)
                .channelPreviewTheme
                .subtitle
                .color
                .withOpacity(opacity),
          ),
    );
  }

  Widget _buildLastMessage(BuildContext context, double opacity) {
    return StreamBuilder<List<Message>>(
      stream: channel.state.messagesStream,
      initialData: channel.state.messages,
      builder: (context, snapshot) {
        final messages = snapshot.data;
        final lastMessage = messages?.isNotEmpty == true
            ? messages.lastWhere((m) =>
                !(m.isDeleted && m.status == MessageSendingStatus.FAILED))
            : null;
        if (lastMessage == null) {
          return SizedBox();
        }

        var text = lastMessage.text;
        if (lastMessage.isDeleted) {
          text = 'This message was deleted.';
        } else if (lastMessage.attachments != null) {
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
}

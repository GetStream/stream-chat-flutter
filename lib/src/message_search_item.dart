import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// It shows the current [Message] preview.
///
/// Usually you don't use this widget as it's the default item used by [MessageSearchListView].
///
/// The widget renders the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageSearchItem extends StatelessWidget {
  /// Instantiate a new MessageSearchItem
  const MessageSearchItem({
    Key key,
    @required this.message,
    this.onTap,
    this.showOnlineStatus = true,
  }) : super(key: key);

  /// [Message] displayed
  final Message message;

  /// Function called when tapping this widget
  final VoidCallback onTap;

  /// If true the [MessageSearchItem] will show the current online Status
  final bool showOnlineStatus;

  @override
  Widget build(BuildContext context) {
    final data = Message.fromJson(message.extraData['message']);
    final user = data.user;
    debugPrint(message.toJson().toString());
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(
        user: user,
        showOnlineStatus: showOnlineStatus,
        constraints: BoxConstraints.tightFor(
          height: 40,
          width: 40,
        ),
      ),
      title: Text(
        user.name,
        style: StreamChatTheme.of(context).channelPreviewTheme.title,
      ),
      subtitle: Row(
        children: [
          Expanded(child: _buildSubtitle(context, data)),
          SizedBox(width: 16),
          _buildDate(context, data),
        ],
      ),
    );
  }

  Widget _buildDate(BuildContext context, Message message) {
    final lastUpdatedAt = message.updatedAt;
    String stringDate;
    final now = DateTime.now();

    if (now.year != lastUpdatedAt.year ||
        now.month != lastUpdatedAt.month ||
        now.day != lastUpdatedAt.day) {
      stringDate = Jiffy(lastUpdatedAt.toLocal()).format('dd/MM/yyyy');
    } else {
      stringDate = Jiffy(lastUpdatedAt.toLocal()).format('HH:mm');
    }

    return Text(
      stringDate,
      style: StreamChatTheme.of(context).channelPreviewTheme.lastMessageAt,
    );
  }

  Widget _buildSubtitle(BuildContext context, Message message) {
    if (message == null) {
      return SizedBox();
    }

    var text = message.text;
    if (message.isDeleted) {
      text = 'This message was deleted.';
    } else if (message.attachments != null) {
      final parts = <String>[
        ...message.attachments.map((e) {
          if (e.type == 'image') {
            return '📷';
          } else if (e.type == 'video') {
            return '🎬';
          } else if (e.type == 'giphy') {
            return '[GIF]';
          }
          return null;
        }).where((e) => e != null),
        message.text ?? '',
      ];

      text = parts.join(' ');
    }

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: StreamChatTheme.of(context).channelPreviewTheme.subtitle.copyWith(
            color:
                StreamChatTheme.of(context).channelPreviewTheme.subtitle.color,
            fontStyle: (message.isSystem || message.isDeleted)
                ? FontStyle.italic
                : FontStyle.normal,
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// It shows the current [Message] preview.
///
/// Usually you don't use this widget as it's the default item used by [MessageSearchListView].
///
/// The widget renders the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageSearchItem extends StatelessWidget {
  /// Instantiate a new MessageSearchItem
  const MessageSearchItem({
    Key? key,
    required this.getMessageResponse,
    this.onTap,
    this.showOnlineStatus = true,
  }) : super(key: key);

  /// [Message] displayed
  final GetMessageResponse getMessageResponse;

  /// Function called when tapping this widget
  final VoidCallback? onTap;

  /// If true the [MessageSearchItem] will show the current online Status
  final bool showOnlineStatus;

  @override
  Widget build(BuildContext context) {
    final message = getMessageResponse.message;
    final channel = getMessageResponse.channel;
    final channelName = channel?.extraData['name'];
    final user = message.user!;
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
      title: Row(
        children: [
          Text(
            user.id == StreamChat.of(context).user?.id ? 'You' : user.name,
            style: StreamChatTheme.of(context).channelPreviewTheme.title,
          ),
          if (channelName != null) ...[
            Text(
              ' in ',
              style: StreamChatTheme.of(context)
                  .channelPreviewTheme
                  .title
                  ?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            Text(
              channelName as String,
              style: StreamChatTheme.of(context).channelPreviewTheme.title,
            ),
          ],
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(child: _buildSubtitle(context, message)),
          SizedBox(width: 16),
          _buildDate(context, message),
        ],
      ),
    );
  }

  Widget _buildDate(BuildContext context, Message message) {
    final createdAt = message.createdAt;
    String stringDate;
    final now = DateTime.now();

    if (now.year != createdAt.year ||
        now.month != createdAt.month ||
        now.day != createdAt.day) {
      stringDate = Jiffy(createdAt.toLocal()).yMd;
    } else {
      stringDate = Jiffy(createdAt.toLocal()).jm;
    }

    return Text(
      stringDate,
      style: StreamChatTheme.of(context).channelPreviewTheme.lastMessageAt,
    );
  }

  Widget _buildSubtitle(BuildContext context, Message message) {
    var text = message.text;
    if (message.isDeleted) {
      text = 'This message was deleted.';
    } else if (message.attachments.isNotEmpty) {
      final parts = <String>[
        ...message.attachments.map((e) {
          if (e.type == 'image') {
            return '📷';
          } else if (e.type == 'video') {
            return '🎬';
          } else if (e.type == 'giphy') {
            return '[GIF]';
          }
          return e == message.attachments.last
              ? (e.title ?? 'File')
              : '${e.title ?? 'File'} , ';
        }),
        message.text ?? '',
      ];

      text = parts.join(' ');
    }

    return Text.rich(
      _getDisplayText(
        text!,
        message.mentionedUsers,
        message.attachments,
        StreamChatTheme.of(context).channelPreviewTheme.subtitle?.copyWith(
              fontStyle: (message.isSystem || message.isDeleted)
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
        StreamChatTheme.of(context).channelPreviewTheme.subtitle?.copyWith(
              fontStyle: (message.isSystem || message.isDeleted)
                  ? FontStyle.italic
                  : FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextSpan _getDisplayText(
      String text,
      List<User> mentions,
      List<Attachment> attachments,
      TextStyle? normalTextStyle,
      TextStyle? mentionsTextStyle) {
    final textList = text.split(' ');
    final resList = <TextSpan>[];
    for (var e in textList) {
      if (mentions.isNotEmpty &&
          mentions.any((element) => '@${element.name}' == e)) {
        resList.add(TextSpan(
          text: '$e ',
          style: mentionsTextStyle,
        ));
      } else if (attachments.isNotEmpty &&
          attachments
              .where((e) => e.title != null)
              .any((element) => element.title == e)) {
        resList.add(TextSpan(
          text: '$e ',
          style: normalTextStyle?.copyWith(fontStyle: FontStyle.italic),
        ));
      } else {
        resList.add(TextSpan(
          text: e == textList.last ? e : '$e ',
          style: normalTextStyle,
        ));
      }
    }

    return TextSpan(children: resList);
  }
}

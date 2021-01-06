import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';

import '../stream_chat_flutter.dart';
import 'channel_name.dart';
import 'channel_unread_indicator.dart';

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
    return StreamBuilder<bool>(
        stream: channel.isMutedStream,
        initialData: channel.isMuted,
        builder: (context, snapshot) {
          return Opacity(
            opacity: snapshot.data ? 0.5 : 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: ChannelName(
                      textStyle:
                          StreamChatTheme.of(context).channelPreviewTheme.title,
                    ),
                  ),
                  StreamBuilder<List<Member>>(
                      stream: channel.state.membersStream,
                      initialData: channel.state.members,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.isEmpty ||
                            !snapshot.data.any((Member e) =>
                                e.user.id == channel.client.state.user.id)) {
                          return SizedBox();
                        }
                        return ChannelUnreadIndicator(
                          channel: channel,
                        );
                      }),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child: _buildSubtitle(context)),
                  Builder(
                    builder: (context) {
                      if (channel.state.lastMessage?.user?.id ==
                          StreamChat.of(context).user.id) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: SendingIndicator(
                            message: channel.state.lastMessage,
                            size: StreamChatTheme.of(context)
                                .channelPreviewTheme
                                .lastMessageAt
                                .fontSize,
                            isMessageRead: channel.state.read
                                    ?.where((element) =>
                                        element.user.id !=
                                        channel.client.state.user.id)
                                    ?.where((element) => element.lastRead
                                        .isAfter(channel
                                            .state.lastMessage.createdAt))
                                    ?.isNotEmpty ==
                                true,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  _buildDate(context),
                ],
              ),
            ),
          );
        });
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

        var startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.millisecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).format('HH:mm');
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.subtract(Duration(days: 1)).millisecondsSinceEpoch) {
          stringDate = 'Yesterday';
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).format('dd/MM/yyyy');
        }

        return Text(
          stringDate,
          style: StreamChatTheme.of(context).channelPreviewTheme.lastMessageAt,
        );
      },
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    if (channel.isMuted) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          StreamSvgIcon.mute(
            size: 16,
          ),
          Text(
            '  Channel is muted',
            style: StreamChatTheme.of(context)
                .channelPreviewTheme
                .subtitle
                .copyWith(
                  color: StreamChatTheme.of(context)
                      .channelPreviewTheme
                      .subtitle
                      .color,
                ),
          ),
        ],
      );
    }
    return TypingIndicator(
      channel: channel,
      alternativeWidget: _buildLastMessage(context),
      style: StreamChatTheme.of(context).channelPreviewTheme.subtitle.copyWith(
            color:
                StreamChatTheme.of(context).channelPreviewTheme.subtitle.color,
          ),
    );
  }

  Widget _buildLastMessage(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: channel.state.messagesStream,
      initialData: channel.state.messages,
      builder: (context, snapshot) {
        final lastMessage = channel.state.lastMessage;
        if (lastMessage == null) {
          return SizedBox();
        }

        var text = lastMessage.text;
        if (lastMessage.isDeleted) {
          text = 'This message was deleted.';
        } else if (lastMessage.attachments != null) {
          final parts = <String>[
            ...lastMessage.attachments.map((e) {
              if (e.type == 'image') {
                return '📷';
              } else if (e.type == 'video') {
                return '🎬';
              } else if (e.type == 'giphy') {
                return '[GIF]';
              }
              return e == lastMessage.attachments.last
                  ? (e.title ?? 'File')
                  : '${e.title ?? 'File'}, ';
            }).where((e) => e != null),
            lastMessage.text ?? '',
          ];

          text = parts.join(' ');
        }

        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: _getDisplayText(
            text,
            lastMessage.mentionedUsers,
            StreamChatTheme.of(context).channelPreviewTheme.subtitle.copyWith(
                color: StreamChatTheme.of(context)
                    .channelPreviewTheme
                    .subtitle
                    .color,
                fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                    ? FontStyle.italic
                    : FontStyle.normal),
            StreamChatTheme.of(context).channelPreviewTheme.subtitle.copyWith(
                color: StreamChatTheme.of(context)
                    .channelPreviewTheme
                    .subtitle
                    .color,
                fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                    ? FontStyle.italic
                    : FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  TextSpan _getDisplayText(String text, List<User> mentions,
      TextStyle normalTextStyle, TextStyle mentionsTextStyle) {
    var textList = text.split(' ');
    List<TextSpan> resList = [];
    for (var e in textList) {
      if (mentions.any((element) => '@${element.name}' == e)) {
        resList.add(TextSpan(
          text: '$e ',
          style: mentionsTextStyle,
        ));
      } else {
        resList.add(TextSpan(
          text: '$e ',
          style: normalTextStyle,
        ));
      }
    }

    return TextSpan(children: resList);
  }
}

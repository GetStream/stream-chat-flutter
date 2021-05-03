import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

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
  final void Function(Channel)? onTap;

  /// Function called when long pressing this widget
  final void Function(Channel)? onLongPress;

  /// Channel displayed
  final Channel channel;

  /// The function called when the image is tapped
  final VoidCallback? onImageTap;

  /// Widget rendering the title
  final Widget? title;

  /// Widget rendering the subtitle
  final Widget? subtitle;

  /// Widget rendering the leading element, by default it shows the [ChannelImage]
  final Widget? leading;

  /// Widget rendering the trailing element, by default it shows the last message date
  final Widget? trailing;

  /// Widget rendering the sending indicator, by default it uses the [SendingIndicator] widget
  final Widget? sendingIndicator;

  ChannelPreview({
    required this.channel,
    Key? key,
    this.onTap,
    this.onLongPress,
    this.onImageTap,
    this.title,
    this.subtitle,
    this.leading,
    this.sendingIndicator,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelPreviewTheme = StreamChatTheme.of(context).channelPreviewTheme;
    return StreamBuilder<bool>(
        stream: channel.isMutedStream,
        initialData: channel.isMuted,
        builder: (context, snapshot) {
          return Opacity(
            opacity: snapshot.data! ? 0.5 : 1,
            child: ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              onTap: () {
                if (onTap != null) {
                  onTap!(channel);
                }
              },
              onLongPress: () {
                if (onLongPress != null) {
                  onLongPress!(channel);
                }
              },
              leading: leading ??
                  ChannelImage(
                    onTap: onImageTap,
                  ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: title ??
                        ChannelName(
                          textStyle: channelPreviewTheme.title,
                        ),
                  ),
                  StreamBuilder<List<Member>>(
                    stream: channel.state?.membersStream,
                    initialData: channel.state?.members,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.data!.isEmpty ||
                          !snapshot.data!.any((Member e) =>
                              e.user!.id == channel.client.state.user?.id)) {
                        return SizedBox();
                      }
                      return UnreadIndicator(
                        cid: channel.cid,
                      );
                    },
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child: subtitle ?? _buildSubtitle(context)),
                  sendingIndicator ??
                      Builder(
                        builder: (context) {
                          final lastMessage =
                              channel.state?.messages.lastWhereOrNull(
                            (m) => !m.isDeleted && m.shadowed != true,
                          );
                          if (lastMessage?.user?.id ==
                              StreamChat.of(context).user?.id) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: SendingIndicator(
                                message: lastMessage!,
                                size: channelPreviewTheme.indicatorIconSize,
                                isMessageRead: channel.state!.read
                                        ?.where((element) =>
                                            element.user.id !=
                                            channel.client.state.user!.id)
                                        .where((element) => element.lastRead
                                            .isAfter(lastMessage.createdAt))
                                        .isNotEmpty ==
                                    true,
                              ),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                  trailing ?? _buildDate(context),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildDate(BuildContext context) {
    return StreamBuilder<DateTime?>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }
        final lastMessageAt = snapshot.data!.toLocal();

        String stringDate;
        final now = DateTime.now();

        var startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.millisecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).jm;
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.subtract(Duration(days: 1)).millisecondsSinceEpoch) {
          stringDate = 'Yesterday';
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
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
            style: StreamChatTheme.of(context).channelPreviewTheme.subtitle,
          ),
        ],
      );
    }
    return TypingIndicator(
      channel: channel,
      alternativeWidget: _buildLastMessage(context),
      style: StreamChatTheme.of(context).channelPreviewTheme.subtitle,
    );
  }

  Widget _buildLastMessage(BuildContext context) {
    return StreamBuilder<List<Message>?>(
      stream: channel.state!.messagesStream,
      initialData: channel.state!.messages,
      builder: (context, snapshot) {
        final lastMessage = snapshot.data
            ?.lastWhereOrNull((m) => m.shadowed != true && !m.isDeleted);
        if (lastMessage == null) {
          return SizedBox();
        }

        var text = lastMessage.text;
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
                : '${e.title ?? 'File'} , ';
          }),
          lastMessage.text ?? '',
        ];

        text = parts.join(' ');

        return Text.rich(
          _getDisplayText(
            text,
            lastMessage.mentionedUsers,
            lastMessage.attachments,
            StreamChatTheme.of(context).channelPreviewTheme.subtitle?.copyWith(
                color: StreamChatTheme.of(context)
                    .channelPreviewTheme
                    .subtitle
                    ?.color,
                fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                    ? FontStyle.italic
                    : FontStyle.normal),
            StreamChatTheme.of(context).channelPreviewTheme.subtitle?.copyWith(
                  color: StreamChatTheme.of(context)
                      .channelPreviewTheme
                      .subtitle
                      ?.color,
                  fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                      ? FontStyle.italic
                      : FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  TextSpan _getDisplayText(
    String text,
    List<User> mentions,
    List<Attachment> attachments,
    TextStyle? normalTextStyle,
    TextStyle? mentionsTextStyle,
  ) {
    final textList = text.split(' ');
    final resList = <TextSpan>[];
    for (final e in textList) {
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
          text: e == textList.last ? '$e' : '$e ',
          style: normalTextStyle,
        ));
      }
    }

    return TextSpan(children: resList);
  }
}

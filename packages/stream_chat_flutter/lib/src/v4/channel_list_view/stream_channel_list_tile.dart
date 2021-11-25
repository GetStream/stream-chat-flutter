import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart' show Channel;
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/sending_indicator.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/channel_preview_theme.dart';
import 'package:stream_chat_flutter/src/typing_indicator.dart';
import 'package:stream_chat_flutter/src/unread_indicator.dart';
import 'package:stream_chat_flutter/src/v4/stream_channel_avatar.dart';
import 'package:stream_chat_flutter/src/v4/stream_channel_name.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// A widget that displays a channel preview.
///
/// This widget is intended to be used as a Tile in [StreamChannelListView]
///
/// It shows the last message of the channel, the last message time, the unread
/// message count, the typing indicator, the sending indicator and the channel
/// avatar.
///
/// See also:
/// * [StreamChannelAvatar]
/// * [StreamChannelName]
class StreamChannelListTile extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListTile] widget.
  StreamChannelListTile({
    Key? key,
    required this.channel,
    this.leading,
    this.title,
    this.subtitle,
    this.onTap,
    this.onLongPress,
    this.visualDensity = VisualDensity.compact,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
  })  : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        ),
        super(key: key);

  /// The channel to display.
  final Channel channel;

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final Widget? title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  /// Defines how compact the list tile's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  final VisualDensity visualDensity;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final channelState = channel.state!;
    final currentUser = channel.client.state.currentUser!;

    final channelPreviewTheme = ChannelPreviewTheme.of(context);

    final leading = this.leading ??
        StreamChannelAvatar(
          channel: channel,
        );

    final title = this.title ??
        StreamChannelName(
          channel: channel,
          textStyle: channelPreviewTheme.titleStyle,
        );

    final subtitle = this.subtitle ??
        ChannelListTileSubtitle(
          channel: channel,
          textStyle: channelPreviewTheme.subtitleStyle,
        );

    return BetterStreamBuilder<bool>(
      stream: channel.isMutedStream,
      initialData: channel.isMuted,
      builder: (context, isMuted) => AnimatedOpacity(
        opacity: isMuted ? 0.5 : 1,
        duration: const Duration(milliseconds: 300),
        child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          visualDensity: visualDensity,
          contentPadding: contentPadding,
          leading: leading,
          title: Row(
            children: [
              Expanded(child: title),
              BetterStreamBuilder<List<Member>>(
                stream: channelState.membersStream,
                initialData: channelState.members,
                comparator: const ListEquality().equals,
                builder: (context, members) {
                  if (members.isEmpty ||
                      !members.any((it) => it.user!.id == currentUser.id)) {
                    return const Offstage();
                  }
                  return UnreadIndicator(cid: channel.cid);
                },
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: subtitle,
                ),
              ),
              BetterStreamBuilder<List<Message>>(
                stream: channelState.messagesStream,
                initialData: channelState.messages,
                comparator: const ListEquality().equals,
                builder: (context, messages) {
                  final lastMessage = messages.lastWhereOrNull(
                    (m) => !m.shadowed && !m.isDeleted,
                  );

                  if (lastMessage == null ||
                      (lastMessage.user?.id != currentUser.id)) {
                    return const Offstage();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: SendingIndicator(
                      message: lastMessage,
                      size: channelPreviewTheme.indicatorIconSize,
                      isMessageRead: channelState.read
                          .where((it) => it.user.id != currentUser.id)
                          .where(
                            (it) => it.lastRead.isAfter(lastMessage.createdAt),
                          )
                          .isNotEmpty,
                    ),
                  );
                },
              ),
              ChannelLastMessageDate(
                channel: channel,
                textStyle: channelPreviewTheme.lastMessageAtStyle,
              ),
              // trailing ?? _buildDate(context),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that displays the channel last message date.
class ChannelLastMessageDate extends StatelessWidget {
  /// Creates a new instance of the [ChannelLastMessageDate] widget.
  ChannelLastMessageDate({
    Key? key,
    required this.channel,
    this.textStyle,
  })  : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        ),
        super(key: key);

  /// The channel to display the last message date for.
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => BetterStreamBuilder<DateTime>(
        stream: channel.lastMessageAtStream,
        initialData: channel.lastMessageAt,
        builder: (context, data) {
          final lastMessageAt = data.toLocal();

          String stringDate;
          final now = DateTime.now();

          final startOfDay = DateTime(now.year, now.month, now.day);

          if (lastMessageAt.millisecondsSinceEpoch >=
              startOfDay.millisecondsSinceEpoch) {
            stringDate = Jiffy(lastMessageAt.toLocal()).jm;
          } else if (lastMessageAt.millisecondsSinceEpoch >=
              startOfDay
                  .subtract(const Duration(days: 1))
                  .millisecondsSinceEpoch) {
            stringDate = context.translations.yesterdayLabel;
          } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
            stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
          } else {
            stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
          }

          return Text(
            stringDate,
            style: textStyle,
          );
        },
      );
}

/// A widget that displays the subtitle for [StreamChannelListTile].
class ChannelListTileSubtitle extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListTileSubtitle] widget.
  ChannelListTileSubtitle({
    Key? key,
    required this.channel,
    this.textStyle,
  })  : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        ),
        super(key: key);

  /// The channel to create the subtitle from.
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (channel.isMuted) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          StreamSvgIcon.mute(size: 16),
          Text(
            '  ${context.translations.channelIsMutedText}',
            style: textStyle,
          ),
        ],
      );
    }
    return TypingIndicator(
      channel: channel,
      style: textStyle,
      alternativeWidget: ChannelLastMessageText(
        channel: channel,
        textStyle: textStyle,
      ),
    );
  }
}

/// A widget that displays the last message of a channel.
class ChannelLastMessageText extends StatelessWidget {
  /// Creates a new instance of [ChannelLastMessageText] widget.
  ChannelLastMessageText({
    Key? key,
    required this.channel,
    this.textStyle,
  })  : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        ),
        super(key: key);

  /// The channel to display the last message of.
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => BetterStreamBuilder<List<Message>>(
        stream: channel.state!.messagesStream,
        initialData: channel.state!.messages,
        builder: (context, messages) {
          final lastMessage = messages.lastWhereOrNull(
            (m) => !m.shadowed && !m.isDeleted,
          );

          if (lastMessage == null) return const Offstage();

          final lastMessageText = lastMessage.text;
          final lastMessageAttachments = lastMessage.attachments;
          final lastMessageMentionedUsers = lastMessage.mentionedUsers;

          final messageTextParts = [
            ...lastMessageAttachments.map((it) {
              if (it.type == 'image') {
                return '📷';
              } else if (it.type == 'video') {
                return '🎬';
              } else if (it.type == 'giphy') {
                return '[GIF]';
              }
              return it == lastMessage.attachments.last
                  ? (it.title ?? 'File')
                  : '${it.title ?? 'File'} , ';
            }),
            if (lastMessageText != null) lastMessageText,
          ];

          final fontStyle = (lastMessage.isSystem || lastMessage.isDeleted)
              ? FontStyle.italic
              : FontStyle.normal;

          final regularTextStyle = textStyle?.copyWith(fontStyle: fontStyle);

          final mentionsTextStyle = textStyle?.copyWith(
            fontStyle: fontStyle,
            fontWeight: FontWeight.bold,
          );

          final spans = [
            for (final part in messageTextParts)
              if (lastMessageMentionedUsers.isNotEmpty &&
                  lastMessageMentionedUsers.any((it) => '@${it.name}' == part))
                TextSpan(
                  text: '$part ',
                  style: mentionsTextStyle,
                )
              else if (lastMessageAttachments.isNotEmpty &&
                  lastMessageAttachments
                      .where((it) => it.title != null)
                      .any((it) => it.title == part))
                TextSpan(
                  text: '$part ',
                  style: regularTextStyle,
                )
              else
                TextSpan(
                  text: part == messageTextParts.last ? part : '$part ',
                  style: regularTextStyle,
                ),
          ];

          return Text.rich(
            TextSpan(children: spans),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          );
        },
      );
}

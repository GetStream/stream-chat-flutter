import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a channel preview.
///
/// This widget is intended to be used as a Tile in [StreamChannelListView].
///
/// It shows the last message of the channel, the last message time, the unread
/// message count, the typing indicator, the sending indicator and the channel
/// avatar.
///
/// Internally uses [StreamChannelListItem] from the core design system for
/// consistent visual presentation.
///
/// See also:
/// * [StreamChannelAvatar]
/// * [StreamChannelName]
/// * [StreamChannelListItem]
class StreamChannelListTile extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListTile] widget.
  StreamChannelListTile({
    super.key,
    required this.channel,
    this.leading,
    this.title,
    this.titleTrailing,
    this.subtitle,
    this.subtitleTrailing,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.sendingIndicatorBuilder,
  }) : assert(
         channel.state != null,
         'Channel ${channel.id} is not initialized',
       );

  /// The channel to display.
  final Channel channel;

  /// A widget to display as the avatar.
  ///
  /// Defaults to [StreamChannelAvatar].
  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Defaults to [StreamChannelName].
  final Widget? title;

  /// An optional widget displayed after the title.
  ///
  /// Typically used for a mute icon or similar indicator.
  final Widget? titleTrailing;

  /// Additional content displayed below the title.
  ///
  /// Defaults to [ChannelListTileSubtitle] which shows typing indicators,
  /// draft messages, or the last message preview.
  final Widget? subtitle;

  /// An optional trailing widget in the subtitle row.
  ///
  /// When not provided, a sending indicator is shown for outgoing messages.
  final Widget? subtitleTrailing;

  /// A widget to display as the timestamp.
  ///
  /// Defaults to [ChannelLastMessageDate].
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  /// The widget builder for the sending indicator.
  ///
  /// `Message` is the last message in the channel. Use it to determine the
  /// status using [Message.state].
  final Widget Function(BuildContext, Message)? sendingIndicatorBuilder;

  /// Creates a copy of this tile but with the given fields replaced with
  /// the new values.
  StreamChannelListTile copyWith({
    Key? key,
    Channel? channel,
    Widget? leading,
    Widget? title,
    Widget? titleTrailing,
    Widget? subtitle,
    Widget? subtitleTrailing,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Widget Function(BuildContext, Message)? sendingIndicatorBuilder,
  }) {
    return StreamChannelListTile(
      key: key ?? this.key,
      channel: channel ?? this.channel,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      titleTrailing: titleTrailing ?? this.titleTrailing,
      subtitle: subtitle ?? this.subtitle,
      subtitleTrailing: subtitleTrailing ?? this.subtitleTrailing,
      trailing: trailing ?? this.trailing,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      sendingIndicatorBuilder:
          sendingIndicatorBuilder ?? this.sendingIndicatorBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final channelState = channel.state!;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final avatar = leading ?? StreamChannelAvatar(channel: channel);
    final titleWidget =
        title ??
        StreamChannelName(
          channel: channel,
          textStyle: textTheme.headingSm.copyWith(height: 1),
        );
    final subtitleWidget =
        subtitle ??
        ChannelListTileSubtitle(
          channel: channel,
          textStyle: textTheme.captionDefault.copyWith(
            color: colorScheme.textSecondary,
          ),
          sendingIndicatorBuilder: sendingIndicatorBuilder,
        );
    final timestampWidget =
        trailing ??
        ChannelLastMessageDate(
          channel: channel,
          textStyle: textTheme.captionDefault.copyWith(
            color: colorScheme.textTertiary,
          ),
        );

    return BetterStreamBuilder<bool>(
      stream: channel.isMutedStream,
      initialData: channel.isMuted,
      builder: (context, isMuted) => BetterStreamBuilder<int>(
        stream: channelState.unreadCountStream,
        initialData: channelState.unreadCount,
        builder: (context, unreadCount) {
          final titleTrailing = isMuted
              ? Icon(
                  context.streamIcons.mute,
                  size: 20,
                  color: colorScheme.textTertiary,
                )
              : null;
          return StreamChannelListItem(
            avatar: avatar,
            title: titleWidget,
            titleTrailing: titleTrailing,
            subtitle: subtitleWidget,
            timestamp: timestampWidget,
            unreadCount: unreadCount,
            onTap: onTap,
            onLongPress: onLongPress,
          );
        },
      ),
    );
  }
}

/// Shows the delivery status icon + "You:" prefix for outgoing messages in
/// the channel list.
///
/// Unlike [StreamSendingIndicator], this widget does not show a read count
/// number. It only shows:
/// - Clock icon + "You:" (sending)
/// - Single check + "You:" (sent)
/// - Double check grey + "You:" (delivered)
/// - Double check blue + "You:" (read)
class _ChannelListDeliveryStatus extends StatelessWidget {
  const _ChannelListDeliveryStatus({
    required this.channel,
    required this.message,
  });

  final Channel channel;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    final colorScheme = context.streamColorScheme;

    return BetterStreamBuilder<List<Read>>(
      stream: channel.state?.readStream,
      initialData: channel.state?.read,
      builder: (context, data) {
        final isRead = data.readsOf(message: message).isNotEmpty;
        final isDelivered = data.deliveriesOf(message: message).isNotEmpty;

        final Widget icon;
        if (isRead) {
          icon = StreamSvgIcon(
            size: 16,
            icon: StreamSvgIcons.checkAll,
            color: colorTheme.accentPrimary,
          );
        } else if (isDelivered) {
          icon = StreamSvgIcon(
            size: 16,
            icon: StreamSvgIcons.checkAll,
            color: colorScheme.textTertiary,
          );
        } else if (message.state.isCompleted) {
          icon = StreamSvgIcon(
            size: 16,
            icon: StreamSvgIcons.check,
            color: colorScheme.textTertiary,
          );
        } else if (message.state.isOutgoing) {
          icon = StreamSvgIcon(
            size: 16,
            icon: StreamSvgIcons.time,
            color: colorScheme.textTertiary,
          );
        } else {
          return const Empty();
        }

        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: icon,
        );
      },
    );
  }
}

/// A widget that displays the channel last message date.
class ChannelLastMessageDate extends StatelessWidget {
  /// Creates a new instance of the [ChannelLastMessageDate] widget.
  ChannelLastMessageDate({
    super.key,
    required this.channel,
    this.textStyle,
    this.formatter,
  }) : assert(
         channel.state != null,
         'Channel ${channel.id} is not initialized',
       );

  /// The channel to display the last message date for.
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// The formatter to format the date.
  final DateFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    return BetterStreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, lastMessageAt) => StreamTimestamp(
        date: lastMessageAt.toLocal(),
        style: textStyle,
        formatter: formatter,
      ),
    );
  }
}

/// A widget that displays the subtitle for [StreamChannelListTile].
///
/// Shows typing indicators, draft messages, or the last message preview.
/// The delivery status prefix (icon + "You:") is only shown when the subtitle
/// displays an actual sent message from the current user (not for drafts or
/// typing indicators).
class ChannelListTileSubtitle extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListTileSubtitle] widget.
  ChannelListTileSubtitle({
    super.key,
    required this.channel,
    this.textStyle,
    this.sendingIndicatorBuilder,
  }) : assert(
         channel.state != null,
         'Channel ${channel.id} is not initialized',
       );

  /// The channel to create the subtitle from.
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// The widget builder for the sending indicator.
  ///
  /// `Message` is the last message in the channel. Use it to determine the
  /// status using [Message.state].
  final Widget Function(BuildContext, Message)? sendingIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    if (channel.isMuted) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const StreamSvgIcon(size: 16, icon: StreamSvgIcons.mute),
          Expanded(
            child: Text(
              '  ${context.translations.channelIsMutedText}',
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    return StreamTypingIndicator(
      channel: channel,
      style: textStyle,
      alternativeWidget: _ChannelLastMessageWithStatus(
        channel: channel,
        textStyle: textStyle,
        sendingIndicatorBuilder: sendingIndicatorBuilder,
      ),
    );
  }
}

/// Combines the delivery status prefix with the last message text.
///
/// Shows the delivery status only when the displayed content is an actual
/// sent message from the current user (not a draft).
class _ChannelLastMessageWithStatus extends StatefulWidget {
  const _ChannelLastMessageWithStatus({
    required this.channel,
    this.textStyle,
    this.sendingIndicatorBuilder,
  });

  final Channel channel;
  final TextStyle? textStyle;
  final Widget Function(BuildContext, Message)? sendingIndicatorBuilder;

  @override
  State<_ChannelLastMessageWithStatus> createState() =>
      _ChannelLastMessageWithStatusState();
}

class _ChannelLastMessageWithStatusState
    extends State<_ChannelLastMessageWithStatus> {
  Message? _currentLastMessage;

  static bool _defaultLastMessagePredicate(Message message) {
    if (message.isShadowed) return false;
    if (message.isDeleted) return false;
    if (message.isError) return false;
    if (message.isEphemeral) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final channelState = widget.channel.state;
    if (channelState == null) return const Empty();

    final currentUser = widget.channel.client.state.currentUser;

    return BetterStreamBuilder<(Draft?, List<Message>)>(
      stream: CombineLatestStream.combine2(
        channelState.draftStream,
        channelState.messagesStream,
        (draft, messages) => (draft, messages),
      ),
      initialData: (channelState.draft, channelState.messages),
      builder: (context, data) {
        final (draft, messages) = data;

        // If there's a draft, show only the draft preview (no delivery status).
        if (draft?.message case final draftMessage?) {
          return StreamDraftMessagePreviewText(
            draftMessage: draftMessage,
            textStyle: widget.textStyle,
          );
        }

        // Find the last valid message.
        final message = messages.lastWhereOrNull(
          _defaultLastMessagePredicate,
        );
        final latestLastMessage = [message, _currentLastMessage].latest;

        if (latestLastMessage == null) {
          return Text(
            context.translations.emptyMessagesText,
            style: widget.textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        final isOwnMessage =
            currentUser != null &&
            latestLastMessage.user?.id == currentUser.id;

        // Show delivery status prefix only for own messages.
        final Widget deliveryPrefix;
        if (isOwnMessage) {
          deliveryPrefix =
              widget.sendingIndicatorBuilder
                  ?.call(context, latestLastMessage) ??
              _ChannelListDeliveryStatus(
                channel: widget.channel,
                message: latestLastMessage,
              );
        } else {
          deliveryPrefix = const Empty();
        }

        return Row(
          children: [
            deliveryPrefix,
            Flexible(
              child: StreamMessagePreviewText(
                message: latestLastMessage,
                textStyle: widget.textStyle,
                channel: channelState.channelState.channel,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A widget that displays the last message of a channel.
class ChannelLastMessageText extends StatefulWidget {
  /// Creates a new instance of [ChannelLastMessageText] widget.
  ChannelLastMessageText({
    super.key,
    required this.channel,
    this.textStyle,
    this.lastMessagePredicate = _defaultLastMessagePredicate,
  }) : assert(
         channel.state != null,
         'Channel ${channel.id} is not initialized',
       );

  /// The channel to display the last message of.
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// The predicate to determine if the message should be considered for the
  /// last message.
  ///
  /// This predicate is used to filter out messages that should not be
  /// considered for the last message.
  final bool Function(Message) lastMessagePredicate;

  // The default predicate to determine if the message should be
  // considered for the last message.
  static bool _defaultLastMessagePredicate(Message message) {
    if (message.isShadowed) return false;
    if (message.isDeleted) return false;
    if (message.isError) return false;
    if (message.isEphemeral) return false;

    return true;
  }

  @override
  State<ChannelLastMessageText> createState() => _ChannelLastMessageTextState();
}

class _ChannelLastMessageTextState extends State<ChannelLastMessageText> {
  Message? _currentLastMessage;

  @override
  Widget build(BuildContext context) {
    final channelState = widget.channel.state;
    if (channelState == null) return const Empty();

    return BetterStreamBuilder<(Draft?, List<Message>)>(
      stream: CombineLatestStream.combine2(
        channelState.draftStream,
        channelState.messagesStream,
        (draft, messages) => (draft, messages),
      ),
      initialData: (channelState.draft, channelState.messages),
      builder: (context, data) {
        final (draft, messages) = data;

        // Prioritize the draft message if it exists.
        if (draft?.message case final draftMessage?) {
          return StreamDraftMessagePreviewText(
            draftMessage: draftMessage,
            textStyle: widget.textStyle,
          );
        }

        // Otherwise, show the channel last message if it exists.
        final message = messages.lastWhereOrNull(widget.lastMessagePredicate);
        final latestLastMessage = [message, _currentLastMessage].latest;

        if (latestLastMessage == null) {
          return Text(
            maxLines: 1,
            context.translations.emptyMessagesText,
            style: widget.textStyle,
            overflow: TextOverflow.ellipsis,
          );
        }

        return StreamMessagePreviewText(
          message: latestLastMessage,
          textStyle: widget.textStyle,
          channel: channelState.channelState.channel,
        );
      },
    );
  }
}

extension on Iterable<Message?> {
  Message? get latest {
    return reduce((a, b) {
      if (a == null) return b;
      if (b == null) return a;

      if (a.createdAt.isAfter(b.createdAt)) return a;
      return b;
    });
  }
}

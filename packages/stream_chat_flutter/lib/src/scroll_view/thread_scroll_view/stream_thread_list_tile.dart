import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamThreadListTile}
/// A widget that displays a thread in a list.
///
/// This widget is used in the [ThreadListView] to display a thread.
///
/// The widget displays the channel name, the message the thread is replying to,
/// the latest reply, and the unread message count.
/// {@endtemplate}
class StreamThreadListTile extends StatelessWidget {
  /// {@macro streamThreadListTile}
  const StreamThreadListTile({
    super.key,
    required this.thread,
    this.currentUser,
    this.onTap,
    this.onLongPress,
  });

  /// The thread to display.
  final Thread thread;

  /// The current user.
  final User? currentUser;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final language = currentUser?.language;
    final unreadMessageCount = thread.read
        ?.firstWhereOrNull((read) => read.user.id == currentUser?.id)
        ?.unreadMessages;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (thread.channel case final channel?)
              ThreadTitle(
                channelName: channel.formatName(currentUser: currentUser),
              ),
            Row(
              children: [
                if (thread.parentMessage case final parentMessage?)
                  Expanded(
                    child: ThreadReplyToContent(
                      language: language,
                      prefix: context.translations.repliedToLabel,
                      parentMessage: parentMessage,
                    ),
                  ),
                if (unreadMessageCount case final count? when count > 0)
                  ThreadUnreadCount(unreadCount: count),
              ],
            ),
            if (thread.latestReplies.lastOrNull case final latestReply?)
              ThreadLatestReply(
                language: language,
                latestReply: latestReply,
              ),
          ].insertBetween(const SizedBox(height: 6)),
        ),
      ),
    );
  }
}

/// {@template threadTitle}
/// A widget that displays the channel name.
/// {@endtemplate}
class ThreadTitle extends StatelessWidget {
  /// {@macro threadTitle}
  const ThreadTitle({
    super.key,
    this.channelName,
  });

  /// The channel name to display.
  final String? channelName;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.message_outlined,
          size: 16,
          color: theme.colorTheme.textHighEmphasis,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            channelName ?? context.translations.noTitleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyBold,
          ),
        ),
      ],
    );
  }
}

/// {@template threadReplyToContent}
/// A widget that displays the message the thread is replying to.
/// {@endtemplate}
class ThreadReplyToContent extends StatelessWidget {
  /// {@macro threadReplyToContent}
  const ThreadReplyToContent({
    super.key,
    this.language,
    this.prefix = 'replied to:',
    required this.parentMessage,
  });

  /// The prefix to display before the message.
  ///
  /// Defaults to `replied to:`.
  final String prefix;

  /// The language of the message.
  final String? language;

  /// The message the thread is replying to.
  final Message parentMessage;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          prefix,
          style: theme.textTheme.footnote.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: StreamMessagePreviewText(
            language: language,
            message: parentMessage,
            textStyle: theme.textTheme.footnote.copyWith(
              color: theme.colorTheme.textLowEmphasis,
            ),
          ),
        ),
      ],
    );
  }
}

/// {@template threadUnreadCount}
/// A widget that displays the unread message count.
/// {@endtemplate}
class ThreadUnreadCount extends StatelessWidget {
  /// {@macro threadUnreadCount}
  const ThreadUnreadCount({
    super.key,
    required this.unreadCount,
  }) : assert(unreadCount > 0, 'unreadCount must be greater than 0');

  /// The number of unread messages.
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Badge(
      textColor: Colors.white,
      textStyle: theme.textTheme.footnoteBold,
      backgroundColor: theme.channelPreviewTheme.unreadCounterColor,
      label: Text('$unreadCount'),
    );
  }
}

/// {@template threadLatestReply}
/// A widget that displays the latest reply in the thread.
/// {@endtemplate}
class ThreadLatestReply extends StatelessWidget {
  /// {@macro threadLatestReply}
  const ThreadLatestReply({
    super.key,
    this.language,
    required this.latestReply,
  });

  /// The language of the message.
  final String? language;

  /// The latest reply in the thread.
  final Message latestReply;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Row(
      children: <Widget>[
        if (latestReply.user case final user?) StreamUserAvatar(user: user),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                latestReply.user!.name,
                style: theme.textTheme.bodyBold,
              ),
              Row(
                children: [
                  Expanded(
                    child: StreamMessagePreviewText(
                      language: language,
                      message: latestReply,
                      textStyle: theme.textTheme.body.copyWith(
                        color: theme.colorTheme.textLowEmphasis,
                      ),
                    ),
                  ),
                  StreamTimestamp(
                    date: latestReply.createdAt.toLocal(),
                    style: theme.textTheme.body.copyWith(
                      color: theme.colorTheme.textLowEmphasis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ].insertBetween(const SizedBox(width: 8)),
    );
  }
}
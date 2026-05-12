import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
  StreamThreadListTile({
    super.key,
    required Thread thread,
    User? currentUser,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
  }) : props = StreamThreadListTileProps(
         thread: thread,
         currentUser: currentUser,
         onTap: onTap,
         onLongPress: onLongPress,
       );

  /// Creates a thread list tile from pre-built [props].
  const StreamThreadListTile.fromProps({
    super.key,
    required this.props,
  });

  /// The properties configuring this thread list tile.
  final StreamThreadListTileProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamThreadListTileProps>();
    return builder?.call(context, props) ?? _DefaultStreamThreadListTile(props: props);
  }
}

/// Properties for configuring a [StreamThreadListTile].
class StreamThreadListTileProps {
  /// Creates properties for a thread list tile.
  const StreamThreadListTileProps({
    required this.thread,
    this.currentUser,
    this.onTap,
    this.onLongPress,
  });

  /// The thread displayed by the tile.
  final Thread thread;

  /// The current user.
  final User? currentUser;

  /// Called when the tile is tapped.
  final GestureTapCallback? onTap;

  /// Called when the tile is long pressed.
  final GestureLongPressCallback? onLongPress;
}

class _DefaultStreamThreadListTile extends StatelessWidget {
  const _DefaultStreamThreadListTile({
    required this.props,
  });

  final StreamThreadListTileProps props;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    final theme = StreamThreadListTileTheme.of(context);
    final defaults = _StreamThreadListTileThemeDefaults(context);

    final effectiveBackgroundColor = theme.backgroundColor ?? defaults.backgroundColor;
    final effectivePadding = theme.padding ?? defaults.padding;
    final effectiveChannelNameStyle = theme.threadChannelNameStyle ?? defaults.threadChannelNameStyle;
    final effectiveReplyToMessageStyle = theme.threadReplyToMessageStyle ?? defaults.threadReplyToMessageStyle;
    final effectiveLatestReplyMessageStyle =
        theme.threadLatestReplyMessageStyle ?? defaults.threadLatestReplyMessageStyle;
    final effectiveReplyCountStyle = theme.threadReplyCountStyle ?? defaults.threadReplyCountStyle;
    final effectiveTimestampStyle = theme.threadLatestReplyTimestampStyle ?? defaults.threadLatestReplyTimestampStyle;
    final effectiveTimestampFormatter =
        theme.threadLatestReplyTimestampFormatter ?? defaults.threadLatestReplyTimestampFormatter;
    final effectiveUnreadCountStyle = theme.threadUnreadMessageCountStyle ?? defaults.threadUnreadMessageCountStyle;
    final effectiveUnreadCountBackgroundColor =
        theme.threadUnreadMessageCountBackgroundColor ?? defaults.threadUnreadMessageCountBackgroundColor;

    final thread = props.thread;
    final currentUser = props.currentUser;
    final parentMessage = thread.parentMessage;
    final latestReply = thread.latestReplies.lastOrNull;
    final channel = thread.channel;
    final language = currentUser?.language;
    final unreadMessageCount = thread.read?.firstWhereOrNull((read) => read.user.id == currentUser?.id)?.unreadMessages;
    final latestActivityAt = thread.lastMessageAt ?? latestReply?.createdAt ?? thread.updatedAt;
    final avatarUser = parentMessage?.user ?? latestReply?.user ?? thread.createdBy;
    final channelName =
        channel?.formatName(currentUser: currentUser) ?? avatarUser?.name ?? context.translations.noTitleText;
    final participantUsers = thread.threadParticipants.map((it) => it.user).nonNulls.toList(growable: false);

    return Padding(
      padding: EdgeInsets.all(spacing.xxs),
      child: StreamListTileTheme(
        data: StreamListTileThemeData(
          contentPadding: effectivePadding,
          backgroundColor: .all(effectiveBackgroundColor),
        ),
        child: StreamListTileContainer(
          onTap: props.onTap,
          onLongPress: props.onLongPress,
          child: Row(
            spacing: spacing.sm,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (avatarUser case final user?)
                StreamUserAvatar(
                  user: user,
                  size: StreamAvatarSize.xl,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      spacing: spacing.sm,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ThreadTitle(
                            channelName: channelName,
                            style: effectiveChannelNameStyle,
                          ),
                        ),
                        if (unreadMessageCount case final count? when count > 0)
                          ThreadUnreadCount(
                            unreadCount: count,
                            style: effectiveUnreadCountStyle,
                            backgroundColor: effectiveUnreadCountBackgroundColor,
                          ),
                      ],
                    ),
                    SizedBox(height: spacing.xxs),
                    ThreadRootMessagePreview(
                      parentMessage: parentMessage,
                      channel: channel,
                      language: language,
                      style: effectiveReplyToMessageStyle,
                      emptyStyle: effectiveLatestReplyMessageStyle,
                    ),
                    SizedBox(height: spacing.xs),
                    ThreadFooter(
                      participantUsers: participantUsers,
                      replyCount: thread.replyCount,
                      latestActivityAt: latestActivityAt,
                      replyCountStyle: effectiveReplyCountStyle,
                      timestampStyle: effectiveTimestampStyle,
                      timestampFormatter: effectiveTimestampFormatter,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    this.style,
  });

  /// The channel name to display.
  final String? channelName;

  /// The text style to use.
  ///
  /// When null, uses the effective style resolved from the theme and defaults.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      channelName ?? context.translations.noTitleText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}

/// A widget that displays the original thread message as a single-line preview.
class ThreadRootMessagePreview extends StatelessWidget {
  /// Creates a new instance of [ThreadRootMessagePreview].
  const ThreadRootMessagePreview({
    super.key,
    required this.parentMessage,
    this.channel,
    this.language,
    this.style,
    this.emptyStyle,
  });

  /// The root message of the thread.
  final Message? parentMessage;

  /// The channel the thread belongs to.
  final ChannelModel? channel;

  /// The language used for translations.
  final String? language;

  /// The text style used for the message preview.
  ///
  /// When null, uses the effective style resolved from the theme and defaults.
  final TextStyle? style;

  /// The text style used when no parent message is available.
  ///
  /// When null, uses the effective style resolved from the theme and defaults.
  final TextStyle? emptyStyle;

  @override
  Widget build(BuildContext context) {
    if (parentMessage case final message?) {
      return StreamMessagePreviewText(
        message: message,
        channel: channel,
        language: language,
        textStyle: style,
      );
    }

    return Text(
      context.translations.emptyMessagesText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: emptyStyle,
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
    this.style,
    this.backgroundColor,
  }) : assert(unreadCount > 0, 'unreadCount must be greater than 0');

  /// The number of unread messages.
  final int unreadCount;

  /// The text style for the badge label.
  ///
  /// When null, uses the effective style resolved from the theme and defaults.
  final TextStyle? style;

  /// The background color for the badge.
  ///
  /// When null, uses the effective color resolved from the theme and defaults.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Badge(
      textStyle: style,
      textColor: style?.color,
      backgroundColor: backgroundColor,
      largeSize: 20,
      label: Text('$unreadCount'),
    );
  }
}

/// A widget that displays reply metadata for a thread.
class ThreadFooter extends StatelessWidget {
  /// Creates a new instance of [ThreadFooter].
  const ThreadFooter({
    super.key,
    required this.participantUsers,
    required this.replyCount,
    required this.latestActivityAt,
    this.replyCountStyle,
    this.timestampStyle,
    this.timestampFormatter,
  });

  /// Users participating in the thread.
  final List<User> participantUsers;

  /// The number of replies in the thread.
  final int replyCount;

  /// The latest activity time in the thread.
  final DateTime latestActivityAt;

  /// The text style for the reply count label.
  ///
  /// When null, uses the effective style resolved from the theme and defaults.
  final TextStyle? replyCountStyle;

  /// The text style for the timestamp.
  ///
  /// When null, uses the effective style resolved from the theme and defaults.
  final TextStyle? timestampStyle;

  /// The formatter to use for the timestamp.
  ///
  /// When null, uses [formatRecentDateTime].
  final DateFormatter? timestampFormatter;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Row(
      spacing: spacing.xs,
      children: [
        if (participantUsers.isNotEmpty)
          StreamUserAvatarStack(
            users: participantUsers,
            size: StreamAvatarStackSize.sm,
            max: 3,
          ),
        Text(
          context.translations.threadReplyCountText(replyCount),
          style: replyCountStyle,
        ),
        StreamTimestamp(
          date: latestActivityAt.toLocal(),
          style: timestampStyle,
          formatter: timestampFormatter ?? formatRecentDateTime,
        ),
      ],
    );
  }
}

class _StreamThreadListTileThemeDefaults extends StreamThreadListTileThemeData {
  _StreamThreadListTileThemeDefaults(this._context);

  final BuildContext _context;

  late final _spacing = _context.streamSpacing;
  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;

  @override
  EdgeInsetsGeometry get padding => EdgeInsets.all(_spacing.sm);

  @override
  Color get backgroundColor => _colorScheme.backgroundApp;

  @override
  TextStyle get threadChannelNameStyle => _textTheme.captionEmphasis.copyWith(color: _colorScheme.textTertiary);

  @override
  TextStyle get threadReplyToMessageStyle => _textTheme.bodyDefault;

  @override
  TextStyle get threadLatestReplyMessageStyle => _textTheme.bodyDefault;

  @override
  TextStyle get threadReplyCountStyle => _textTheme.captionEmphasis.copyWith(color: _colorScheme.textLink);

  @override
  TextStyle get threadLatestReplyTimestampStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.textTertiary);

  @override
  DateFormatter get threadLatestReplyTimestampFormatter => formatRecentDateTime;

  @override
  TextStyle get threadUnreadMessageCountStyle => _textTheme.numericXl.copyWith(color: _colorScheme.textOnAccent);

  @override
  Color get threadUnreadMessageCountBackgroundColor => _colorScheme.accentPrimary;
}

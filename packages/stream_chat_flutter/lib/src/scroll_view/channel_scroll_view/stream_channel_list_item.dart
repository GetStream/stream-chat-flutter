import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A widget that displays a channel preview.
///
/// This widget is intended to be used as a Tile in [StreamChannelListView].
///
/// It shows the last message of the channel, the last message time, the unread
/// message count, the typing indicator, the sending indicator and the channel
/// avatar.
///
/// Internally uses [StreamListTileContainer] from the core design system for
/// consistent visual presentation.
///
/// See also:
/// * [StreamChannelAvatar]
/// * [StreamChannelName]
class StreamChannelListItem extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListItem] widget.
  StreamChannelListItem({
    super.key,
    required Channel channel,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    bool selected = false,
  }) : assert(
         channel.state != null,
         'Channel ${channel.id} is not initialized',
       ),
       props = .new(
         channel: channel,
         onTap: onTap,
         onLongPress: onLongPress,
         selected: selected,
       );

  /// The properties for the channel list item.
  final StreamChannelListItemProps props;

  /// Creates a copy of this tile but with the given fields replaced with
  /// the new values.
  StreamChannelListItem copyWith({
    Key? key,
    Channel? channel,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool? selected,
  }) {
    return StreamChannelListItem(
      key: key ?? this.key,
      channel: channel ?? props.channel,
      onTap: onTap ?? props.onTap,
      onLongPress: onLongPress ?? props.onLongPress,
      selected: selected ?? props.selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamChannelListItemProps>();
    return builder?.call(context, props) ?? _DefaultStreamChannelListItem(props: props);
  }
}

/// Properties for configuring a [StreamChannelListItem].
///
/// This class holds all the configuration options for a channel list item,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamChannelListItem], which uses these properties.
///  * [DefaultStreamChannelListItem], the default implementation.
class StreamChannelListItemProps {
  /// Creates properties for a channel list item.
  const StreamChannelListItemProps({
    required this.channel,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.sendingIndicatorBuilder,
    this.selected = false,
  });

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

  /// Additional content displayed below the title.
  ///
  /// Defaults to [ChannelListTileSubtitle] which shows typing indicators,
  /// draft messages, or the last message preview.
  final Widget? subtitle;

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

  /// True if the tile is in a selected state.
  final bool selected;
}

class _DefaultStreamChannelListItem extends StatelessWidget {
  const _DefaultStreamChannelListItem({
    required this.props,
  });

  final StreamChannelListItemProps props;

  @override
  Widget build(BuildContext context) {
    final channelState = props.channel.state!;
    final textTheme = context.streamTextTheme;

    final avatar = props.leading ?? StreamChannelAvatar(channel: props.channel, size: StreamAvatarGroupSize.xl);
    final titleWidget =
        props.title ??
        StreamChannelName(
          channel: props.channel,
          textStyle: textTheme.headingSm.copyWith(height: 1),
        );
    final subtitleWidget =
        props.subtitle ??
        ChannelListTileSubtitle(
          channel: props.channel,
          sendingIndicatorBuilder: props.sendingIndicatorBuilder,
        );
    final timestampWidget = props.trailing ?? ChannelLastMessageDate(channel: props.channel);

    return BetterStreamBuilder<bool>(
      stream: props.channel.isMutedStream,
      initialData: props.channel.isMuted,
      builder: (context, isMuted) => BetterStreamBuilder<int>(
        stream: channelState.unreadCountStream,
        initialData: channelState.unreadCount,
        builder: (context, unreadCount) {
          return StreamChannelListTile(
            avatar: avatar,
            title: titleWidget,
            subtitle: subtitleWidget,
            timestamp: timestampWidget,
            unreadCount: unreadCount,
            isMuted: isMuted,
            onTap: props.onTap,
            onLongPress: props.onLongPress,
            selected: props.selected,
          );
        },
      ),
    );
  }
}

/// A widget that displays a channel list tile.
/// It's the basic component for [StreamChannelListItem] without any of the logic.
/// It can be used to fully customize the list tile data being shown.
class StreamChannelListTile extends StatelessWidget {
  /// Creates a new instance of [StreamChannelListTile] widget.
  const StreamChannelListTile({
    super.key,
    required this.avatar,
    required this.title,
    this.subtitle,
    this.timestamp,
    this.unreadCount = 0,
    this.isMuted = false,
    this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  /// The avatar widget displayed at the leading edge.
  ///
  /// Typically a [StreamAvatar], [StreamAvatarGroup], or an avatar wrapped
  /// in a [StreamOnlineIndicator].
  final Widget avatar;

  /// The channel title widget.
  ///
  /// Typically a [Text] widget with the channel name. The default text style
  /// is provided by the theme's title style via [DefaultTextStyle].
  final Widget title;

  /// The message preview widget displayed below the title.
  ///
  /// Typically a [Text] widget with the last message, but can be any widget
  /// for richer content (e.g., icons, read receipts, sender prefix).
  final Widget? subtitle;

  /// The timestamp widget displayed in the trailing section of the title row.
  ///
  /// Typically a [Text] widget with a formatted date string. The default text
  /// style is provided by the theme's timestamp style via [DefaultTextStyle].
  final Widget? timestamp;

  /// The number of unread messages.
  ///
  /// When greater than zero, a [StreamBadgeNotification] is displayed.
  final int unreadCount;

  /// Whether the channel is muted.
  ///
  /// When true, a mute icon is displayed in the title or subtitle.
  final bool isMuted;

  /// Called when the list item is tapped.
  final VoidCallback? onTap;

  /// Called when the list item is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the list item is in a selected state.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final channelListItemTheme = StreamChannelListItemTheme.of(context);
    final defaults = _StreamChannelListItemThemeDefaults(context);

    final effectiveTitleStyle = channelListItemTheme.titleStyle ?? defaults.titleStyle;
    final effectiveSubtitleStyle = channelListItemTheme.subtitleStyle ?? defaults.subtitleStyle;
    final effectiveTimestampStyle = channelListItemTheme.timestampStyle ?? defaults.timestampStyle;
    final effectiveMuteIconPosition = channelListItemTheme.muteIconPosition ?? defaults.muteIconPosition;

    final muteIcon = isMuted
        ? Icon(
            context.streamIcons.mute,
            size: 20,
            color: context.streamColorScheme.textTertiary,
          )
        : null;

    final hasMuteIconInSubtitle = effectiveMuteIconPosition == MuteIconPosition.subtitle && isMuted;

    return StreamListTileTheme(
      data: context.streamListTileTheme.copyWith(
        contentPadding: EdgeInsets.all(spacing.md - 4),
        backgroundColor: channelListItemTheme.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          type: MaterialType.transparency,
          child: StreamListTileContainer(
            enabled: true,
            selected: selected,
            onTap: onTap,
            onLongPress: onLongPress,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing.md,
              children: [
                avatar,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.xxxs),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: spacing.xxs,
                      children: [
                        _TitleRow(
                          title: title,
                          titleTrailing: effectiveMuteIconPosition == MuteIconPosition.title ? muteIcon : null,
                          timestamp: timestamp,
                          unreadCount: unreadCount,
                          titleStyle: effectiveTitleStyle,
                          timestampStyle: effectiveTimestampStyle,
                          spacing: spacing,
                        ),
                        if (subtitle != null || hasMuteIconInSubtitle)
                          _SubtitleRow(
                            subtitle: subtitle,
                            subtitleTrailing: effectiveMuteIconPosition == MuteIconPosition.subtitle ? muteIcon : null,
                            subtitleStyle: effectiveSubtitleStyle,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({
    required this.title,
    this.titleTrailing,
    this.timestamp,
    required this.unreadCount,
    required this.titleStyle,
    required this.timestampStyle,
    required this.spacing,
  });

  final Widget title;
  final Widget? titleTrailing;
  final Widget? timestamp;
  final int unreadCount;
  final TextStyle titleStyle;
  final TextStyle timestampStyle;
  final StreamSpacing spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacing.md,
      children: [
        Expanded(
          child: Row(
            spacing: spacing.xxs,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: StreamBadgeNotificationSize.sm.value),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: 1,
                    child: DefaultTextStyle.merge(
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title,
                    ),
                  ),
                ),
              ),
              ?titleTrailing,
            ],
          ),
        ),
        if (timestamp != null || unreadCount > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing.xs,
            children: [
              if (timestamp case final timestamp?)
                DefaultTextStyle.merge(
                  style: timestampStyle,
                  child: timestamp,
                ),
              if (unreadCount > 0) StreamBadgeNotification(label: '$unreadCount'),
            ],
          ),
      ],
    );
  }
}

class _SubtitleRow extends StatelessWidget {
  const _SubtitleRow({
    required this.subtitle,
    this.subtitleTrailing,
    required this.subtitleStyle,
  });

  final Widget? subtitle;
  final Widget? subtitleTrailing;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: subtitleStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: [
          Expanded(child: subtitle ?? const SizedBox.shrink()),
          ?subtitleTrailing,
        ],
      ),
    );
  }
}

class _StreamChannelListItemThemeDefaults extends StreamChannelListItemThemeData {
  _StreamChannelListItemThemeDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;

  @override
  TextStyle get titleStyle => _textTheme.headingSm.copyWith(color: _colorScheme.textPrimary);

  @override
  TextStyle get subtitleStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.textSecondary);

  @override
  TextStyle get timestampStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.textTertiary);

  @override
  Color get borderColor => _colorScheme.borderSubtle;

  @override
  MuteIconPosition get muteIconPosition => MuteIconPosition.title;
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
    final colorTheme = context.streamMessageTheme.mergeWithDefaults(context);
    final colorScheme = context.streamColorScheme;

    return BetterStreamBuilder<List<Read>>(
      stream: channel.state?.readStream,
      initialData: channel.state?.read,
      builder: (context, data) {
        final isRead = data.readsOf(message: message).isNotEmpty;
        final isDelivered = data.deliveriesOf(message: message).isNotEmpty;

        final Widget icon;
        if (isRead) {
          icon = Icon(
            context.streamIcons.checks,
            size: 16,
            color: colorTheme.outgoing?.textReadColor ?? colorScheme.accentPrimary,
          );
        } else if (isDelivered) {
          icon = Icon(
            context.streamIcons.checks,
            size: 16,
            color: colorTheme.outgoing?.textTimestampColor ?? colorScheme.textTertiary,
          );
        } else if (message.state.isCompleted) {
          icon = Icon(
            context.streamIcons.checkmark,
            size: 16,
            color: colorTheme.outgoing?.textTimestampColor ?? colorScheme.textTertiary,
          );
        } else if (message.state.isOutgoing) {
          icon = Icon(
            context.streamIcons.clock,
            size: 16,
            color: colorTheme.outgoing?.textTimestampColor ?? colorScheme.textTertiary,
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

/// A widget that displays the subtitle for [StreamChannelListItem].
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
  State<_ChannelLastMessageWithStatus> createState() => _ChannelLastMessageWithStatusState();
}

class _ChannelLastMessageWithStatusState extends State<_ChannelLastMessageWithStatus> {
  Message? _currentLastMessage;

  static bool _defaultLastMessagePredicate(Message message) {
    if (message.isShadowed) return false;
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
            style: widget.textStyle?.copyWith(color: context.streamColorScheme.textTertiary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        final isOwnMessage = currentUser != null && latestLastMessage.user?.id == currentUser.id;

        // Show delivery status prefix only for own messages.
        final Widget deliveryPrefix;
        if (isOwnMessage) {
          deliveryPrefix =
              widget.sendingIndicatorBuilder?.call(context, latestLastMessage) ??
              _ChannelListDeliveryStatus(
                channel: widget.channel,
                message: latestLastMessage,
              );
        } else {
          deliveryPrefix = const Empty();
        }

        return Row(
          children: [
            if (!latestLastMessage.isDeleted) deliveryPrefix,
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

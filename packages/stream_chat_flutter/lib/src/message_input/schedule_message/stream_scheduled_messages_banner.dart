import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';

/// A banner that counts the scheduled messages of the enclosing channel.
///
/// It counts the channel's own scheduled messages, or the scheduled replies of
/// the thread of [StreamScheduledMessagesBannerProps.parentId] when given.
/// Failed messages take precedence over the others, which are counted only
/// while the channel allows scheduling messages. The banner is empty when there
/// is nothing to count.
///
/// This widget renders [DefaultStreamScheduledMessagesBanner] unless a custom
/// builder is registered through
/// `streamChatComponentBuilders(scheduledMessagesBanner: ...)`, which then
/// receives the same [StreamScheduledMessagesBannerProps].
///
/// See also:
///
///  * [StreamScheduledMessagesBannerProps], which holds every configurable
///    property.
///  * [StreamChannelPage] and [StreamThreadPage], which show this banner above
///    their composer.
class StreamScheduledMessagesBanner extends StatelessWidget {
  /// Creates a banner of the scheduled messages of the enclosing channel, or
  /// of the thread of [parentId].
  StreamScheduledMessagesBanner({
    super.key,
    String? parentId,
    VoidCallback? onViewAllPressed,
    EdgeInsetsGeometry? margin,
  }) : props = .new(parentId: parentId, onViewAllPressed: onViewAllPressed, margin: margin);

  /// Creates a banner from pre-built [props].
  const StreamScheduledMessagesBanner.fromProps({
    super.key,
    required this.props,
  });

  /// The properties that configure this banner.
  final StreamScheduledMessagesBannerProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamScheduledMessagesBannerProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamScheduledMessagesBanner(props: props);
  }
}

/// Properties for configuring a [StreamScheduledMessagesBanner].
///
/// See also:
///
///  * [StreamScheduledMessagesBanner], which uses these properties.
///  * [DefaultStreamScheduledMessagesBanner], which renders them by default.
class StreamScheduledMessagesBannerProps {
  /// Creates properties for a scheduled messages banner.
  const StreamScheduledMessagesBannerProps({
    this.parentId,
    this.onViewAllPressed,
    this.margin,
  });

  /// The ID of the message whose thread's scheduled replies are counted.
  ///
  /// When null, the channel's own scheduled messages are counted.
  final String? parentId;

  /// Called when the user taps "View all".
  ///
  /// When null, "View all" isn't shown.
  final VoidCallback? onViewAllPressed;

  /// Empty space to surround the banner.
  ///
  /// Not applied while the banner shows nothing.
  final EdgeInsetsGeometry? margin;

  /// Returns a copy of this [StreamScheduledMessagesBannerProps] with the
  /// given fields replaced with new values.
  StreamScheduledMessagesBannerProps copyWith({
    String? parentId,
    VoidCallback? onViewAllPressed,
    EdgeInsetsGeometry? margin,
  }) {
    return StreamScheduledMessagesBannerProps(
      parentId: parentId ?? this.parentId,
      onViewAllPressed: onViewAllPressed ?? this.onViewAllPressed,
      margin: margin ?? this.margin,
    );
  }
}

/// The default implementation of [StreamScheduledMessagesBanner].
///
/// Shows how many messages failed to send, or how many are scheduled, beside
/// an icon and a "View all" link. Its styles come from the enclosing
/// [StreamScheduledMessagesBannerTheme].
class DefaultStreamScheduledMessagesBanner extends StatefulWidget {
  /// Creates a default scheduled messages banner with the given [props].
  const DefaultStreamScheduledMessagesBanner({
    super.key,
    required this.props,
  });

  /// The properties that configure this widget.
  final StreamScheduledMessagesBannerProps props;

  @override
  State<DefaultStreamScheduledMessagesBanner> createState() {
    return _DefaultStreamScheduledMessagesBannerState();
  }
}

class _DefaultStreamScheduledMessagesBannerState extends State<DefaultStreamScheduledMessagesBanner> {
  Channel? _channel;
  // The scheduled messages the banner counts.
  Stream<List<ScheduledMessage>>? _stream;
  // Every scheduled message of the channel, thread replies included, which
  // count toward its limit. Only followed for a channel's own banner.
  Stream<List<ScheduledMessage>>? _channelStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final channel = StreamChannel.of(context).channel;
    if (channel == _channel) return;

    _channel = channel;
    _followScheduledMessages();
  }

  @override
  void didUpdateWidget(covariant DefaultStreamScheduledMessagesBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.parentId == oldWidget.props.parentId) return;

    _followScheduledMessages();
  }

  void _followScheduledMessages() {
    final channel = _channel!;
    final clientState = channel.client.state;
    final cid = channel.cid;

    _stream = switch ((widget.props.parentId, cid)) {
      (final parentId?, _) => clientState.scheduledThreadRepliesStream(parentId),
      (null, final cid?) => clientState.scheduledChannelMessagesStream(cid),
      (null, null) => null,
    };
    _channelStream = switch ((widget.props.parentId, cid)) {
      (null, final cid?) =>
        clientState.scheduledMessagesStream
            .map((it) => it.where((message) => message.cid == cid).toList())
            .distinct(const ListEquality<ScheduledMessage>().equals),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final channel = _channel!;
    final stream = _stream;
    if (stream == null) return const SizedBox.shrink();

    final clientState = channel.client.state;
    final parentId = widget.props.parentId;
    final cid = channel.cid!;
    final initialData = switch (parentId) {
      final parentId? => clientState.scheduledThreadReplies(parentId),
      null => clientState.scheduledChannelMessages(cid),
    };

    return BetterStreamBuilder<List<ScheduledMessage>>(
      stream: stream,
      initialData: initialData,
      builder: (context, scheduledMessages) {
        final channelStream = _channelStream;
        if (channelStream == null) {
          return _buildBanner(scheduledMessages, channelPendingCount: null);
        }

        final channelMessages = clientState.scheduledMessages.where((it) => it.cid == cid).toList();
        return BetterStreamBuilder<List<ScheduledMessage>>(
          stream: channelStream,
          initialData: channelMessages,
          builder: (context, channelMessages) {
            final channelPendingCount = channelMessages.where((it) => it.status.isPending).length;
            return _buildBanner(scheduledMessages, channelPendingCount: channelPendingCount);
          },
        );
      },
    );
  }

  Widget _buildBanner(
    List<ScheduledMessage> scheduledMessages, {
    required int? channelPendingCount,
  }) {
    return _ScheduledMessagesBanner(
      channel: _channel!,
      scheduledMessages: scheduledMessages,
      channelPendingCount: channelPendingCount,
      onViewAllPressed: widget.props.onViewAllPressed,
      margin: widget.props.margin,
    );
  }
}

class _ScheduledMessagesBanner extends StatelessWidget {
  const _ScheduledMessagesBanner({
    required this.channel,
    required this.scheduledMessages,
    required this.channelPendingCount,
    this.onViewAllPressed,
    this.margin,
  });

  final Channel channel;
  final List<ScheduledMessage> scheduledMessages;
  // The pending messages of the whole channel, or null for a thread's banner.
  final int? channelPendingCount;
  final VoidCallback? onViewAllPressed;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;
    final translations = context.translations;

    final theme = StreamScheduledMessagesBannerTheme.of(context);
    final defaults = _StreamScheduledMessagesBannerThemeDefaults(context);

    final failed = scheduledMessages.where((it) => it.status == .failed);
    final pending = scheduledMessages.where((it) => it.status.isPending);

    final failedCount = failed.length;
    final pendingCount = pending.length;
    final isFailed = failedCount > 0;
    final isPending = pendingCount > 0 && channel.canScheduleMessage;
    if (!isFailed && !isPending) return const SizedBox.shrink();

    String label() {
      if (isFailed) {
        return translations.scheduledMessagesFailedCountText(count: failedCount);
      }
      final channelPendingCount = this.channelPendingCount;
      if (channelPendingCount == null) {
        return translations.scheduledRepliesCountText(count: pendingCount);
      }

      final limit = channel.config?.scheduledMessagesMaxPerChannel;
      if (limit != null && channelPendingCount >= limit) {
        return translations.scheduledMessagesLimitText(count: channelPendingCount, limit: limit);
      }

      return translations.scheduledMessagesCountText(count: pendingCount);
    }

    final effectiveIconColor = switch (isFailed) {
      true => theme.failedIconColor ?? defaults.failedIconColor,
      false => theme.iconColor ?? defaults.iconColor,
    };
    final effectiveCountStyle = theme.countStyle ?? defaults.countStyle;
    final effectiveViewAllStyle = theme.viewAllStyle ?? defaults.viewAllStyle;
    final effectiveSide = theme.side ?? defaults.side;
    final effectiveBoxShadow = theme.boxShadow ?? defaults.boxShadow;
    final effectivePadding = theme.padding ?? defaults.padding;
    final effectiveBackgroundColor = theme.backgroundColor ?? defaults.backgroundColor;

    final onViewAllPressed = this.onViewAllPressed;

    final banner = DecoratedBox(
      decoration: ShapeDecoration(
        color: effectiveBackgroundColor,
        shadows: effectiveBoxShadow,
        shape: RoundedSuperellipseBorder(borderRadius: .all(radius.max), side: effectiveSide),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Padding(
          padding: effectivePadding,
          child: Row(
            spacing: spacing.sm,
            children: [
              Icon(
                isFailed ? icons.exclamationCircle : icons.clock,
                size: 20,
                color: effectiveIconColor,
              ),
              Expanded(
                child: Text(
                  label(),
                  style: effectiveCountStyle,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
              if (onViewAllPressed != null) Text(translations.viewAllLabel, style: effectiveViewAllStyle),
            ],
          ),
        ),
      ),
    );

    // Announced as one phrase whenever the count changes.
    final result = Semantics(
      container: true,
      liveRegion: true,
      button: onViewAllPressed != null,
      child: GestureDetector(
        behavior: .opaque,
        onTap: onViewAllPressed,
        child: banner,
      ),
    );

    final margin = this.margin;
    if (margin == null) return result;
    return Padding(padding: margin, child: result);
  }
}

class _StreamScheduledMessagesBannerThemeDefaults extends StreamScheduledMessagesBannerThemeData {
  _StreamScheduledMessagesBannerThemeDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;
  late final _spacing = _context.streamSpacing;

  @override
  Color get backgroundColor => _colorScheme.backgroundElevation2;

  @override
  BorderSide get side => BorderSide(color: _colorScheme.borderDefault);

  @override
  List<BoxShadow> get boxShadow => _context.streamBoxShadow.elevation3;

  @override
  EdgeInsetsGeometry get padding {
    return EdgeInsets.symmetric(horizontal: _spacing.md, vertical: _spacing.sm);
  }

  @override
  TextStyle get countStyle {
    final color = _colorScheme.textPrimary;
    return _textTheme.metadataEmphasis.copyWith(color: color);
  }

  @override
  TextStyle get viewAllStyle {
    return _textTheme.metadataDefault.copyWith(color: _colorScheme.textLink);
  }

  @override
  Color get iconColor => _colorScheme.accentPrimary;

  @override
  Color get failedIconColor => _colorScheme.accentError;
}

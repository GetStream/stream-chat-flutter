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

// The counts a banner shows. [channelPending] counts the pending messages of
// the whole channel, thread replies included, toward its limit.
typedef _Counts = ({int failed, int pending, int channelPending});

class _DefaultStreamScheduledMessagesBannerState extends State<DefaultStreamScheduledMessagesBanner> {
  Channel? _channel;
  late Stream<_Counts> _counts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final channel = StreamChannel.of(context).channel;
    if (channel == _channel) return;

    _channel = channel;
    _counts = _followCounts();
  }

  @override
  void didUpdateWidget(covariant DefaultStreamScheduledMessagesBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.parentId == oldWidget.props.parentId) return;

    _counts = _followCounts();
  }

  Stream<_Counts> _followCounts() {
    return _channel!.client.state.scheduledMessagesStream.map(_countsOf).distinct();
  }

  _Counts _countsOf(List<ScheduledMessage> scheduledMessages) {
    final cid = _channel!.cid;
    final parentId = widget.props.parentId;

    var failed = 0;
    var pending = 0;
    var channelPending = 0;
    for (final it in scheduledMessages) {
      if (it.cid != cid) continue;

      final isPending = it.status.isPending;
      if (isPending) channelPending += 1;

      // A channel's banner counts its own messages, a thread's its replies.
      if (it.message.parentId != parentId) continue;
      if (it.status == .failed) failed += 1;
      if (isPending) pending += 1;
    }

    return (failed: failed, pending: pending, channelPending: channelPending);
  }

  @override
  Widget build(BuildContext context) {
    final channel = _channel!;
    final scheduledMessages = channel.client.state.scheduledMessages;

    return BetterStreamBuilder<_Counts>(
      stream: _counts,
      initialData: _countsOf(scheduledMessages),
      builder: (context, counts) => _ScheduledMessagesBanner(
        channel: channel,
        counts: counts,
        isThread: widget.props.parentId != null,
        onViewAllPressed: widget.props.onViewAllPressed,
        margin: widget.props.margin,
      ),
    );
  }
}

class _ScheduledMessagesBanner extends StatelessWidget {
  const _ScheduledMessagesBanner({
    required this.channel,
    required this.counts,
    required this.isThread,
    this.onViewAllPressed,
    this.margin,
  });

  final Channel channel;
  final _Counts counts;
  final bool isThread;
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

    final (:failed, :pending, :channelPending) = counts;
    final isFailed = failed > 0;
    final isPending = pending > 0 && channel.canScheduleMessage;
    if (!isFailed && !isPending) return const SizedBox.shrink();

    String label() {
      if (isFailed) return translations.scheduledMessagesFailedCountText(count: failed);
      if (isThread) return translations.scheduledRepliesCountText(count: pending);

      final limit = channel.config?.scheduledMessagesMaxPerChannel;
      if (limit != null && channelPending >= limit) {
        return translations.scheduledMessagesLimitText(count: channelPending, limit: limit);
      }

      return translations.scheduledMessagesCountText(count: pending);
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

import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import 'scheduled_message_counts.dart';

/// A banner that counts the scheduled messages of the enclosing channel.
///
/// It counts the channel's own scheduled messages, or the scheduled replies of
/// the thread of [StreamScheduledMessagesBannerProps.parentId] when given.
/// Failed messages take precedence over the others. It shows only in channels
/// where the current user can schedule messages, and is empty when there is
/// nothing to count.
///
/// It counts the scheduled messages the client has loaded, such as through
/// `includeScheduledMessages` on a channel or channel list query, or
/// [StreamChatClient.loadScheduledMessages].
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
  /// Creates a banner of the enclosing channel's scheduled messages.
  ///
  /// With [parentId], it counts the scheduled replies of that thread instead.
  StreamScheduledMessagesBanner({
    super.key,
    String? parentId,
    VoidCallback? onTap,
    EdgeInsetsGeometry? margin,
  }) : props = .new(parentId: parentId, onTap: onTap, margin: margin);

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
    this.onTap,
    this.margin,
  });

  /// The ID of the message whose thread's scheduled replies are counted.
  ///
  /// When null, the channel's own scheduled messages are counted.
  final String? parentId;

  /// Called when the banner is tapped.
  ///
  /// The link label, such as "View all", shows only when it is set.
  final VoidCallback? onTap;

  /// Empty space to surround the banner.
  ///
  /// Not applied while the banner shows nothing.
  final EdgeInsetsGeometry? margin;

  /// Returns a copy of this [StreamScheduledMessagesBannerProps] with the
  /// given fields replaced with new values.
  StreamScheduledMessagesBannerProps copyWith({
    String? parentId,
    VoidCallback? onTap,
    EdgeInsetsGeometry? margin,
  }) {
    return StreamScheduledMessagesBannerProps(
      parentId: parentId ?? this.parentId,
      onTap: onTap ?? this.onTap,
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
  State<DefaultStreamScheduledMessagesBanner> createState() => _DefaultStreamScheduledMessagesBannerState();
}

class _DefaultStreamScheduledMessagesBannerState extends State<DefaultStreamScheduledMessagesBanner> {
  Channel? _channel;
  Future<bool>? _initialized;
  // Followed once the channel has a cid, and again when it or the thread
  // changes.
  Stream<bool>? _canSchedule;
  Stream<ScheduledMessageCounts>? _counts;

  @override
  void didUpdateWidget(covariant DefaultStreamScheduledMessagesBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.parentId == oldWidget.props.parentId) return;

    _counts = null;
  }

  ScheduledMessageCounts _countsOf(List<ScheduledMessage> scheduledMessages, String cid) {
    return ScheduledMessageCounts.of(
      scheduledMessages,
      cid: cid,
      parentId: widget.props.parentId,
    );
  }

  // Follows the enclosing channel, which can be swapped without notifying
  // this state.
  void _followChannel(Channel channel) {
    if (channel == _channel) return;

    _channel = channel;
    _initialized = channel.initialized;
    _canSchedule = null;
    _counts = null;
  }

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    _followChannel(channel);
    final cid = channel.cid;
    if (cid != null && channel.state != null) return _buildForChannel(channel, cid);

    // A channel that isn't created or watched yet has no scheduled messages
    // to show. It has its cid and state once it is.
    return FutureBuilder(
      future: _initialized,
      builder: (context, _) => switch (channel.cid) {
        final cid? when channel.state != null => _buildForChannel(channel, cid),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildForChannel(Channel channel, String cid) {
    final canSchedule = _canSchedule ??= channel.ownCapabilitiesStream.map(
      (it) => it.contains(ChannelCapability.scheduleMessage),
    );

    return BetterStreamBuilder<bool>(
      stream: canSchedule,
      initialData: channel.canScheduleMessage,
      builder: (context, canSchedule) {
        if (!canSchedule) return const SizedBox.shrink();

        final clientState = channel.client.state;
        final counts = _counts ??= clientState.scheduledMessagesStream.map((it) => _countsOf(it, cid));

        return BetterStreamBuilder<ScheduledMessageCounts>(
          stream: counts,
          initialData: _countsOf(clientState.scheduledMessages, cid),
          builder: (context, counts) => _ScheduledMessagesBanner(
            channel: channel,
            counts: counts,
            isThread: widget.props.parentId != null,
            onTap: widget.props.onTap,
            margin: widget.props.margin,
          ),
        );
      },
    );
  }
}

class _ScheduledMessagesBanner extends StatelessWidget {
  const _ScheduledMessagesBanner({
    required this.channel,
    required this.counts,
    required this.isThread,
    this.onTap,
    this.margin,
  });

  final Channel channel;
  final ScheduledMessageCounts counts;
  final bool isThread;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final translations = context.translations;

    final theme = StreamScheduledMessagesBannerTheme.of(context);
    final defaults = _StreamScheduledMessagesBannerThemeDefaults(context);

    final ScheduledMessageCounts(:failed, :pending, :channelPending, :hasFailed, :hasPending) = counts;
    if (!hasFailed && !hasPending) return const SizedBox.shrink();

    // The channel's limit counts its thread replies too, so a thread shows it.
    final limit = channel.config?.scheduledMessagesMaxPerChannel;
    final isAtLimit = limit != null && channelPending >= limit;
    // The only scheduled message, or reply, is named by when it is sent.
    final onlyScheduledAt = switch (counts.nextScheduledAt) {
      final scheduledAt? when !hasFailed && !isAtLimit && pending == 1 => scheduledAt,
      _ => null,
    };

    String label() {
      if (hasFailed) return translations.scheduledMessagesFailedCountText(count: failed);
      if (limit != null && isAtLimit) {
        return translations.scheduledMessagesLimitText(count: channelPending, limit: limit);
      }
      if (onlyScheduledAt != null) {
        return translations.scheduledMessageScheduledForText(
          scheduledAt: onlyScheduledAt,
          use24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
        );
      }
      if (isThread) return translations.scheduledRepliesCountText(count: pending);

      return translations.scheduledMessagesCountText(count: pending);
    }

    // A single message is opened on its own.
    final isSingle = onlyScheduledAt != null || failed == 1;
    final linkLabel = isSingle ? translations.viewLabel : translations.viewAllLabel;

    final effectiveIconColor = hasFailed
        ? theme.failedIconColor ?? defaults.failedIconColor
        : theme.iconColor ?? defaults.iconColor;

    final effectiveCountStyle = theme.countStyle ?? defaults.countStyle;
    final effectiveViewAllStyle = theme.viewAllStyle ?? defaults.viewAllStyle;
    final effectiveShape = theme.shape ?? defaults.shape;
    final effectiveElevation = theme.elevation ?? defaults.elevation;
    final effectivePadding = theme.padding ?? defaults.padding;
    final effectiveBackgroundColor = theme.backgroundColor ?? defaults.backgroundColor;

    final onTap = this.onTap;

    final banner = Material(
      color: effectiveBackgroundColor,
      elevation: effectiveElevation,
      shape: effectiveShape,
      child: InkWell(
        customBorder: effectiveShape,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: effectivePadding,
            child: Row(
              spacing: spacing.sm,
              children: [
                Icon(
                  hasFailed ? icons.exclamationCircle : icons.clock,
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
                if (onTap != null) Text(linkLabel, style: effectiveViewAllStyle),
              ],
            ),
          ),
        ),
      ),
    );

    // Announced as one phrase whenever the count changes.
    final result = Semantics(
      container: true,
      liveRegion: true,
      button: onTap != null,
      child: banner,
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
  ShapeBorder get shape => RoundedSuperellipseBorder(
    borderRadius: .all(_context.streamRadius.max),
    side: BorderSide(color: _colorScheme.borderDefault),
  );

  @override
  double get elevation => _context.streamElevation.level3;

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

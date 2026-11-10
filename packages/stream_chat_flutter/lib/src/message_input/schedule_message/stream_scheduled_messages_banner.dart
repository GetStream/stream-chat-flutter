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
///  * [StreamMessageComposer], which shows this banner above its input.
class StreamScheduledMessagesBanner extends StatelessWidget {
  /// Creates a banner of the scheduled messages of the enclosing channel, or
  /// of the thread of [parentId].
  StreamScheduledMessagesBanner({
    super.key,
    String? parentId,
    VoidCallback? onViewAllPressed,
  }) : props = .new(parentId: parentId, onViewAllPressed: onViewAllPressed);

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
  });

  /// The ID of the message whose thread's scheduled replies are counted.
  ///
  /// When null, the channel's own scheduled messages are counted.
  final String? parentId;

  /// Called when the user taps "View all".
  ///
  /// When null, "View all" isn't shown.
  final VoidCallback? onViewAllPressed;

  /// Returns a copy of this [StreamScheduledMessagesBannerProps] with the
  /// given fields replaced with new values.
  StreamScheduledMessagesBannerProps copyWith({
    String? parentId,
    VoidCallback? onViewAllPressed,
  }) {
    return StreamScheduledMessagesBannerProps(
      parentId: parentId ?? this.parentId,
      onViewAllPressed: onViewAllPressed ?? this.onViewAllPressed,
    );
  }
}

/// The default implementation of [StreamScheduledMessagesBanner].
///
/// Shows how many messages failed to send, or how many are scheduled, beside
/// an icon and a "View all" link. Its styles come from the enclosing
/// [StreamScheduledMessagesBannerTheme].
class DefaultStreamScheduledMessagesBanner extends StatelessWidget {
  /// Creates a default scheduled messages banner with the given [props].
  const DefaultStreamScheduledMessagesBanner({
    super.key,
    required this.props,
  });

  /// The properties that configure this widget.
  final StreamScheduledMessagesBannerProps props;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final state = channel.state;
    if (state == null) return const SizedBox.shrink();

    final parentId = props.parentId;
    final scheduledMessages = switch (parentId) {
      final parentId? => state.scheduledThreadReplies(parentId),
      null => state.scheduledMessages,
    };
    final scheduledMessagesStream = switch (parentId) {
      final parentId? => state.scheduledThreadRepliesStream(parentId),
      null => state.scheduledMessagesStream,
    };

    final clientState = channel.client.state;

    return BetterStreamBuilder<List<ScheduledMessage>>(
      stream: clientState.scheduledMessagesStream,
      initialData: clientState.scheduledMessages,
      builder: (context, allScheduledMessages) {
        final channelMessages = allScheduledMessages.where((it) => it.cid == channel.cid);

        return BetterStreamBuilder<List<ScheduledMessage>>(
          stream: scheduledMessagesStream,
          initialData: scheduledMessages,
          builder: (context, scheduledMessages) => _ScheduledMessagesBanner(
            channel: channel,
            scheduledMessages: scheduledMessages,
            channelPendingCount: channelMessages.where(_isPending).length,
            isThread: parentId != null,
            onViewAllPressed: props.onViewAllPressed,
          ),
        );
      },
    );
  }
}

bool _isPending(ScheduledMessage message) {
  return switch (message.status) {
    .scheduled || .sending || .preparingToSchedule => true,
    _ => false,
  };
}

class _ScheduledMessagesBanner extends StatelessWidget {
  const _ScheduledMessagesBanner({
    required this.channel,
    required this.scheduledMessages,
    required this.channelPendingCount,
    required this.isThread,
    this.onViewAllPressed,
  });

  final Channel channel;
  final List<ScheduledMessage> scheduledMessages;
  final int channelPendingCount;
  final bool isThread;
  final VoidCallback? onViewAllPressed;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;
    final translations = context.translations;

    final theme = StreamScheduledMessagesBannerTheme.of(context);
    final defaults = _StreamScheduledMessagesBannerThemeDefaults(context);

    final failed = scheduledMessages.where((it) => it.status == .failed);
    final pending = scheduledMessages.where(_isPending);

    final failedCount = failed.length;
    final pendingCount = pending.length;
    final isFailed = failedCount > 0;
    final isPending = pendingCount > 0 && channel.canScheduleMessage;
    if (!isFailed && !isPending) return const SizedBox.shrink();

    String label() {
      if (isFailed) {
        return translations.scheduledMessagesFailedCountText(count: failedCount);
      }
      if (isThread) {
        return translations.scheduledRepliesCountText(count: pendingCount);
      }

      final limit = channel.config?.scheduledMessagesMaxPerChannel;
      if (limit != null && channelPendingCount >= limit) {
        return translations.scheduledMessagesLimitText(count: channelPendingCount, limit: limit);
      }

      return translations.scheduledMessagesCountText(count: pendingCount);
    }

    final iconColor = switch (isFailed) {
      true => theme.failedIconColor ?? defaults.failedIconColor,
      false => theme.iconColor ?? defaults.iconColor,
    };
    final effectiveLabelStyle = theme.labelStyle ?? defaults.labelStyle;
    final effectiveLinkStyle = theme.linkStyle ?? defaults.linkStyle;
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
                color: iconColor,
              ),
              Expanded(
                child: Text(
                  label(),
                  style: effectiveLabelStyle,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
              if (onViewAllPressed != null) Text(translations.viewAllLabel, style: effectiveLinkStyle),
            ],
          ),
        ),
      ),
    );

    // Announced as one phrase whenever the count changes.
    return Padding(
      padding: EdgeInsetsDirectional.only(start: spacing.md, end: spacing.md, bottom: spacing.xs),
      child: Semantics(
        container: true,
        liveRegion: true,
        button: onViewAllPressed != null,
        child: GestureDetector(
          behavior: .opaque,
          onTap: onViewAllPressed,
          child: banner,
        ),
      ),
    );
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
  TextStyle get labelStyle {
    final color = _colorScheme.textPrimary;
    return _textTheme.metadataEmphasis.copyWith(color: color);
  }

  @override
  TextStyle get linkStyle {
    return _textTheme.metadataDefault.copyWith(color: _colorScheme.textLink);
  }

  @override
  Color get iconColor => _colorScheme.accentPrimary;

  @override
  Color get failedIconColor => _colorScheme.accentError;
}

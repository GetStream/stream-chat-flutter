import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../stream_chat_flutter.dart';

/// A row that shows a [ScheduledMessage] in a list of scheduled messages.
///
/// It shows when the message is sent, the channel it is sent to, a preview of
/// the message, and whether it is being sent or why it could not be.
///
/// This widget renders [DefaultStreamScheduledMessageListItem] unless a custom
/// builder is registered through
/// `streamChatComponentBuilders(scheduledMessageListItem: ...)`, which then
/// receives the same [StreamScheduledMessageListItemProps].
///
/// {@tool snippet}
///
/// A row that opens the actions on its scheduled message when tapped:
///
/// ```dart
/// StreamScheduledMessageListItem(
///   scheduledMessage: scheduledMessage,
///   onTap: () => showStreamScheduledMessageActions(
///     context,
///     scheduledMessage: scheduledMessage,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamScheduledMessageListItemProps], which holds every configurable
///    property.
///  * [DefaultStreamScheduledMessageListItem], which is rendered when no
///    custom builder is registered.
///  * [StreamScheduledMessageListView], which lists these items.
class StreamScheduledMessageListItem extends StatelessWidget {
  /// Creates a list item for the given [scheduledMessage].
  StreamScheduledMessageListItem({
    super.key,
    required ScheduledMessage scheduledMessage,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    bool selected = false,
  }) : props = .new(
         scheduledMessage: scheduledMessage,
         onTap: onTap,
         onLongPress: onLongPress,
         selected: selected,
       );

  /// Creates a list item from pre-built [props].
  const StreamScheduledMessageListItem.fromProps({
    super.key,
    required this.props,
  });

  /// The properties that configure this list item.
  final StreamScheduledMessageListItemProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamScheduledMessageListItemProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamScheduledMessageListItem(props: props);
  }
}

/// Properties for configuring a [StreamScheduledMessageListItem].
///
/// See also:
///
///  * [StreamScheduledMessageListItem], which uses these properties.
///  * [DefaultStreamScheduledMessageListItem], which renders them by default.
class StreamScheduledMessageListItemProps {
  /// Creates properties for a scheduled message list item.
  const StreamScheduledMessageListItemProps({
    required this.scheduledMessage,
    this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  /// The scheduled message to display.
  final ScheduledMessage scheduledMessage;

  /// Called when the user taps the item.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses the item.
  final GestureLongPressCallback? onLongPress;

  /// Whether the item is in a selected state.
  final bool selected;

  /// Returns a copy of this [StreamScheduledMessageListItemProps] with the
  /// given fields replaced with new values.
  StreamScheduledMessageListItemProps copyWith({
    ScheduledMessage? scheduledMessage,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    bool? selected,
  }) {
    return StreamScheduledMessageListItemProps(
      scheduledMessage: scheduledMessage ?? this.scheduledMessage,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      selected: selected ?? this.selected,
    );
  }
}

/// The default implementation of [StreamScheduledMessageListItem].
///
/// Shows when the message is sent above the avatar of the channel it is sent
/// to, the channel's name, a preview of the message and, while it is being
/// sent or once it failed, its status. Its styles come from the enclosing
/// [StreamScheduledMessageListItemTheme].
class DefaultStreamScheduledMessageListItem extends StatelessWidget {
  /// Creates a default scheduled message list item with the given [props].
  const DefaultStreamScheduledMessageListItem({
    super.key,
    required this.props,
  });

  /// The properties that configure this widget.
  final StreamScheduledMessageListItemProps props;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);

    final effectiveBackgroundColor = theme.backgroundColor ?? defaults.backgroundColor;
    final effectivePadding = theme.padding ?? defaults.padding;

    final scheduledMessage = props.scheduledMessage;

    final listItem = Padding(
      padding: EdgeInsets.all(spacing.xxs),
      child: StreamListTileTheme(
        data: StreamListTileThemeData(
          contentPadding: effectivePadding,
          backgroundColor: effectiveBackgroundColor,
        ),
        child: StreamListTileContainer(
          onTap: props.onTap,
          onLongPress: props.onLongPress,
          selected: props.selected,
          child: Column(
            crossAxisAlignment: .start,
            spacing: spacing.xs,
            children: [
              _ScheduledMessageSendTime(
                scheduledAt: scheduledMessage.scheduledAt,
                isFailed: scheduledMessage.status == .failed,
              ),
              _ScheduledMessageBody(scheduledMessage: scheduledMessage),
            ],
          ),
        ),
      ),
    );

    return MergeSemantics(child: listItem);
  }
}

// The avatar of the channel a scheduled message is sent to, beside the
// channel's name, a preview of the message and its status.
class _ScheduledMessageBody extends StatelessWidget {
  const _ScheduledMessageBody({required this.scheduledMessage});

  final ScheduledMessage scheduledMessage;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);

    final effectiveTitleStyle = theme.titleStyle ?? defaults.titleStyle;
    final effectiveMessagePreviewStyle = theme.messagePreviewStyle ?? defaults.messagePreviewStyle;
    final basePreviewTextTheme = defaults.messagePreviewTextTheme.merge(StreamMessagePreviewTextTheme.of(context));
    final effectiveMessagePreviewTextTheme = basePreviewTextTheme.merge(theme.messagePreviewTextTheme);

    final streamChat = StreamChat.of(context);
    final channel = streamChat.client.state.channels[scheduledMessage.cid];
    final channelState = channel?.state;
    final loadedChannel = channelState != null ? channel : null;
    final summary = scheduledMessage.channel;

    // A loaded channel keeps its members on its state, not on its model.
    final loadedModel = channelState?.channelState.channel?.copyWith(members: channelState.members);
    final loadedName = loadedModel?.formatName(currentUser: streamChat.currentUser);
    final summaryName = switch (summary?.name) {
      final name? when name.trim().isNotEmpty => name,
      _ => null,
    };
    final channelName = loadedName ?? summaryName ?? context.translations.noTitleText;

    return Row(
      crossAxisAlignment: .start,
      spacing: spacing.sm,
      children: [
        switch (loadedChannel) {
          final loaded? => StreamChannelAvatar(channel: loaded, size: .xl),
          null => StreamAvatar(
            imageUrl: summary?.extraData['image'].safeCast<String>(),
            size: .xl,
            placeholder: (context) => Icon(context.streamIcons.users),
          ),
        },
        Expanded(
          child: core.StreamColumn(
            crossAxisAlignment: .start,
            spacing: spacing.xs,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xxxs),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: spacing.xxs,
                  children: [
                    Text(
                      channelName,
                      style: effectiveTitleStyle,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    DefaultTextStyle.merge(
                      style: effectiveMessagePreviewStyle,
                      maxLines: 1,
                      overflow: .ellipsis,
                      child: _ScheduledMessagePreview(
                        scheduledMessage: scheduledMessage,
                        messagePreviewTextTheme: effectiveMessagePreviewTextTheme,
                      ),
                    ),
                  ],
                ),
              ),
              _ScheduledMessageStatusLine(scheduledMessage: scheduledMessage),
            ],
          ),
        ),
      ],
    );
  }
}

// The send time of a scheduled message, such as "Send Wed, Oct 21 at 8:00
// AM".
//
// Screen readers announce the full date and time.
class _ScheduledMessageSendTime extends StatelessWidget {
  const _ScheduledMessageSendTime({
    required this.scheduledAt,
    this.isFailed = false,
  });

  final DateTime scheduledAt;

  // A failed message shows its send time in the failed style.
  final bool isFailed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);
    final a11y = context.translations.accessibility;

    final effectiveSendTimeStyle = theme.sendTimeStyle ?? defaults.sendTimeStyle;
    final effectiveFailedSendTimeStyle = theme.failedSendTimeStyle ?? defaults.failedSendTimeStyle;
    final effectiveSendTimeFormatter = theme.sendTimeFormatter ?? defaults.sendTimeFormatter;

    return Semantics(
      label: a11y.scheduledMessageSendAtLabel(scheduledAt: scheduledAt),
      excludeSemantics: true,
      child: Text(
        effectiveSendTimeFormatter(context, scheduledAt),
        style: isFailed ? effectiveFailedSendTimeStyle : effectiveSendTimeStyle,
        maxLines: 1,
        overflow: .ellipsis,
      ),
    );
  }
}

// A preview of the message a [scheduledMessage] sends.
//
// The preview of a reply in a thread starts with a thread-reply prefix, and
// that of a message quoting another with the quoted author's name.
// Attachments show their icon and label.
class _ScheduledMessagePreview extends StatelessWidget {
  const _ScheduledMessagePreview({
    required this.scheduledMessage,
    required this.messagePreviewTextTheme,
  });

  final ScheduledMessage scheduledMessage;
  final StreamMessagePreviewTextThemeData messagePreviewTextTheme;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final message = scheduledMessage.message;

    final prefix = switch (message) {
      Message(parentId: _?) => translations.scheduledThreadReplyPrefixText,
      Message(quotedMessageId: _?) => translations.scheduledQuoteReplyPrefixText(
        name: _quotedMessage(context, scheduledMessage)?.user?.name,
      ),
      _ => null,
    };

    final preview = StreamMessagePreviewTextTheme(
      data: messagePreviewTextTheme,
      child: StreamMessagePreviewText(message: message),
    );

    if (prefix == null) return preview;
    return Row(
      spacing: context.streamSpacing.xxs,
      children: [
        Flexible(child: Text(prefix, maxLines: 1, overflow: .ellipsis)),
        Flexible(child: preview),
      ],
    );
  }
}

// The state of a [scheduledMessage] under its preview.
//
// A message being scheduled or sent shows a spinner and "Sending…", or
// "Uploading…" while its attachments upload. One that failed shows a warning
// icon and why. A scheduled one shows nothing.
class _ScheduledMessageStatusLine extends core.NullableStatelessWidget {
  const _ScheduledMessageStatusLine({required this.scheduledMessage});

  final ScheduledMessage scheduledMessage;

  @override
  Widget? nullableBuild(BuildContext context) {
    final spacing = context.streamSpacing;
    final translations = context.translations;
    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);

    final effectiveStatusStyle = theme.statusStyle ?? defaults.statusStyle;
    final effectiveFailedStatusStyle = theme.failedStatusStyle ?? defaults.failedStatusStyle;

    switch (scheduledMessage.status) {
      case .failed:
        final quoted = _quotedMessage(context, scheduledMessage);
        final reason = translations.scheduledMessageFailureReasonText(
          reason: scheduledMessage.failureReason,
          isQuoteDeleted: quoted?.isDeleted ?? false,
        );

        return Row(
          crossAxisAlignment: .start,
          spacing: spacing.xxs,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.xxxs),
              child: Icon(
                context.streamIcons.exclamationTriangleFill,
                size: 16,
                color: effectiveFailedStatusStyle.color,
              ),
            ),
            Expanded(child: Text(reason, style: effectiveFailedStatusStyle)),
          ],
        );
      case .preparingToSchedule || .sending:
        final attachments = scheduledMessage.message.attachments;
        final isUploading = attachments.any((it) => !it.uploadState.isSuccess);
        final label = switch (isUploading) {
          true => translations.scheduledMessageUploadingLabel,
          false => translations.scheduledMessageSendingLabel,
        };

        return Row(
          spacing: spacing.xxs,
          children: [
            StreamLoadingSpinner(size: .xs),
            Flexible(child: Text(label, style: effectiveStatusStyle)),
          ],
        );
      default:
        return null;
    }
  }
}

// The message a scheduled message quotes, when it is loaded in the channel or
// in the thread the message is sent to.
Message? _quotedMessage(
  BuildContext context,
  ScheduledMessage scheduledMessage,
) {
  final message = scheduledMessage.message;
  if (message.quotedMessage case final quoted?) return quoted;

  final quotedMessageId = message.quotedMessageId;
  if (quotedMessageId == null) return null;

  final client = StreamChat.of(context).client;
  final state = client.state.channels[scheduledMessage.cid]?.state;
  final loaded = [...?state?.messages, ...?state?.threads[message.parentId]];

  return loaded.firstWhereOrNull((it) => it.id == quotedMessageId);
}

class _StreamScheduledMessageListItemThemeDefaults extends StreamScheduledMessageListItemThemeData {
  _StreamScheduledMessageListItemThemeDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;
  late final _spacing = _context.streamSpacing;

  @override
  WidgetStateProperty<Color?> get backgroundColor => .resolveWith((states) {
    final base = _colorScheme.backgroundApp;
    if (!states.contains(WidgetState.selected)) return base;
    return .alphaBlend(_colorScheme.backgroundSelected, base);
  });

  @override
  EdgeInsetsGeometry get padding => .symmetric(horizontal: _spacing.md, vertical: _spacing.sm);

  @override
  TextStyle get sendTimeStyle {
    return _textTheme.captionDefault.copyWith(color: _colorScheme.textTertiary);
  }

  @override
  DateFormatter get sendTimeFormatter => (context, date) {
    final translations = context.translations;
    return translations.scheduledMessageSendAtText(scheduledAt: date);
  };

  @override
  TextStyle get failedSendTimeStyle {
    return _textTheme.captionDefault.copyWith(color: _colorScheme.textDisabled);
  }

  @override
  TextStyle get titleStyle {
    final color = _colorScheme.textTertiary;
    return _textTheme.captionEmphasis.copyWith(color: color);
  }

  @override
  TextStyle get messagePreviewStyle {
    return _textTheme.bodyDefault.copyWith(color: _colorScheme.textPrimary);
  }

  @override
  StreamMessagePreviewTextThemeData get messagePreviewTextTheme {
    return const StreamMessagePreviewTextThemeData(iconSize: 20);
  }

  @override
  TextStyle get statusStyle {
    return _textTheme.captionDefault.copyWith(color: _colorScheme.textTertiary);
  }

  @override
  TextStyle get failedStatusStyle {
    return _textTheme.captionDefault.copyWith(color: _colorScheme.accentError);
  }
}

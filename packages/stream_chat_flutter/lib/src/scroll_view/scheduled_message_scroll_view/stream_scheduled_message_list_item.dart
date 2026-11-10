import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';

/// Displays a [ScheduledMessage] in a list of scheduled messages.
///
/// It shows when the message is sent, the channel it is sent to, a preview of
/// the message, and whether it is being sent or why it could not be.
///
/// This widget delegates rendering to either a custom builder registered via
/// [StreamComponentFactory], or [DefaultStreamScheduledMessageListItem] when
/// no custom builder is provided. Register a custom builder through
/// `streamChatComponentBuilders(scheduledMessageListItem: ...)` to fully
/// replace the default rendering while still receiving the same
/// [StreamScheduledMessageListItemProps].
///
/// See also:
///
///  * [StreamScheduledMessageListItemProps], which holds every configurable
///    property.
///  * [DefaultStreamScheduledMessageListItem], the default implementation used
///    when no custom builder is registered.
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
  const StreamScheduledMessageListItem.fromProps({super.key, required this.props});

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
///  * [DefaultStreamScheduledMessageListItem], the default implementation.
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
    final colorScheme = context.streamColorScheme;

    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);

    final effectiveBackgroundColor = theme.backgroundColor ?? defaults.backgroundColor;
    final effectivePadding = theme.padding ?? defaults.padding;

    final scheduledMessage = props.scheduledMessage;

    final listItem = Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
      child: StreamListTileTheme(
        data: StreamListTileThemeData(
          contentPadding: effectivePadding,
          backgroundColor: .resolveWith((states) {
            if (!states.contains(WidgetState.selected)) return effectiveBackgroundColor;
            return .alphaBlend(colorScheme.backgroundSelected, effectiveBackgroundColor);
          }),
        ),
        child: StreamListTileContainer(
          onTap: props.onTap,
          onLongPress: props.onLongPress,
          selected: props.selected,
          child: Column(
            crossAxisAlignment: .start,
            spacing: spacing.xs,
            children: [
              ScheduledMessageSendTime(
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
    final effectivePreviewStyle = theme.previewStyle ?? defaults.previewStyle;

    final streamChat = StreamChat.of(context);
    final channel = streamChat.client.state.channels[scheduledMessage.cid];
    final channelState = channel?.state;
    final loadedChannel = channelState != null ? channel : null;

    // A loaded channel keeps its members on its state, not on its model.
    final loadedModel = channelState?.channelState.channel?.copyWith(members: channelState.members);
    final summaryName = switch (scheduledMessage.channel?.name) {
      final name? when name.trim().isNotEmpty => name,
      _ => null,
    };
    final channelName =
        loadedModel?.formatName(currentUser: streamChat.currentUser) ?? summaryName ?? context.translations.noTitleText;

    return Row(
      crossAxisAlignment: .start,
      spacing: spacing.sm,
      children: [
        switch (loadedChannel) {
          final loaded? => StreamChannelAvatar(channel: loaded, size: .xl),
          null => StreamAvatar(
            imageUrl: scheduledMessage.channel?.extraData['image'].safeCast<String>(),
            size: .xl,
            placeholder: (context) => Icon(context.streamIcons.users),
          ),
        },
        Expanded(
          child: Column(
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
                      style: effectivePreviewStyle,
                      maxLines: 1,
                      overflow: .ellipsis,
                      child: ScheduledMessagePreview(scheduledMessage: scheduledMessage),
                    ),
                  ],
                ),
              ),
              ScheduledMessageStatusLine(scheduledMessage: scheduledMessage),
            ],
          ),
        ),
      ],
    );
  }
}

/// The send time of a scheduled message, such as "Send Wed, Oct 21 at 8:00
/// AM".
///
/// Screen readers announce the full date and time.
class ScheduledMessageSendTime extends StatelessWidget {
  /// Creates the send time of a message scheduled at [scheduledAt].
  const ScheduledMessageSendTime({
    super.key,
    required this.scheduledAt,
    this.isFailed = false,
    this.style,
    this.formatter,
  });

  /// The time the message is sent.
  final DateTime scheduledAt;

  /// Whether the message could not be sent.
  ///
  /// A failed message shows its send time in the failed style.
  final bool isFailed;

  /// The style of the send time.
  ///
  /// When null, uses the effective style resolved from the theme and
  /// defaults.
  final TextStyle? style;

  /// The formatter of the send time.
  ///
  /// When null, uses the effective formatter resolved from the theme and
  /// defaults.
  final DateFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);
    final a11y = context.translations.accessibility;

    final effectiveStyle = switch (isFailed) {
      true => style ?? theme.failedSendTimeStyle ?? defaults.failedSendTimeStyle,
      false => style ?? theme.sendTimeStyle ?? defaults.sendTimeStyle,
    };
    final effectiveFormatter = formatter ?? theme.sendTimeFormatter ?? defaults.sendTimeFormatter;

    return Semantics(
      label: a11y.scheduledMessageSendAtLabel(scheduledAt: scheduledAt.toLocal()),
      excludeSemantics: true,
      child: Text(
        effectiveFormatter(context, scheduledAt),
        style: effectiveStyle,
        maxLines: 1,
        overflow: .ellipsis,
      ),
    );
  }
}

/// A preview of the message a [scheduledMessage] sends.
///
/// The preview of a reply in a thread starts with a thread-reply prefix, and
/// that of a message quoting another with the quoted author's name.
/// Attachments show their icon and label.
class ScheduledMessagePreview extends StatelessWidget {
  /// Creates a preview of the message [scheduledMessage] sends.
  const ScheduledMessagePreview({
    super.key,
    required this.scheduledMessage,
    this.textTheme,
  });

  /// The scheduled message whose message is previewed.
  final ScheduledMessage scheduledMessage;

  /// The theme for styling parts of the preview differently from the rest.
  ///
  /// When null, uses the effective theme resolved from the theme and
  /// defaults.
  final StreamMessagePreviewTextThemeData? textTheme;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);
    final message = scheduledMessage.message;

    final baseTextTheme = defaults.previewTextTheme.merge(StreamMessagePreviewTextTheme.of(context));
    final effectiveTextTheme = baseTextTheme.merge(textTheme ?? theme.previewTextTheme);

    final prefix = switch (message) {
      Message(parentId: _?) => translations.scheduledThreadReplyPrefixText,
      Message(quotedMessageId: _?) => translations.scheduledQuoteReplyPrefixText(
        name: _quotedMessage(context, scheduledMessage)?.user?.name,
      ),
      _ => null,
    };

    final preview = StreamMessagePreviewTextTheme(
      data: effectiveTextTheme,
      child: StreamMessagePreviewText(message: message),
    );

    if (prefix == null) return preview;
    return Row(
      children: [
        Flexible(child: Text(prefix, maxLines: 1, overflow: .ellipsis)),
        Flexible(child: preview),
      ],
    );
  }
}

/// The state of a [scheduledMessage] under its preview.
///
/// A message being scheduled or sent shows a spinner and "Sending…", or
/// "Uploading…" while its attachments upload. One that failed shows a warning
/// icon and why. A scheduled one shows nothing.
class ScheduledMessageStatusLine extends StatelessWidget {
  /// Creates the status of [scheduledMessage].
  const ScheduledMessageStatusLine({
    super.key,
    required this.scheduledMessage,
    this.style,
    this.failedStyle,
  });

  /// The scheduled message whose state is shown.
  final ScheduledMessage scheduledMessage;

  /// The style of the state of a message being sent.
  ///
  /// When null, uses the effective style resolved from the theme and
  /// defaults.
  final TextStyle? style;

  /// The style of why a message could not be sent.
  ///
  /// When null, uses the effective style resolved from the theme and
  /// defaults.
  final TextStyle? failedStyle;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final translations = context.translations;
    final theme = StreamScheduledMessageListItemTheme.of(context);
    final defaults = _StreamScheduledMessageListItemThemeDefaults(context);

    switch (scheduledMessage.status) {
      case .failed:
        final effectiveStyle = failedStyle ?? theme.failedStatusStyle ?? defaults.failedStatusStyle;
        final quoted = _quotedMessage(context, scheduledMessage);
        final reason = translations.scheduledMessageFailedText(
          reason: scheduledMessage.failureReason,
          isQuoteDeleted: quoted?.isDeleted ?? false,
        );

        return Row(
          crossAxisAlignment: .start,
          spacing: spacing.xxs,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.xxxs),
              child: Icon(context.streamIcons.exclamationTriangleFill, size: 16, color: effectiveStyle.color),
            ),
            Expanded(child: Text(reason, style: effectiveStyle)),
          ],
        );
      case .preparingToSchedule || .sending:
        final effectiveStyle = style ?? theme.statusStyle ?? defaults.statusStyle;
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
            Flexible(child: Text(label, style: effectiveStyle)),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// The message a scheduled message quotes, when it is loaded in the channel or
// in the thread the message is sent to.
Message? _quotedMessage(BuildContext context, ScheduledMessage scheduledMessage) {
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
  Color get backgroundColor => _colorScheme.backgroundApp;

  @override
  EdgeInsetsGeometry get padding => EdgeInsets.all(_spacing.md);

  @override
  TextStyle get sendTimeStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.textTertiary);

  @override
  DateFormatter get sendTimeFormatter {
    return (context, date) => context.translations.scheduledMessageSendAtText(scheduledAt: date);
  }

  @override
  TextStyle get failedSendTimeStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.textDisabled);

  @override
  TextStyle get titleStyle => _textTheme.captionEmphasis.copyWith(color: _colorScheme.textTertiary);

  @override
  TextStyle get previewStyle => _textTheme.bodyDefault.copyWith(color: _colorScheme.textPrimary);

  @override
  StreamMessagePreviewTextThemeData get previewTextTheme => const StreamMessagePreviewTextThemeData(iconSize: 20);

  @override
  TextStyle get statusStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.textTertiary);

  @override
  TextStyle get failedStatusStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.accentError);
}

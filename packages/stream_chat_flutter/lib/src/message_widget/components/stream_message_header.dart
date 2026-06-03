import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Displays contextual annotations above the message bubble for the given
/// message.
///
/// This widget delegates rendering to either a custom builder registered via
/// [StreamComponentFactory], or [DefaultStreamMessageHeader] when no custom
/// builder is provided. Register a custom builder through
/// `streamChatComponentBuilders(messageHeader: ...)` to fully replace the
/// default header rendering while still receiving the same
/// [StreamMessageHeaderProps].
///
/// See also:
///
///  * [StreamMessageHeaderProps], which holds every configurable property.
///  * [DefaultStreamMessageHeader], the default implementation used when no
///    custom builder is registered.
///  * [StreamMessageFooter], the symmetric slot below the message bubble.
class StreamMessageHeader extends core.NullableStatelessWidget {
  /// Creates a message header for the given [message].
  StreamMessageHeader({
    super.key,
    required Message message,
    VoidCallback? onViewChannelTap,
  }) : props = .new(
         message: message,
         onViewChannelTap: onViewChannelTap,
       );

  /// Creates a message header from pre-built [props].
  const StreamMessageHeader.fromProps({super.key, required this.props});

  /// The properties that configure this header.
  final StreamMessageHeaderProps props;

  @override
  Widget? nullableBuild(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMessageHeaderProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMessageHeader(props: props);
  }
}

/// Properties for configuring a [StreamMessageHeader].
///
/// See also:
///
///  * [StreamMessageHeader], which uses these properties.
///  * [DefaultStreamMessageHeader], the default implementation.
class StreamMessageHeaderProps {
  /// Creates properties for a message header.
  const StreamMessageHeaderProps({
    required this.message,
    this.onViewChannelTap,
  });

  /// The message whose annotations to display.
  final Message message;

  /// Called when the "View" link in the show-in-channel annotation is tapped.
  final VoidCallback? onViewChannelTap;

  /// Returns a copy of this [StreamMessageHeaderProps] with the given fields
  /// replaced with new values.
  StreamMessageHeaderProps copyWith({
    Message? message,
    VoidCallback? onViewChannelTap,
  }) {
    return StreamMessageHeaderProps(
      message: message ?? this.message,
      onViewChannelTap: onViewChannelTap ?? this.onViewChannelTap,
    );
  }
}

/// The default implementation of [StreamMessageHeader].
///
/// Annotations are shown in the following order when applicable:
///
///  1. **Saved for later** — when a reminder exists without a scheduled time.
///  2. **Pinned** — when [Message.pinned] is true, showing who pinned it.
///  3. **Show in channel / Replied to thread** — when [Message.showInChannel]
///     is true. The label adapts based on whether the message list is a
///     channel or thread view, and includes a tappable "View" link that
///     invokes [StreamMessageHeaderProps.onViewChannelTap].
///  4. **Reminder** — when a reminder exists with a scheduled time.
///
/// Returns `null` when no annotations apply, allowing the parent layout to
/// collapse the slot and skip spacing automatically.
class DefaultStreamMessageHeader extends core.NullableStatelessWidget {
  /// Creates a default message header with the given [props].
  const DefaultStreamMessageHeader({super.key, required this.props});

  /// The properties that configure this widget.
  final StreamMessageHeaderProps props;

  @override
  Widget? nullableBuild(BuildContext context) {
    final message = props.message;
    final translations = context.translations;
    final icons = context.streamIcons;
    final colorScheme = context.streamColorScheme;
    final crossAxisAlignment = core.StreamMessageLayout.crossAxisAlignmentOf(context);

    Widget? savedForLaterAnnotation;
    if (message.reminder case final reminder? when reminder.remindAt == null) {
      savedForLaterAnnotation = core.StreamMessageAnnotation(
        leading: Icon(icons.save),
        label: Text(translations.savedForLaterLabel),
        style: .from(textColor: colorScheme.accentPrimary, iconColor: colorScheme.accentPrimary),
      );
    }

    Widget? pinnedAnnotation;
    if (message.pinned case true) {
      final currentUser = StreamChat.of(context).currentUser!;
      final pinnedBy = message.pinnedBy ?? currentUser;

      pinnedAnnotation = core.StreamMessageAnnotation(
        leading: Icon(icons.pin),
        label: Text(translations.pinnedByUserText(pinnedBy: pinnedBy, currentUser: currentUser)),
      );
    }

    Widget? showInChannelAnnotation;
    if (message.showInChannel case true) {
      final listKind = core.StreamMessageLayout.listKindOf(context);
      final annotationLabel = switch (listKind) {
        .channel => '${translations.repliedToThreadAnnotationLabel} ·',
        .thread => '${translations.alsoSentInChannelAnnotationLabel} ·',
      };

      showInChannelAnnotation = core.StreamMessageAnnotation(
        onTap: props.onViewChannelTap,
        leading: Icon(icons.arrowUpRight),
        label: Text(annotationLabel),
        trailing: Text(translations.viewLabel),
        style: .from(trailingTextColor: colorScheme.textLink),
      );
    }

    Widget? reminderAnnotation;
    if (message.reminder?.remindAt?.toLocal() case final remindAt?) {
      reminderAnnotation = core.StreamMessageAnnotation(
        leading: Icon(icons.bell),
        label: Text('${translations.reminderSetLabel} ·'),
        trailing: Text(translations.reminderAtText(Jiffy.parseFromDateTime(remindAt).jm)),
      );
    }

    final children = [
      ?savedForLaterAnnotation,
      ?pinnedAnnotation,
      ?showInChannelAnnotation,
      ?reminderAnnotation,
    ];

    if (children.isEmpty) return null;

    return core.StreamColumn(
      mainAxisSize: .min,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

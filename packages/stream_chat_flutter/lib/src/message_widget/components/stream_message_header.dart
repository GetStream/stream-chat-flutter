import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Displays contextual annotations above the message bubble for the given
/// [message].
///
/// Annotations are shown in the following order when applicable:
///
///  1. **Saved for later** — when a reminder exists without a scheduled time.
///  2. **Pinned** — when [Message.pinned] is true, showing who pinned it.
///  3. **Show in channel / Replied to thread** — when [Message.showInChannel]
///     is true. The label adapts based on whether the message list is a
///     channel or thread view, and includes a tappable "View" link that
///     invokes [onViewChannelTap].
///  4. **Reminder** — when a reminder exists with a scheduled time.
///
/// Returns `null` when no annotations apply, allowing [StreamColumn] to
/// collapse the widget and skip spacing automatically.
///
/// See also:
///
///  * [StreamMessageFooter], the symmetric slot below the message bubble.
///  * [DefaultStreamMessageItem], which controls header visibility.
class StreamMessageHeader extends core.NullableStatelessWidget {
  /// Creates a message header for the given [message].
  const StreamMessageHeader({
    super.key,
    required this.message,
    this.onViewChannelTap,
  });

  /// The message whose annotations to display.
  final Message message;

  /// Called when the "View" link in the show-in-channel annotation is tapped.
  final VoidCallback? onViewChannelTap;

  @override
  Widget? nullableBuild(BuildContext context) {
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
        onTap: onViewChannelTap,
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

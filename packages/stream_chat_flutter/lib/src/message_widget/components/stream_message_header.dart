import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// Builds the message header containing contextual annotations for the given
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
/// Returns `null` when no annotations apply, allowing the caller to skip
/// rendering the header entirely.
///
/// See also:
///
///  * [DefaultStreamMessage], which controls header visibility.
Widget? streamMessageHeader({
  required BuildContext context,
  required Message message,
  VoidCallback? onViewChannelTap,
}) {
  final translations = context.translations;
  final icons = context.streamIcons;
  final textTheme = context.streamTextTheme;
  final colorScheme = context.streamColorScheme;
  final crossAxisAlignment = StreamMessagePlacement.crossAxisAlignmentOf(context);

  Widget? savedForLaterAnnotation;
  if (message.reminder case final reminder? when reminder.remindAt == null) {
    savedForLaterAnnotation = StreamMessageAnnotation(
      leading: Icon(icons.bookmark, color: colorScheme.accentPrimary),
      label: Text(translations.savedForLaterLabel, style: TextStyle(color: colorScheme.accentPrimary)),
    );
  }

  Widget? pinnedAnnotation;
  if (message.pinned case true) {
    final currentUser = StreamChat.of(context).currentUser!;
    pinnedAnnotation = StreamMessageAnnotation(
      leading: Icon(icons.pin),
      label: Text(
        translations.pinnedByUserText(
          pinnedBy: message.pinnedBy ?? currentUser,
          currentUser: currentUser,
        ),
      ),
    );
  }

  Widget? showInChannelAnnotation;
  if (message.showInChannel case true) {
    final listKind = StreamMessagePlacement.listKindOf(context);
    final annotationLabel = switch (listKind) {
      .channel => '${translations.repliedToThreadAnnotationLabel} · ',
      .thread => '${translations.alsoSentInChannelAnnotationLabel} · ',
    };

    showInChannelAnnotation = StreamMessageAnnotation(
      onTap: onViewChannelTap,
      leading: Icon(icons.arrowUpRight),
      label: Text.rich(
        TextSpan(
          text: annotationLabel,
          children: [
            TextSpan(
              text: translations.viewLabel,
              style: textTheme.metadataDefault.copyWith(color: colorScheme.textLink),
            ),
          ],
        ),
      ),
    );
  }

  Widget? reminderAnnotation;
  if (message.reminder?.remindAt?.toLocal() case final remindAt?) {
    reminderAnnotation = StreamMessageAnnotation(
      leading: Icon(icons.bellNotification),
      label: Text.rich(
        TextSpan(
          text: '${translations.reminderSetLabel} · ',
          children: [
            TextSpan(
              text: translations.reminderAtText(Jiffy.parseFromDateTime(remindAt).jm),
              style: textTheme.metadataDefault,
            ),
          ],
        ),
      ),
    );
  }

  final children = [
    ?savedForLaterAnnotation,
    ?pinnedAnnotation,
    ?showInChannelAnnotation,
    ?reminderAnnotation,
  ];

  if (children.isEmpty) return null;

  return StreamColumn(
    mainAxisSize: .min,
    crossAxisAlignment: crossAxisAlignment,
    children: children,
  );
}

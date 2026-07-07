import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Returns the screen-reader announcement string for an attachment
/// transition.
///
/// Resolves a diff between two attachment lists into a short message
/// describing the change ("Photo added", "2 attachments removed", …), or
/// `null` when nothing meaningful changed.
///
/// Comparison is by attachment id so re-orderings and metadata-only updates
/// don't fire an announcement.
///
/// See also:
///
///  * [ComposerAttachmentAnnouncer], which dispatches the resolved message.
@visibleForTesting
String? composerAttachmentAnnouncement(
  BuildContext context, {
  required List<Attachment> previous,
  required List<Attachment> current,
}) {
  final a11y = context.translations.accessibility;
  final previousIds = previous.map((it) => it.id).toSet();

  final added = current.where((it) => !previousIds.contains(it.id)).toList();
  if (added.isNotEmpty) {
    if (added.length > 1) return a11y.attachmentsAddedAnnouncement(count: added.length);
    return switch (added.single.type) {
      AttachmentType.file => a11y.fileAttachmentAddedAnnouncement,
      AttachmentType.image => a11y.imageAttachmentAddedAnnouncement,
      AttachmentType.video => a11y.videoAttachmentAddedAnnouncement,
      AttachmentType.giphy => a11y.gifAttachmentAddedAnnouncement,
      AttachmentType.audio || AttachmentType.voiceRecording => a11y.voiceRecordingAttachmentAddedAnnouncement,
      _ => a11y.attachmentAddedAnnouncement,
    };
  }

  final currentIds = current.map((it) => it.id).toSet();
  final removed = previous.where((it) => !currentIds.contains(it.id)).toList();
  if (removed.isNotEmpty) {
    if (removed.length > 1) return a11y.attachmentsRemovedAnnouncement(count: removed.length);
    return switch (removed.single.type) {
      AttachmentType.file => a11y.fileAttachmentRemovedAnnouncement,
      AttachmentType.image => a11y.imageAttachmentRemovedAnnouncement,
      AttachmentType.video => a11y.videoAttachmentRemovedAnnouncement,
      AttachmentType.giphy => a11y.gifAttachmentRemovedAnnouncement,
      AttachmentType.audio || AttachmentType.voiceRecording => a11y.voiceRecordingAttachmentRemovedAnnouncement,
      _ => a11y.attachmentRemovedAnnouncement,
    };
  }

  return null;
}

/// Observes [controller] and dispatches screen-reader announcements on every
/// attachment add/remove.
///
/// [ComposerAttachmentAnnouncer] is a behavior-only wrapper — it returns
/// [child] from `build` without modifying the visual tree. Mount it once at
/// the composer root so it captures every transition, including the first
/// attachment added from an empty composer.
///
/// {@tool snippet}
///
/// Wrap a composer subtree so attachment changes are announced politely:
///
/// ```dart
/// ComposerAttachmentAnnouncer(
///   controller: composerController,
///   child: MyComposer(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [composerAttachmentAnnouncement], the pure function that resolves
///    transition messages and is exposed for unit testing.
///  * [StreamSemanticsTransitionAnnouncer], the generic observer this
///    widget specialises.
@internal
class ComposerAttachmentAnnouncer extends StatelessWidget {
  /// Creates an announcer that wraps [child].
  const ComposerAttachmentAnnouncer({
    super.key,
    required this.controller,
    required this.child,
    this.assertiveness = .polite,
  });

  /// The controller whose attachment changes drive announcements.
  final StreamMessageComposerController controller;

  /// The widget the announcer wraps. Returned unchanged from [build].
  final Widget child;

  /// Priority used to dispatch the resolved announcement.
  ///
  /// Defaults to [Assertiveness.polite] so announcements queue behind any
  /// current screen-reader speech.
  final Assertiveness assertiveness;

  @override
  Widget build(BuildContext context) {
    String? resolveMessage(
      List<Attachment> previous,
      List<Attachment> current,
    ) {
      return composerAttachmentAnnouncement(
        context,
        previous: previous,
        current: current,
      );
    }

    return StreamSemanticsTransitionAnnouncer(
      listenable: controller,
      snapshot: () => controller.attachments,
      resolveMessage: resolveMessage,
      assertiveness: assertiveness,
      child: child,
    );
  }
}

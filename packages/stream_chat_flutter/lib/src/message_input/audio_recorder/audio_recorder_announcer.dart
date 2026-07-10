import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter/src/message_input/audio_recorder/audio_recorder_controller.dart';
import 'package:stream_chat_flutter/src/message_input/audio_recorder/audio_recorder_state.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/core.dart';

/// Returns the screen-reader announcement string for a recording state
/// transition.
///
/// Resolves an [AudioRecorderState] diff into a short message describing the
/// change ("Recording started.", "Recording locked", and so on), or `null`
/// when no announcement is warranted.
///
/// [wasLastCancelled] disambiguates the transition to [RecordStateIdle],
/// which can be either a user-initiated cancellation or a successful send.
///
/// See also:
///
///  * [AudioRecorderAnnouncer], which dispatches the resolved message.
///  * [StreamAudioRecorderController.wasLastCancelled], the disambiguation
///    source.
@visibleForTesting
String? audioRecorderAnnouncement(
  BuildContext context, {
  required AudioRecorderState previous,
  required AudioRecorderState current,
  required bool wasLastCancelled,
}) {
  if (previous.runtimeType == current.runtimeType) return null;
  final a11y = context.translations.accessibility;
  return switch ((previous, current)) {
    (RecordStateIdle(), RecordStateRecordingHold()) => a11y.recordingStartedAnnouncement,
    (RecordStateRecordingHold(), RecordStateRecordingLocked()) => a11y.recordingLockedAnnouncement,
    (RecordStateRecording(), RecordStateStopped()) => a11y.recordingStoppedAnnouncement,
    (RecordStateRecording(), RecordStateIdle()) when wasLastCancelled => a11y.recordingCancelledAnnouncement,
    (RecordStateRecording(), RecordStateIdle()) => a11y.recordingCompletedAnnouncement,
    (RecordStateStopped(), RecordStateIdle()) when wasLastCancelled => a11y.recordingCancelledAnnouncement,
    (RecordStateStopped(), RecordStateIdle()) => a11y.recordingCompletedAnnouncement,
    _ => null,
  };
}

/// Observes [controller] and dispatches screen-reader announcements on
/// every recording state transition.
///
/// [AudioRecorderAnnouncer] is a behavior-only wrapper — it returns [child]
/// from `build` without modifying the visual tree. Place it anywhere that
/// has the [controller] in scope and a [MaterialApp] ancestor.
///
/// {@tool snippet}
///
/// Wrap a composer subtree so its recording state changes are announced
/// assertively (interrupting any current screen-reader output):
///
/// ```dart
/// AudioRecorderAnnouncer(
///   controller: audioRecorderController,
///   assertiveness: Assertiveness.assertive,
///   child: MyComposer(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [audioRecorderAnnouncement], the pure function that resolves
///    transition messages and is exposed for unit testing.
///  * [StreamSemanticsTransitionAnnouncer], the generic observer this
///    widget specialises.
@internal
class AudioRecorderAnnouncer extends StatelessWidget {
  /// Creates an announcer that wraps [child].
  const AudioRecorderAnnouncer({
    super.key,
    required this.controller,
    required this.child,
    this.assertiveness = .polite,
  });

  /// The controller whose state transitions drive announcements.
  final StreamAudioRecorderController controller;

  /// The widget the announcer wraps. Returned unchanged from [build].
  final Widget child;

  /// Priority used to dispatch the resolved announcement.
  ///
  /// Defaults to [Assertiveness.polite] so announcements queue behind any
  /// current screen-reader speech. Use [Assertiveness.assertive] for
  /// time-sensitive state changes that should preempt other output.
  final Assertiveness assertiveness;

  @override
  Widget build(BuildContext context) {
    String? resolveMessage(
      AudioRecorderState previous,
      AudioRecorderState current,
    ) {
      return audioRecorderAnnouncement(
        context,
        previous: previous,
        current: current,
        wasLastCancelled: controller.wasLastCancelled,
      );
    }

    return StreamSemanticsTransitionAnnouncer(
      listenable: controller,
      snapshot: () => controller.value,
      resolveMessage: resolveMessage,
      assertiveness: assertiveness,
      child: child,
    );
  }
}

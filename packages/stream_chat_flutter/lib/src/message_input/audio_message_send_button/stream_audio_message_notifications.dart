import 'package:flutter/widgets.dart';

/// A notification that is dispatched when the user
/// interacts with the audio message recording widget
abstract class AudioMessageNotification extends Notification {
  /// Creates a new instance of the [AudioMessageNotification]
  const AudioMessageNotification();
}

/// A notification that is dispatched when the user
/// locks the recording by moving the finger up
class RecordingLockedNotification extends AudioMessageNotification {
  /// Creates a new instance of the [RecordingLockedNotification]
  const RecordingLockedNotification();
}

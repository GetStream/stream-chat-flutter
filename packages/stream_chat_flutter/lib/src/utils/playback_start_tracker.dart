import 'package:flutter/foundation.dart';

/// Tells when playback of a [T] has really started, from a player's updates.
///
/// Playback counts as started once the position moves past where playing
/// began, so loading, buffering and failures don't count; [onStarted] is then
/// called once with what is playing. A pause, or a switch to something else,
/// starts the count again.
@internal
class PlaybackStartTracker<T extends Object> {
  /// Creates a tracker that calls [onStarted] each time playback starts.
  PlaybackStartTracker({required this.onStarted});

  /// Called with what started playing.
  final ValueChanged<T> onStarted;

  T? _playing;
  Duration? _startPosition;
  var _reported = false;

  /// Takes the player's latest state.
  ///
  /// [playing] is what is playing, such as one recording in a playlist, or
  /// null when nothing is.
  void handleUpdate({
    required T? playing,
    required Duration position,
  }) {
    if (playing == null) {
      _playing = null;
      _startPosition = null;
      _reported = false;
      return;
    }

    final startPosition = _startPosition;
    if (startPosition == null || playing != _playing) {
      _playing = playing;
      _startPosition = position;
      _reported = false;
      return;
    }

    if (_reported || position <= startPosition) return;
    _reported = true;
    onStarted(playing);
  }
}

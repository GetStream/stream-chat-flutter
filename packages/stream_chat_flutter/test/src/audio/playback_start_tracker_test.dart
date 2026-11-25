import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/audio/playback_start_tracker.dart';

// The video player can only be driven through a real video engine, so its
// start rule is covered here, through the tracker both players share.
void main() {
  const second = Duration(seconds: 1);

  test('a start counts once the position moves', () {
    final tracker = PlaybackStartTracker();

    expect(tracker.update(isPlaying: true, position: Duration.zero), isFalse);
    expect(tracker.update(isPlaying: true, position: second), isTrue);
  });

  test('a start that never moves does not count', () {
    final tracker = PlaybackStartTracker();

    expect(tracker.update(isPlaying: true, position: Duration.zero), isFalse);
    expect(tracker.update(isPlaying: true, position: Duration.zero), isFalse);
    expect(tracker.update(isPlaying: false, position: Duration.zero), isFalse);
  });

  test('a start counts once while it keeps playing', () {
    final tracker = PlaybackStartTracker()
      ..update(isPlaying: true, position: Duration.zero)
      ..update(isPlaying: true, position: second);

    expect(tracker.update(isPlaying: true, position: second * 2), isFalse);
  });

  test('a resume after a pause counts again once it moves', () {
    final tracker = PlaybackStartTracker()
      ..update(isPlaying: true, position: Duration.zero)
      ..update(isPlaying: true, position: second)
      ..update(isPlaying: false, position: second);

    expect(tracker.update(isPlaying: true, position: second), isFalse);
    expect(tracker.update(isPlaying: true, position: second * 2), isTrue);
  });

  test('a switch to another key counts again once it moves', () {
    final tracker = PlaybackStartTracker()
      ..update(isPlaying: true, position: Duration.zero, key: 'a')
      ..update(isPlaying: true, position: second, key: 'a');

    expect(tracker.update(isPlaying: true, position: Duration.zero, key: 'b'), isFalse);
    expect(tracker.update(isPlaying: true, position: second, key: 'b'), isTrue);
  });
}

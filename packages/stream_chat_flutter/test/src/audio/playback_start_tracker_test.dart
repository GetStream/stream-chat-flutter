import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/audio/playback_start_tracker.dart';

// The video player can only be driven through a real video engine, so its
// start rule is covered here, through the tracker both players share.
void main() {
  const second = Duration(seconds: 1);

  late List<Object?> started;
  late PlaybackStartTracker tracker;

  setUp(() {
    started = [];
    tracker = PlaybackStartTracker(onStarted: started.add);
  });

  test('a start counts once the position moves', () {
    tracker
      ..handleUpdate(isPlaying: true, position: Duration.zero, key: 'a')
      ..handleUpdate(isPlaying: true, position: second, key: 'a');

    expect(started, ['a']);
  });

  test('a start that never moves does not count', () {
    tracker
      ..handleUpdate(isPlaying: true, position: Duration.zero)
      ..handleUpdate(isPlaying: true, position: Duration.zero)
      ..handleUpdate(isPlaying: false, position: Duration.zero);

    expect(started, isEmpty);
  });

  test('a start counts once while it keeps playing', () {
    tracker
      ..handleUpdate(isPlaying: true, position: Duration.zero)
      ..handleUpdate(isPlaying: true, position: second)
      ..handleUpdate(isPlaying: true, position: second * 2);

    expect(started, hasLength(1));
  });

  test('a resume after a pause counts again once it moves', () {
    tracker
      ..handleUpdate(isPlaying: true, position: Duration.zero)
      ..handleUpdate(isPlaying: true, position: second)
      ..handleUpdate(isPlaying: false, position: second)
      ..handleUpdate(isPlaying: true, position: second)
      ..handleUpdate(isPlaying: true, position: second * 2);

    expect(started, hasLength(2));
  });

  test('a switch to another key counts again once it moves', () {
    tracker
      ..handleUpdate(isPlaying: true, position: Duration.zero, key: 'a')
      ..handleUpdate(isPlaying: true, position: second, key: 'a')
      ..handleUpdate(isPlaying: true, position: Duration.zero, key: 'b')
      ..handleUpdate(isPlaying: true, position: second, key: 'b');

    expect(started, ['a', 'b']);
  });

  test('a switch after a pause counts once the new key moves', () {
    tracker
      ..handleUpdate(isPlaying: true, position: Duration.zero, key: 'a')
      ..handleUpdate(isPlaying: true, position: second, key: 'a')
      ..handleUpdate(isPlaying: false, position: second, key: 'a')
      ..handleUpdate(isPlaying: true, position: Duration.zero, key: 'b')
      ..handleUpdate(isPlaying: true, position: second, key: 'b');

    expect(started, ['a', 'b']);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/utils/playback_start_tracker.dart';

// The video player can only be driven through a real video engine, so its
// start rule is covered here, through the tracker both players share.
void main() {
  const second = Duration(seconds: 1);

  late List<String> started;
  late PlaybackStartTracker<String> tracker;

  setUp(() {
    started = [];
    tracker = PlaybackStartTracker<String>(onStarted: started.add);
  });

  test('a start counts once the position moves', () {
    tracker
      ..handleUpdate(playing: 'a', position: Duration.zero)
      ..handleUpdate(playing: 'a', position: second);

    expect(started, ['a']);
  });

  test('a start that never moves does not count', () {
    tracker
      ..handleUpdate(playing: 'a', position: Duration.zero)
      ..handleUpdate(playing: 'a', position: Duration.zero)
      ..handleUpdate(playing: null, position: Duration.zero);

    expect(started, isEmpty);
  });

  test('a start counts once while it keeps playing', () {
    tracker
      ..handleUpdate(playing: 'a', position: Duration.zero)
      ..handleUpdate(playing: 'a', position: second)
      ..handleUpdate(playing: 'a', position: second * 2);

    expect(started, hasLength(1));
  });

  test('a resume after a pause counts again once it moves', () {
    tracker
      ..handleUpdate(playing: 'a', position: Duration.zero)
      ..handleUpdate(playing: 'a', position: second)
      ..handleUpdate(playing: null, position: second)
      ..handleUpdate(playing: 'a', position: second)
      ..handleUpdate(playing: 'a', position: second * 2);

    expect(started, hasLength(2));
  });

  test('a switch to another track counts again once it moves', () {
    tracker
      ..handleUpdate(playing: 'a', position: Duration.zero)
      ..handleUpdate(playing: 'a', position: second)
      ..handleUpdate(playing: 'b', position: Duration.zero)
      ..handleUpdate(playing: 'b', position: second);

    expect(started, ['a', 'b']);
  });

  test('a switch after a pause counts once the new track moves', () {
    tracker
      ..handleUpdate(playing: 'a', position: Duration.zero)
      ..handleUpdate(playing: 'a', position: second)
      ..handleUpdate(playing: null, position: second)
      ..handleUpdate(playing: 'b', position: Duration.zero)
      ..handleUpdate(playing: 'b', position: second);

    expect(started, ['a', 'b']);
  });
}

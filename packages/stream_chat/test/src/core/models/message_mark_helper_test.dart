import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

final _markedAt = DateTime.utc(2026, 11, 20, 10);

MessageMark _mark({required String by}) {
  return MessageMark(
    type: MessageMarkType.played,
    messageId: 'voice-note',
    userId: by,
    createdAt: _markedAt,
  );
}

void main() {
  test('addMark counts a marker once per type', () {
    final message = Message(id: 'voice-note');

    final once = message.addMark(_mark(by: 'listener'));
    final twice = once.addMark(_mark(by: 'listener'));

    expect(twice.markGroups![MessageMarkType.played]!.count, 1);
  });

  test('addMark lists the newest marker first', () {
    final message = Message(id: 'voice-note');

    final first = message.addMark(_mark(by: 'first-listener'));
    final marked = first.addMark(_mark(by: 'second-listener'));

    final group = marked.markGroups![MessageMarkType.played]!;
    final markers = group.latestBy.map((it) => it.userId);
    expect(markers, ['second-listener', 'first-listener']);
  });

  test('addMark lists at most 100 markers', () {
    final message = Message(
      id: 'voice-note',
      markGroups: {MessageMarkType.played: _fullGroup()},
    );

    final marked = message.addMark(_mark(by: 'newest-listener'));

    final group = marked.markGroups![MessageMarkType.played]!;
    expect(group.latestBy, hasLength(100));
  });

  test('addMark counts a marker past the 100 listed', () {
    final message = Message(
      id: 'voice-note',
      markGroups: {MessageMarkType.played: _fullGroup()},
    );

    final marked = message.addMark(_mark(by: 'newest-listener'));

    expect(marked.markGroups![MessageMarkType.played]!.count, 151);
  });

  test('addMyMark keeps one own mark per type', () {
    final message = Message(id: 'voice-note');

    final once = message.addMyMark(_mark(by: 'me'));
    final twice = once.addMyMark(_mark(by: 'me'));

    final ownMark = OwnMark(type: MessageMarkType.played, createdAt: _markedAt);
    expect(twice.ownMarks, [ownMark]);
  });
}

// A group of 150 markers that lists the latest 100 of them.
MarkGroup _fullGroup() {
  final markers = [
    for (var i = 0; i < 100; i++)
      MessageMarker(
        userId: 'listener-$i',
        createdAt: DateTime.utc(2026),
      ),
  ];
  return MarkGroup(count: 150, latestBy: markers);
}

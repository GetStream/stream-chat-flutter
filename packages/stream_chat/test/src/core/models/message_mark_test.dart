import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  test('a message reads the mark groups on it', () {
    final message = Message.fromJson(const {
      'id': 'voice-note',
      'mark_groups': {
        'played': {
          'count': 2,
          'latest_by': [
            {
              'user_id': 'second-listener',
              'created_at': '2026-11-20T10:00:00.000Z',
            },
            {
              'user_id': 'first-listener',
              'created_at': '2026-11-19T10:00:00.000Z',
            },
          ],
        },
      },
    });

    final second = MessageMarker(
      userId: 'second-listener',
      createdAt: DateTime.utc(2026, 11, 20, 10),
    );
    final first = MessageMarker(
      userId: 'first-listener',
      createdAt: DateTime.utc(2026, 11, 19, 10),
    );
    expect(message.markGroups, {
      MessageMarkType.played: MarkGroup(count: 2, latestBy: [second, first]),
    });
    expect(message.extraData, isEmpty);
  });

  test("a message reads the current user's marks on it", () {
    final message = Message.fromJson(const {
      'id': 'voice-note',
      'own_marks': [
        {'type': 'played', 'created_at': '2026-11-20T10:00:00.000Z'},
      ],
    });

    final ownMark = OwnMark(
      type: MessageMarkType.played,
      createdAt: DateTime.utc(2026, 11, 20, 10),
    );
    expect(message.ownMarks, [ownMark]);
    expect(message.extraData, isEmpty);
  });

  test('a message does not send its marks', () {
    final ownMark = OwnMark(
      type: MessageMarkType.played,
      createdAt: DateTime.utc(2026, 11, 20),
    );
    final message = Message(
      id: 'voice-note',
      markGroups: const {MessageMarkType.played: MarkGroup(count: 1)},
      ownMarks: [ownMark],
    );

    final json = message.toJson();

    expect(json.containsKey('mark_groups'), isFalse);
    expect(json.containsKey('own_marks'), isFalse);
  });

  test('a mark added event reads the mark', () {
    final event = Event.fromJson({
      'type': 'message.mark_added',
      'cid': 'messaging:general',
      'message_id': 'voice-note',
      'mark': {
        'type': 'played',
        'message_id': 'voice-note',
        'user_id': 'listener',
        'created_at': '2026-11-20T10:00:00.000Z',
      },
      'created_at': '2026-11-20T10:00:00.000Z',
    });

    expect(
      event.mark,
      MessageMark(
        type: MessageMarkType.played,
        messageId: 'voice-note',
        userId: 'listener',
        createdAt: DateTime.utc(2026, 11, 20, 10),
      ),
    );
    expect(event.extraData, isEmpty);
  });

  test('a channel config reads the mark types it allows', () {
    final config = ChannelConfig.fromJson({
      'mark_types': ['played'],
    });

    expect(config.markTypes, [MessageMarkType.played]);
  });

  test('a channel config allows no mark types when none are given', () {
    expect(ChannelConfig.fromJson({}).markTypes, isEmpty);
  });
}

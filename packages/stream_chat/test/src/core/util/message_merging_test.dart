import 'package:stream_chat/src/core/util/message_merging.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

Message _message(
  String id, {
  DateTime? createdAt,
  String? text,
  String? parentId,
  bool? showInChannel,
  String? quotedMessageId,
  Message? quotedMessage,
  bool pinned = false,
  DateTime? pinExpires,
  String type = 'regular',
  Location? sharedLocation,
}) {
  return Message(
    id: id,
    createdAt: createdAt ?? DateTime(2024),
    text: text,
    parentId: parentId,
    showInChannel: showInChannel,
    quotedMessageId: quotedMessageId,
    quotedMessage: quotedMessage,
    pinned: pinned,
    pinExpires: pinExpires,
    type: type,
    sharedLocation: sharedLocation,
  );
}

Location _sharedLocation({
  String? messageId,
  String? userId = 'user-id',
  String? channelCid = 'messaging:channel-id',
  String? createdByDeviceId = 'device-id',
  DateTime? endAt,
  double latitude = 0,
  double longitude = 0,
}) {
  return Location(
    messageId: messageId,
    userId: userId,
    channelCid: channelCid,
    createdByDeviceId: createdByDeviceId,
    endAt: endAt,
    latitude: latitude,
    longitude: longitude,
  );
}

Iterable<String?> _ids(Iterable<Message> messages) => messages.map((it) => it.id);

void main() {
  group('MessageMerging.mergeUpdate', () {
    test('merges the incoming message into the original, preserving enrichment', () {
      final location = _sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
      final original = _message('m1', text: 'old', sharedLocation: location);
      final updated = _message('m1', text: 'new');

      final result = MessageMerging.mergeUpdate(original, updated);

      expect(result.text, 'new');
      expect(result.sharedLocation, location);
    });
  });

  group('MessageMerging.replaceUpdate', () {
    test('takes the incoming message as-is, dropping enrichment', () {
      final location = _sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
      final original = _message('m1', text: 'old', sharedLocation: location);
      final updated = _message('m1', text: 'new');

      final result = MessageMerging.replaceUpdate(original, updated);

      expect(result, same(updated));
      expect(result.sharedLocation, isNull);
    });
  });

  group('MessageMerging.sortByCreatedAt', () {
    test('orders messages by their creation time', () {
      final earlier = _message('m1', createdAt: DateTime(2024));
      final later = _message('m2', createdAt: DateTime(2024, 2));

      expect(MessageMerging.sortByCreatedAt(earlier, later), isNegative);
      expect(MessageMerging.sortByCreatedAt(later, earlier), isPositive);
      expect(MessageMerging.sortByCreatedAt(earlier, earlier), isZero);
    });
  });

  group('MessageMerging.mergeMessages', () {
    test('returns the existing messages untouched when there is nothing to merge', () {
      final existing = [_message('m1')];

      final result = MessageMerging.mergeMessages(existing: existing, toMerge: const []);

      expect(result, same(existing));
    });

    test('inserts a single unknown message in sorted position', () {
      final existing = [
        _message('m1', createdAt: DateTime(2024)),
        _message('m3', createdAt: DateTime(2024, 3)),
      ];
      final incoming = _message('m2', createdAt: DateTime(2024, 2));

      final result = MessageMerging.mergeMessages(existing: existing, toMerge: [incoming]);

      expect(_ids(result), ['m1', 'm2', 'm3']);
    });

    test('updates a single existing message via the default merge strategy', () {
      final location = _sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
      final existing = [_message('m1', text: 'old', sharedLocation: location)];
      final incoming = _message('m1', text: 'new');

      final result = MessageMerging.mergeMessages(existing: existing, toMerge: [incoming]);

      expect(result, hasLength(1));
      expect(result.first.text, 'new');
      expect(result.first.sharedLocation, location, reason: 'enrichment should survive a stripped payload');
    });

    test('upsert: false skips a single message that is not loaded', () {
      final existing = [_message('m1')];
      final incoming = _message('m2');

      final result = MessageMerging.mergeMessages(existing: existing, toMerge: [incoming], upsert: false);

      expect(result, same(existing));
    });

    test('rewrites the embedded quote on quoters when the incoming message is deleted', () {
      final quoted = _message('m1', createdAt: DateTime(2024), text: 'quoted');
      final quoter = _message(
        'm2',
        createdAt: DateTime(2024, 2),
        quotedMessageId: 'm1',
        quotedMessage: quoted,
      );
      final deleted = _message('m1', createdAt: DateTime(2024), type: MessageType.deleted);

      final result = MessageMerging.mergeMessages(existing: [quoted, quoter], toMerge: [deleted]);

      final updatedQuoter = result.singleWhere((it) => it.id == 'm2');
      expect(updatedQuoter.quotedMessage?.isDeleted, isTrue);
    });

    test('does not rewrite the embedded quote on quoters for a non-delete update', () {
      final quoted = _message('m1', createdAt: DateTime(2024), text: 'quoted');
      final quoter = _message(
        'm2',
        createdAt: DateTime(2024, 2),
        quotedMessageId: 'm1',
        quotedMessage: quoted,
      );
      final edited = _message('m1', createdAt: DateTime(2024), text: 'edited');

      final result = MessageMerging.mergeMessages(existing: [quoted, quoter], toMerge: [edited]);

      final updatedQuoter = result.singleWhere((it) => it.id == 'm2');
      expect(updatedQuoter.quotedMessage?.text, 'quoted');
    });

    test('interleaves a batch of unknown messages in sorted order', () {
      final existing = [
        _message('m1', createdAt: DateTime(2024)),
        _message('m3', createdAt: DateTime(2024, 3)),
      ];
      final incoming = [
        _message('m4', createdAt: DateTime(2024, 4)),
        _message('m2', createdAt: DateTime(2024, 2)),
      ];

      final result = MessageMerging.mergeMessages(existing: existing, toMerge: incoming);

      expect(_ids(result), ['m1', 'm2', 'm3', 'm4']);
    });

    test('upsert: false only applies the batch entries that are already loaded', () {
      final existing = [_message('m1', text: 'old')];
      final incoming = [
        _message('m1', text: 'new'),
        _message('m2'),
        _message('m3'),
      ];

      final result = MessageMerging.mergeMessages(existing: existing, toMerge: incoming, upsert: false);

      expect(_ids(result), ['m1']);
      expect(result.first.text, 'new');
    });

    test('honors a replacing update strategy for a batch', () {
      final location = _sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
      final existing = [
        _message('m1', text: 'old', sharedLocation: location),
        _message('m2', createdAt: DateTime(2024, 2)),
      ];
      final incoming = [
        _message('m1', text: 'new'),
        _message('m2', createdAt: DateTime(2024, 2)),
      ];

      final result = MessageMerging.mergeMessages(
        existing: existing,
        toMerge: incoming,
        update: MessageMerging.replaceUpdate,
      );

      final replaced = result.singleWhere((it) => it.id == 'm1');
      expect(replaced.text, 'new');
      expect(replaced.sharedLocation, isNull);
    });

    test('rewrites the embedded quote on quoters when a batch entry is deleted', () {
      final quoted = _message('m1', createdAt: DateTime(2024), text: 'quoted');
      final quoter = _message(
        'm3',
        createdAt: DateTime(2024, 3),
        quotedMessageId: 'm1',
        quotedMessage: quoted,
      );
      final incoming = [
        _message('m1', createdAt: DateTime(2024), type: MessageType.deleted),
        _message('m2', createdAt: DateTime(2024, 2)),
      ];

      final result = MessageMerging.mergeMessages(existing: [quoted, quoter], toMerge: incoming);

      final updatedQuoter = result.singleWhere((it) => it.id == 'm3');
      expect(updatedQuoter.quotedMessage?.isDeleted, isTrue);
    });
  });

  group('MessageMerging.mergeThreadMessages', () {
    test('returns the existing threads untouched when nothing targets a thread', () {
      final existing = {
        'p1': [_message('m1', parentId: 'p1')],
      };

      final result = MessageMerging.mergeThreadMessages(existing: existing, toMerge: [_message('m2')]);

      expect(result, same(existing));
    });

    test('groups replies into their own threads', () {
      final existing = {
        'p1': [_message('m1', parentId: 'p1', createdAt: DateTime(2024))],
        'p2': [_message('m2', parentId: 'p2', createdAt: DateTime(2024))],
      };
      final incoming = [
        _message('m3', parentId: 'p1', createdAt: DateTime(2024, 2)),
        _message('m4', parentId: 'p2', createdAt: DateTime(2024, 2)),
      ];

      final result = MessageMerging.mergeThreadMessages(existing: existing, toMerge: incoming);

      expect(_ids(result['p1']!), ['m1', 'm3']);
      expect(_ids(result['p2']!), ['m2', 'm4']);
    });

    test('creates the thread entry for a reply to a new thread', () {
      final result = MessageMerging.mergeThreadMessages(
        existing: const {},
        toMerge: [_message('m1', parentId: 'p1')],
      );

      expect(_ids(result['p1']!), ['m1']);
    });

    test('upsert: false does not create an entry for a thread that was never loaded', () {
      final result = MessageMerging.mergeThreadMessages(
        existing: const {},
        toMerge: [_message('m1', parentId: 'p1')],
        upsert: false,
      );

      expect(result, isEmpty);
    });

    test('upsert: false still updates a reply in a loaded thread', () {
      final existing = {
        'p1': [_message('m1', parentId: 'p1', text: 'old')],
      };

      final result = MessageMerging.mergeThreadMessages(
        existing: existing,
        toMerge: [_message('m1', parentId: 'p1', text: 'new')],
        upsert: false,
      );

      expect(result['p1']!.single.text, 'new');
    });
  });

  group('MessageMerging.mergePinnedMessages', () {
    test('keeps only messages that are still valid pins', () {
      final existing = [_message('m1', createdAt: DateTime(2024), pinned: true)];
      final incoming = [
        _message('m2', createdAt: DateTime(2024, 2), pinned: true),
        _message('m3', createdAt: DateTime(2024, 3)),
        _message(
          'm4',
          createdAt: DateTime(2024, 4),
          pinned: true,
          pinExpires: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        _message('m5', createdAt: DateTime(2024, 5), pinned: true, type: MessageType.deleted),
      ];

      final result = MessageMerging.mergePinnedMessages(existing: existing, toMerge: incoming);

      expect(_ids(result), ['m1', 'm2']);
    });

    test('drops an existing pin that the incoming message unpins', () {
      final existing = [_message('m1', pinned: true)];
      final incoming = [_message('m1')];

      final result = MessageMerging.mergePinnedMessages(existing: existing, toMerge: incoming);

      expect(result, isEmpty);
    });
  });

  group('MessageMerging.mergeActiveLocations', () {
    test('replaces the existing location sharing the same key', () {
      final endAt = DateTime.now().add(const Duration(hours: 1));
      final existing = [_sharedLocation(messageId: 'm1', endAt: endAt, latitude: 1)];
      final incoming = _message(
        'm1',
        sharedLocation: _sharedLocation(messageId: 'm1', endAt: endAt, latitude: 2),
      );

      final result = MessageMerging.mergeActiveLocations(existing: existing, toMerge: [incoming]);

      expect(result, hasLength(1));
      expect(result.first.latitude, 2);
    });

    test('drops expired locations and ignores messages without a live location', () {
      final expired = _sharedLocation(
        messageId: 'm1',
        endAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      final incoming = _message('m2');

      final result = MessageMerging.mergeActiveLocations(existing: [expired], toMerge: [incoming]);

      expect(result, isEmpty);
    });

    test('drops the location when its attached message is deleted', () {
      final active = _sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
      final incoming = _message('m1', type: MessageType.deleted);

      final result = MessageMerging.mergeActiveLocations(existing: [active], toMerge: [incoming]);

      expect(result, isEmpty);
    });
  });

  group('MessageMerging.removeMessages', () {
    test('returns the existing messages untouched when there is nothing to remove', () {
      final existing = [_message('m1')];

      final result = MessageMerging.removeMessages(existing: existing, toRemove: const []);

      expect(result, same(existing));
    });

    test('removes the given messages by id', () {
      final existing = [_message('m1'), _message('m2')];

      final result = MessageMerging.removeMessages(existing: existing, toRemove: [_message('m1')]);

      expect(_ids(result), ['m2']);
    });

    test('clears the quoted-message reference of quoters of a removed message', () {
      final quoted = _message('m1');
      final quoter = _message('m2', quotedMessageId: 'm1', quotedMessage: quoted);

      final result = MessageMerging.removeMessages(existing: [quoted, quoter], toRemove: [quoted]);

      final updatedQuoter = result.single;
      expect(updatedQuoter.id, 'm2');
      expect(updatedQuoter.quotedMessageId, isNull);
      expect(updatedQuoter.quotedMessage, isNull);
    });
  });

  group('MessageMerging.removeThreadMessages', () {
    test('returns the existing threads untouched when nothing targets a thread', () {
      final existing = {
        'p1': [_message('m1', parentId: 'p1')],
      };

      final result = MessageMerging.removeThreadMessages(existing: existing, toRemove: [_message('m2')]);

      expect(result, same(existing));
    });

    test('removes the reply from its thread', () {
      final existing = {
        'p1': [
          _message('m1', parentId: 'p1'),
          _message('m2', parentId: 'p1'),
        ],
      };

      final result = MessageMerging.removeThreadMessages(
        existing: existing,
        toRemove: [_message('m1', parentId: 'p1')],
      );

      expect(_ids(result['p1']!), ['m2']);
    });

    test('drops the thread entry when its last reply is removed', () {
      final existing = {
        'p1': [_message('m1', parentId: 'p1')],
      };

      final result = MessageMerging.removeThreadMessages(
        existing: existing,
        toRemove: [_message('m1', parentId: 'p1')],
      );

      expect(result, isEmpty);
    });

    test('ignores replies to threads that are not loaded', () {
      final existing = {
        'p1': [_message('m1', parentId: 'p1')],
      };

      final result = MessageMerging.removeThreadMessages(
        existing: existing,
        toRemove: [_message('m2', parentId: 'p2')],
      );

      expect(_ids(result['p1']!), ['m1']);
    });
  });

  group('MessageMerging.removePinnedMessages', () {
    test('removes the given messages and filters out pins that are no longer valid', () {
      final existing = [
        _message('m1', pinned: true),
        _message(
          'm2',
          pinned: true,
          pinExpires: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        _message('m3', pinned: true),
      ];

      final result = MessageMerging.removePinnedMessages(existing: existing, toRemove: [_message('m1')]);

      expect(_ids(result), ['m3']);
    });
  });

  group('MessageMerging.removeActiveLocations', () {
    test('returns the existing locations untouched when there is nothing to remove', () {
      final existing = [_sharedLocation(messageId: 'm1')];

      final result = MessageMerging.removeActiveLocations(existing: existing, toRemove: const []);

      expect(result, same(existing));
    });

    test('removes the locations attached to the removed messages', () {
      final existing = [
        _sharedLocation(messageId: 'm1'),
        _sharedLocation(messageId: 'm2'),
      ];

      final result = MessageMerging.removeActiveLocations(existing: existing, toRemove: [_message('m1')]);

      expect(result, hasLength(1));
      expect(result.first.messageId, 'm2');
    });
  });
}

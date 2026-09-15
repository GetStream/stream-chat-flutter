import 'package:stream_chat/src/core/util/message_merging.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'message_merging_fixtures.dart';

void main() {
  test('mergeUpdate merges the incoming message into the original, preserving enrichment', () {
    final location = sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
    final original = message('m1', text: 'old', sharedLocation: location);
    final updated = message('m1', text: 'new');

    final result = MessageMerging.mergeUpdate(original, updated);

    expect(result.text, 'new');
    expect(result.sharedLocation, location);
  });

  test('replaceUpdate takes the incoming message as-is, dropping enrichment', () {
    final location = sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
    final original = message('m1', text: 'old', sharedLocation: location);
    final updated = message('m1', text: 'new');

    final result = MessageMerging.replaceUpdate(original, updated);

    expect(result, same(updated));
    expect(result.sharedLocation, isNull);
  });

  test('sortByCreatedAt orders messages by their creation time', () {
    final earlier = message('m1', createdAt: DateTime(2024));
    final later = message('m2', createdAt: DateTime(2024, 2));

    expect(MessageMerging.sortByCreatedAt(earlier, later), isNegative);
    expect(MessageMerging.sortByCreatedAt(later, earlier), isPositive);
    expect(MessageMerging.sortByCreatedAt(earlier, earlier), isZero);
  });

  test('mergeMessages returns the existing messages untouched when there is nothing to merge', () {
    final existing = [message('m1')];

    final result = MessageMerging.mergeMessages(existing: existing, toMerge: const []);

    expect(result, same(existing));
  });

  test('mergeMessages inserts a single unknown message in sorted position', () {
    final existing = [
      message('m1', createdAt: DateTime(2024)),
      message('m3', createdAt: DateTime(2024, 3)),
    ];
    final incoming = message('m2', createdAt: DateTime(2024, 2));

    final result = MessageMerging.mergeMessages(existing: existing, toMerge: [incoming]);

    expect(ids(result), ['m1', 'm2', 'm3']);
  });

  test('mergeMessages updates a single existing message via the default merge strategy', () {
    final location = sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
    final existing = [message('m1', text: 'old', sharedLocation: location)];
    final incoming = message('m1', text: 'new');

    final result = MessageMerging.mergeMessages(existing: existing, toMerge: [incoming]);

    expect(result, hasLength(1));
    expect(result.first.text, 'new');
    expect(result.first.sharedLocation, location, reason: 'enrichment should survive a stripped payload');
  });

  test('mergeMessages re-sorts a single message whose creation time moved', () {
    final existing = [
      message('m1', createdAt: DateTime(2024)),
      message('m2', createdAt: DateTime(2024, 2)),
      message('m3', createdAt: DateTime(2024, 3)),
    ];

    final result = MessageMerging.mergeMessages(
      existing: existing,
      toMerge: [message('m1', createdAt: DateTime(2024, 4))],
    );

    expect(ids(result), ['m2', 'm3', 'm1']);
  });

  test('mergeMessages updates the last entry when existing holds duplicate ids', () {
    final existing = [
      message('m1', text: 'first'),
      message('m1', text: 'second'),
    ];

    final result = MessageMerging.mergeMessages(
      existing: existing,
      toMerge: [message('m1', text: 'new')],
    );

    expect(result.map((it) => it.text), ['first', 'new']);
  });

  test('mergeMessages with upsert: false skips a single message that is not loaded', () {
    final existing = [message('m1')];
    final incoming = message('m2');

    final result = MessageMerging.mergeMessages(existing: existing, toMerge: [incoming], upsert: false);

    expect(result, same(existing));
  });

  test('mergeMessages rewrites the embedded quote on quoters when the incoming message is deleted', () {
    final quoted = message('m1', createdAt: DateTime(2024), text: 'quoted');
    final quoter = message(
      'm2',
      createdAt: DateTime(2024, 2),
      quotedMessageId: 'm1',
      quotedMessage: quoted,
    );
    final deleted = message('m1', createdAt: DateTime(2024), type: MessageType.deleted);

    final result = MessageMerging.mergeMessages(existing: [quoted, quoter], toMerge: [deleted]);

    final updatedQuoter = result.singleWhere((it) => it.id == 'm2');
    expect(updatedQuoter.quotedMessage?.isDeleted, isTrue);
  });

  test('mergeMessages does not rewrite the embedded quote on quoters for a non-delete update', () {
    final quoted = message('m1', createdAt: DateTime(2024), text: 'quoted');
    final quoter = message(
      'm2',
      createdAt: DateTime(2024, 2),
      quotedMessageId: 'm1',
      quotedMessage: quoted,
    );
    final edited = message('m1', createdAt: DateTime(2024), text: 'edited');

    final result = MessageMerging.mergeMessages(existing: [quoted, quoter], toMerge: [edited]);

    final updatedQuoter = result.singleWhere((it) => it.id == 'm2');
    expect(updatedQuoter.quotedMessage?.text, 'quoted');
  });

  test('mergeMessages interleaves a batch of unknown messages in sorted order', () {
    final existing = [
      message('m1', createdAt: DateTime(2024)),
      message('m3', createdAt: DateTime(2024, 3)),
    ];
    final incoming = [
      message('m4', createdAt: DateTime(2024, 4)),
      message('m2', createdAt: DateTime(2024, 2)),
    ];

    final result = MessageMerging.mergeMessages(existing: existing, toMerge: incoming);

    expect(ids(result), ['m1', 'm2', 'm3', 'm4']);
  });

  test('mergeMessages with upsert: false only applies the batch entries that are already loaded', () {
    final existing = [message('m1', text: 'old')];
    final incoming = [
      message('m1', text: 'new'),
      message('m2'),
      message('m3'),
    ];

    final result = MessageMerging.mergeMessages(existing: existing, toMerge: incoming, upsert: false);

    expect(ids(result), ['m1']);
    expect(result.first.text, 'new');
  });

  test('mergeMessages honors a replacing update strategy for a batch', () {
    final location = sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
    final existing = [
      message('m1', text: 'old', sharedLocation: location),
      message('m2', createdAt: DateTime(2024, 2)),
    ];
    final incoming = [
      message('m1', text: 'new'),
      message('m2', createdAt: DateTime(2024, 2)),
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

  test('mergeMessages rewrites the embedded quote on quoters when a batch entry is deleted', () {
    final quoted = message('m1', createdAt: DateTime(2024), text: 'quoted');
    final quoter = message(
      'm3',
      createdAt: DateTime(2024, 3),
      quotedMessageId: 'm1',
      quotedMessage: quoted,
    );
    final incoming = [
      message('m1', createdAt: DateTime(2024), type: MessageType.deleted),
      message('m2', createdAt: DateTime(2024, 2)),
    ];

    final result = MessageMerging.mergeMessages(existing: [quoted, quoter], toMerge: incoming);

    final updatedQuoter = result.singleWhere((it) => it.id == 'm3');
    expect(updatedQuoter.quotedMessage?.isDeleted, isTrue);
  });

  test('removeMessages returns the existing messages untouched when there is nothing to remove', () {
    final existing = [message('m1')];

    final result = MessageMerging.removeMessages(existing: existing, toRemove: const []);

    expect(result, same(existing));
  });

  test('removeMessages removes the given messages by id', () {
    final existing = [message('m1'), message('m2')];

    final result = MessageMerging.removeMessages(existing: existing, toRemove: [message('m1')]);

    expect(ids(result), ['m2']);
  });

  test('removeMessages clears the quoted-message reference of quoters of a removed message', () {
    final quoted = message('m1');
    final quoter = message('m2', quotedMessageId: 'm1', quotedMessage: quoted);

    final result = MessageMerging.removeMessages(existing: [quoted, quoter], toRemove: [quoted]);

    final updatedQuoter = result.single;
    expect(updatedQuoter.id, 'm2');
    expect(updatedQuoter.quotedMessageId, isNull);
    expect(updatedQuoter.quotedMessage, isNull);
  });
}

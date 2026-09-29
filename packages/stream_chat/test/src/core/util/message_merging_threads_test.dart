import 'package:stream_chat/src/core/util/message_merging.dart';
import 'package:test/test.dart';

import 'message_merging_fixtures.dart';

void main() {
  test('mergeThreadMessages returns the existing threads untouched when nothing targets a thread', () {
    final existing = {
      'p1': [message('m1', parentId: 'p1')],
    };

    final result = MessageMerging.mergeThreadMessages(existing: existing, toMerge: [message('m2')]);

    expect(result, same(existing));
  });

  test('mergeThreadMessages groups replies into their own threads', () {
    final existing = {
      'p1': [message('m1', parentId: 'p1', createdAt: DateTime(2024))],
      'p2': [message('m2', parentId: 'p2', createdAt: DateTime(2024))],
    };
    final incoming = [
      message('m3', parentId: 'p1', createdAt: DateTime(2024, 2)),
      message('m4', parentId: 'p2', createdAt: DateTime(2024, 2)),
    ];

    final result = MessageMerging.mergeThreadMessages(existing: existing, toMerge: incoming);

    expect(ids(result['p1']!), ['m1', 'm3']);
    expect(ids(result['p2']!), ['m2', 'm4']);
  });

  test('mergeThreadMessages creates the thread entry for a reply to a new thread', () {
    final result = MessageMerging.mergeThreadMessages(
      existing: const {},
      toMerge: [message('m1', parentId: 'p1')],
    );

    expect(ids(result['p1']!), ['m1']);
  });

  test('mergeThreadMessages with upsert: false does not create an entry for a thread that was never loaded', () {
    final result = MessageMerging.mergeThreadMessages(
      existing: const {},
      toMerge: [message('m1', parentId: 'p1')],
      upsert: false,
    );

    expect(result, isEmpty);
  });

  test('mergeThreadMessages with upsert: false returns a new map when a reply targeted an unloaded thread', () {
    final existing = {
      'p1': [message('m1', parentId: 'p1')],
    };

    final result = MessageMerging.mergeThreadMessages(
      existing: existing,
      toMerge: [message('m2', parentId: 'p2')],
      upsert: false,
    );

    expect(result.keys, ['p1']);
    expect(result, isNot(same(existing)), reason: 'the caller writes back whenever a thread was targeted');
  });

  test('mergeThreadMessages with upsert: false still updates a reply in a loaded thread', () {
    final existing = {
      'p1': [message('m1', parentId: 'p1', text: 'old')],
    };

    final result = MessageMerging.mergeThreadMessages(
      existing: existing,
      toMerge: [message('m1', parentId: 'p1', text: 'new')],
      upsert: false,
    );

    expect(result['p1']!.single.text, 'new');
  });

  test('removeThreadMessages returns the existing threads untouched when nothing targets a thread', () {
    final existing = {
      'p1': [message('m1', parentId: 'p1')],
    };

    final result = MessageMerging.removeThreadMessages(existing: existing, toRemove: [message('m2')]);

    expect(result, same(existing));
  });

  test('removeThreadMessages removes the reply from its thread', () {
    final existing = {
      'p1': [
        message('m1', parentId: 'p1'),
        message('m2', parentId: 'p1'),
      ],
    };

    final result = MessageMerging.removeThreadMessages(
      existing: existing,
      toRemove: [message('m1', parentId: 'p1')],
    );

    expect(ids(result['p1']!), ['m2']);
  });

  test('removeThreadMessages drops the thread entry when its last reply is removed', () {
    final existing = {
      'p1': [message('m1', parentId: 'p1')],
    };

    final result = MessageMerging.removeThreadMessages(
      existing: existing,
      toRemove: [message('m1', parentId: 'p1')],
    );

    expect(result, isEmpty);
  });

  test('removeThreadMessages ignores replies to threads that are not loaded', () {
    final existing = {
      'p1': [message('m1', parentId: 'p1')],
    };

    final result = MessageMerging.removeThreadMessages(
      existing: existing,
      toRemove: [message('m2', parentId: 'p2')],
    );

    expect(ids(result['p1']!), ['m1']);
  });
}

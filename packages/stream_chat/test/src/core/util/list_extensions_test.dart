import 'package:stream_chat/src/core/util/list_extensions.dart';
import 'package:test/test.dart';

int _intCompare(int a, int b) => a.compareTo(b);

class _Item {
  const _Item(this.id, this.value, [this.tag = '']);

  final String id;
  final int value;
  final String tag;

  @override
  String toString() => '_Item($id, $value, $tag)';
}

int _itemCompare(_Item a, _Item b) => a.value.compareTo(b.value);
String _itemKey(_Item it) => it.id;

void main() {
  group('SortedListX.sortedInsert', () {
    test('inserts into the middle of a sorted list', () {
      expect(
        [1, 3, 5, 7].sortedInsert(4, compare: _intCompare),
        [1, 3, 4, 5, 7],
      );
    });

    test('prepends when smaller than first element', () {
      expect([2, 3, 4].sortedInsert(1, compare: _intCompare), [1, 2, 3, 4]);
    });

    test('appends when greater than last element', () {
      expect([1, 2, 3].sortedInsert(4, compare: _intCompare), [1, 2, 3, 4]);
    });

    test('inserts into empty list', () {
      expect(<int>[].sortedInsert(42, compare: _intCompare), [42]);
    });

    test('stable insertion: equal element lands after existing one', () {
      const original = [
        _Item('a', 1, 'orig'),
        _Item('b', 3, 'orig'),
      ];
      final result = original.sortedInsert(
        const _Item('c', 1, 'new'),
        compare: _itemCompare,
      );
      // New element with value=1 should land AFTER the existing value=1 entry.
      expect(result.map((it) => it.id).toList(), ['a', 'c', 'b']);
    });

    test('does not modify the receiver', () {
      final original = [1, 2, 3];
      // ignore: cascade_invocations
      original.sortedInsert(4, compare: _intCompare);
      expect(original, [1, 2, 3]);
    });
  });

  group('SortedListX.sortedUpsert', () {
    test('inserts when no element with the key exists', () {
      const original = [_Item('a', 1), _Item('c', 5)];
      final result = original.sortedUpsert(
        const _Item('b', 3),
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'b', 'c']);
    });

    test('replaces in place when sort position is unchanged', () {
      const original = [_Item('a', 1), _Item('b', 3), _Item('c', 5)];
      final result = original.sortedUpsert(
        const _Item('b', 3, 'updated'),
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(result.map((it) => it.tag).toList(), ['', 'updated', '']);
    });

    test('removes + re-inserts when sort position changes', () {
      const original = [_Item('a', 1), _Item('b', 3), _Item('c', 5)];
      final result = original.sortedUpsert(
        const _Item('b', 7), // was 3, now 7 — should move past 'c'
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'c', 'b']);
    });

    test('uses update callback when provided', () {
      const original = [_Item('a', 1, 'keep')];
      final result = original.sortedUpsert(
        const _Item('a', 1, 'incoming'),
        key: _itemKey,
        compare: _itemCompare,
        update: (orig, upd) => _Item(orig.id, orig.value, '${orig.tag}+merged'),
      );
      expect(result.single.tag, 'keep+merged');
    });

    test('does not modify the receiver', () {
      final original = [const _Item('a', 1)];
      // ignore: cascade_invocations
      original.sortedUpsert(
        const _Item('b', 2),
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(original.length, 1);
    });
  });

  group('SortedListX.sortedUpsertAt', () {
    test('inserts via sortedInsert when index is -1', () {
      const original = [_Item('a', 1), _Item('c', 5)];
      final result = original.sortedUpsertAt(
        -1,
        const _Item('b', 3),
        compare: _itemCompare,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'b', 'c']);
    });

    test('replaces in place when sort position is unchanged', () {
      const original = [_Item('a', 1), _Item('b', 3), _Item('c', 5)];
      final result = original.sortedUpsertAt(
        1,
        const _Item('b', 3, 'updated'),
        compare: _itemCompare,
      );
      expect(result.map((it) => it.tag).toList(), ['', 'updated', '']);
    });

    test('removes + re-inserts when sort position changes', () {
      const original = [_Item('a', 1), _Item('b', 3), _Item('c', 5)];
      final result = original.sortedUpsertAt(
        1,
        const _Item('b', 7),
        compare: _itemCompare,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'c', 'b']);
    });

    test('matches sortedUpsert when caller passes the same index', () {
      const original = [_Item('a', 1), _Item('b', 3), _Item('c', 5)];
      final viaUpsert = original.sortedUpsert(
        const _Item('b', 4, 'x'),
        key: _itemKey,
        compare: _itemCompare,
      );
      final viaUpsertAt = original.sortedUpsertAt(
        1,
        const _Item('b', 4, 'x'),
        compare: _itemCompare,
      );
      expect(viaUpsertAt, viaUpsert);
    });
  });

  group('SortedListX.merge', () {
    test('returns this when other is null', () {
      final original = [1, 2, 3];
      expect(identical(original.merge(null, key: (it) => it), original), true);
    });

    test('returns this when other is empty', () {
      final original = [1, 2, 3];
      expect(
        identical(original.merge(const <int>[], key: (it) => it), original),
        true,
      );
    });

    test('returns this when other is identical to this', () {
      final original = [1, 2, 3];
      expect(
        identical(original.merge(original, key: (it) => it), original),
        true,
      );
    });

    test('appends new items from other', () {
      final result = [const _Item('a', 1)].merge(
        const [_Item('b', 2)],
        key: _itemKey,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'b']);
    });

    test('default update: prefers the element from other', () {
      final result = [const _Item('a', 1, 'old')].merge(
        const [_Item('a', 2, 'new')],
        key: _itemKey,
      );
      expect(result.single.tag, 'new');
    });

    test('custom update resolves duplicates', () {
      final result = [const _Item('a', 1, 'old')].merge(
        const [_Item('a', 2, 'new')],
        key: _itemKey,
        update: (orig, upd) => _Item(orig.id, upd.value, '${orig.tag}+merged'),
      );
      expect(result.single.tag, 'old+merged');
    });

    test('sorts the result when compare is provided', () {
      final result = [const _Item('b', 3)].merge(
        const [_Item('a', 1), _Item('c', 5)],
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(result.map((it) => it.value).toList(), [1, 3, 5]);
    });

    test('preserves insertion order when compare is not provided', () {
      // Map iteration preserves insertion order in Dart — items from `this`
      // come first, then new items from `other`.
      final result = [const _Item('a', 1)].merge(
        const [_Item('b', 2)],
        key: _itemKey,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'b']);
    });

    test('non-overlapping append fast-path (livestream)', () {
      const existing = [_Item('a', 1), _Item('b', 3)];
      const incoming = [_Item('c', 5), _Item('d', 7)];
      final result = existing.merge(
        incoming,
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'b', 'c', 'd']);
    });

    test('non-overlapping prepend fast-path (pagination)', () {
      const existing = [_Item('c', 5), _Item('d', 7)];
      const incoming = [_Item('a', 1), _Item('b', 3)];
      final result = existing.merge(
        incoming,
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'b', 'c', 'd']);
    });

    test('two-pointer path: merges pre-sorted lists in sorted order', () {
      const existing = [_Item('a', 1), _Item('c', 5), _Item('e', 9)];
      const incoming = [_Item('b', 3), _Item('d', 7)];
      final result = existing.merge(
        incoming,
        key: _itemKey,
        compare: _itemCompare,
      );
      expect(result.map((it) => it.id).toList(), ['a', 'b', 'c', 'd', 'e']);
    });

    test('two-pointer path: applies update on key collisions', () {
      const existing = [_Item('a', 1), _Item('b', 3, 'orig')];
      const incoming = [_Item('b', 3, 'new'), _Item('c', 5)];
      final result = existing.merge(
        incoming,
        key: _itemKey,
        update: (orig, upd) => _Item(orig.id, upd.value, '${orig.tag}+merged'),
        compare: _itemCompare,
      );
      expect(result.map((it) => it.tag).toList(), ['', 'orig+merged', '']);
    });

    test('two-pointer path: asserts when receiver is not sorted', () {
      const unsorted = [_Item('a', 5), _Item('b', 1)];
      expect(
        () => unsorted.merge(
          const [_Item('c', 3)],
          key: _itemKey,
          compare: _itemCompare,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('two-pointer path: asserts when other is not sorted', () {
      const sorted = [_Item('a', 1), _Item('b', 3)];
      expect(
        () => sorted.merge(
          const [_Item('c', 5), _Item('d', 2)],
          key: _itemKey,
          compare: _itemCompare,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ListX.updateIf', () {
    test('replaces matching elements', () {
      expect(
        [1, 2, 3, 4].updateIf((n) => n.isEven, (n) => n * 10),
        [1, 20, 3, 40],
      );
    });

    test('returns the receiver unchanged when nothing matches', () {
      final original = [1, 3, 5];
      final result = original.updateIf((n) => n.isEven, (n) => n * 10);
      expect(identical(result, original), true);
    });

    test('does not modify the receiver', () {
      final original = [1, 2, 3];
      // ignore: cascade_invocations
      original.updateIf((n) => n.isEven, (n) => n * 10);
      expect(original, [1, 2, 3]);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/channel_sort_converter.dart';

void main() {
  const converter = ChannelSortConverter();

  test('a non-empty sort round-trips unchanged', () {
    final original = [
      ChannelSort.desc(ChannelSortField.pinnedAt),
      ChannelSort.asc(ChannelSortField.createdAt),
    ];

    final decoded = converter.fromSql(converter.toSql(original));

    expect(decoded.length, original.length);
    for (var i = 0; i < original.length; i++) {
      // `SortField` has no value equality, so this also asserts the declared
      // field came back rather than a `custom` one built from its name.
      expect(decoded[i].field, same(original[i].field));
      expect(decoded[i].direction, original[i].direction);
    }
  });

  test('an empty sort round-trips as empty', () {
    final decoded = converter.fromSql(converter.toSql([]));
    expect(decoded, isEmpty);
  });

  test("a round-tripped sort keeps the field's null ordering", () {
    // `pinned_at` is nulls-last in either direction, which the server does and
    // `ChannelSort` resolves off the field. A bare `Sort` would lose it. Only
    // the field-derived ordering survives — the wire shape carries no null
    // ordering, so an explicit override could not be persisted here.
    final decoded = converter.fromSql(
      converter.toSql([ChannelSort.desc(ChannelSortField.pinnedAt)]),
    );

    expect(decoded.single.nullOrdering, NullOrdering.nullsLast);
  });

  test('the persisted shape is the one the API uses', () {
    // Rows outlive the SDK version that wrote them, so this shape cannot drift
    // silently. It is also what the API echoes back for a predefined filter.
    final encoded = converter.toSql([ChannelSort.desc(ChannelSortField.lastMessageAt)]);

    expect(encoded, '[{"field":"last_message_at","direction":-1}]');
    expect(converter.fromSql(encoded).single.field, same(ChannelSortField.lastMessageAt));
  });

  test('a field the SDK does not model still decodes', () {
    final decoded = converter.fromSql('[{"field":"not_a_known_field","direction":1}]');

    expect(decoded.single.field.remote, 'not_a_known_field');
    expect(decoded.single.direction, SortDirection.asc);
  });
}

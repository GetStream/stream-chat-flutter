import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/filter_converter.dart';

void main() {
  const converter = FilterConverter();

  test('empty filter round-trips as empty', () {
    const original = ChannelFilter.raw({});

    final decoded = converter.fromSql(converter.toSql(original));

    expect(decoded.toJson(), isEmpty);
  });

  test('raw map filter round-trips unchanged', () {
    const original = ChannelFilter.raw({
      'type': 'messaging',
      'members': ['user-1', 'user-2'],
    });

    final decoded = converter.fromSql(converter.toSql(original));

    expect(decoded.toJson(), original.toJson());
  });
}

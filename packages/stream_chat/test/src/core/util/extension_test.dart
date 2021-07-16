import 'package:test/test.dart';
import 'package:stream_chat/src/core/util/extension.dart';

void main() {
  test('`.withNullifyer` converts the type into non-nullable', () {
    final items = ['A', 'B', null, 'D'];
    expect(items, isA<Iterable<String?>>());
    expect(items.length, 4);

    final nullifiedItems = items.withNullifyer;
    expect(nullifiedItems, isA<Iterable<String>>());
    expect(nullifiedItems.length, 3);
  });

  test('`.nullProtected should remove all the null keys, value`', () {
    final map = {'name': 'sahil', 'age': null, null: 'India'};
    expect(map, isA<Map<String?, String?>>());
    expect(map.length, 3);

    final nullProtectedMap = map.nullProtected;
    expect(nullProtectedMap, isA<Map<String, String>>());
    expect(nullProtectedMap.length, 1);
  });

  group('mimeType', () {
    test('should return null if `String` is not a filename', () {
      const fileName = 'not-a-file-name';
      final mimeType = fileName.mimeType;
      expect(mimeType, isNull);
    });

    test('should return mimeType if string is a filename', () {
      const fileName = 'dummyFileName.jpeg';
      final mimeType = fileName.mimeType;
      expect(mimeType, isNotNull);
      expect(mimeType!.type, 'image');
      expect(mimeType.subtype, 'jpeg');
    });

    test('should return `image/heic` if ends with `heic`', () {
      const fileName = 'dummyFileName.heic';
      final mimeType = fileName.mimeType;
      expect(mimeType, isNotNull);
      expect(mimeType!.type, 'image');
      expect(mimeType.subtype, 'heic');
    });
  });
}

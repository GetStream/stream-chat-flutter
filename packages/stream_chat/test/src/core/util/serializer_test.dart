import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:test/test.dart';

void main() {
  group('Serializer', () {
    test('moveKeysToMapInPlace', () {
      final serializer = Serializer.moveToExtraDataFromRoot(
        {
          'test': 'test',
          'name': 'Sahil',
          'age': 22,
          'country': 'India',
        },
        ['test'],
      );
      expect(serializer, {
        'test': 'test',
        'extra_data': {
          'name': 'Sahil',
          'age': 22,
          'country': 'India',
        }
      });
    });

    test('moveKeysToMapInPlace', () {
      final serializer = Serializer.moveFromExtraDataToRoot({
        'test': 'test',
        'extra_data': {
          'name': 'Sahil',
          'age': 22,
          'country': 'India',
        }
      });
      expect(serializer, {
        'test': 'test',
        'name': 'Sahil',
        'age': 22,
        'country': 'India',
      });
    });
  });
}

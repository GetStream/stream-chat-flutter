import 'package:test/test.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

void main() {
  group('src/models/serialization', () {
    test('should move unknown keys from root to dedicate property', () {
      final json = {
        'prop1': 'test',
        'prop2': 123,
        'prop3': true,
      };
      final result = Serializer.moveToExtraDataFromRoot(json, [
        'prop1',
        'prop2',
      ]);

      expect(result, {
        'prop1': 'test',
        'prop2': 123,
        'extra_data': {
          'prop3': true,
        },
      });

      expect(json, {
        'prop1': 'test',
        'prop2': 123,
        'prop3': true,
      });
    });

    test('should have empty extraData', () {
      final result = Serializer.moveToExtraDataFromRoot({
        'prop1': 'test',
        'prop2': 123,
        'prop3': true,
      }, [
        'prop1',
        'prop2',
        'prop3'
      ]);

      expect(result, {
        'prop1': 'test',
        'prop2': 123,
        'prop3': true,
        'extra_data': {},
      });
    });

    test('should return null', () {
      final result = Serializer.moveToExtraDataFromRoot({}, [
        'prop1',
        'prop2',
      ]);

      expect(result, {'extra_data': {}});
    });
  });
}

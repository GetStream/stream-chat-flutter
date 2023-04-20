import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

void main() {
  group('MapConverter', () {
    final mapConverter = MapConverter<String>();

    group('fromSql', () {
      test('should throw type error if the provided json is not a map', () {
        const json = ['testData1', 'testData2', 'testData3'];
        expect(
          () => mapConverter.fromSql(jsonEncode(json)),
          throwsA(isA<TypeError>()),
        );
      });

      test(
        'should throw type error if the provided json is not a '
        'map of String, String',
        () {
          const json = {'test_key': 22, 'test_key2': 33, 'test_key3': 44};
          expect(
            () => mapConverter.fromSql(jsonEncode(json)),
            throwsA(isA<TypeError>()),
          );
        },
      );

      test('should return map of String, String if json data is provided', () {
        const data = {
          'test_key': 'testValue',
          'test_key2': 'testValue2',
          'test_key3': 'testValue3',
        };
        final res = mapConverter.fromSql(jsonEncode(data));
        expect(res, data);
      });
    });

    group('toSql', () {
      test('should return json string if data map is provided', () {
        const data = {
          'test_key': 'testValue',
          'test_key2': 'testValue2',
          'test_key3': 'testValue3',
        };
        final res = mapConverter.toSql(data);
        expect(res, jsonEncode(data));
      });
    });
  });

  group('NullableMapConverter', () {
    final mapConverter = NullableMapConverter<String>();

    group('fromSql', () {
      test('should return null if nothing is provided', () {
        final res = mapConverter.fromSql(null);
        expect(res, isNull);
      });

      test('should throw type error if the provided json is not a map', () {
        const json = ['testData1', 'testData2', 'testData3'];
        expect(
          () => mapConverter.fromSql(jsonEncode(json)),
          throwsA(isA<TypeError>()),
        );
      });

      test(
        'should throw type error if the provided json is not a '
        'map of String, String',
        () {
          const json = {'test_key': 22, 'test_key2': 33, 'test_key3': 44};
          expect(
            () => mapConverter.fromSql(jsonEncode(json)),
            throwsA(isA<TypeError>()),
          );
        },
      );

      test('should return map of String, String if json data is provided', () {
        const data = {
          'test_key': 'testValue',
          'test_key2': 'testValue2',
          'test_key3': 'testValue3',
        };
        final res = mapConverter.fromSql(jsonEncode(data));
        expect(res, data);
      });
    });

    group('toSql', () {
      test('should return null if nothing is provided', () {
        final res = mapConverter.toSql(null);
        expect(res, isNull);
      });

      test('should return json string if data map is provided', () {
        const data = {
          'test_key': 'testValue',
          'test_key2': 'testValue2',
          'test_key3': 'testValue3',
        };
        final res = mapConverter.toSql(data);
        expect(res, jsonEncode(data));
      });
    });
  });
}

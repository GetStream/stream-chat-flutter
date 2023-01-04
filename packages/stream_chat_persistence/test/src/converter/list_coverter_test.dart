import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_persistence/src/converter/list_converter.dart';

void main() {
  group('mapToDart', () {
    final listConverter = ListConverter<String>();

    test('should throw type error if the provided json is not a list', () {
      final json = {'test_key': 'testData'};
      expect(
        () => listConverter.fromSql(jsonEncode(json)),
        throwsA(isA<TypeError>()),
      );
    });

    test('should throw type error if the provided json is not a list of String', () {
      final json = [22, 33, 44];
      expect(
        () => listConverter.fromSql(jsonEncode(json)),
        throwsA(isA<TypeError>()),
      );
    });

    test('should return list of String if json data list is provided', () {
      final data = ['data1', 'data2', 'data3'];
      final res = listConverter.fromSql(jsonEncode(data));
      expect(res.length, data.length);
    });
  });

  group('mapToSql', () {
    final listConverter = ListConverter<String>();

    test('should return json string if data list is provided', () {
      final data = ['data1', 'data2', 'data3'];
      final res = listConverter.toSql(data);
      expect(res, jsonEncode(data));
    });
  });
}

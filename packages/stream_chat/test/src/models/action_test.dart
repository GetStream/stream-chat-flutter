import 'dart:convert';

import 'package:test/test.dart';
import 'package:stream_chat/src/models/action.dart';

void main() {
  group('src/models/action', () {
    const jsonExample = '''
    {
    "name": "name",
    "style": "style",
    "text": "text",
    "type": "type",
    "value": "value"
    }''';

    test('should parse json correctly', () {
      final action = Action.fromJson(json.decode(jsonExample));
      expect(action.name, 'name');
      expect(action.style, 'style');
      expect(action.text, 'text');
      expect(action.type, 'type');
      expect(action.value, 'value');
    });

    test('should serialize to json correctly', () {
      final action = Action(
        name: 'name',
        style: 'style',
        text: 'text',
        type: 'type',
        value: 'value',
      );

      expect(
        action.toJson(),
        {
          'name': 'name',
          'style': 'style',
          'text': 'text',
          'type': 'type',
          'value': 'value',
        },
      );
    });
  });
}

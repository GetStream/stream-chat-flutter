import 'package:stream_chat/src/core/models/action.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/action', () {
    test('should parse json correctly', () {
      final action = Action.fromJson(jsonFixture('action.json'));
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

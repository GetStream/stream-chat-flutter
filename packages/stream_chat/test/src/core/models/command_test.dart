import 'package:stream_chat/src/core/models/command.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/command', () {
    test('should parse json correctly', () {
      final command = Command.fromJson(jsonFixture('command.json'));
      expect(command.name, 'giphy');
      expect(command.description, 'Post a random gif to the channel');
      expect(command.args, '[text]');
    });

    test('should serialize to json correctly', () {
      final command = Command(
        name: 'giphy',
        description: 'Post a random gif to the channel',
        args: '[text]',
      );

      expect(
        command.toJson(),
        {
          'name': 'giphy',
          'description': 'Post a random gif to the channel',
          'args': '[text]',
        },
      );
    });
  });
}

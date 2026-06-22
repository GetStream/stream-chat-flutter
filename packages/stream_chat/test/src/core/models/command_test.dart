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
      expect(command.set, CommandSet.fun);
    });

    test('should default to an empty set when the field is missing', () {
      final command = Command.fromJson({
        'name': 'ban',
        'description': 'Ban a user',
        'args': '[@username]',
      });
      expect(command.set, const CommandSet(''));
    });

    test('should parse json with a custom set value', () {
      final command = Command.fromJson({
        'name': 'custom',
        'description': '',
        'args': '',
        'set': 'app_specific_set',
      });
      expect(command.set, const CommandSet('app_specific_set'));
    });

    test('should serialize to json correctly', () {
      final command = Command(
        name: 'giphy',
        description: 'Post a random gif to the channel',
        args: '[text]',
        set: CommandSet.fun,
      );

      expect(
        command.toJson(),
        {
          'name': 'giphy',
          'description': 'Post a random gif to the channel',
          'args': '[text]',
          'set': 'fun_set',
        },
      );
    });
  });
}

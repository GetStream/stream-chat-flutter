import 'dart:convert';

import 'package:test/test.dart';
import 'package:stream_chat/src/models/reaction.dart';
import 'package:stream_chat/src/models/user.dart';

void main() {
  group('src/models/reaction', () {
    const jsonExample = '''
      {
        "message_id": "76cd8c82-b557-4e48-9d12-87995d3a0e04",
        "user_id": "2de0297c-f3f2-489d-b930-ef77342edccf",
        "user": {
          "id": "2de0297c-f3f2-489d-b930-ef77342edccf",
          "role": "user",
          "created_at": "2020-01-28T22:17:30.810011Z",
          "updated_at": "2020-01-28T22:17:31.077195Z",
          "banned": false,
          "online": false,
          "image": "https://randomuser.me/api/portraits/women/45.jpg",
          "name": "Daisy Morgan"
        },
        "type": "wow",
        "score": 1,
        "created_at": "2020-01-28T22:17:31.108742Z",
        "updated_at": "2020-01-28T22:17:31.108742Z"
      }
      ''';

    test('should parse json correctly', () {
      final reaction = Reaction.fromJson(json.decode(jsonExample));
      expect(reaction.messageId, '76cd8c82-b557-4e48-9d12-87995d3a0e04');
      expect(reaction.createdAt, DateTime.parse('2020-01-28T22:17:31.108742Z'));
      expect(reaction.type, 'wow');
      expect(
        reaction.user.toJson(),
        User(id: '2de0297c-f3f2-489d-b930-ef77342edccf', extraData: {
          'image': 'https://randomuser.me/api/portraits/women/45.jpg',
          'name': 'Daisy Morgan'
        }).toJson(),
      );
      expect(reaction.score, 1);
      expect(reaction.userId, '2de0297c-f3f2-489d-b930-ef77342edccf');
      expect(reaction.extraData, {'updated_at': '2020-01-28T22:17:31.108742Z'});
    });

    test('should serialize to json correctly', () {
      final reaction = Reaction(
        messageId: '76cd8c82-b557-4e48-9d12-87995d3a0e04',
        createdAt: DateTime.parse('2020-01-28T22:17:31.108742Z'),
        type: 'wow',
        user: User(id: '2de0297c-f3f2-489d-b930-ef77342edccf', extraData: {
          'image': 'https://randomuser.me/api/portraits/women/45.jpg',
          'name': 'Daisy Morgan'
        }),
        userId: '2de0297c-f3f2-489d-b930-ef77342edccf',
        extraData: {'bananas': 'yes'},
        score: 1,
      );

      expect(
        reaction.toJson(),
        {
          'message_id': '76cd8c82-b557-4e48-9d12-87995d3a0e04',
          'type': 'wow',
          'score': 1,
          'bananas': 'yes',
        },
      );
    });
  });
}

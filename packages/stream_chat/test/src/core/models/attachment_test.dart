import 'package:stream_chat/src/core/models/action.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/attachment', () {
    test('should parse json correctly', () {
      final attachment = Attachment.fromJson(jsonFixture('attachment.json'));
      expect(attachment.type, 'giphy');
      expect(attachment.title, 'awesome');
      expect(
        attachment.titleLink,
        'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
      );
      expect(
        attachment.thumbUrl,
        'https://media0.giphy.com/media/3o7TKnCdBx5cMg0qti/giphy.gif',
      );
      expect(attachment.actions, hasLength(3));
      expect(attachment.actions[0], isA<Action>());
    });

    test('should serialize to json correctly', () {
      final channel = Attachment(
        type: 'image',
        title: 'soo',
        titleLink:
            'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
      );

      expect(
        channel.toJson(),
        {
          'type': 'image',
          'title': 'soo',
          'title_link':
              'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
          'actions': [],
        },
      );
    });
  });
}

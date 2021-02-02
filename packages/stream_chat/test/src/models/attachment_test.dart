import 'package:stream_chat/src/models/attachment.dart';
import 'package:stream_chat/src/models/action.dart';
import 'dart:convert';

import 'package:test/test.dart';

void main() {
  group('src/models/attachment', () {
    const jsonExample = r'''{
  "type": "giphy",
  "title": "awesome",
  "title_link": "https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti",
  "thumb_url": "https://media0.giphy.com/media/3o7TKnCdBx5cMg0qti/giphy.gif",
  "actions": [
    {
    "name": "image_action",
    "text": "Send",
    "style": "primary",
    "type": "button",
    "value": "send"
    },
    {
    "name": "image_action",
    "text": "Shuffle",
    "style": "default",
    "type": "button",
    "value": "shuffle"
    },
    {
    "name": "image_action",
    "text": "Cancel",
    "style": "default",
    "type": "button",
    "value": "cancel"
    }
  ]
}''';

    test('should parse json correctly', () {
      final attachment = Attachment.fromJson(json.decode(jsonExample));
      expect(attachment.type, "giphy");
      expect(attachment.title, "awesome");
      expect(attachment.titleLink,
          "https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti");
      expect(attachment.thumbUrl,
          "https://media0.giphy.com/media/3o7TKnCdBx5cMg0qti/giphy.gif");
      expect(attachment.actions, hasLength(3));
      expect(attachment.actions[0], isA<Action>());
    });

    test('should serialize to json correctly', () {
      final channel = Attachment(
          type: "image",
          title: "soo",
          titleLink:
              "https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti");

      expect(
        channel.toJson(),
        {
          'type': 'image',
          'title': 'soo',
          'title_link':
              'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti'
        },
      );
    });
  });
}

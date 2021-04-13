import 'dart:convert';

import 'package:test/test.dart';
import 'package:stream_chat/src/models/attachment.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/reaction.dart';
import 'package:stream_chat/src/models/user.dart';

void main() {
  group('src/models/message', () {
    const jsonExample = r'''{
      "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
      "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
      "type": "regular",
      "silent": false,
      "status": "SENT",
      "user": {
          "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
          "role": "user",
          "created_at": "2020-01-28T22:17:30.83015Z",
          "updated_at": "2020-01-28T22:17:31.19435Z",
          "banned": false,
          "online": false,
          "image": "https://randomuser.me/api/portraits/women/2.jpg",
          "name": "Mia Denys"
      },
      "attachments": [
          {
              "type": "video",
              "author_name": "GIPHY",
              "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
              "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
              "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
              "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
              "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
              "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
              "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
          }
      ],
      "latest_reactions": [
          {
              "message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
              "user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
              "user": {
                  "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                  "role": "user",
                  "created_at": "2020-01-28T22:17:30.83015Z",
                  "updated_at": "2020-01-28T22:17:31.19435Z",
                  "banned": false,
                  "online": false,
                  "image": "https://randomuser.me/api/portraits/women/2.jpg",
                  "name": "Mia Denys"
              },
              "type": "love",
              "score": 1,
              "created_at": "2020-01-28T22:17:31.128376Z",
              "updated_at": "2020-01-28T22:17:31.128376Z"
          }
      ],
      "own_reactions": [],
      "reaction_counts": {
          "love": 1
      },
      "reaction_scores": {
          "love": 1
      },
      "pinned": false,
      "pinned_at": null,
      "pin_expires": null,
      "pinned_by": null,
      "reply_count": 0,
      "created_at": "2020-01-28T22:17:31.107978Z",
      "updated_at": "2020-01-28T22:17:31.130506Z",
      "mentioned_users": []
    }''';

    test('should parse json correctly', () {
      final message = Message.fromJson(json.decode(jsonExample));
      expect(message.id, '4637f7e4-a06b-42db-ba5a-8d8270dd926f');
      expect(message.text,
          'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA');
      expect(message.type, 'regular');
      expect(message.user, isA<User>());
      expect(message.silent, isA<bool>());
      expect(message.attachments, isA<List<Attachment>>());
      expect(message.latestReactions, isA<List<Reaction>>());
      expect(message.ownReactions, isA<List<Reaction>>());
      expect(message.reactionCounts, {'love': 1});
      expect(message.reactionScores, {'love': 1});
      expect(message.createdAt, DateTime.parse('2020-01-28T22:17:31.107978Z'));
      expect(message.updatedAt, DateTime.parse('2020-01-28T22:17:31.130506Z'));
      expect(message.mentionedUsers, isA<List<User>>());
      expect(message.pinned, false);
      expect(message.pinnedAt, null);
      expect(message.pinExpires, null);
      expect(message.pinnedBy, null);
    });

    test('should serialize to json correctly', () {
      final message = Message.temp(
        id: '4637f7e4-a06b-42db-ba5a-8d8270dd926f',
        text:
            'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA',
        silent: false,
        attachments: [
          Attachment.fromJson({
            'type': 'video',
            'author_name': 'GIPHY',
            'title': 'The Lion King Disney GIF - Find \u0026 Share on GIPHY',
            'title_link':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'text':
                '''Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.''',
            'image_url':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'thumb_url':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'asset_url':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4',
            'og_scrape_url':
                'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA'
          })
        ],
        showInChannel: true,
        parentId: 'parentId',
        extraData: {'hey': 'test'},
      );

      expect(
        message.toJson(),
        json.decode('''
        {
            "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
            "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
            "silent": false,
            "skip_push": null,
            "attachments": [
              {
                "type": "video",
                "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                "title": "The Lion King Disney GIF - Find & Share on GIPHY",
                "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                "text": "Discover & share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                "author_name": "GIPHY",
                "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4"
              }
            ],
            "mentioned_users": null,
            "parent_id": "parentId",
            "quoted_message": null,
            "quoted_message_id": null,
            "pinned": false,
            "pinned_at": null,
            "pin_expires": null,
            "pinned_by": null,
            "show_in_channel": true,
            "hey": "test"
          }
        '''),
      );
    });
  });
}

import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/message', () {
    test('should parse json correctly', () {
      final message = Message.fromJson(jsonFixture('message.json'));
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
      final message = Message(
        id: '4637f7e4-a06b-42db-ba5a-8d8270dd926f',
        text:
            'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA',
        attachments: [
          Attachment.fromJson(const {
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
        extraData: const {'hey': 'test'},
      );

      expect(
        message.toJson(),
        jsonFixture('message_to_json.json'),
      );
    });
  });
}

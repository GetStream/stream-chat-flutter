import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('Mention hierarchy', () {
    test('StreamUserMention exposes user payload, type, display from user.name', () {
      final user = User(id: 'alice-id', name: 'Alice');
      final mention = StreamUserMention(user: user);

      expect(mention.user, same(user));
      expect(mention.type, StreamMentionType.user);
      expect(mention.display, 'Alice');
    });

    test('StreamUserMention.display falls back to user.id when name is unset', () {
      final user = User(id: 'alice-id');
      final mention = StreamUserMention(user: user);

      expect(mention.display, 'alice-id');
    });

    test('StreamChannelMention has fixed type and display', () {
      const mention = StreamChannelMention();

      expect(mention.type, StreamMentionType.channel);
      expect(mention.display, 'channel');
    });

    test('StreamHereMention has fixed type and display', () {
      const mention = StreamHereMention();

      expect(mention.type, StreamMentionType.here);
      expect(mention.display, 'here');
    });

    test('StreamRoleMention carries role name as type / display', () {
      const mention = StreamRoleMention(role: 'admin');

      expect(mention.role, 'admin');
      expect(mention.type, StreamMentionType.role);
      expect(mention.display, 'admin');
    });

    test('StreamGroupMention exposes userGroup payload, type, display from name', () {
      final group = UserGroup(
        id: 'grp-1',
        name: 'Dream Team',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final mention = StreamGroupMention(userGroup: group);

      expect(mention.userGroup, same(group));
      expect(mention.type, StreamMentionType.group);
      expect(mention.display, 'Dream Team');
    });
  });
}

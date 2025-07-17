import 'package:stream_chat/src/core/models/unread_counts.dart';
import 'package:test/test.dart';

void main() {
  group('UnreadCountsChannel', () {
    const channelId = 'messaging:test-channel-id';
    const unreadCount = 5;
    final lastRead = DateTime.parse('2024-01-15T10:30:00Z');

    test('should parse json correctly', () {
      final json = {
        'channel_id': channelId,
        'unread_count': unreadCount,
        'last_read': '2024-01-15T10:30:00.000Z',
      };

      final unreadCountsChannel = UnreadCountsChannel.fromJson(json);

      expect(unreadCountsChannel.channelId, channelId);
      expect(unreadCountsChannel.unreadCount, unreadCount);
      expect(unreadCountsChannel.lastRead, lastRead);
    });

    test('should serialize to json correctly', () {
      final unreadCountsChannel = UnreadCountsChannel(
        channelId: channelId,
        unreadCount: unreadCount,
        lastRead: lastRead,
      );

      final json = unreadCountsChannel.toJson();

      expect(json['channel_id'], channelId);
      expect(json['unread_count'], unreadCount);
      expect(json['last_read'], lastRead.toIso8601String());
    });
  });

  group('UnreadCountsThread', () {
    const unreadCount = 3;
    final lastRead = DateTime.parse('2024-01-15T10:30:00Z');
    const lastReadMessageId = 'last-read-message-id';
    const parentMessageId = 'parent-message-id';

    test('should parse json correctly', () {
      final json = {
        'unread_count': unreadCount,
        'last_read': '2024-01-15T10:30:00.000Z',
        'last_read_message_id': lastReadMessageId,
        'parent_message_id': parentMessageId,
      };

      final unreadCountsThread = UnreadCountsThread.fromJson(json);

      expect(unreadCountsThread.unreadCount, unreadCount);
      expect(unreadCountsThread.lastRead, lastRead);
      expect(unreadCountsThread.lastReadMessageId, lastReadMessageId);
      expect(unreadCountsThread.parentMessageId, parentMessageId);
    });

    test('should serialize to json correctly', () {
      final unreadCountsThread = UnreadCountsThread(
        unreadCount: unreadCount,
        lastRead: lastRead,
        lastReadMessageId: lastReadMessageId,
        parentMessageId: parentMessageId,
      );

      final json = unreadCountsThread.toJson();

      expect(json['unread_count'], unreadCount);
      expect(json['last_read'], lastRead.toIso8601String());
      expect(json['last_read_message_id'], lastReadMessageId);
      expect(json['parent_message_id'], parentMessageId);
    });
  });

  group('UnreadCountsChannelType', () {
    const channelType = 'messaging';
    const channelCount = 10;
    const unreadCount = 25;

    test('should parse json correctly', () {
      final json = {
        'channel_type': channelType,
        'channel_count': channelCount,
        'unread_count': unreadCount,
      };

      final unreadCountsChannelType = UnreadCountsChannelType.fromJson(json);

      expect(unreadCountsChannelType.channelType, channelType);
      expect(unreadCountsChannelType.channelCount, channelCount);
      expect(unreadCountsChannelType.unreadCount, unreadCount);
    });

    test('should serialize to json correctly', () {
      const unreadCountsChannelType = UnreadCountsChannelType(
        channelType: channelType,
        channelCount: channelCount,
        unreadCount: unreadCount,
      );

      final json = unreadCountsChannelType.toJson();

      expect(json['channel_type'], channelType);
      expect(json['channel_count'], channelCount);
      expect(json['unread_count'], unreadCount);
    });

    test('should handle different channel types', () {
      final channelTypes = ['messaging', 'livestream', 'team', 'commerce'];

      for (final type in channelTypes) {
        final unreadCountsChannelType = UnreadCountsChannelType(
          channelType: type,
          channelCount: channelCount,
          unreadCount: unreadCount,
        );

        expect(unreadCountsChannelType.channelType, type);
        expect(unreadCountsChannelType.channelCount, channelCount);
        expect(unreadCountsChannelType.unreadCount, unreadCount);
      }
    });
  });
}

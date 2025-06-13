// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

void main() {
  group('MessageReminder', () {
    final now = DateTime.now();
    const channelCid = 'messaging:123';
    const messageId = 'message-123';
    const userId = 'user-123';
    final remindAt = DateTime.now().add(const Duration(days: 1));

    final messageReminder = MessageReminder(
      channelCid: channelCid,
      messageId: messageId,
      userId: userId,
      remindAt: remindAt,
      createdAt: now,
      updatedAt: now,
    );

    test('should create a valid instance with required parameters', () {
      expect(messageReminder.channelCid, equals(channelCid));
      expect(messageReminder.messageId, equals(messageId));
      expect(messageReminder.userId, equals(userId));
      expect(messageReminder.remindAt, equals(remindAt));
      expect(messageReminder.createdAt, equals(now));
      expect(messageReminder.updatedAt, equals(now));
      expect(messageReminder.channel, isNull);
      expect(messageReminder.message, isNull);
      expect(messageReminder.user, isNull);
    });

    test('should create a valid instance with all parameters', () {
      final channel = ChannelModel(cid: channelCid);
      final message = Message(id: messageId);
      final user = User(id: userId);

      final fullReminder = MessageReminder(
        channelCid: channelCid,
        channel: channel,
        messageId: messageId,
        message: message,
        userId: userId,
        user: user,
        remindAt: remindAt,
        createdAt: now,
        updatedAt: now,
      );

      expect(fullReminder.channelCid, equals(channelCid));
      expect(fullReminder.channel, equals(channel));
      expect(fullReminder.messageId, equals(messageId));
      expect(fullReminder.message, equals(message));
      expect(fullReminder.userId, equals(userId));
      expect(fullReminder.user, equals(user));
      expect(fullReminder.remindAt, equals(remindAt));
      expect(fullReminder.createdAt, equals(now));
      expect(fullReminder.updatedAt, equals(now));
    });

    test('should create a bookmark reminder when remindAt is null', () {
      final bookmarkReminder = MessageReminder(
        channelCid: channelCid,
        messageId: messageId,
        userId: userId,
        remindAt: null, // This makes it a bookmark
        createdAt: now,
        updatedAt: now,
      );

      expect(bookmarkReminder.remindAt, isNull);
      expect(bookmarkReminder.channelCid, equals(channelCid));
      expect(bookmarkReminder.messageId, equals(messageId));
      expect(bookmarkReminder.userId, equals(userId));
    });

    test('should correctly serialize to JSON', () {
      final json = messageReminder.toJson();

      expect(json['channel_cid'], equals(channelCid));
      expect(json['message_id'], equals(messageId));
      expect(json['user_id'], equals(userId));
      expect(json['remind_at'], isA<String>());
      expect(json['created_at'], isA<String>());
      expect(json['updated_at'], isA<String>());

      // These fields should not be included in JSON
      expect(json.containsKey('channel'), isFalse);
      expect(json.containsKey('message'), isFalse);
      expect(json.containsKey('user'), isFalse);
    });

    test('should correctly deserialize from JSON', () {
      final json = {
        'channel_cid': channelCid,
        'message_id': messageId,
        'user_id': userId,
        'remind_at': remindAt.toIso8601String(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final deserializedReminder = MessageReminder.fromJson(json);

      expect(deserializedReminder.channelCid, equals(channelCid));
      expect(deserializedReminder.messageId, equals(messageId));
      expect(deserializedReminder.userId, equals(userId));
      expect(deserializedReminder.remindAt, equals(remindAt));
      expect(deserializedReminder.createdAt, equals(now));
      expect(deserializedReminder.updatedAt, equals(now));
    });

    test('should implement equality correctly', () {
      final reminder1 = MessageReminder(
        channelCid: channelCid,
        messageId: messageId,
        userId: userId,
        remindAt: remindAt,
        createdAt: now,
        updatedAt: now,
      );

      final reminder2 = MessageReminder(
        channelCid: channelCid,
        messageId: messageId,
        userId: userId,
        remindAt: remindAt,
        createdAt: now,
        updatedAt: now,
      );

      final reminder3 = MessageReminder(
        channelCid: 'different:123',
        messageId: messageId,
        userId: userId,
        remindAt: remindAt,
        createdAt: now,
        updatedAt: now,
      );

      expect(reminder1, equals(reminder2));
      expect(reminder1, isNot(equals(reminder3)));
    });

    test('should implement equality correctly with null remindAt', () {
      final bookmark1 = MessageReminder(
        channelCid: channelCid,
        messageId: messageId,
        userId: userId,
        remindAt: null,
        createdAt: now,
        updatedAt: now,
      );

      final bookmark2 = MessageReminder(
        channelCid: channelCid,
        messageId: messageId,
        userId: userId,
        remindAt: null,
        createdAt: now,
        updatedAt: now,
      );

      final scheduledReminder = MessageReminder(
        channelCid: channelCid,
        messageId: messageId,
        userId: userId,
        remindAt: remindAt,
        createdAt: now,
        updatedAt: now,
      );

      expect(bookmark1, equals(bookmark2));
      expect(bookmark1, isNot(equals(scheduledReminder)));
    });

    test('should implement copyWith correctly', () {
      const newChannelCid = 'messaging:456';
      const newMessageId = 'message-456';
      const newUserId = 'user-456';
      final newRemindAt = DateTime.now().add(const Duration(days: 2));
      final newCreatedAt = DateTime.now().add(const Duration(hours: 1));
      final newUpdatedAt = DateTime.now().add(const Duration(hours: 2));

      final copiedReminder = messageReminder.copyWith(
        channelCid: newChannelCid,
        messageId: newMessageId,
        userId: newUserId,
        remindAt: newRemindAt,
        createdAt: newCreatedAt,
        updatedAt: newUpdatedAt,
      );

      expect(copiedReminder.channelCid, equals(newChannelCid));
      expect(copiedReminder.messageId, equals(newMessageId));
      expect(copiedReminder.userId, equals(newUserId));
      expect(copiedReminder.remindAt, equals(newRemindAt));
      expect(copiedReminder.createdAt, equals(newCreatedAt));
      expect(copiedReminder.updatedAt, equals(newUpdatedAt));

      // Original should be unchanged
      expect(messageReminder.channelCid, equals(channelCid));
      expect(messageReminder.messageId, equals(messageId));
      expect(messageReminder.userId, equals(userId));
      expect(messageReminder.remindAt, equals(remindAt));
      expect(messageReminder.createdAt, equals(now));
      expect(messageReminder.updatedAt, equals(now));
    });

    test('should implement copyWith correctly with null remindAt', () {
      final copiedReminder = messageReminder.copyWith(
        remindAt: null,
      );

      expect(copiedReminder.remindAt, isNull);
      expect(copiedReminder.channelCid, equals(messageReminder.channelCid));
      expect(copiedReminder.messageId, equals(messageReminder.messageId));
      expect(copiedReminder.userId, equals(messageReminder.userId));
    });

    test('should implement merge correctly', () {
      final originalReminder = MessageReminder(
        channelCid: channelCid,
        messageId: messageId,
        userId: userId,
        remindAt: remindAt,
        createdAt: now,
        updatedAt: now,
      );

      const newChannelCid = 'messaging:456';
      const newMessageId = 'message-456';
      final newRemindAt = DateTime.now().add(const Duration(days: 2));
      final newUpdatedAt = DateTime.now().add(const Duration(hours: 1));

      final otherReminder = MessageReminder(
        channelCid: newChannelCid,
        messageId: newMessageId,
        userId: userId, // Same userId
        remindAt: newRemindAt,
        createdAt: now, // Same createdAt
        updatedAt: newUpdatedAt,
      );

      final mergedReminder = originalReminder.merge(otherReminder);

      expect(mergedReminder.channelCid, equals(newChannelCid));
      expect(mergedReminder.messageId, equals(newMessageId));
      expect(mergedReminder.userId, equals(userId));
      expect(mergedReminder.remindAt, equals(newRemindAt));
      expect(mergedReminder.createdAt, equals(now));
      expect(mergedReminder.updatedAt, equals(newUpdatedAt));
    });

    test('should return original instance when merging with null', () {
      final mergedReminder = messageReminder.merge(null);

      expect(mergedReminder, equals(messageReminder));
      expect(identical(mergedReminder, messageReminder), isTrue);
    });

    test('should implement ComparableFieldProvider interface', () {
      // Test channelCid field
      final channelCidField = messageReminder.getComparableField(
        MessageReminderSortKey.channelCid,
      );
      expect(channelCidField, isA<ComparableField>());
      expect(channelCidField?.value, equals(channelCid));

      // Test remindAt field
      final remindAtField = messageReminder.getComparableField(
        MessageReminderSortKey.remindAt,
      );
      expect(remindAtField, isA<ComparableField>());
      expect(remindAtField?.value, equals(remindAt));

      // Test createdAt field
      final createdAtField = messageReminder.getComparableField(
        MessageReminderSortKey.createdAt,
      );
      expect(createdAtField, isA<ComparableField>());
      expect(createdAtField?.value, equals(now));

      // Test non-existent field
      final nonExistentField = messageReminder.getComparableField('unknown');
      expect(nonExistentField?.value, isNull);
    });

    test('MessageReminderSortKey should have defined constants', () {
      expect(MessageReminderSortKey.channelCid, equals('channel_cid'));
      expect(MessageReminderSortKey.remindAt, equals('remind_at'));
      expect(MessageReminderSortKey.createdAt, equals('created_at'));
    });
  });
}

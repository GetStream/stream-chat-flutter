import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/draft_message.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:test/test.dart';

void main() {
  group('Draft', () {
    final now = DateTime.now();
    const channelCid = 'messaging:123';
    final draftMessage = DraftMessage(text: 'Hello, world!');

    final draft = Draft(
      channelCid: channelCid,
      createdAt: now,
      message: draftMessage,
    );

    test('should create a valid instance', () {
      expect(draft.channelCid, equals(channelCid));
      expect(draft.createdAt, equals(now));
      expect(draft.message, equals(draftMessage));
      expect(draft.channel, isNull);
      expect(draft.parentId, isNull);
      expect(draft.parentMessage, isNull);
      expect(draft.quotedMessage, isNull);
    });

    test('should create a valid instance with all parameters', () {
      final channel = ChannelModel(cid: channelCid);
      const parentId = 'parent-123';
      final parentMessage = Message(id: parentId);
      final quotedMessage = Message(id: 'quote-123');

      final fullDraft = Draft(
        channelCid: channelCid,
        createdAt: now,
        message: draftMessage,
        channel: channel,
        parentId: parentId,
        parentMessage: parentMessage,
        quotedMessage: quotedMessage,
      );

      expect(fullDraft.channelCid, equals(channelCid));
      expect(fullDraft.createdAt, equals(now));
      expect(fullDraft.message, equals(draftMessage));
      expect(fullDraft.channel, equals(channel));
      expect(fullDraft.parentId, equals(parentId));
      expect(fullDraft.parentMessage, equals(parentMessage));
      expect(fullDraft.quotedMessage, equals(quotedMessage));
    });

    test('should correctly serialize to JSON', () {
      final json = draft.toJson();

      expect(json['channel_cid'], equals(channelCid));
      expect(json['created_at'], isA<String>());
      expect(json['message'], isA<Map<String, dynamic>>());
    });

    test('should correctly deserialize from JSON', () {
      final json = {
        'channel_cid': channelCid,
        'created_at': now.toIso8601String(),
        'message': draftMessage.toJson(),
      };

      final deserializedDraft = Draft.fromJson(json);

      expect(deserializedDraft.channelCid, equals(channelCid));
      expect(deserializedDraft.createdAt, equals(now));
      expect(deserializedDraft.message.id, equals(draftMessage.id));
      expect(deserializedDraft.message.text, equals(draftMessage.text));
    });

    test('should implement equality correctly', () {
      final draft1 = Draft(
        channelCid: channelCid,
        createdAt: now,
        message: draftMessage,
      );

      final draft2 = Draft(
        channelCid: channelCid,
        createdAt: now,
        message: draftMessage,
      );

      final draft3 = Draft(
        channelCid: 'different:123',
        createdAt: now,
        message: draftMessage,
      );

      expect(draft1, equals(draft2));
      expect(draft1, isNot(equals(draft3)));
    });

    test('should implement copyWith correctly', () {
      final newMessage = DraftMessage(text: 'Updated text');
      final newCreatedAt = DateTime.now().add(const Duration(days: 1));

      final copiedDraft = draft.copyWith(
        message: newMessage,
        createdAt: newCreatedAt,
      );

      expect(copiedDraft.channelCid, equals(draft.channelCid));
      expect(copiedDraft.createdAt, equals(newCreatedAt));
      expect(copiedDraft.message, equals(newMessage));

      // Original should be unchanged
      expect(draft.message, equals(draftMessage));
      expect(draft.createdAt, equals(now));
    });

    test('should implement ComparableFieldProvider interface', () {
      // Test createdAt field
      final createdAtField = draft.getComparableField(DraftSortKey.createdAt);
      expect(createdAtField, isA<ComparableField>());
      expect(createdAtField?.value, equals(now));

      // Test extraData field from message
      final draftWithExtraData = Draft(
        channelCid: channelCid,
        createdAt: now,
        message: DraftMessage(
          text: 'Hello, world!',
          extraData: const {'priority': 'high'},
        ),
      );

      final priorityField = draftWithExtraData.getComparableField('priority');
      expect(priorityField, isA<ComparableField>());
      expect(priorityField?.value, equals('high'));

      // Test non-existent field
      final nonExistentField = draft.getComparableField('non_existent');
      expect(nonExistentField?.value, isNull);
    });

    test('DraftSortKey should have defined constants', () {
      expect(DraftSortKey.createdAt, equals('created_at'));
    });
  });
}

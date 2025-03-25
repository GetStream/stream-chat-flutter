import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';

void main() {
  group('StreamMessageAction', () {
    test('equality is based on type', () {
      const action1 = StreamMessageAction(
        type: StreamMessageActionType.reply,
        title: Text('Reply'),
      );

      const action2 = StreamMessageAction(
        type: StreamMessageActionType.reply,
        title: Text('Reply (Different Text)'),
      );

      const action3 = StreamMessageAction(
        type: StreamMessageActionType.threadReply,
        title: Text('Reply'),
      );

      expect(action1 == action2, isTrue);
      expect(action1 == action3, isFalse);
      expect(action1.hashCode == action2.hashCode, isTrue);
      expect(action1.hashCode == action3.hashCode, isFalse);
    });

    test('creates with required parameters', () {
      const action = StreamMessageAction(
        type: StreamMessageActionType.reply,
        title: Text('Reply'),
        isDestructive: true,
        leading: Icon(Icons.reply),
      );

      expect(action.type, StreamMessageActionType.reply);
      expect(action.title, isA<Text>());
      expect(action.isDestructive, isTrue);
      expect(action.leading, isA<Icon>());
    });
  });

  group('StreamMessageActionType', () {
    test('has expected string values', () {
      expect(StreamMessageActionType.selectReaction, 'selectReaction');
      expect(StreamMessageActionType.banUser, 'banUser');
      expect(StreamMessageActionType.blockUser, 'blockUser');
      expect(StreamMessageActionType.copyMessage, 'copyMessage');
      expect(StreamMessageActionType.deleteMessage, 'deleteMessage');
      expect(StreamMessageActionType.editMessage, 'editMessage');
      expect(StreamMessageActionType.flagMessage, 'flagMessage');
      expect(StreamMessageActionType.markUnread, 'markUnread');
      expect(StreamMessageActionType.muteUser, 'muteUser');
      expect(StreamMessageActionType.pinMessage, 'pinMessage');
      expect(StreamMessageActionType.unpinMessage, 'unpinMessage');
      expect(StreamMessageActionType.reply, 'reply');
      expect(StreamMessageActionType.retry, 'retry');
      expect(StreamMessageActionType.quotedReply, 'quotedReply');
      expect(StreamMessageActionType.threadReply, 'threadReply');
    });

    test('is a String', () {
      const type = StreamMessageActionType.reply;
      expect(type, isA<String>());

      const String stringValue = type;
      expect(stringValue, 'reply');
    });
  });
}

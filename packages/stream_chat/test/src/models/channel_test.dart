import 'dart:convert';

import 'package:stream_chat/src/models/channel_model.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/channel', () {
    const jsonExample = '''
      {
        "id": "test",
        "type": "livestream",
        "cid": "livestream:test",
        "cats": true,
        "fruit": ["bananas", "apples"]
      }      
      ''';

    test('should parse json correctly', () {
      final channel = ChannelModel.fromJson(json.decode(jsonExample));
      expect(channel.id, equals('test'));
      expect(channel.type, equals('livestream'));
      expect(channel.cid, equals('livestream:test'));
      expect(channel.extraData['cats'], equals(true));
      expect(channel.extraData['fruit'], equals(['bananas', 'apples']));
    });

    test('should serialize to json correctly', () {
      final channel = ChannelModel(
        type: 'type',
        id: 'id',
        cid: 'a:a',
        extraData: {'name': 'cool'},
      );

      expect(
        channel.toJson(),
        {'id': 'id', 'type': 'type', 'frozen': false, 'name': 'cool'},
      );
    });

    test('should serialize to json correctly when frozen is provided', () {
      final channel = ChannelModel(
        type: 'type',
        id: 'id',
        cid: 'a:a',
        extraData: {'name': 'cool'},
      );

      expect(
        channel.toJson(),
        {'id': 'id', 'type': 'type', 'name': 'cool', 'frozen': false},
      );
    });
  });
}

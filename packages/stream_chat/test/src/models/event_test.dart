import 'dart:convert';

import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/own_user.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/event', () {
    const jsonExample = '''
      {
        "type": "type",
        "cid": "cid",
        "connection_id": "connectionId",
        "created_at": "2019-04-03T18:43:33.213374Z",
        "me": {
         "id": "dry-meadow-0",
         "role": "user",
         "created_at": "2019-03-27T17:40:17.155892Z",
         "updated_at": "2020-01-29T03:22:47.641589Z",
         "last_active": "2020-01-29T03:22:47.63613Z",
         "banned": false,
         "online": false,
         "image": "https://getstream.io/random_svg/?name=Dry+meadow",
         "name": "Dry meadow"
       },
        "parent_id": null,
        "user": {
         "id": "dry-meadow-0",
         "role": "user",
         "created_at": "2019-03-27T17:40:17.155892Z",
         "updated_at": "2020-01-29T03:22:47.641589Z",
         "last_active": "2020-01-29T03:22:47.63613Z",
         "banned": false,
         "online": false,
         "image": "https://getstream.io/random_svg/?name=Dry+meadow",
         "name": "Dry meadow"
       }
      }      
      ''';

    test('should parse json correctly', () {
      final event = Event.fromJson(json.decode(jsonExample));
      expect(event.type, 'type');
      expect(event.cid, 'cid');
      expect(event.connectionId, 'connectionId');
      expect(event.createdAt, isA<DateTime>());
      expect(event.me, isA<OwnUser>());
      expect(event.user, isA<User>());
    });

    test('should serialize to json correctly', () {
      final event = Event(
        user: User(id: 'id'),
        type: 'type',
        cid: 'cid',
        connectionId: 'connectionId',
        createdAt: DateTime.parse('2020-01-29T03:22:47.63613Z'),
        me: OwnUser(id: 'id2'),
        totalUnreadCount: 1,
        unreadChannels: 1,
        online: true,
      );

      expect(
        event.toJson(),
        {
          'type': 'type',
          'cid': 'cid',
          'connection_id': 'connectionId',
          'created_at': '2020-01-29T03:22:47.636130Z',
          'me': {'id': 'id2'},
          'user': {'id': 'id'},
          'reaction': null,
          'message': null,
          'channel': null,
          'total_unread_count': 1,
          'unread_channels': 1,
          'online': true,
          'member': null,
          'channel_id': null,
          'channel_type': null,
          'parent_id': null,
        },
      );
    });
  });
}

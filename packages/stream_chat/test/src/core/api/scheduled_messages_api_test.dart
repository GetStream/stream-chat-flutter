import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/scheduled_messages_api.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
    data: data,
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
  );

  final scheduledMessageJson = {
    'id': 'scheduled-id',
    'cid': 'messaging:general',
    'user': {'id': 'alice'},
    'message': {'text': 'Good morning', 'custom': <String, dynamic>{}},
    'scheduled_at': '2026-11-02T09:00:00.000Z',
    'status': 'scheduled',
    'created_at': '2026-10-29T10:00:00.000Z',
    'updated_at': '2026-10-29T10:00:00.000Z',
  };

  late final client = MockHttpClient();
  late ScheduledMessagesApi scheduledMessagesApi;

  setUp(() {
    scheduledMessagesApi = ScheduledMessagesApi(client);
  });

  tearDown(() => reset(client));

  group('queryScheduledMessages', () {
    const path = '/scheduled_messages/query';

    test('sends an empty filter when nothing narrows the page', () async {
      final payload = jsonEncode({'filter': <String, dynamic>{}});
      when(() => client.post(path, data: payload)).thenAnswer(
        (_) async => successResponse(path, data: {'scheduled_messages': <Object>[]}),
      );

      await scheduledMessagesApi.queryScheduledMessages();

      verify(() => client.post(path, data: payload)).called(1);
    });

    test('sends the channel and statuses as a plain filter', () async {
      final payload = jsonEncode({
        'filter': {
          'cid': 'messaging:general',
          'status': ['scheduled', 'failed'],
        },
        'limit': 100,
        'next': 'cursor',
      });
      when(() => client.post(path, data: payload)).thenAnswer(
        (_) async => successResponse(
          path,
          data: {
            'scheduled_messages': [scheduledMessageJson],
            'next': 'next-cursor',
          },
        ),
      );

      final res = await scheduledMessagesApi.queryScheduledMessages(
        cid: 'messaging:general',
        statuses: [ScheduledMessageStatus.scheduled, ScheduledMessageStatus.failed],
        limit: 100,
        next: 'cursor',
      );

      expect(res.scheduledMessages.single.id, 'scheduled-id');
      expect(res.next, 'next-cursor');
    });
  });

  group('updateScheduledMessage', () {
    const path = '/scheduled_messages/scheduled-id';

    test('sends the new message and time in UTC', () async {
      final message = Message(
        id: 'scheduled-id',
        text: 'Good evening @Bob',
        mentionedUsers: [User(id: 'bob')],
      );
      final scheduledAt = DateTime.utc(2026, 11, 2, 18);
      final payload = jsonEncode({
        'message': {
          ...message.toJson(),
          'mentioned_users': ['bob'],
        },
        'scheduled_at': '2026-11-02T18:00:00.000Z',
      });
      when(() => client.patch(path, data: payload)).thenAnswer(
        (_) async => successResponse(path, data: {'scheduled_message': scheduledMessageJson}),
      );

      final res = await scheduledMessagesApi.updateScheduledMessage(
        'scheduled-id',
        message: message,
        scheduledAt: scheduledAt,
      );

      expect(res.scheduledMessage.id, 'scheduled-id');
      verify(() => client.patch(path, data: payload)).called(1);
    });

    test('sends only the time when rescheduling', () async {
      final payload = jsonEncode({'scheduled_at': '2026-11-02T18:00:00.000Z'});
      when(() => client.patch(path, data: payload)).thenAnswer(
        (_) async => successResponse(path, data: {'scheduled_message': scheduledMessageJson}),
      );

      await scheduledMessagesApi.updateScheduledMessage(
        'scheduled-id',
        scheduledAt: DateTime.utc(2026, 11, 2, 18),
      );

      verify(() => client.patch(path, data: payload)).called(1);
    });
  });

  test('deleteScheduledMessage returns the canceled message', () async {
    const path = '/scheduled_messages/scheduled-id';
    when(() => client.delete(path)).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'scheduled_message': {...scheduledMessageJson, 'status': 'canceled'},
        },
      ),
    );

    final res = await scheduledMessagesApi.deleteScheduledMessage('scheduled-id');

    expect(res.scheduledMessage.status, ScheduledMessageStatus.canceled);
    verify(() => client.delete(path)).called(1);
  });

  test('sendScheduledMessageNow posts to the send now path', () async {
    const path = '/scheduled_messages/scheduled-id/send_now';
    when(() => client.post(path)).thenAnswer(
      (_) async => successResponse(path, data: {'scheduled_message': scheduledMessageJson}),
    );

    final res = await scheduledMessagesApi.sendScheduledMessageNow('scheduled-id');

    expect(res.scheduledMessage.id, 'scheduled-id');
    verify(() => client.post(path)).called(1);
  });
}

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
    'message': {'text': 'Good morning'},
    'scheduled_at': '2026-11-02T09:00:00.000Z',
    'status': 'scheduled',
    'created_at': '2026-10-29T10:00:00.000Z',
    'updated_at': '2026-10-29T10:00:00.000Z',
  };

  late final client = MockHttpClient();
  late ScheduledMessagesApi scheduledMessagesApi;

  setUp(() {
    scheduledMessagesApi = ScheduledMessagesApi(client);
    addTearDown(() => reset(client));
  });

  test('scheduleMessage sends the message with the time in UTC', () async {
    const path = '/channels/messaging/general/message';
    final message = Message(id: 'scheduled-id', text: 'Good morning');
    final payload = {
      'message': message,
      'skip_push': false,
      'skip_enrich_url': false,
      'scheduled_at': '2026-11-02T09:00:00.000Z',
    };
    when(() => client.post(path, data: payload)).thenAnswer(
      (_) async => successResponse(path, data: {'message': message.toJson()}),
    );

    await scheduledMessagesApi.scheduleMessage(
      'general',
      'messaging',
      message,
      DateTime.utc(2026, 11, 2, 9).toLocal(),
    );

    verify(() => client.post(path, data: payload)).called(1);
  });

  test('scheduleMessage reads the scheduled message', () async {
    const path = '/channels/messaging/general/message';
    final message = Message(id: 'scheduled-id', text: 'Good morning');
    when(() => client.post(path, data: any(named: 'data'))).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'message': message.toJson(),
          'scheduled_message': scheduledMessageJson,
        },
      ),
    );

    final response = await scheduledMessagesApi.scheduleMessage(
      'general',
      'messaging',
      message,
      DateTime.utc(2026, 11, 2, 9),
    );

    expect(response.scheduledMessage?.id, 'scheduled-id');
    expect(response.scheduledMessage?.scheduledAt, DateTime.utc(2026, 11, 2, 9));
  });

  test('queryScheduledMessages sends an empty filter when nothing narrows the page', () async {
    const path = '/scheduled_messages/query';
    final payload = jsonEncode({'filter': <String, dynamic>{}});
    when(() => client.post(path, data: payload)).thenAnswer(
      (_) async => successResponse(path, data: {'scheduled_messages': <Object>[]}),
    );

    await scheduledMessagesApi.queryScheduledMessages(const ScheduledMessagesQuery());

    verify(() => client.post(path, data: payload)).called(1);
  });

  test('queryScheduledMessages sends the channel and statuses as a plain filter', () async {
    const path = '/scheduled_messages/query';
    final payload = jsonEncode({
      'filter': {
        'cid': 'messaging:general',
        'status': ['scheduled', 'failed'],
      },
      'limit': 100,
      'next': 'cursor',
    });
    when(() => client.post(path, data: payload)).thenAnswer(
      (_) async => successResponse(path, data: {'scheduled_messages': <Object>[]}),
    );

    await scheduledMessagesApi.queryScheduledMessages(
      const ScheduledMessagesQuery(
        cid: 'messaging:general',
        statuses: [ScheduledMessageStatus.scheduled, ScheduledMessageStatus.failed],
        limit: 100,
        next: 'cursor',
      ),
    );

    verify(() => client.post(path, data: payload)).called(1);
  });

  test('queryScheduledMessages reads the page and the next cursor', () async {
    const path = '/scheduled_messages/query';
    when(() => client.post(path, data: any(named: 'data'))).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'scheduled_messages': [scheduledMessageJson],
          'next': 'next-cursor',
        },
      ),
    );

    final res = await scheduledMessagesApi.queryScheduledMessages(const ScheduledMessagesQuery());

    expect(res.scheduledMessages.single.id, 'scheduled-id');
    expect(res.next, 'next-cursor');
  });

  test('updateScheduledMessage sends the new message and time in UTC', () async {
    const path = '/scheduled_messages/scheduled-id';
    final message = Message(
      id: 'scheduled-id',
      text: 'Good evening @Bob',
      mentionedUsers: [User(id: 'bob')],
    );
    final scheduledAt = DateTime.utc(2026, 11, 2, 18);
    final payload = jsonEncode({
      'message': message.toJson(),
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

  test('updateScheduledMessage sends only the time when rescheduling', () async {
    const path = '/scheduled_messages/scheduled-id';
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

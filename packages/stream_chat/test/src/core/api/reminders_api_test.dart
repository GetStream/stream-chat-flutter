// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/reminders_api.dart';
import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late RemindersApi remindersApi;

  setUp(() {
    remindersApi = RemindersApi(client);
  });

  group('queryReminders', () {
    test('should query reminders without parameters', () async {
      const path = '/reminders/query';

      final reminders = [
        MessageReminder(
          messageId: 'test-message-id-1',
          channelCid: 'test-channel-cid-1',
          userId: 'test-user-id',
          remindAt: DateTime(2024, 1, 1),
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
        MessageReminder(
          messageId: 'test-message-id-2',
          channelCid: 'test-channel-cid-2',
          userId: 'test-user-id',
          remindAt: DateTime(2024, 1, 2),
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(() => client.post(path, data: jsonEncode({})))
          .thenAnswer((_) async => successResponse(path, data: {
                'reminders': reminders.map((r) => r.toJson()).toList(),
              }));

      final res = await remindersApi.queryReminders();

      expect(res, isNotNull);
      expect(res.reminders, hasLength(2));
      expect(res.reminders.first.messageId, 'test-message-id-1');

      verify(() => client.post(path, data: jsonEncode({}))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should query reminders with filter, sort, and pagination', () async {
      const path = '/reminders/query';
      final filter = Filter.equal('userId', 'test-user-id');
      const sort = [SortOption<MessageReminder>.desc('remindAt')];
      const pagination = PaginationParams(limit: 10, offset: 5);

      final expectedPayload = jsonEncode({
        'filter': filter,
        'sort': sort,
        ...pagination.toJson(),
      });

      final reminders = List.generate(
        5,
        (index) => MessageReminder(
          messageId: 'test-message-id-$index',
          channelCid: 'test-channel-cid-$index',
          userId: 'test-user-id',
          remindAt: DateTime(2024, 1, index + 1),
          createdAt: DateTime(2024, 1, index + 1),
          updatedAt: DateTime(2024, 1, index + 1),
        ),
      );

      when(() => client.post(path, data: expectedPayload))
          .thenAnswer((_) async => successResponse(path, data: {
                'reminders': reminders.map((r) => r.toJson()).toList(),
              }));

      final res = await remindersApi.queryReminders(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );

      expect(res, isNotNull);
      expect(res.reminders, hasLength(5));

      verify(() => client.post(path, data: expectedPayload)).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('createReminder', () {
    test('should create reminder without remindAt', () async {
      const messageId = 'test-message-id';
      const path = '/messages/$messageId/reminders';

      final reminder = MessageReminder(
        messageId: messageId,
        channelCid: 'test-channel-cid',
        userId: 'test-user-id',
        remindAt: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(() => client.post(path, data: jsonEncode({})))
          .thenAnswer((_) async => successResponse(path, data: {
                'reminder': reminder.toJson(),
              }));

      final res = await remindersApi.createReminder(messageId);

      expect(res, isNotNull);
      expect(res.reminder.messageId, messageId);

      verify(() => client.post(path, data: jsonEncode({}))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should create reminder with remindAt', () async {
      const messageId = 'test-message-id';
      const path = '/messages/$messageId/reminders';
      final remindAt = DateTime(2024, 6, 15, 14, 30);

      final reminder = MessageReminder(
        messageId: messageId,
        channelCid: 'test-channel-cid',
        userId: 'test-user-id',
        remindAt: remindAt,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final expectedPayload = jsonEncode({
        'remind_at': remindAt.toUtc().toIso8601String(),
      });

      when(() => client.post(path, data: expectedPayload))
          .thenAnswer((_) async => successResponse(path, data: {
                'reminder': reminder.toJson(),
              }));

      final res =
          await remindersApi.createReminder(messageId, remindAt: remindAt);

      expect(res, isNotNull);
      expect(res.reminder.messageId, messageId);
      expect(res.reminder.remindAt, remindAt);

      verify(() => client.post(path, data: expectedPayload)).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('updateReminder', () {
    test('should update reminder without remindAt', () async {
      const messageId = 'test-message-id';
      const path = '/messages/$messageId/reminders';

      final reminder = MessageReminder(
        messageId: messageId,
        channelCid: 'test-channel-cid',
        userId: 'test-user-id',
        remindAt: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      when(() => client.patch(path, data: jsonEncode({})))
          .thenAnswer((_) async => successResponse(path, data: {
                'reminder': reminder.toJson(),
              }));

      final res = await remindersApi.updateReminder(messageId);

      expect(res, isNotNull);
      expect(res.reminder.messageId, messageId);

      verify(() => client.patch(path, data: jsonEncode({}))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should update reminder with remindAt', () async {
      const messageId = 'test-message-id';
      const path = '/messages/$messageId/reminders';
      final remindAt = DateTime(2024, 8, 20, 16, 45);

      final reminder = MessageReminder(
        messageId: messageId,
        channelCid: 'test-channel-cid',
        userId: 'test-user-id',
        remindAt: remindAt,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final expectedPayload = jsonEncode({
        'remind_at': remindAt.toUtc().toIso8601String(),
      });

      when(() => client.patch(path, data: expectedPayload))
          .thenAnswer((_) async => successResponse(path, data: {
                'reminder': reminder.toJson(),
              }));

      final res =
          await remindersApi.updateReminder(messageId, remindAt: remindAt);

      expect(res, isNotNull);
      expect(res.reminder.messageId, messageId);
      expect(res.reminder.remindAt, remindAt);

      verify(() => client.patch(path, data: expectedPayload)).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('deleteReminder', () {
    test('should delete reminder', () async {
      const messageId = 'test-message-id';
      const path = '/messages/$messageId/reminders';

      when(() => client.delete(path)).thenAnswer(
          (_) async => successResponse(path, data: <String, dynamic>{}));

      final res = await remindersApi.deleteReminder(messageId);

      expect(res, isNotNull);

      verify(() => client.delete(path)).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}

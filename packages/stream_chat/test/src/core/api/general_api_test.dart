import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late GeneralApi generalApi;

  setUp(() {
    generalApi = GeneralApi(client);
  });

  test('sync', () async {
    const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
    final lastSyncAt = DateTime.now();

    const path = '/sync';

    final events =
        List.generate(3, (index) => Event(type: 'test-event-type-$index'));

    final data = {
      'channel_cids': cids,
      'last_sync_at': lastSyncAt.toUtc().toIso8601String(),
    };

    when(() => client.post(
          path,
          data: data,
        )).thenAnswer((_) async => successResponse(path, data: {
          'events': [...events.map((it) => it.toJson())]
        }));

    final res = await generalApi.sync(cids, lastSyncAt);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  group('searchMessages', () {
    test(
      'should throw if `query` and `messageFilters` is not provided',
      () async {
        final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
        try {
          await generalApi.searchMessages(filter);
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }
      },
    );

    test(
      'should throw if `query` and `messageFilters` both are provided',
      () async {
        final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
        const query = 'test-query';
        final messageFilter = Filter.query('key', 'text');
        try {
          await generalApi.searchMessages(
            filter,
            query: query,
            messageFilters: messageFilter,
          );
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }
      },
    );

    test('should run successfully with `query`', () async {
      final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
      const query = 'test-query';
      const sort = [SortOption<ChannelModel>('test-field')];
      const pagination = PaginationParams();

      const path = '/search';

      final payload = jsonEncode({
        'filter_conditions': filter,
        'sort': sort,
        'query': query,
        ...pagination.toJson(),
      });

      when(
        () => client.get(
          path,
          queryParameters: {
            'payload': payload,
          },
        ),
      ).thenAnswer((_) async => successResponse(path, data: {'results': []}));

      final res = await generalApi.searchMessages(
        filter,
        query: query,
        sort: sort,
        pagination: pagination,
      );

      expect(res, isNotNull);
      expect(res.results, isEmpty);

      verify(
        () => client.get(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should run successfully with `messageFilter`', () async {
      final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
      const sort = [SortOption<ChannelModel>('test-field')];
      final messageFilter = Filter.query('key', 'text');
      const pagination = PaginationParams();

      const path = '/search';

      final payload = jsonEncode({
        'filter_conditions': filter,
        'sort': sort,
        'message_filter_conditions': messageFilter,
        ...pagination.toJson(),
      });

      when(
        () => client.get(
          path,
          queryParameters: {
            'payload': payload,
          },
        ),
      ).thenAnswer((_) async => successResponse(path, data: {'results': []}));

      final res = await generalApi.searchMessages(
        filter,
        messageFilters: messageFilter,
        sort: sort,
        pagination: pagination,
      );

      expect(res, isNotNull);
      expect(res.results, isEmpty);

      verify(
        () => client.get(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('queryMembers', () {
    test('with `channelId`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
      const pagination = PaginationParams();
      const sort = [SortOption('test-field')];

      const path = '/members';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id=$index'),
      );

      final payload = jsonEncode({
        'type': channelType,
        'filter_conditions': filter,
        'id': channelId,
        'sort': sort,
        ...pagination.toJson(),
      });

      when(() => client.get(
            path,
            queryParameters: {
              'payload': payload,
            },
          )).thenAnswer((_) async => successResponse(path, data: {
            'members': [...members.map((it) => it.toJson())]
          }));

      final res = await generalApi.queryMembers(
        channelType,
        channelId: channelId,
        filter: filter,
        pagination: pagination,
        sort: sort,
      );

      expect(res, isNotNull);
      expect(res.members.length, members.length);

      verify(
        () => client.get(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('with `members`', () async {
      const channelType = 'test-channel-type';
      final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
      const pagination = PaginationParams();
      const sort = [SortOption('test-field')];

      const path = '/members';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id=$index'),
      );

      final payload = jsonEncode({
        'type': channelType,
        'filter_conditions': filter,
        'members': members,
        'sort': sort,
        ...pagination.toJson(),
      });

      when(() => client.get(
            path,
            queryParameters: {
              'payload': payload,
            },
          )).thenAnswer((_) async => successResponse(path, data: {
            'members': [...members.map((it) => it.toJson())]
          }));

      final res = await generalApi.queryMembers(
        channelType,
        filter: filter,
        pagination: pagination,
        sort: sort,
        members: members,
      );

      expect(res, isNotNull);
      expect(res.members.length, members.length);

      verify(
        () => client.get(path, queryParameters: any(named: 'queryParameters')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}

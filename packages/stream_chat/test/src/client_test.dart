import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat/src/api/requests.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/exceptions.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/user.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements DioForNative {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

class Functions {
  Future<String> tokenProvider(String userId) => null;
}

class MockFunctions extends Mock implements Functions {}

void main() {
  group('src/client', () {
    group('constructor', () {
      final List<String> log = [];

      overridePrint(testFn()) => () {
            log.clear();
            final spec = ZoneSpecification(print: (_, __, ___, String msg) {
              // Add to log instead of printing to stdout
              log.add(msg);
            });
            return Zone.current.fork(specification: spec).run(testFn);
          };

      tearDown(() {
        log.clear();
      });

      test('should create the object correctly', () {
        final client = StreamChatClient('api-key');

        expect(client.baseURL, 'chat-us-east-1.stream-io-api.com');
        expect(client.apiKey, 'api-key');
        expect(client.logLevel, Level.WARNING);
        expect(client.httpClient.options.connectTimeout, 6000);
        expect(client.httpClient.options.receiveTimeout, 6000);
      });

      test('should create the object correctly', overridePrint(() {
        final LogHandlerFunction logHandler = (LogRecord record) {
          print(record.message);
        };

        final client = StreamChatClient(
          'api-key',
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 12),
          logLevel: Level.INFO,
          baseURL: 'test.com',
          logHandlerFunction: logHandler,
        );

        expect(client.baseURL, 'test.com');
        expect(client.apiKey, 'api-key');
        expect(Logger.root.level, Level.INFO);
        expect(client.httpClient.options.connectTimeout, 10000);
        expect(client.httpClient.options.receiveTimeout, 12000);

        client.logger.warning('test');
        client.logger.config('test config');

        expect([log[log.length - 2], log[log.length - 1]],
            ['instantiating new client', 'test']);
      }));

      test('Channel', () {
        final client = StreamChatClient('test');
        final Map<String, dynamic> data = {'test': 1};
        final channelClient = client.channel('type', id: 'id', extraData: data);
        expect(channelClient.type, 'type');
        expect(channelClient.id, 'id');
      });
    });

    group('queryChannels', () {
      test('should pass right default parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final queryParams = {
          'payload': json.encode({
            "filter_conditions": null,
            "sort": null,
            "state": true,
            "watch": true,
            "presence": false,
            "limit": 10,
          }),
        };

        when(mockDio.get<String>('/channels', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.queryChannels(waitForConnect: false);

        verify(mockDio.get<String>('/channels', queryParameters: queryParams))
            .called(1);
      });

      test('should pass right parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final queryFilter = <String, dynamic>{
          "id": {
            "\$in": ["test"],
          },
        };
        final sortOptions = <SortOption>[];
        final options = {"state": false, "watch": false, "presence": true};
        final paginationParams = PaginationParams(
          limit: 10,
          offset: 2,
        );

        final queryParams = {
          'payload': json.encode({
            "filter_conditions": queryFilter,
            "sort": sortOptions,
          }
            ..addAll(options)
            ..addAll(paginationParams.toJson())),
        };

        when(mockDio.get<String>('/channels', queryParameters: queryParams))
            .thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.queryChannels(
          filter: queryFilter,
          sort: sortOptions,
          options: options,
          paginationParams: paginationParams,
          waitForConnect: false,
        );

        verify(mockDio.get<String>('/channels', queryParameters: queryParams))
            .called(1);
      });
    });

    group('search', () {
      test('should pass right default parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final filter = {
          'cid': {
            r'$in': ['messaging:testId']
          }
        };

        final query = 'hello';

        final queryParams = {
          'payload': json.encode({
            'filter_conditions': filter,
            'query': query,
          }),
        };

        when(mockDio.get<String>('/search', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.search(filter, query: query);

        verify(mockDio.get<String>('/search', queryParameters: queryParams))
            .called(1);
      });

      test('should pass right parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final filters = {
          "id": {
            "\$in": ["test"],
          },
        };
        final sortOptions = [SortOption('name')];
        final query = 'query';

        final queryParams = {
          'payload': json.encode({
            'filter_conditions': filters,
            'query': query,
            'sort': sortOptions,
            'limit': 10,
          }),
        };

        when(mockDio.get<String>('/search', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.search(
          filters,
          sort: sortOptions,
          query: query,
          paginationParams: PaginationParams(),
        );

        verify(mockDio.get<String>('/search', queryParameters: queryParams))
            .called(1);
      });
    });

    group('devices', () {
      test('addDevice', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/devices', data: {
          'id': 'test-id',
          'push_provider': 'firebase',
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.addDevice('test-id', PushProvider.firebase);

        verify(
          mockDio.post<String>(
            '/devices',
            data: {'id': 'test-id', 'push_provider': 'firebase'},
          ),
        ).called(1);
      });

      test('getDevices', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.get<String>('/devices'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.getDevices();

        verify(mockDio.get<String>('/devices')).called(1);
      });

      test('removeDevice', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio
                .delete<String>('/devices', queryParameters: {'id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.removeDevice('test-id');

        verify(mockDio.delete<String>('/devices',
            queryParameters: {'id': 'test-id'})).called(1);
      });
    });

    test('devToken', () {
      final client = StreamChatClient('api-key');
      final token = client.devToken('test');

      expect(
        token,
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.devtoken',
      );
    });

    group('queryUsers', () {
      test('should pass right default parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final queryParams = {
          'payload': json.encode({
            "filter_conditions": {},
            "sort": null,
            "presence": false,
          }),
        };

        when(mockDio.get<String>('/users', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.queryUsers();

        verify(mockDio.get<String>('/users', queryParameters: queryParams))
            .called(1);
      });

      test('should pass right parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final Map<String, dynamic> queryFilter = {
          "id": {
            "\$in": ["test"],
          },
        };
        final List<SortOption> sortOptions = [];
        final options = {"presence": true};

        final Map<String, dynamic> queryParams = {
          'payload': json.encode({
            "filter_conditions": queryFilter,
            "sort": sortOptions,
          }..addAll(options)),
        };

        when(mockDio.get<String>('/users', queryParameters: queryParams))
            .thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.queryUsers(
          filter: queryFilter,
          sort: sortOptions,
          options: options,
        );

        verify(mockDio.get<String>('/users', queryParameters: queryParams))
            .called(1);
      });
    });

    group('user', () {
      test('connectUser should throw exception', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/moderation/flag',
                data: {'target_user_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.flagUser('test-id');

        verify(mockDio.post<String>('/moderation/flag',
            data: {'target_user_id': 'test-id'})).called(1);
      });

      test('flagUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        expect(() => client.connectUserWithProvider(User(id: 'test-id')),
            throwsA(isA<Exception>()));
      });

      test('unflagUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/moderation/unflag',
                data: {'target_user_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.unflagUser('test-id');

        verify(mockDio.post<String>('/moderation/unflag',
            data: {'target_user_id': 'test-id'})).called(1);
      });

      test('updateUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final user = User(id: 'test-id');

        final data = {
          'users': {user.id: user.toJson()},
        };

        when(mockDio.post<String>('/users', data: data))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.updateUser(user);

        verify(mockDio.post<String>('/users', data: data)).called(1);
      });

      test('updateUsers', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final user = User(id: 'test-id');
        final user2 = User(id: 'test-id2');

        final data = {
          'users': {
            user.id: user.toJson(),
            user2.id: user2.toJson(),
          },
        };

        when(mockDio.post<String>('/users', data: data))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.updateUsers([user, user2]);

        verify(mockDio.post<String>('/users', data: data)).called(1);
      });

      test('banUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/moderation/ban',
                data: {'test': true, 'target_user_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.banUser('test-id', {'test': true});

        verify(mockDio.post<String>('/moderation/ban',
            data: {'test': true, 'target_user_id': 'test-id'})).called(1);
      });

      test('unbanUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.delete<String>('/moderation/ban',
                queryParameters: {'test': true, 'target_user_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.unbanUser('test-id', {'test': true});

        verify(mockDio.delete<String>('/moderation/ban',
                queryParameters: {'test': true, 'target_user_id': 'test-id'}))
            .called(1);
      });

      test('muteUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/moderation/mute',
                data: {'target_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.muteUser('test-id');

        verify(mockDio.post<String>('/moderation/mute',
            data: {'target_id': 'test-id'})).called(1);
      });

      test('unmuteUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/moderation/unmute',
                data: {'target_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.unmuteUser('test-id');

        verify(mockDio.post<String>('/moderation/unmute',
            data: {'target_id': 'test-id'})).called(1);
      });
    });

    group('message', () {
      test('flagMessage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/moderation/flag',
                data: {'target_message_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.flagMessage('test-id');

        verify(mockDio.post<String>('/moderation/flag',
            data: {'target_message_id': 'test-id'})).called(1);
      });

      test('unflagMessage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/moderation/unflag',
                data: {'target_message_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.unflagMessage('test-id');

        verify(mockDio.post<String>('/moderation/unflag',
            data: {'target_message_id': 'test-id'})).called(1);
      });

      test('updateMessage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final message = Message(
          id: 'test',
          updatedAt: DateTime.now(),
        );

        when(mockDio.post<String>(
          '/messages/${message.id}',
          data: {'message': anything},
        )).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.updateMessage(message);

        verify(mockDio.post<String>('/messages/${message.id}',
            data: {'message': anything})).called(1);
      });

      test('deleteMessage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final messageId = 'test';

        when(mockDio.delete<String>('/messages/$messageId'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.deleteMessage(Message(id: messageId));

        verify(mockDio.delete<String>('/messages/$messageId')).called(1);
      });

      test('getMessage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final messageId = 'test';

        when(mockDio.get<String>('/messages/$messageId'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.getMessage(messageId);

        verify(mockDio.get<String>('/messages/$messageId')).called(1);
      });

      test('markAllRead', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        when(mockDio.post<String>('/channels/read'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.markAllRead();

        verify(mockDio.post<String>('/channels/read')).called(1);
      });
    });

    group('api methods', () {
      group('get', () {
        test('should put the correct parameters', () async {
          final mockDio = MockDio();

          when(mockDio.options).thenReturn(BaseOptions());
          when(mockDio.interceptors).thenReturn(Interceptors());

          final client = StreamChatClient(
            'api-key',
            httpClient: mockDio,
          );

          final Map<String, dynamic> queryParams = {
            'test': 1,
          };

          when(mockDio.get<String>('/test', queryParameters: queryParams))
              .thenAnswer((_) async {
            return Response(data: '{}', statusCode: 200);
          });

          await client.get('/test', queryParameters: queryParams);

          verify(mockDio.get<String>('/test', queryParameters: queryParams))
              .called(1);
        });

        test('should catch the error', () async {
          final dioHttp = Dio();
          final mockHttpClientAdapter = MockHttpClientAdapter();
          dioHttp.httpClientAdapter = mockHttpClientAdapter;

          final client = StreamChatClient(
            'api-key',
            httpClient: dioHttp,
          );

          when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
              (_) async => ResponseBody.fromString('test error', 400));

          expect(client.get('/test'), throwsA(ApiError('test error', 400)));
        });
      });

      group('post', () {
        test('should put the correct parameters', () async {
          final mockDio = MockDio();

          when(mockDio.options).thenReturn(BaseOptions());
          when(mockDio.interceptors).thenReturn(Interceptors());

          final client = StreamChatClient(
            'api-key',
            httpClient: mockDio,
          );

          final Map<String, dynamic> data = {
            'test': 1,
          };

          when(mockDio.post<String>('/test', data: data)).thenAnswer((_) async {
            return Response(data: '{}', statusCode: 200);
          });

          await client.post('/test', data: data);

          verify(mockDio.post<String>('/test', data: data)).called(1);
        });

        test('should catch the error', () async {
          final dioHttp = Dio();
          final mockHttpClientAdapter = MockHttpClientAdapter();
          dioHttp.httpClientAdapter = mockHttpClientAdapter;

          final client = StreamChatClient(
            'api-key',
            httpClient: dioHttp,
          );

          when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
              (_) async => ResponseBody.fromString('test error', 400));

          expect(client.post('/test'), throwsA(ApiError('test error', 400)));
        });
      });

      group('put', () {
        test('should put the correct parameters', () async {
          final mockDio = MockDio();

          when(mockDio.options).thenReturn(BaseOptions());
          when(mockDio.interceptors).thenReturn(Interceptors());

          final client = StreamChatClient(
            'api-key',
            httpClient: mockDio,
          );

          final Map<String, dynamic> data = {
            'test': 1,
          };

          when(mockDio.put<String>('/test', data: data)).thenAnswer((_) async {
            return Response(data: '{}', statusCode: 200);
          });

          await client.put('/test', data: data);

          verify(mockDio.put<String>('/test', data: data)).called(1);
        });

        test('should catch the error', () async {
          final dioHttp = Dio();
          final mockHttpClientAdapter = MockHttpClientAdapter();
          dioHttp.httpClientAdapter = mockHttpClientAdapter;

          final client = StreamChatClient(
            'api-key',
            httpClient: dioHttp,
          );

          when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
              (_) async => ResponseBody.fromString('test error', 400));

          expect(client.put('/test'), throwsA(ApiError('test error', 400)));
        });
      });

      group('patch', () {
        test('should put the correct parameters', () async {
          final mockDio = MockDio();

          when(mockDio.options).thenReturn(BaseOptions());
          when(mockDio.interceptors).thenReturn(Interceptors());

          final client = StreamChatClient(
            'api-key',
            httpClient: mockDio,
          );

          final Map<String, dynamic> data = {
            'test': 1,
          };

          when(mockDio.patch<String>('/test', data: data))
              .thenAnswer((_) async {
            return Response(data: '{}', statusCode: 200);
          });

          await client.patch('/test', data: data);

          verify(mockDio.patch<String>('/test', data: data)).called(1);
        });

        test('should catch the error', () async {
          final dioHttp = Dio();
          final mockHttpClientAdapter = MockHttpClientAdapter();
          dioHttp.httpClientAdapter = mockHttpClientAdapter;

          final client = StreamChatClient(
            'api-key',
            httpClient: dioHttp,
          );

          when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
              (_) async => ResponseBody.fromString('test error', 400));

          expect(client.patch('/test'), throwsA(ApiError('test error', 400)));
        });
      });

      group('delete', () {
        test('should put the correct parameters', () async {
          final mockDio = MockDio();

          when(mockDio.options).thenReturn(BaseOptions());
          when(mockDio.interceptors).thenReturn(Interceptors());

          final client = StreamChatClient(
            'api-key',
            httpClient: mockDio,
          );

          final Map<String, dynamic> queryParams = {
            'test': 1,
          };

          when(mockDio.delete<String>('/test', queryParameters: queryParams))
              .thenAnswer((_) async {
            return Response(data: '{}', statusCode: 200);
          });

          await client.delete('/test', queryParameters: queryParams);

          verify(mockDio.delete<String>('/test', queryParameters: queryParams))
              .called(1);
        });

        test('should catch the error', () async {
          final dioHttp = Dio();
          final mockHttpClientAdapter = MockHttpClientAdapter();
          dioHttp.httpClientAdapter = mockHttpClientAdapter;

          final client = StreamChatClient(
            'api-key',
            httpClient: dioHttp,
          );

          when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
              (_) async => ResponseBody.fromString('test error', 400));

          expect(client.delete('/test'), throwsA(ApiError('test error', 400)));
        });
      });

      group('pin message', () {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        test('should throw argument error', () {
          final message = Message(text: 'Hello');
          expect(
            () => client.pinMessage(message, 'InvalidType'),
            throwsArgumentError,
          );
        });

        test('should complete successfully', () async {
          final timeout = 30;
          final message = Message(text: 'Hello');

          when(mockDio.post<String>(
            '/messages/${message.id}',
            data: anything,
          )).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

          await client.pinMessage(message, timeout);

          verify(mockDio.post<String>('/messages/${message.id}',
              data: {'message': anything})).called(1);
        });

        test('should unpin message successfully', () async {
          final message = Message(text: 'Hello');

          when(mockDio.post<String>(
            '/messages/${message.id}',
            data: anything,
          )).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

          await client.unpinMessage(message);

          verify(mockDio.post<String>('/messages/${message.id}',
                  data: anything))
              .called(1);
        });
      });
    });

    group('channel', () {
      test('should update channel', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
        );

        final channelClient =
            client.channel('type', id: 'id', extraData: {'name': 'init'});

        var update = {
          'set': {'name': 'demo'}
        };

        when(mockDio.patch<String>(
          '/channels/${channelClient.type}/${channelClient.id}',
          data: update,
        )).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.updatePartial(update);
        verify(mockDio.patch<String>(
                '/channels/${channelClient.type}/${channelClient.id}',
                data: update))
            .called(1);
      });
    });
  });
}

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/api/requests.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/reaction.dart';
import 'package:stream_chat/src/models/own_user.dart';
import 'package:test/test.dart';

import 'package:stream_chat/stream_chat.dart';

class MockDio extends Mock implements DioForNative {}

class FakeRequestOptions extends Fake implements RequestOptions {}

class MockAttachmentUploader extends Mock implements AttachmentFileUploader {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

void main() {
  group('src/api/channel', () {
    group('message', () {
      test('sendMessage', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final message = Message(text: 'hey', id: 'test');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid/message',
            data: {'message': message.toJson()},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.sendMessage(message);

        verify(() =>
            mockDio.post<String>('/channels/messaging/testid/message', data: {
              'message': message.toJson(),
            })).called(1);
      });

      test('markRead', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );

        final channelClient = client.channel('messaging', id: 'testid');

        when(() => mockDio.post<String>(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              data: '{}',
              statusCode: 200,
              requestOptions: FakeRequestOptions(),
            ));
        await channelClient.watch();

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid/read',
            data: {},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.markRead();

        verify(() => mockDio.post<String>('/channels/messaging/testid/read',
            data: {})).called(1);
      });

      test('getReplies', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        const pagination = PaginationParams();

        when(() => mockDio.get<String>('/messages/messageid/replies',
            queryParameters: pagination.toJson())).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.getReplies('messageid', pagination);

        verify(() => mockDio.get<String>('/messages/messageid/replies',
            queryParameters: pagination.toJson())).called(1);
      });

      test('sendAction', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(() => mockDio.post<String>(
              any(),
              data: any(named: 'data'),
            )).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );
        await channelClient.watch();

        final data = <String, dynamic>{'test': true};

        when(() => mockDio.post<String>('/messages/messageid/action', data: {
              'id': 'testid',
              'type': 'messaging',
              'form_data': data,
              'message_id': 'messageid',
            })).thenAnswer((_) async => Response(
              data: '{}',
              statusCode: 200,
              requestOptions: FakeRequestOptions(),
            ));

        await channelClient.sendAction(Message(id: 'messageid'), data);

        verify(() => mockDio.post<String>('/messages/messageid/action', data: {
              'id': 'testid',
              'type': 'messaging',
              'form_data': data,
              'message_id': 'messageid',
            })).called(1);
      });

      test('getMessagesById', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final messageIds = ['a', 'b'];

        when(() => mockDio.get<String>('/channels/messaging/testid/messages',
            queryParameters: {'ids': messageIds.join(',')})).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.getMessagesById(messageIds);

        verify(() => mockDio.get<String>('/channels/messaging/testid/messages',
            queryParameters: {'ids': messageIds.join(',')})).called(1);
      });

      test('sendFile', () async {
        final mockDio = MockDio();
        final mockUploader = MockAttachmentUploader();

        const file = AttachmentFile(path: 'filePath/fileName.pdf');
        const channelId = 'testId';
        const channelType = 'messaging';

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
          attachmentFileUploader: mockUploader,
        );
        final channelClient = client.channel(channelType, id: channelId);

        when(() => mockUploader.sendFile(file, channelId, channelType))
            .thenAnswer((_) async => SendFileResponse());

        await channelClient.sendFile(file);

        verify(() => mockUploader.sendFile(file, channelId, channelType))
            .called(1);
      });

      test('sendImage', () async {
        final mockDio = MockDio();
        final mockUploader = MockAttachmentUploader();

        const image = AttachmentFile(path: 'imagePath/imageName.jpeg');
        const channelId = 'testId';
        const channelType = 'messaging';

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
          attachmentFileUploader: mockUploader,
        );
        final channelClient = client.channel(channelType, id: channelId);

        when(() => mockUploader.sendImage(image, channelId, channelType))
            .thenAnswer((_) async => SendImageResponse());

        await channelClient.sendImage(image);

        verify(() => mockUploader.sendImage(image, channelId, channelType))
            .called(1);
      });

      test('deleteFile', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        const url = 'url';

        when(
          () => mockDio.delete<String>(
            '/channels/messaging/testid/file',
            queryParameters: {'url': url},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.deleteFile(url);

        verify(() => mockDio.delete<String>('/channels/messaging/testid/file',
            queryParameters: {'url': url})).called(1);
      });

      test('deleteImage', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        const url = 'url';

        when(
          () => mockDio.delete<String>(
            '/channels/messaging/testid/image',
            queryParameters: {'url': url},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.deleteImage(url);

        verify(() => mockDio.delete<String>('/channels/messaging/testid/image',
            queryParameters: {'url': url})).called(1);
      });

      test('pinMessage should throw argument error', () {
        final client = StreamChatClient('api-key');

        final channelClient = client.channel('messaging', id: 'testid');

        final message = Message(text: 'Hello');

        expect(
          () => channelClient.pinMessage(message, 'InvalidType'),
          throwsArgumentError,
        );
      });

      test('should be pinned successfully', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final message = Message(text: 'Hello', id: 'test');

        when(
          () => mockDio.post<String>(
            '/messages/${message.id}',
            data: anything,
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.pinMessage(message, 30);

        verify(() =>
                mockDio.post<String>('/messages/${message.id}', data: anything))
            .called(1);
      });

      test('should be unpinned successfully', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final message = Message(text: 'Hello', id: 'test');

        when(
          () => mockDio.post<String>(
            '/messages/${message.id}',
            data: anything,
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.unpinMessage(message);

        verify(() =>
                mockDio.post<String>('/messages/${message.id}', data: anything))
            .called(1);
      });
    });

    test('sendEvent', () async {
      final mockDio = MockDio();

      when(() => mockDio.options).thenReturn(BaseOptions());
      when(() => mockDio.interceptors).thenReturn(Interceptors());

      final client = StreamChatClient(
        'api-key',
        httpClient: mockDio,
        tokenProvider: (_) async => '',
      );
      final channelClient = client.channel('messaging', id: 'testid');

      when(
        () => mockDio.post<String>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: '{}',
          statusCode: 200,
          requestOptions: FakeRequestOptions(),
        ),
      );
      await channelClient.watch();

      final event = Event(type: EventType.any);

      when(
        () => mockDio.post<String>(
          '/channels/messaging/testid/event',
          data: {'event': event.toJson()},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: '{}',
          statusCode: 200,
          requestOptions: FakeRequestOptions(),
        ),
      );

      await channelClient.sendEvent(event);

      verify(() => mockDio.post<String>('/channels/messaging/testid/event',
          data: {'event': event.toJson()})).called(1);
    });

    test('keyStroke', () async {
      final mockDio = MockDio();

      when(() => mockDio.options).thenReturn(BaseOptions());
      when(() => mockDio.interceptors).thenReturn(Interceptors());

      final client = StreamChatClient(
        'api-key',
        httpClient: mockDio,
        tokenProvider: (_) async => '',
      );
      final channelClient = client.channel('messaging', id: 'testid');

      when(
        () => mockDio.post<String>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: '{}',
          statusCode: 200,
          requestOptions: FakeRequestOptions(),
        ),
      );
      await channelClient.watch();

      final event = Event(type: EventType.typingStart);

      when(
        () => mockDio.post<String>(
          '/channels/messaging/testid/event',
          data: {'event': event.toJson()},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: '{}',
          statusCode: 200,
          requestOptions: FakeRequestOptions(),
        ),
      );

      await channelClient.keyStroke();

      verify(() => mockDio.post<String>('/channels/messaging/testid/event',
          data: {'event': event.toJson()})).called(1);
    });

    test('stopTyping', () async {
      final mockDio = MockDio();

      when(() => mockDio.options).thenReturn(BaseOptions());
      when(() => mockDio.interceptors).thenReturn(Interceptors());

      final client = StreamChatClient(
        'api-key',
        httpClient: mockDio,
        tokenProvider: (_) async => '',
      );
      final channelClient = client.channel('messaging', id: 'testid');

      when(() => mockDio.post<String>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          data: '{}',
          statusCode: 200,
          requestOptions: FakeRequestOptions(),
        ),
      );
      await channelClient.watch();

      final event = Event(type: EventType.typingStop);

      when(
        () => mockDio.post<String>(
          '/channels/messaging/testid/event',
          data: {'event': event.toJson()},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: '{}',
          statusCode: 200,
          requestOptions: FakeRequestOptions(),
        ),
      );

      await channelClient.stopTyping();

      verify(() => mockDio.post<String>('/channels/messaging/testid/event',
          data: {'event': event.toJson()})).called(1);
    });

    group('reactions', () {
      test('sendReaction', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        )..state.user = OwnUser(id: 'test-id');

        final channelClient = client.channel('messaging', id: 'testid');
        const reactionType = 'test';

        when(
          () => mockDio.post<String>(
            '/messages/messageid/reaction',
            data: {
              'reaction': {
                'type': reactionType,
              },
              'enforce_unique': false,
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.sendReaction(
          Message(
            id: 'messageid',
            reactionCounts: const <String, int>{},
            reactionScores: const <String, int>{},
            latestReactions: const <Reaction>[],
            ownReactions: const <Reaction>[],
          ),
          reactionType,
        );

        verify(
            () => mockDio.post<String>('/messages/messageid/reaction', data: {
                  'reaction': {
                    'type': reactionType,
                  },
                  'enforce_unique': false,
                })).called(1);
      });

      test('deleteReaction', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        )..state.user = OwnUser(id: 'test-id');

        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.delete<String>('/messages/messageid/reaction/test'),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.deleteReaction(
          Message(
            id: 'messageid',
            reactionCounts: const <String, int>{},
            reactionScores: const <String, int>{},
            latestReactions: const <Reaction>[],
            ownReactions: const <Reaction>[],
          ),
          Reaction(type: 'test'),
        );

        verify(() =>
                mockDio.delete<String>('/messages/messageid/reaction/test'))
            .called(1);
      });

      test('getReactions', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        const pagination = PaginationParams();

        when(
          () => mockDio.get<String>(
            '/messages/messageid/reactions',
            queryParameters: pagination.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.getReactions('messageid', pagination);

        verify(() => mockDio.get<String>('/messages/messageid/reactions',
            queryParameters: pagination.toJson())).called(1);
      });
    });

    group('channel', () {
      test('addMembers', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final members = ['vishal'];
        final message = Message(text: 'test');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid',
            data: {'add_members': members, 'message': message.toJson()},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.addMembers(members, message);

        verify(() => mockDio.post<String>('/channels/messaging/testid',
                data: {'add_members': members, 'message': message.toJson()}))
            .called(1);
      });

      test('acceptInvite', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final message = Message(text: 'test');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid',
            data: {'accept_invite': true, 'message': message.toJson()},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.acceptInvite(message);

        verify(() => mockDio.post<String>('/channels/messaging/testid',
                data: {'accept_invite': true, 'message': message.toJson()}))
            .called(1);
      });

      group('query', () {
        test('without id', () async {
          final mockDio = MockDio();

          when(() => mockDio.options).thenReturn(BaseOptions());
          when(() => mockDio.interceptors).thenReturn(Interceptors());

          final client = StreamChatClient(
            'api-key',
            httpClient: mockDio,
            tokenProvider: (_) async => '',
          );
          final channelClient = client.channel('messaging');
          final options = <String, dynamic>{
            'watch': true,
            'state': false,
            'presence': true,
          };

          when(() => mockDio.post<String>('/channels/messaging/query',
              data: options)).thenAnswer(
            (_) async => Response(
              data: r'''
            {
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
            "messages": [
                {
                    "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                            "user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                            "user": {
                                "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.83015Z",
                                "updated_at": "2020-01-28T22:17:31.19435Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/2.jpg",
                                "name": "Mia Denys"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.128376Z",
                            "updated_at": "2020-01-28T22:17:31.128376Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.107978Z",
                    "updated_at": "2020-01-28T22:17:31.130506Z",
                    "mentioned_users": []
                },
                {
                    "id": "16e19c46-fb96-4f89-8031-d5bd2ce3bd64",
                    "text": "Few can name a topfull mother that isn't a breezeless damage.",
                    "html": "\u003cp\u003eFew can name a topfull mother that isn’t a breezeless damage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.153518Z",
                    "updated_at": "2020-01-28T22:17:31.153518Z",
                    "mentioned_users": []
                },
                {
                    "id": "38b1b252-c9a6-4aea-a39e-8de3b7f7604b",
                    "text": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "Moustache Thumbs Up GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "text": "Discover \u0026 share this Pouce Leve GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.155428Z",
                    "updated_at": "2020-01-28T22:17:31.155428Z",
                    "mentioned_users": []
                },
                {
                    "id": "5c7d0c68-72d5-4027-b6b7-711b342d0fc4",
                    "text": "The carbons could be said to resemble smartish hoods.",
                    "html": "\u003cp\u003eThe carbons could be said to resemble smartish hoods.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.157811Z",
                    "updated_at": "2020-01-28T22:17:31.157811Z",
                    "mentioned_users": []
                },
                {
                    "id": "5b02535a-0c3c-45fa-9cf8-16f840c5123f",
                    "text": "Their software was, in this moment, a prolix feature.",
                    "html": "\u003cp\u003eTheir software was, in this moment, a prolix feature.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.158391Z",
                    "updated_at": "2020-01-28T22:17:31.158391Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "last_read": "2020-01-28T22:17:31.016937728Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "last_read": "2020-01-28T22:17:31.018856448Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ]
        }
            ''',
              statusCode: 200,
              requestOptions: FakeRequestOptions(),
            ),
          );

          final response = await channelClient.query(options: options);

          verify(() => mockDio.post<String>('/channels/messaging/query',
              data: options)).called(1);
          expect(channelClient.id, response.channel.id);
          expect(channelClient.cid, response.channel.cid);
        });

        test('with id', () async {
          final mockDio = MockDio();

          when(() => mockDio.options).thenReturn(BaseOptions());
          when(() => mockDio.interceptors).thenReturn(Interceptors());

          final client = StreamChatClient(
            'api-key',
            httpClient: mockDio,
            tokenProvider: (_) async => '',
          );
          final channelClient = client.channel('messaging', id: 'testid');
          final options = <String, dynamic>{'state': false};

          when(() => mockDio.post<String>('/channels/messaging/testid/query',
              data: options)).thenAnswer(
            (_) async => Response(
              data: r'''
            {
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
            "messages": [
                {
                    "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                            "user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                            "user": {
                                "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.83015Z",
                                "updated_at": "2020-01-28T22:17:31.19435Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/2.jpg",
                                "name": "Mia Denys"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.128376Z",
                            "updated_at": "2020-01-28T22:17:31.128376Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.107978Z",
                    "updated_at": "2020-01-28T22:17:31.130506Z",
                    "mentioned_users": []
                },
                {
                    "id": "16e19c46-fb96-4f89-8031-d5bd2ce3bd64",
                    "text": "Few can name a topfull mother that isn't a breezeless damage.",
                    "html": "\u003cp\u003eFew can name a topfull mother that isn’t a breezeless damage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.153518Z",
                    "updated_at": "2020-01-28T22:17:31.153518Z",
                    "mentioned_users": []
                },
                {
                    "id": "38b1b252-c9a6-4aea-a39e-8de3b7f7604b",
                    "text": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "Moustache Thumbs Up GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "text": "Discover \u0026 share this Pouce Leve GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.155428Z",
                    "updated_at": "2020-01-28T22:17:31.155428Z",
                    "mentioned_users": []
                },
                {
                    "id": "5c7d0c68-72d5-4027-b6b7-711b342d0fc4",
                    "text": "The carbons could be said to resemble smartish hoods.",
                    "html": "\u003cp\u003eThe carbons could be said to resemble smartish hoods.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.157811Z",
                    "updated_at": "2020-01-28T22:17:31.157811Z",
                    "mentioned_users": []
                },
                {
                    "id": "5b02535a-0c3c-45fa-9cf8-16f840c5123f",
                    "text": "Their software was, in this moment, a prolix feature.",
                    "html": "\u003cp\u003eTheir software was, in this moment, a prolix feature.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.158391Z",
                    "updated_at": "2020-01-28T22:17:31.158391Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "last_read": "2020-01-28T22:17:31.016937728Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "last_read": "2020-01-28T22:17:31.018856448Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ]
        }
            ''',
              statusCode: 200,
              requestOptions: FakeRequestOptions(),
            ),
          );

          await channelClient.query(options: options);

          verify(() => mockDio.post<String>('/channels/messaging/testid/query',
              data: options)).called(1);
        });
      });

      test('create', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging');
        final options = <String, dynamic>{
          'watch': false,
          'state': false,
          'presence': false,
        };

        when(() => mockDio.post<String>('/channels/messaging/query',
            data: options)).thenAnswer(
          (_) async => Response(
            data: r'''
            {
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
            "messages": [
                {
                    "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                            "user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                            "user": {
                                "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.83015Z",
                                "updated_at": "2020-01-28T22:17:31.19435Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/2.jpg",
                                "name": "Mia Denys"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.128376Z",
                            "updated_at": "2020-01-28T22:17:31.128376Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.107978Z",
                    "updated_at": "2020-01-28T22:17:31.130506Z",
                    "mentioned_users": []
                },
                {
                    "id": "16e19c46-fb96-4f89-8031-d5bd2ce3bd64",
                    "text": "Few can name a topfull mother that isn't a breezeless damage.",
                    "html": "\u003cp\u003eFew can name a topfull mother that isn’t a breezeless damage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.153518Z",
                    "updated_at": "2020-01-28T22:17:31.153518Z",
                    "mentioned_users": []
                },
                {
                    "id": "38b1b252-c9a6-4aea-a39e-8de3b7f7604b",
                    "text": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "Moustache Thumbs Up GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "text": "Discover \u0026 share this Pouce Leve GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.155428Z",
                    "updated_at": "2020-01-28T22:17:31.155428Z",
                    "mentioned_users": []
                },
                {
                    "id": "5c7d0c68-72d5-4027-b6b7-711b342d0fc4",
                    "text": "The carbons could be said to resemble smartish hoods.",
                    "html": "\u003cp\u003eThe carbons could be said to resemble smartish hoods.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.157811Z",
                    "updated_at": "2020-01-28T22:17:31.157811Z",
                    "mentioned_users": []
                },
                {
                    "id": "5b02535a-0c3c-45fa-9cf8-16f840c5123f",
                    "text": "Their software was, in this moment, a prolix feature.",
                    "html": "\u003cp\u003eTheir software was, in this moment, a prolix feature.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.158391Z",
                    "updated_at": "2020-01-28T22:17:31.158391Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "last_read": "2020-01-28T22:17:31.016937728Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "last_read": "2020-01-28T22:17:31.018856448Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ]
        }
            ''',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        final response = await channelClient.create();

        verify(() => mockDio.post<String>('/channels/messaging/query',
            data: options)).called(1);
        expect(channelClient.id, response.channel.id);
        expect(channelClient.cid, response.channel.cid);
      });

      test('watch', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging');
        final options = {
          'watch': true,
          'state': true,
          'presence': true,
        };

        when(() => mockDio.post<String>('/channels/messaging/query',
            data: options)).thenAnswer(
          (_) async => Response(
            data: r'''
            {
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
            "messages": [
                {
                    "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                            "user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                            "user": {
                                "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.83015Z",
                                "updated_at": "2020-01-28T22:17:31.19435Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/2.jpg",
                                "name": "Mia Denys"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.128376Z",
                            "updated_at": "2020-01-28T22:17:31.128376Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.107978Z",
                    "updated_at": "2020-01-28T22:17:31.130506Z",
                    "mentioned_users": []
                },
                {
                    "id": "16e19c46-fb96-4f89-8031-d5bd2ce3bd64",
                    "text": "Few can name a topfull mother that isn't a breezeless damage.",
                    "html": "\u003cp\u003eFew can name a topfull mother that isn’t a breezeless damage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.153518Z",
                    "updated_at": "2020-01-28T22:17:31.153518Z",
                    "mentioned_users": []
                },
                {
                    "id": "38b1b252-c9a6-4aea-a39e-8de3b7f7604b",
                    "text": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "Moustache Thumbs Up GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "text": "Discover \u0026 share this Pouce Leve GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.155428Z",
                    "updated_at": "2020-01-28T22:17:31.155428Z",
                    "mentioned_users": []
                },
                {
                    "id": "5c7d0c68-72d5-4027-b6b7-711b342d0fc4",
                    "text": "The carbons could be said to resemble smartish hoods.",
                    "html": "\u003cp\u003eThe carbons could be said to resemble smartish hoods.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.157811Z",
                    "updated_at": "2020-01-28T22:17:31.157811Z",
                    "mentioned_users": []
                },
                {
                    "id": "5b02535a-0c3c-45fa-9cf8-16f840c5123f",
                    "text": "Their software was, in this moment, a prolix feature.",
                    "html": "\u003cp\u003eTheir software was, in this moment, a prolix feature.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.158391Z",
                    "updated_at": "2020-01-28T22:17:31.158391Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "last_read": "2020-01-28T22:17:31.016937728Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "last_read": "2020-01-28T22:17:31.018856448Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ]
        }
            ''',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        final response = await channelClient.watch({'presence': true});

        verify(() => mockDio.post<String>('/channels/messaging/query',
            data: options)).called(1);
        expect(channelClient.id, response.channel.id);
        expect(channelClient.cid, response.channel.cid);
      });

      test('stopWatching', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid/stop-watching',
            data: {},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.stopWatching();

        verify(() => mockDio.post<String>(
              '/channels/messaging/testid/stop-watching',
              data: {},
            )).called(1);
      });

      test('update', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final message = Message(text: 'test');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid',
            data: {
              'message': message.toJson(),
              'data': {'test': true},
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.update({'test': true}, message);

        verify(
          () => mockDio.post<String>('/channels/messaging/testid', data: {
            'message': message.toJson(),
            'data': {'test': true},
          }),
        ).called(1);
      });

      test('delete', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.delete<String>('/channels/messaging/testid'),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.delete();

        verify(() => mockDio.delete<String>('/channels/messaging/testid'))
            .called(1);
      });

      test('truncate', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.post<String>('/channels/messaging/testid/truncate'),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.truncate();

        verify(() =>
                mockDio.post<String>('/channels/messaging/testid/truncate'))
            .called(1);
      });

      test('rejectInvite', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final message = Message(text: 'test');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid',
            data: {'reject_invite': true, 'message': message.toJson()},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.rejectInvite(message);

        verify(() => mockDio.post<String>('/channels/messaging/testid',
                data: {'reject_invite': true, 'message': message.toJson()}))
            .called(1);
      });

      test('inviteMembers', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final members = ['vishal'];
        final message = Message(text: 'test');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid',
            data: {'invites': members, 'message': message.toJson()},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.inviteMembers(members, message);

        verify(() => mockDio.post<String>('/channels/messaging/testid',
            data: {'invites': members, 'message': message.toJson()})).called(1);
      });

      test('removeMembers', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');
        final members = ['vishal'];
        final message = Message(text: 'test');

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid',
            data: {'remove_members': members, 'message': message.toJson()},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.removeMembers(members, message);

        verify(() => mockDio.post<String>('/channels/messaging/testid',
                data: {'remove_members': members, 'message': message.toJson()}))
            .called(1);
      });

      test('hide', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.post<String>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );
        await channelClient.watch();

        when(
          () => mockDio.post<String>(
            '/channels/messaging/testid/hide',
            data: {'clear_history': true},
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.hide(clearHistory: true);

        verify(() => mockDio.post<String>('/channels/messaging/testid/hide',
            data: {'clear_history': true})).called(1);
      });

      test('show', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.post<String>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );
        await channelClient.watch();

        when(
          () => mockDio.post<String>('/channels/messaging/testid/show'),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.show();

        verify(() => mockDio.post<String>('/channels/messaging/testid/show'))
            .called(1);
      });

      test('banUser', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.post<String>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );
        await channelClient.watch();

        when(
          () => mockDio.post<String>('/moderation/ban', data: {
            'test': true,
            'target_user_id': 'test-id',
            'type': 'messaging',
            'id': 'testid',
          }),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        final options = <String, dynamic>{'test': true};
        await channelClient.banUser('test-id', options);

        verify(() => mockDio.post<String>('/moderation/ban', data: {
              'test': true,
              'target_user_id': 'test-id',
              'type': 'messaging',
              'id': 'testid',
            })).called(1);
      });

      test('unbanUser', () async {
        final mockDio = MockDio();

        when(() => mockDio.options).thenReturn(BaseOptions());
        when(() => mockDio.interceptors).thenReturn(Interceptors());

        final client = StreamChatClient(
          'api-key',
          httpClient: mockDio,
          tokenProvider: (_) async => '',
        );
        final channelClient = client.channel('messaging', id: 'testid');

        when(
          () => mockDio.post<String>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );
        await channelClient.watch();

        when(
          () => mockDio.delete<String>(
            '/moderation/ban',
            queryParameters: {
              'target_user_id': 'test-id',
              'type': 'messaging',
              'id': 'testid',
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            data: '{}',
            statusCode: 200,
            requestOptions: FakeRequestOptions(),
          ),
        );

        await channelClient.unbanUser('test-id');

        verify(
          () => mockDio.delete<String>('/moderation/ban', queryParameters: {
            'target_user_id': 'test-id',
            'type': 'messaging',
            'id': 'testid',
          }),
        ).called(1);
      });
    });
  });
}

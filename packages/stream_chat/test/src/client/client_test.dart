// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars, deprecated_member_use_from_same_package

import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../matchers.dart';
import '../utils.dart';

void main() {
  group('Fake web-socket connection functions', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, ws: ws, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should work fine', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectUser(user, token);
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    test('`.connectUserWithProvider` should work fine', () async {
      final user = User(id: 'test-user-id');
      Future<String> tokenProvider(String userId) async {
        expect(userId, user.id);
        return Token.development(userId).rawValue;
      }

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectUserWithProvider(user, tokenProvider);
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    group('`.connectGuestUser`', () {
      test('should work fine', () async {
        final user = User(id: 'test-user-id');
        final token = Token.development(user.id).rawValue;

        when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
          (_) async => ConnectGuestUserResponse()
            ..user = user
            ..accessToken = token,
        );

        expectLater(
          // skipping first seed status -> ConnectionStatus.disconnected
          client.wsConnectionStatusStream.skip(1),
          emitsInOrder([
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        final res = await client.connectGuestUser(user);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).called(1);
      });

      test('should throw if `.getGuestUser` fails', () async {
        final user = User(id: 'test-user-id');

        when(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

        expectLater(
          client.wsConnectionStatusStream,
          emitsInOrder([
            // only emits the seed -> disconnected status
            // as the call never reaches `ws.connect`
            ConnectionStatus.disconnected,
          ]),
        );

        try {
          await client.connectGuestUser(user);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        verify(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).called(1);
      });
    });

    test('`.connectAnonymousUser` should work fine', () async {
      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectAnonymousUser();
      expect(res, isNotNull);
    });

    group('`.openConnection`', () {
      test('should throw if state does not contain user', () async {
        expect(client.state.currentUser, isNull);
        try {
          await client.openConnection();
        } catch (e) {
          expect(e, isA<AssertionError>());
        }
      });

      test('should throw if connection is already available', () async {
        expect(client.state.currentUser, isNull);
        try {
          await client.connectAnonymousUser();
          // waiting 300ms for `wsConnectionStatusStream` to emit
          await delay(300);

          await client.openConnection();
        } catch (e) {
          expect(e, isA<StreamChatError>());
          final err = e as StreamChatError;
          expect(
            err.message.contains('Connection already available for'),
            isTrue,
          );
        }
      });

      test('should open connection for closed connection', () async {
        expectLater(
          client.wsConnectionStatusStream.skip(1),
          emitsInOrder([
            // initial connectUser
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
            // close connection
            ConnectionStatus.disconnected,
            // open connection
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        await client.connectAnonymousUser();
        // waiting 300ms for `wsConnectionStatusStream` to emit
        await delay(300);

        client.closeConnection();

        await client.openConnection();
      });
    });
  });

  group('Fake web-socket connection functions failure', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeWebSocketWithConnectionError();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should throw if `ws.connect` fails', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      try {
        await client.connectUser(user, token);
      } catch (e) {
        expect(e, isA<StreamWebSocketError>());
      }
    });

    test(
      '`.connectUserWithProvider` should throw if `ws.connect` fails',
      () async {
        final user = User(id: 'test-user-id');
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        try {
          await client.connectUserWithProvider(user, tokenProvider);
        } catch (e) {
          expect(e, isA<StreamWebSocketError>());
        }
      },
    );

    test('`.connectGuestUser` should throw if `ws.connect` fails', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
        (_) async => ConnectGuestUserResponse()
          ..user = user
          ..accessToken = token,
      );

      try {
        await client.connectGuestUser(user);
      } catch (e) {
        expect(e, isA<StreamWebSocketError>());
      }
      verify(
        () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
      ).called(1);
    });

    test(
      '`.connectAnonymousUser` should throw if `ws.connect` fails',
      () async {
        try {
          await client.connectAnonymousUser();
        } catch (e) {
          expect(e, isA<StreamWebSocketError>());
        }
      },
    );
  });

  group('Connect user calls with `connectWebSocket`: false', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      client = StreamChatClient(apiKey, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should succeed without connecting', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      final res = await client.connectUser(
        user,
        token,
        connectWebSocket: false,
      );
      expect(res, isSameUserAs(user));
      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
    });

    test(
      '`.connectUserWithProvider` should succeed without connecting',
      () async {
        final user = User(id: 'test-user-id');
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        final res = await client.connectUserWithProvider(
          user,
          tokenProvider,
          connectWebSocket: false,
        );
        expect(res, isSameUserAs(user));
        expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      },
    );

    test('`.connectGuestUser` should succeed without connecting', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
        (_) async => ConnectGuestUserResponse()
          ..user = user
          ..accessToken = token,
      );

      final res = await client.connectGuestUser(
        user,
        connectWebSocket: false,
      );

      expect(res, isSameUserAs(user));
      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      verify(
        () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
      ).called(1);
    });

    test(
      '`.connectAnonymousUser` should succeed without connecting',
      () async {
        final res = await client.connectAnonymousUser(
          connectWebSocket: false,
        );

        expect(res, isNotNull);
        expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      },
    );
  });

  group('Client with connected user without persistence', () {
    const apiKey = 'test-api-key';
    const userId = 'test-user-id';
    late final api = FakeChatApi();

    final user = User(id: userId);
    final token = Token.development(user.id).rawValue;

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeEvent());
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeDraftMessage());
      registerFallbackValue(FakePollVote());
      registerFallbackValue(const PaginationParams());
    });

    setUp(() async {
      // Clear any accumulated interactions from a previous test so that
      // verifyNoMoreInteractions on api.general stays accurate.
      clearInteractions(api.general);

      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      // Stub getAppSettings so the background fetch after connectUser succeeds.
      when(() => api.general.getAppSettings()).thenAnswer(
        (_) async => GetAppSettingsResponse()..app = const AppSettings(name: 'test'),
      );
      await client.connectUser(user, token);
      await delay(300);
      expect(client.persistenceEnabled, isFalse);
      expect(client.wsConnectionStatus, ConnectionStatus.connected);
    });

    tearDown(() async {
      await client.dispose();
    });

    test('`.markAllRead`', () async {
      when(() => api.channel.markAllRead()).thenAnswer((_) async => EmptyResponse());

      final res = await client.markAllRead();
      expect(res, isNotNull);

      verify(() => api.channel.markAllRead()).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.markChannelsDelivered`', () async {
      final deliveries = [
        const MessageDelivery(
          channelCid: 'messaging:test-channel-1',
          messageId: 'test-message-id-1',
        ),
        const MessageDelivery(
          channelCid: 'messaging:test-channel-2',
          messageId: 'test-message-id-2',
        ),
      ];

      when(() => api.channel.markChannelsDelivered(deliveries)).thenAnswer((_) async => EmptyResponse());

      final res = await client.markChannelsDelivered(deliveries);
      expect(res, isNotNull);

      verify(() => api.channel.markChannelsDelivered(deliveries)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.sendEvent`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      final event = Event(type: EventType.any);

      when(
        () => api.channel.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(event)),
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await client.sendEvent(channelId, channelType, event);
      expect(res, isNotNull);

      verify(
        () => api.channel.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(event)),
        ),
      ).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.sendReaction`', () async {
      const messageId = 'test-message-id';
      const reactionType = 'like';
      const emojiCode = '👍';
      const score = 4;

      final reaction = Reaction(
        type: reactionType,
        messageId: messageId,
        emojiCode: emojiCode,
        score: score,
      );

      when(() => api.message.sendReaction(messageId, reaction)).thenAnswer(
        (_) async => SendReactionResponse()
          ..message = Message(id: messageId)
          ..reaction = reaction,
      );

      final res = await client.sendReaction(messageId, reaction);
      expect(res, isNotNull);
      expect(res.message.id, messageId);
      expect(res.reaction.type, reactionType);
      expect(res.reaction.emojiCode, emojiCode);
      expect(res.reaction.score, score);
      expect(res.reaction.messageId, messageId);

      verify(() => api.message.sendReaction(messageId, reaction)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteReaction`', () async {
      const messageId = 'test-message-id';
      const reactionType = 'like';

      when(() => api.message.deleteReaction(messageId, reactionType)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteReaction(messageId, reactionType);
      expect(res, isNotNull);

      verify(
        () => api.message.deleteReaction(messageId, reactionType),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.sendMessage`', () async {
      final message = Message(id: 'test-message-id');
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(
        () => api.message.sendMessage(channelId, channelType, any(that: isSameMessageAs(message))),
      ).thenAnswer((_) async => SendMessageResponse()..message = message);

      final res = await client.sendMessage(message, channelId, channelType);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      verify(
        () => api.message.sendMessage(
          channelId,
          channelType,
          any(that: isSameMessageAs(message)),
        ),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.createDraft`', () async {
      final message = DraftMessage(id: 'test-message-id', text: 'Hello!');
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(
        () => api.message.createDraft(
          channelId,
          channelType,
          any(that: isSameDraftMessageAs(message)),
        ),
      ).thenAnswer(
        (_) async => CreateDraftResponse()
          ..draft = Draft(
            channelCid: '$channelType:$channelId',
            createdAt: DateTime.now(),
            message: message,
          ),
      );

      final res = await client.createDraft(
        message,
        channelId,
        channelType,
      );

      expect(res, isNotNull);
      expect(res.draft.message, isSameDraftMessageAs(message));

      verify(
        () => api.message.createDraft(
          channelId,
          channelType,
          any(that: isSameDraftMessageAs(message)),
        ),
      ).called(1);

      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteDraft`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(() => api.message.deleteDraft(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteDraft(channelId, channelType);
      expect(res, isNotNull);

      verify(() => api.message.deleteDraft(channelId, channelType));
      verifyNoMoreInteractions(api.message);
    });

    test('`.getDraft`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final message = DraftMessage(id: 'test-message-id', text: 'Hello!');

      when(() => api.message.getDraft(channelId, channelType)).thenAnswer(
        (_) async => GetDraftResponse()
          ..draft = Draft(
            channelCid: '$channelType:$channelId',
            createdAt: DateTime.now(),
            message: message,
          ),
      );

      final res = await client.getDraft(channelId, channelType);

      expect(res, isNotNull);
      expect(res.draft.message, isSameDraftMessageAs(message));

      verify(() => api.message.getDraft(channelId, channelType));
      verifyNoMoreInteractions(api.message);
    });

    test('`.queryDrafts`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final filter = Filter.equal('channel_cid', '$channelType:$channelId');
      final sort = [const SortOption<Draft>.desc('created_at')];
      const pagination = PaginationParams(limit: 20);

      final drafts = [
        Draft(
          channelCid: '$channelType:$channelId',
          createdAt: DateTime.now(),
          message: DraftMessage(id: 'test-message-id', text: 'Hello!'),
        ),
      ];

      when(
        () => api.message.queryDrafts(
          filter: filter,
          sort: sort,
          pagination: pagination,
        ),
      ).thenAnswer((_) async => QueryDraftsResponse()..drafts = drafts);

      final res = await client.queryDrafts(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );

      expect(res, isNotNull);
      expect(res.drafts.length, drafts.length);

      verify(
        () => api.message.queryDrafts(
          filter: filter,
          sort: sort,
          pagination: pagination,
        ),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getReplies`', () async {
      const parentId = 'test-parent-id';

      final messages = List.generate(
        3,
        (index) => Message(id: 'test-message-id-$index'),
      );

      when(() => api.message.getReplies(parentId)).thenAnswer((_) async => QueryRepliesResponse()..messages = messages);

      final res = await client.getReplies(parentId);
      expect(res, isNotNull);
      expect(res.messages.length, messages.length);

      verify(() => api.message.getReplies(parentId)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getReactions`', () async {
      const messageId = 'test-parent-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reactions-type-$index',
          messageId: messageId,
        ),
      );

      when(
        () => api.message.getReactions(messageId),
      ).thenAnswer((_) async => QueryReactionsResponse()..reactions = reactions);

      final res = await client.getReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => api.message.getReactions(messageId)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.queryReactions`', () async {
      const messageId = 'test-message-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reactions-type-$index',
          messageId: messageId,
        ),
      );

      when(
        () => api.message.queryReactions(messageId),
      ).thenAnswer(
        (_) async => QueryReactionsResponse()
          ..reactions = reactions
          ..next = null,
      );

      final res = await client.queryReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => api.message.queryReactions(messageId)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.updateMessage`', () async {
      final message = Message(id: 'test-message-id', text: 'Hello!');

      when(
        () => api.message.updateMessage(any(that: isSameMessageAs(message))),
      ).thenAnswer((_) async => UpdateMessageResponse()..message = message);

      final res = await client.updateMessage(message);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      verify(
        () => api.message.updateMessage(any(that: isSameMessageAs(message))),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteMessage`', () async {
      const messageId = 'test-message-id';

      when(() => api.message.deleteMessage(messageId, hard: false)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteMessage(messageId);
      expect(res, isNotNull);

      verify(() => api.message.deleteMessage(messageId, hard: false)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteMessageForMe`', () async {
      const messageId = 'test-message-id';

      when(() => api.message.deleteMessage(messageId, deleteForMe: true)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteMessageForMe(messageId);
      expect(res, isNotNull);

      verify(() => api.message.deleteMessage(messageId, deleteForMe: true)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      when(() => api.message.getMessage(messageId)).thenAnswer((_) async => GetMessageResponse()..message = message);

      final res = await client.getMessage(messageId);
      expect(res, isNotNull);
      expect(res.message.id, messageId);

      verify(() => api.message.getMessage(messageId)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getMessagesById`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const messageIds = ['test-message-id'];

      final messages = messageIds.map((id) => Message(id: id)).toList();

      when(
        () => api.message.getMessagesById(channelId, channelType, messageIds),
      ).thenAnswer((_) async => GetMessagesByIdResponse()..messages = messages);

      final res = await client.getMessagesById(
        channelId,
        channelType,
        messageIds,
      );
      expect(res, isNotNull);
      expect(res.messages.length, messageIds.length);

      verify(
        () => api.message.getMessagesById(channelId, channelType, messageIds),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.translateMessage`', () async {
      const messageId = 'test-message-id';
      const language = 'hi'; // Hindi
      const translatedMessageText = 'नमस्ते';
      final translatedMessage = Message(
        i18n: const {
          language: translatedMessageText,
        },
      );

      when(() => api.message.translateMessage(messageId, language)).thenAnswer(
        (_) async => TranslateMessageResponse()..message = translatedMessage,
      );

      final res = await client.translateMessage(messageId, language);

      expect(res, isNotNull);
      expect(res.message.i18n, translatedMessage.i18n);

      verify(() => api.message.translateMessage(messageId, language)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.partialUpdateMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      const set = {'text': 'Update Message text'};
      const unset = ['pinExpires'];

      final updateMessageResponse = UpdateMessageResponse()
        ..message = message.copyWith(text: set['text'], pinExpires: null);

      when(
        () => api.message.partialUpdateMessage(
          message.id,
          set: set,
          unset: unset,
        ),
      ).thenAnswer((_) async => updateMessageResponse);

      final res = await client.partialUpdateMessage(
        messageId,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.message.id, message.id);
      expect(res.message.id, message.id);
      expect(res.message.text, set['text']);
      expect(res.message.pinExpires, isNull);

      verify(
        () => api.message.partialUpdateMessage(
          message.id,
          set: set,
          unset: unset,
        ),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    group('`.pinMessage`', () {
      test('should work fine without passing timeoutOrExpirationDate', () async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);

        when(
          () => api.message.partialUpdateMessage(
            messageId,
            set: any(named: 'set'),
            unset: any(named: 'unset'),
          ),
        ).thenAnswer(
          (_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              pinned: true,
              pinExpires: null,
              state: MessageState.sent,
            ),
        );

        final res = await client.pinMessage(messageId);

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNull);

        verify(
          () => api.message.partialUpdateMessage(
            messageId,
            set: any(named: 'set'),
            unset: any(named: 'unset'),
          ),
        ).called(1);
        verifyNoMoreInteractions(api.message);
      });

      test(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          const timeoutOrExpirationDate = 300; // 300 seconds

          when(
            () => api.message.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).thenAnswer(
            (_) async => UpdateMessageResponse()
              ..message = message.copyWith(
                pinned: true,
                pinExpires: DateTime.now().add(
                  const Duration(seconds: timeoutOrExpirationDate),
                ),
                state: MessageState.sent,
              ),
          );

          final res = await client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);

          verify(
            () => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
          verifyNoMoreInteractions(api.message);
        },
      );

      test(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          final timeoutOrExpirationDate = DateTime.now().add(const Duration(days: 3)); // 3 days

          when(
            () => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).thenAnswer(
            (_) async => UpdateMessageResponse()
              ..message = message.copyWith(
                pinned: true,
                pinExpires: timeoutOrExpirationDate,
                state: MessageState.sent,
              ),
          );

          final res = await client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);
          expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

          verify(
            () => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
          verifyNoMoreInteractions(api.message);
        },
      );

      test(
        'should throw if invalid timeoutOrExpirationDate is passed',
        () async {
          const messageId = 'test-message-id';
          const timeoutOrExpirationDate = 'invalid-value';

          try {
            await client.pinMessage(
              messageId,
              timeoutOrExpirationDate: timeoutOrExpirationDate,
            );
          } catch (e) {
            expect(e, isA<ArgumentError>());
          }
        },
      );
    });

    test('`.unpinMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId, pinned: true);

      when(
        () => api.message.partialUpdateMessage(
          messageId,
          set: {'pinned': false},
        ),
      ).thenAnswer(
        (_) async => UpdateMessageResponse()
          ..message = message.copyWith(
            pinned: false,
            state: MessageState.sent,
          ),
      );

      final res = await client.unpinMessage(messageId);

      expect(res, isNotNull);
      expect(res.message.pinned, isFalse);

      verify(
        () => api.message.partialUpdateMessage(
          messageId,
          set: {'pinned': false},
        ),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.enrichUrl`', () async {
      const url = 'https://www.techyourchance.com/finite-state-machine-with-unit-tests-real-world-example';

      when(() => api.general.enrichUrl(url)).thenAnswer(
        (_) async => OGAttachmentResponse()
          ..type = 'image'
          ..ogScrapeUrl = url
          ..authorName = 'TechYourChance'
          ..title = 'Finite State Machine with Unit Tests: Real World Example',
      );

      final res = await client.enrichUrl(url);

      expect(res, isNotNull);
      expect(res.type, 'image');
      expect(res.ogScrapeUrl, url);
      expect(res.authorName, 'TechYourChance');
      expect(
        res.title,
        'Finite State Machine with Unit Tests: Real World Example',
      );

      verify(() => api.general.enrichUrl(url)).called(1);
      verify(() => api.general.getAppSettings()).called(1);
      verifyNoMoreInteractions(api.general);
    });

    test(
      '''setting the `currentUser` should also compute and update the unreadCounts''',
      () {
        final state = client.state;
        final initialUser = OwnUser.fromUser(user);

        expect(state.currentUser, initialUser);
        expect(state.totalUnreadCount, 0);
        expect(state.unreadChannels, 0);

        final updateUser = initialUser.copyWith(
          totalUnreadCount: 33,
          unreadChannels: 33,
        );
        state.currentUser = updateUser;

        expect(state.currentUser, updateUser);
        expect(state.totalUnreadCount, 33);
        expect(state.unreadChannels, 33);
      },
    );
  });
}

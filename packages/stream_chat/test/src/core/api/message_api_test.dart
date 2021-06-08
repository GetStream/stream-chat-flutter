import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
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
  late MessageApi messageApi;

  setUp(() {
    messageApi = MessageApi(client);
  });

  test('sendMessage', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final message = Message(id: 'test-message-id', text: 'test-message-text');

    const path = '/channels/$channelType/$channelId/message';

    when(() => client.post(path, data: any(named: 'data')))
        .thenAnswer((_) async => successResponse(path, data: {
              'message': message.toJson(),
            }));

    final res = await messageApi.sendMessage(channelId, channelType, message);

    expect(res, isNotNull);
    expect(res.message.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getMessagesById', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const messageIds = ['test-message-id-1', 'test-message-id-2'];

    const path = '/channels/$channelType/$channelId/messages';

    final messages = List.generate(
      3,
      (index) => Message(id: 'test-message-id-$index'),
    );

    when(() => client.get(path, queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => successResponse(path, data: {
              'messages': [...messages.map((it) => it.toJson())],
            }));

    final res = await messageApi.getMessagesById(
      channelId,
      channelType,
      messageIds,
    );

    expect(res, isNotNull);
    expect(res.messages.length, messages.length);

    verify(
      () => client.get(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getMessage', () async {
    const messageId = 'test-message-id';

    const path = '/messages/$messageId';

    final message = Message(id: messageId);

    when(() => client.get(path)).thenAnswer((_) async =>
        successResponse(path, data: {'message': message.toJson()}));

    final res = await messageApi.getMessage(messageId);

    expect(res, isNotNull);
    expect(res.message.id, messageId);

    verify(() => client.get(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updateMessage', () async {
    final message = Message(id: 'test-message-id');

    final path = '/messages/${message.id}';

    when(() => client.post(path, data: any(named: 'data'))).thenAnswer(
      (_) async => successResponse(path, data: {'message': message.toJson()}),
    );

    final res = await messageApi.updateMessage(message);

    expect(res, isNotNull);
    expect(res.message.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deleteMessage', () async {
    const messageId = 'test-message-id';

    const path = '/messages/$messageId';

    when(() => client.delete(path)).thenAnswer(
      (_) async => successResponse(path, data: <String, dynamic>{}),
    );

    final res = await messageApi.deleteMessage(messageId);

    expect(res, isNotNull);

    verify(() => client.delete(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('sendAction', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const messageId = 'test-message-id';
    const formData = {'test-key': 'test-data'};

    const path = '/messages/$messageId/action';

    when(() => client.post(path, data: any(named: 'data'))).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await messageApi.sendAction(
      channelId,
      channelType,
      messageId,
      formData,
    );

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('sendReaction', () async {
    const messageId = 'test-message-id';
    const reactionType = 'test-reaction-type';
    const extraData = {'test-key': 'test-data'};

    const path = '/messages/$messageId/reaction';

    final message = Message(id: messageId);
    final reaction = Reaction(type: reactionType, messageId: messageId);

    when(() => client.post(path, data: any(named: 'data')))
        .thenAnswer((_) async => successResponse(path, data: {
              'message': message.toJson(),
              'reaction': reaction.toJson(),
            }));

    final res = await messageApi.sendReaction(
      messageId,
      reactionType,
      extraData: extraData,
    );

    expect(res, isNotNull);
    expect(res.message.id, messageId);
    expect(res.reaction.messageId, messageId);
    expect(res.reaction.type, reactionType);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deleteReaction', () async {
    const messageId = 'test-message-id';
    const reactionType = 'test-reaction-type';

    const path = '/messages/$messageId/reaction/$reactionType';

    when(() => client.delete(path)).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await messageApi.deleteReaction(messageId, reactionType);

    expect(res, isNotNull);

    verify(() => client.delete(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getReactions', () async {
    const messageId = 'test-message-id';
    const options = PaginationParams();

    const path = '/messages/$messageId/reactions';

    final reactions = List.generate(
      3,
      (index) => Reaction(
        type: 'test-reaction-type-$index',
        messageId: messageId,
      ),
    );

    when(() => client.get(path, queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => successResponse(path, data: {
              'reactions': [...reactions.map((it) => it.toJson())]
            }));

    final res = await messageApi.getReactions(messageId, options);

    expect(res, isNotNull);
    expect(res.reactions.length, reactions.length);
    expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

    verify(
      () => client.get(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('translateMessage', () async {
    const messageId = 'test-message-id';
    const messageText = 'hello';
    const language = 'hi'; // Hindi
    final message = Message(id: messageId, text: messageText);

    final path = '/messages/${message.id}/translate';

    const translatedMessageText = 'नमस्ते';
    final translatedMessage = TranslatedMessage(const {
      language: translatedMessageText,
    });

    when(() => client.post(path, data: any(named: 'data')))
        .thenAnswer((_) async => successResponse(path, data: {
              'message': translatedMessage.toJson(),
            }));

    final res = await messageApi.translateMessage(messageId, language);

    expect(res, isNotNull);
    expect(res.message.i18n?.containsKey(language), isTrue);
    expect(res.message.i18n?[language], translatedMessageText);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getReplies', () async {
    const parentId = 'test-parent-id';
    const options = PaginationParams();

    const path = '/messages/$parentId/replies';

    final messages = List.generate(
      3,
      (index) => Message(
        id: 'test-message-id-$index',
        parentId: parentId,
      ),
    );

    when(() => client.get(path, queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => successResponse(path, data: {
              'messages': [...messages.map((it) => it.toJson())]
            }));

    final res = await messageApi.getReplies(parentId, options);

    expect(res, isNotNull);
    expect(res.messages.length, messages.length);
    expect(res.messages.every((it) => it.parentId == parentId), isTrue);

    verify(
      () => client.get(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });
}

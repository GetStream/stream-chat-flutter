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

    when(
      () => client.post(
        path,
        data: {
          'message': message,
          'skip_push': false,
          'skip_enrich_url': false,
        },
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'message': message.toJson(),
        },
      ),
    );

    final res = await messageApi.sendMessage(channelId, channelType, message);

    expect(res, isNotNull);
    expect(res.message.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('sendMessage with skipPush: true', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final message = Message(id: 'test-message-id', text: 'test-message-text');

    const path = '/channels/$channelType/$channelId/message';

    when(
      () => client.post(
        path,
        data: {
          'message': message,
          'skip_push': true,
          'skip_enrich_url': false,
        },
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'message': message.toJson(),
        },
      ),
    );

    final res = await messageApi.sendMessage(
      channelId,
      channelType,
      message,
      skipPush: true,
    );

    expect(res, isNotNull);
    expect(res.message.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updateMessage', () async {
    final message = Message(id: 'test-message-id');

    final path = '/messages/${message.id}';

    when(
      () => client.post(
        path,
        data: {
          'message': message,
          'skip_push': false,
          'skip_enrich_url': false,
        },
      ),
    ).thenAnswer(
      (_) async => successResponse(path, data: {'message': message.toJson()}),
    );

    final res = await messageApi.updateMessage(message);

    expect(res, isNotNull);
    expect(res.message.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('partialUpdateMessage', () async {
    const messageId = 'test-message-id';

    const set = {'text': 'Update Message text'};
    const unset = ['pinExpires'];

    const path = '/messages/$messageId';
    final message = Message(id: 'test-message-id', text: set['text']);

    when(
      () => client.put(
        path,
        data: {
          'set': set,
          'unset': unset,
          'skip_enrich_url': false,
        },
      ),
    ).thenAnswer(
      (_) async => successResponse(path, data: {'message': message.toJson()}),
    );

    final res = await messageApi.partialUpdateMessage(
      messageId,
      set: set,
      unset: unset,
    );

    expect(res, isNotNull);
    expect(res.message.id, message.id);
    expect(res.message.text, set['text']);
    expect(res.message.pinExpires, isNull);

    verify(
      () => client.put(
        path,
        data: {
          'set': set,
          'unset': unset,
          'skip_enrich_url': false,
        },
      ),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deleteMessage', () async {
    const messageId = 'test-message-id';

    const path = '/messages/$messageId';
    const params = {'delete_for_me': true};

    when(() => client.delete(path, queryParameters: params)).thenAnswer(
      (_) async => successResponse(path, data: <String, dynamic>{}),
    );

    final res = await messageApi.deleteMessage(messageId, deleteForMe: true);

    expect(res, isNotNull);

    verify(() => client.delete(path, queryParameters: params)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('sendAction', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const messageId = 'test-message-id';
    const formData = {'test-key': 'test-data'};

    const path = '/messages/$messageId/action';

    when(
      () => client.post(
        path,
        data: {
          'id': channelId,
          'type': channelType,
          'form_data': formData,
          'message_id': messageId,
        },
      ),
    ).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

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
}

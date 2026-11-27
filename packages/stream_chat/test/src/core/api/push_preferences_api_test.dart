import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/push_preferences_api.dart';
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
  late PushPreferencesApi pushPreferencesApi;

  setUp(() {
    pushPreferencesApi = PushPreferencesApi(client);
  });

  test('setPushPreferences', () async {
    const path = '/push_preferences';

    const preferences = [
      PushPreferenceInput(chatLevel: ChatLevel.directMentions),
    ];

    when(() => client.post(path, data: any(named: 'data'))).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'user_preferences': <String, dynamic>{},
          'user_channel_preferences': <String, dynamic>{},
        },
      ),
    );

    final res = await pushPreferencesApi.setPushPreferences(preferences);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('setPushPreferences throws on empty list', () async {
    expect(
      () => pushPreferencesApi.setPushPreferences([]),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('setPushPreferences allows removeDisable as only field', () async {
    const path = '/push_preferences';

    const preferences = [
      PushPreferenceInput(removeDisable: true),
    ];

    when(() => client.post(path, data: any(named: 'data'))).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'user_preferences': <String, dynamic>{},
          'user_channel_preferences': <String, dynamic>{},
        },
      ),
    );

    final res = await pushPreferencesApi.setPushPreferences(preferences);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('setPushPreferences with channel-specific preference', () async {
    const path = '/push_preferences';

    const preferences = [
      PushPreferenceInput.channel(
        channelCid: 'messaging:general',
        chatLevel: ChatLevel.none,
      ),
    ];

    when(() => client.post(path, data: any(named: 'data'))).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'user_preferences': <String, dynamic>{},
          'user_channel_preferences': <String, dynamic>{},
        },
      ),
    );

    final res = await pushPreferencesApi.setPushPreferences(preferences);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });
}

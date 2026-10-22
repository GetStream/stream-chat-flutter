import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  String _getChannelUrl(String channelId, String channelType) => '/channels/$channelType/$channelId';

  Response successResponse(String path, {Object? data}) => Response(
    data: data,
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
  );

  late final client = MockHttpClient();
  late ChannelApi channelApi;

  setUp(() {
    channelApi = ChannelApi(client);
  });

  test('stopWatching', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final path = '${_getChannelUrl(channelId, channelType)}/stop-watching';

    when(() => client.post(path, data: {})).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.stopWatching(channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.post(path, data: {})).called(1);
    verifyNoMoreInteractions(client);
  });
}

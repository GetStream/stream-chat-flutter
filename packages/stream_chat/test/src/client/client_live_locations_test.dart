import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const api.UpdateLiveLocationRequest(messageId: 'fallback'));
  });

  test('StreamChatClient.getUserLiveLocations sends the request and returns the active live locations', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.getUserLiveLocations();

    final locations = res.getOrNull()!.activeLiveLocations;
    // A channel compares by identity, so it is checked on its own.
    expect(locations.map((location) => location.channel?.cid), ['messaging:general', 'messaging:general']);
    expect(
      res,
      Result.success(
        SharedLocationsResponse(
          duration: '4.21ms',
          activeLiveLocations: [_firstLocation(locations[0].channel), _secondLocation(locations[1].channel)],
        ),
      ),
    );
    verify(defaultApi.getUserLiveLocations).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.getUserLiveLocations stores the live locations it returns in the client state', () async {
    final client = _client(_defaultApi());

    final res = await client.getUserLiveLocations();

    expect(client.state.activeLiveLocations, res.getOrNull()!.activeLiveLocations);
  });

  test('StreamChatClient.getUserLiveLocations returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(defaultApi.getUserLiveLocations).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getUserLiveLocations();

    expect(res.exceptionOrNull(), error);
  });

  test(
    'StreamChatClient.getUserLiveLocations leaves the live locations in the client state unchanged when it fails',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);
      final stored = (await client.getUserLiveLocations()).getOrNull()!.activeLiveLocations;
      when(
        defaultApi.getUserLiveLocations,
      ).thenAnswer((_) async => const Result.failure(StreamClientException(message: 'boom')));

      await client.getUserLiveLocations();

      expect(client.state.activeLiveLocations, stored);
    },
  );

  test(
    'StreamChatClient.updateLiveLocation sends the message id, coordinates and end time and returns the updated location',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.updateLiveLocation(
        messageId: 'first-message',
        location: const LocationCoordinate(latitude: 41.5, longitude: -73.5),
        endAt: DateTime.utc(2100, 3),
      );

      final location = res.getOrNull()!.location;
      // A channel compares by identity, so it is checked on its own.
      expect(location.channel?.cid, 'messaging:general');
      expect(
        res,
        Result.success(
          SharedLocationResponse(
            duration: '3.14ms',
            location: _firstLocation(location.channel),
          ),
        ),
      );
      verify(
        () => defaultApi.updateLiveLocation(
          updateLiveLocationRequest: api.UpdateLiveLocationRequest(
            messageId: 'first-message',
            latitude: 41.5,
            longitude: -73.5,
            endAt: DateTime.utc(2100, 3),
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.updateLiveLocation sends no end time when it is omitted', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.updateLiveLocation(
      messageId: 'first-message',
      location: const LocationCoordinate(latitude: 41.5, longitude: -73.5),
    );

    verify(
      () => defaultApi.updateLiveLocation(
        updateLiveLocationRequest: const api.UpdateLiveLocationRequest(
          messageId: 'first-message',
          latitude: 41.5,
          longitude: -73.5,
        ),
      ),
    ).called(1);
  });

  test('StreamChatClient.updateLiveLocation returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateLiveLocation(updateLiveLocationRequest: any(named: 'updateLiveLocationRequest')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.updateLiveLocation(messageId: 'first-message');

    expect(res.exceptionOrNull(), error);
  });

  test(
    'StreamChatClient.stopLiveLocation sends the message id and an end time of now and returns the location',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final before = DateTime.timestamp();
      final res = await client.stopLiveLocation(messageId: 'first-message');
      final after = DateTime.timestamp();

      final location = res.getOrNull()!.location;
      expect(
        res,
        Result.success(SharedLocationResponse(duration: '3.14ms', location: _firstLocation(location.channel))),
      );
      final request =
          verify(
                () => defaultApi.updateLiveLocation(
                  updateLiveLocationRequest: captureAny(named: 'updateLiveLocationRequest'),
                ),
              ).captured.single
              as api.UpdateLiveLocationRequest;
      expect(request.messageId, 'first-message');
      expect(request.latitude, isNull);
      expect(request.longitude, isNull);
      expect(request.endAt, isNotNull);
      expect(request.endAt!.isBefore(before), isFalse);
      expect(request.endAt!.isAfter(after), isFalse);
    },
  );
}

MockDefaultApi _defaultApi() {
  final defaultApi = MockDefaultApi();
  when(defaultApi.getUserLiveLocations).thenAnswer(
    (_) async => Result.success(
      api.SharedLocationsResponse(
        duration: '4.21ms',
        activeLiveLocations: _locationResponses(),
      ),
    ),
  );
  when(
    () => defaultApi.updateLiveLocation(updateLiveLocationRequest: any(named: 'updateLiveLocationRequest')),
  ).thenAnswer(
    (_) async => Result.success(
      api.SharedLocationResponse(
        duration: '3.14ms',
        channel: generatedChannel,
        channelCid: 'messaging:general',
        createdAt: DateTime.utc(2026, 2, 1),
        createdByDeviceId: 'first-device',
        endAt: DateTime.utc(2100, 3),
        latitude: 41.5,
        longitude: -73.5,
        message: generatedLeafMessage('first-message'),
        messageId: 'first-message',
        updatedAt: DateTime.utc(2026, 2, 2),
        userId: 'first-user',
      ),
    ),
  );
  return defaultApi;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}

// The locations the generated ones map to. A channel compares by identity, so
// each one is passed in, taken from the mapped location.
Location _firstLocation(ChannelModel? channel) => Location(
  channelCid: 'messaging:general',
  channel: channel,
  messageId: 'first-message',
  message: expectedLeafMessage('first-message'),
  userId: 'first-user',
  latitude: 41.5,
  longitude: -73.5,
  createdByDeviceId: 'first-device',
  endAt: DateTime.utc(2100, 3),
  createdAt: DateTime.utc(2026, 2, 1),
  updatedAt: DateTime.utc(2026, 2, 2),
);

Location _secondLocation(ChannelModel? channel) => Location(
  channelCid: 'messaging:general',
  channel: channel,
  messageId: 'second-message',
  message: expectedLeafMessage('second-message'),
  userId: 'second-user',
  latitude: 42.5,
  longitude: -74.5,
  createdByDeviceId: 'second-device',
  endAt: DateTime.utc(2100, 4),
  createdAt: DateTime.utc(2026, 3, 1),
  updatedAt: DateTime.utc(2026, 3, 2),
);

List<api.SharedLocationResponseData> _locationResponses() => [
  api.SharedLocationResponseData(
    channel: generatedChannel,
    channelCid: 'messaging:general',
    createdAt: DateTime.utc(2026, 2, 1),
    createdByDeviceId: 'first-device',
    endAt: DateTime.utc(2100, 3),
    latitude: 41.5,
    longitude: -73.5,
    message: generatedLeafMessage('first-message'),
    messageId: 'first-message',
    updatedAt: DateTime.utc(2026, 2, 2),
    userId: 'first-user',
  ),
  api.SharedLocationResponseData(
    channel: generatedChannel,
    channelCid: 'messaging:general',
    createdAt: DateTime.utc(2026, 3, 1),
    createdByDeviceId: 'second-device',
    endAt: DateTime.utc(2100, 4),
    latitude: 42.5,
    longitude: -74.5,
    message: generatedLeafMessage('second-message'),
    messageId: 'second-message',
    updatedAt: DateTime.utc(2026, 3, 2),
    userId: 'second-user',
  ),
];

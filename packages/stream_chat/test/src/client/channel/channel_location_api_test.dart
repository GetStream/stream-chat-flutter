import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('`.sendStaticLocation`', () {
    const deviceId = 'test-device-id';
    const locationId = 'test-location-id';
    const coordinates = LocationCoordinates(
      latitude: 40.7128,
      longitude: -74.0060,
    );

    channelTest(
      'should create a static location and call sendMessage',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(Message(id: locationId))),
          ),
          result: createDefaultSendMessageResponse(
            message: Message(
              id: locationId,
              text: 'Location shared',
              extraData: const {'custom': 'data'},
              sharedLocation: Location(
                channelCid: tester.channel.cid,
                messageId: locationId,
                userId: tester.currentUser?.id,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                createdByDeviceId: deviceId,
              ),
            ),
          ),
        );

        final response = await tester.channel.sendStaticLocation(
          id: locationId,
          messageText: 'Location shared',
          createdByDeviceId: deviceId,
          location: coordinates,
          extraData: {'custom': 'data'},
        );

        expect(response, isNotNull);
        expect(response.message.id, locationId);
        expect(response.message.text, 'Location shared');
        expect(response.message.extraData['custom'], 'data');
        expect(response.message.sharedLocation, isNotNull);

        tester.verifyApi(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(Message(id: locationId))),
          ),
        );
      },
    );
  });

  group('`.startLiveLocationSharing`', () {
    const deviceId = 'test-device-id';
    const locationId = 'test-location-id';
    final endSharingAt = DateTime.timestamp().add(const Duration(hours: 1));
    const coordinates = LocationCoordinates(
      latitude: 40.7128,
      longitude: -74.0060,
    );

    channelTest(
      'should create message with live location and call sendMessage',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(Message(id: locationId))),
          ),
          result: createDefaultSendMessageResponse(
            message: Message(
              id: locationId,
              text: 'Location shared',
              extraData: const {'custom': 'data'},
              sharedLocation: Location(
                channelCid: tester.channel.cid,
                messageId: locationId,
                userId: tester.currentUser?.id,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                createdByDeviceId: deviceId,
                endAt: endSharingAt,
              ),
            ),
          ),
        );

        final response = await tester.channel.startLiveLocationSharing(
          id: locationId,
          messageText: 'Location shared',
          createdByDeviceId: deviceId,
          location: coordinates,
          endSharingAt: endSharingAt,
          extraData: {'custom': 'data'},
        );

        expect(response, isNotNull);
        expect(response.message.id, locationId);
        expect(response.message.text, 'Location shared');
        expect(response.message.extraData['custom'], 'data');
        expect(response.message.sharedLocation, isNotNull);
        expect(response.message.sharedLocation?.endAt, endSharingAt);

        tester.verifyApi(
          (api) => api.message.sendMessage(
            _channelId,
            _channelType,
            any(that: isSameMessageAs(Message(id: locationId))),
          ),
        );
      },
    );
  });
}

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel({
  List<ChannelCapability> ownCapabilities = const [],
}) {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      ownCapabilities: ownCapabilities,
    ),
  );
}

// Reconnects the current user with typing indicators disabled in their
// privacy settings, the way a server-sent `health.check` frame would.
Future<void> _disableTypingIndicators(ChannelTester tester) {
  return tester.emitEvent(
    createDefaultConnectedEvent(
      me: createDefaultOwnUser(
        privacySettings: const PrivacySettings(
          typingIndicators: TypingIndicators(enabled: false),
        ),
      ),
    ),
  );
}

void main() {
  group('Typing Indicator', () {
    channelTest(
      ".keystore should return if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no typingEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final typingEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.keyStroke(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      '.keystore should return when user privacy settings is disabled',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        await _disableTypingIndicators(tester);

        final typingEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.keyStroke(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".keystore should send 'typingStart' event if there is not already a typingEvent or the difference between "
      'the two is > 3 seconds',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        final startTypingEvent = Event(type: EventType.typingStart);
        final stopTypingEvent = Event(type: EventType.typingStop);

        tester
          ..mockApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(startTypingEvent, matchParentId: true)),
            ),
            result: createDefaultEmptyResponse(),
          )
          ..mockApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(stopTypingEvent, matchParentId: true)),
            ),
            result: createDefaultEmptyResponse(),
          );

        await expectLater(tester.channel.keyStroke(), completes);

        tester
          ..verifyApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(startTypingEvent, matchParentId: true)),
            ),
          )
          ..verifyApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(stopTypingEvent, matchParentId: true)),
            ),
          );
      },
    );

    channelTest(
      ".startTyping should return if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no typingEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final typingStartEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.startTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      '.startTyping should return when user privacy settings is disabled',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        await _disableTypingIndicators(tester);

        final typingStartEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.startTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".startTyping should send 'typingStart' successfully",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        final typingStartEvent = Event(type: EventType.typingStart);

        tester.mockApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(tester.channel.startTyping(), completes);

        tester.verifyApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".stopTyping should return if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no typingEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final typingStopEvent = Event(type: EventType.typingStop);

        await expectLater(tester.channel.stopTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      '.stopTyping should return when user privacy settings is disabled',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        await _disableTypingIndicators(tester);

        final typingStopEvent = Event(type: EventType.typingStop);

        await expectLater(tester.channel.stopTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".stopTyping should send 'typingStop' successfully",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        final typingStopEvent = Event(type: EventType.typingStop);

        tester.mockApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(tester.channel.stopTyping(), completes);

        tester.verifyApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
        );
      },
    );
  });
}

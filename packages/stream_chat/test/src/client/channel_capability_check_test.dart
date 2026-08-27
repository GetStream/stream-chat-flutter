// ignore_for_file: deprecated_member_use_from_same_package

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  group('ChannelCapabilityCheck', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // client logger
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
    });

    /// Parameterized test for channel capability extension properties
    void testCapability(
      String capabilityName,
      ChannelCapability capability,
      bool Function(Channel) getterMethod,
    ) {
      test('can$capabilityName returns false when capability is absent', () {
        final channelState = _generateChannelState(channelId, channelType);
        final channel = Channel.fromState(client, channelState);
        expect(getterMethod(channel), false);
      });

      test('can$capabilityName returns true when capability is present', () {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [capability],
        );
        final channel = Channel.fromState(client, channelState);
        expect(getterMethod(channel), true);
      });
    }

    // Test all channel capabilities using the parameterized function
    testCapability(
      'SendMessage',
      ChannelCapability.sendMessage,
      (channel) => channel.canSendMessage,
    );

    testCapability(
      'SendReply',
      ChannelCapability.sendReply,
      (channel) => channel.canSendReply,
    );

    testCapability(
      'SendRestrictedVisibilityMessage',
      ChannelCapability.sendRestrictedVisibilityMessage,
      (channel) => channel.canSendRestrictedVisibilityMessage,
    );

    testCapability(
      'SendReaction',
      ChannelCapability.sendReaction,
      (channel) => channel.canSendReaction,
    );

    testCapability(
      'SendLinks',
      ChannelCapability.sendLinks,
      (channel) => channel.canSendLinks,
    );

    testCapability(
      'CreateAttachment',
      ChannelCapability.createAttachment,
      (channel) => channel.canCreateAttachment,
    );

    testCapability(
      'FreezeChannel',
      ChannelCapability.freezeChannel,
      (channel) => channel.canFreezeChannel,
    );

    testCapability(
      'SetChannelCooldown',
      ChannelCapability.setChannelCooldown,
      (channel) => channel.canSetChannelCooldown,
    );

    testCapability(
      'LeaveChannel',
      ChannelCapability.leaveChannel,
      (channel) => channel.canLeaveChannel,
    );

    testCapability(
      'JoinChannel',
      ChannelCapability.joinChannel,
      (channel) => channel.canJoinChannel,
    );

    testCapability(
      'PinMessage',
      ChannelCapability.pinMessage,
      (channel) => channel.canPinMessage,
    );

    testCapability(
      'DeleteAnyMessage',
      ChannelCapability.deleteAnyMessage,
      (channel) => channel.canDeleteAnyMessage,
    );

    testCapability(
      'DeleteOwnMessage',
      ChannelCapability.deleteOwnMessage,
      (channel) => channel.canDeleteOwnMessage,
    );

    testCapability(
      'UpdateAnyMessage',
      ChannelCapability.updateAnyMessage,
      (channel) => channel.canUpdateAnyMessage,
    );

    testCapability(
      'UpdateOwnMessage',
      ChannelCapability.updateOwnMessage,
      (channel) => channel.canUpdateOwnMessage,
    );

    testCapability(
      'SearchMessages',
      ChannelCapability.searchMessages,
      (channel) => channel.canSearchMessages,
    );

    testCapability(
      'SendTypingEvents',
      ChannelCapability.sendTypingEvents,
      (channel) => channel.canSendTypingEvents,
    );

    testCapability(
      'UploadFile',
      ChannelCapability.uploadFile,
      (channel) => channel.canUploadFile,
    );

    testCapability(
      'DeleteChannel',
      ChannelCapability.deleteChannel,
      (channel) => channel.canDeleteChannel,
    );

    testCapability(
      'UpdateChannel',
      ChannelCapability.updateChannel,
      (channel) => channel.canUpdateChannel,
    );

    testCapability(
      'UpdateChannelMembers',
      ChannelCapability.updateChannelMembers,
      (channel) => channel.canUpdateChannelMembers,
    );

    testCapability(
      'UpdateThread',
      ChannelCapability.updateThread,
      (channel) => channel.canUpdateThread,
    );

    testCapability(
      'QuoteMessage',
      ChannelCapability.quoteMessage,
      (channel) => channel.canQuoteMessage,
    );

    testCapability(
      'BanChannelMembers',
      ChannelCapability.banChannelMembers,
      (channel) => channel.canBanChannelMembers,
    );

    testCapability(
      'FlagMessage',
      ChannelCapability.flagMessage,
      (channel) => channel.canFlagMessage,
    );

    testCapability(
      'MuteChannel',
      ChannelCapability.muteChannel,
      (channel) => channel.canMuteChannel,
    );

    testCapability(
      'SendCustomEvents',
      ChannelCapability.sendCustomEvents,
      (channel) => channel.canSendCustomEvents,
    );

    testCapability(
      'ReceiveReadEvents',
      ChannelCapability.readEvents,
      (channel) => channel.canReceiveReadEvents,
    );

    testCapability(
      'UseReadReceipts',
      ChannelCapability.readEvents,
      (channel) => channel.canUseReadReceipts,
    );

    testCapability(
      'ReceiveConnectEvents',
      ChannelCapability.connectEvents,
      (channel) => channel.canReceiveConnectEvents,
    );

    testCapability(
      'UseTypingEvents',
      ChannelCapability.typingEvents,
      (channel) => channel.canUseTypingEvents,
    );

    testCapability(
      'InSlowMode',
      ChannelCapability.slowMode,
      (channel) => channel.isInSlowMode,
    );

    testCapability(
      'SkipSlowMode',
      ChannelCapability.skipSlowMode,
      (channel) => channel.canSkipSlowMode,
    );

    testCapability(
      'SendPoll',
      ChannelCapability.sendPoll,
      (channel) => channel.canSendPoll,
    );

    testCapability(
      'CastPollVote',
      ChannelCapability.castPollVote,
      (channel) => channel.canCastPollVote,
    );

    testCapability(
      'QueryPollVotes',
      ChannelCapability.queryPollVotes,
      (channel) => channel.canQueryPollVotes,
    );

    testCapability(
      'UseDeliveryReceipts',
      ChannelCapability.deliveryEvents,
      (channel) => channel.canUseDeliveryReceipts,
    );

    testCapability(
      'ShareLocation',
      ChannelCapability.shareLocation,
      (channel) => channel.canShareLocation,
    );

    testCapability(
      'NotifyChannel',
      ChannelCapability.notifyChannel,
      (channel) => channel.canNotifyChannel,
    );

    testCapability(
      'NotifyHere',
      ChannelCapability.notifyHere,
      (channel) => channel.canNotifyHere,
    );

    testCapability(
      'NotifyRole',
      ChannelCapability.notifyRole,
      (channel) => channel.canNotifyRole,
    );

    testCapability(
      'NotifyGroup',
      ChannelCapability.notifyGroup,
      (channel) => channel.canNotifyGroup,
    );

    test('returns correct values with multiple capabilities', () {
      final channelState = _generateChannelState(
        channelId,
        channelType,
        ownCapabilities: [
          ChannelCapability.sendMessage,
          ChannelCapability.sendReply,
          ChannelCapability.deleteOwnMessage,
        ],
      );

      final channel = Channel.fromState(client, channelState);
      expect(channel.canSendMessage, true);
      expect(channel.canSendReply, true);
      expect(channel.canDeleteOwnMessage, true);
      expect(channel.canDeleteAnyMessage, false);
      expect(channel.canUpdateChannel, false);
    });

    group('usesLocalUnreadCount', () {
      // `isLocalUnreadCountEnabled` is a settable field on the mock and the
      // client is shared across the group, so reset it between tests.
      tearDown(() => client.isLocalUnreadCountEnabled = false);

      Channel channelWithReadEvents({required bool available}) {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [
            if (available) ChannelCapability.readEvents,
          ],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        return channel;
      }

      test('is false when disabled and read receipts are unavailable', () {
        client.isLocalUnreadCountEnabled = false;
        final channel = channelWithReadEvents(available: false);
        expect(channel.usesLocalUnreadCount, false);
      });

      test('is false when disabled and read receipts are available', () {
        client.isLocalUnreadCountEnabled = false;
        final channel = channelWithReadEvents(available: true);
        expect(channel.usesLocalUnreadCount, false);
      });

      test('is false when enabled but the channel supports read receipts', () {
        client.isLocalUnreadCountEnabled = true;
        final channel = channelWithReadEvents(available: true);
        expect(channel.usesLocalUnreadCount, false);
      });

      test('is true when enabled and read receipts are unavailable', () {
        client.isLocalUnreadCountEnabled = true;
        final channel = channelWithReadEvents(available: false);
        expect(channel.usesLocalUnreadCount, true);
      });
    });
  });
}

// region Test Helpers

ChannelState _generateChannelState(
  String channelId,
  String channelType, {
  DateTime? lastMessageAt,
  List<ChannelCapability>? ownCapabilities,
  bool mockChannelConfig = false,
}) {
  ChannelConfig? config;
  if (mockChannelConfig) {
    config = MockChannelConfig();
    when(() => config!.readEvents).thenReturn(true);
    when(() => config!.typingEvents).thenReturn(true);
  }
  final channel = ChannelModel(
    id: channelId,
    type: channelType,
    config: config,
    ownCapabilities: ownCapabilities,
    lastMessageAt: lastMessageAt,
  );
  return ChannelState(channel: channel);
}

Logger _createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}

// endregion

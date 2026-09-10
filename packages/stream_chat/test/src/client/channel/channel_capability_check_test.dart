// ignore_for_file: deprecated_member_use_from_same_package

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  // ============================================================
  // FEATURE: Capability Getters
  // ============================================================

  group('Channel Capability Check - Capability Getters', () {
    /// Parameterized test for channel capability extension properties.
    void testCapability(
      String capabilityName,
      ChannelCapability capability,
      bool Function(Channel) getterMethod,
    ) {
      channelTest(
        'can$capabilityName - should return false when capability is absent',
        setUp: (tester) => tester.watch(),
        body: (tester) async {
          expect(getterMethod(tester.channel), false);
        },
      );

      channelTest(
        'can$capabilityName - should return true when capability is present',
        setUp: (tester) => tester.watch(
          modifyResponse: (state) => state.copyWith(
            channel: createDefaultChannelModel(ownCapabilities: [capability]),
          ),
        ),
        body: (tester) async {
          expect(getterMethod(tester.channel), true);
        },
      );
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

    channelTest(
      'should return correct values with multiple capabilities',
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => state.copyWith(
          channel: createDefaultChannelModel(
            ownCapabilities: [
              ChannelCapability.sendMessage,
              ChannelCapability.sendReply,
              ChannelCapability.deleteOwnMessage,
            ],
          ),
        ),
      ),
      body: (tester) async {
        expect(tester.channel.canSendMessage, true);
        expect(tester.channel.canSendReply, true);
        expect(tester.channel.canDeleteOwnMessage, true);
        expect(tester.channel.canDeleteAnyMessage, false);
        expect(tester.channel.canUpdateChannel, false);
      },
    );
  });

  // ============================================================
  // FEATURE: Local Unread Count
  // ============================================================

  group('Channel Capability Check - Local Unread Count', () {
    channelTest(
      'usesLocalUnreadCount - should be false when disabled and read receipts are unavailable',
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        expect(tester.channel.usesLocalUnreadCount, false);
      },
    );

    channelTest(
      'usesLocalUnreadCount - should be false when disabled and read receipts are available',
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => state.copyWith(
          channel: createDefaultChannelModel(
            ownCapabilities: [ChannelCapability.readEvents],
          ),
        ),
      ),
      body: (tester) async {
        expect(tester.channel.usesLocalUnreadCount, false);
      },
    );

    channelTest(
      'usesLocalUnreadCount - should be false when enabled but the channel supports read receipts',
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => state.copyWith(
          channel: createDefaultChannelModel(
            ownCapabilities: [ChannelCapability.readEvents],
          ),
        ),
      ),
      body: (tester) async {
        expect(tester.channel.usesLocalUnreadCount, false);
      },
    );

    channelTest(
      'usesLocalUnreadCount - should be true when enabled and read receipts are unavailable',
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(),
      body: (tester) async {
        expect(tester.channel.usesLocalUnreadCount, true);
      },
    );
  });
}

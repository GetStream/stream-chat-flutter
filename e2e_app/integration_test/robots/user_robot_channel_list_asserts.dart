import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mock_server/data_types.dart';
import '../pages/channel_list_page.dart';
import '../support/widget_test_extensions.dart';
import 'participant_robot.dart';
import 'user_robot.dart';

extension UserRobotChannelListAsserts on UserRobot {
  /// Asserts the preview of the channel at [channelIndex] reads [text].
  ///
  /// [fromCurrentUser] picks the sender prefix the SDK puts in front of the
  /// message: `'You: '` for the current user, the sender's **first** name for
  /// anyone else, or no prefix at all when null (e.g. the empty-channel
  /// placeholder, which belongs to no sender).
  ///
  /// The other-sender prefix only exists because the mock server's channel has
  /// three members: the preview formatter labels the sender in group channels
  /// and stays bare in 1-on-1 ones.
  Future<UserRobot> assertMessageInChannelPreview(
    String text, {
    bool? fromCurrentUser,
    int channelIndex = 0,
  }) async {
    final expected = switch (fromCurrentUser) {
      true => 'You: $text',
      // The formatter keeps the prefix compact by using the first name only.
      false => '${ParticipantRobot.name.split(' ').first}: $text',
      null => text,
    };

    // The row is rebuilt as events land, so this polls for the expected text
    // rather than reading it once.
    await tester.expectRenderedText(_inChannel(ChannelListPage.channel.previewText, channelIndex), expected);
    return this;
  }

  Future<UserRobot> assertMessagePreviewTimestamp({
    bool isDisplayed = true,
    int channelIndex = 0,
  }) async {
    final timestamp = _inChannel(ChannelListPage.channel.timestamp, channelIndex);
    if (isDisplayed) {
      await tester.waitUntilVisible(timestamp);
    } else {
      await tester.waitUntilNotVisible(timestamp);
    }
    return this;
  }

  Future<UserRobot> assertChannelAvatar({int channelIndex = 0}) async {
    await tester.waitUntilVisible(_inChannel(ChannelListPage.channel.avatar, channelIndex));
    return this;
  }

  /// Asserts the delivery status shown on the channel preview at [channelIndex].
  Future<UserRobot> assertMessagePreviewDeliveryStatus(
    MessageDeliveryStatus status, {
    int channelIndex = 0,
  }) async {
    // Unlike in the message list, the channel preview builds no indicator at all
    // for a message the current user did not send, so `nil` is its absence
    // rather than an indicator that renders nothing.
    if (status == MessageDeliveryStatus.nil) {
      await tester.waitUntilNotVisible(_inChannel(ChannelListPage.channel.anySendingStatus, channelIndex));
      return this;
    }

    await tester.waitUntilVisible(_inChannel(ChannelListPage.channel.sendingStatus(status), channelIndex));
    return this;
  }

  /// Scrolls the channel list until [channelsCount] distinct channels have been
  /// rendered.
  ///
  /// Channels are counted by identity across scrolls rather than by row count:
  /// the list is lazy, so only a handful of rows exist at any moment, and
  /// counting identities is also independent of the order the channels arrive
  /// in.
  Future<UserRobot> assertChannelListPagination({required int channelsCount}) async {
    final seen = <String>{};
    void collectRenderedChannels() {
      for (final element in ChannelListPage.channels.evaluate()) {
        final channel = (element.widget as StreamChannelListItem).props.channel;
        // A rendered row always has an initialized channel, so `cid` is set —
        // and were it ever null, the ids would collide and the count would come
        // up short rather than pass falsely.
        seen.add('${channel.cid}');
      }
    }

    await tester.waitUntilVisible(ChannelListPage.channels);
    collectRenderedChannels();
    // Guards against a vacuous pass: only a few rows fit on screen, so reaching
    // the rest has to involve actual scrolling.
    expect(seen, hasLength(lessThan(channelsCount)));

    await tester.scrollDownUntil(
      () {
        collectRenderedChannels();
        return seen.length >= channelsCount;
      },
      description: 'all $channelsCount channels to be rendered',
    );
    expect(seen, hasLength(channelsCount));
    return this;
  }

  Future<UserRobot> assertChannelActionsSheetForGroupChannel() async {
    for (final label in const ['View Info', 'Pin Chat', 'Leave Group', 'Delete Group']) {
      await tester.waitUntilVisible(ChannelListPage.channelAction(label));
    }
    return this;
  }

  Future<UserRobot> assertGroupChannelInfoScreen() async {
    await tester.waitUntilVisible(ChannelInfoPage.groupInfoTitle);
    return this;
  }

  /// Asserts the user chooser — the app's start page — is shown.
  Future<UserRobot> assertStartPageIsShown() async {
    await tester.waitUntilVisible(find.text('Welcome to Stream Chat'));
    return this;
  }

  /// Asserts the channel list shows its loading skeleton.
  Future<UserRobot> assertChannelListIsLoading() async {
    // The skeleton is not exported, hence matching on the runtime type.
    await tester.waitUntilVisible(
      find.byWidgetPredicate((it) => it.runtimeType.toString() == 'StreamChannelListSkeletonLoading'),
    );
    return this;
  }

  Future<UserRobot> assertChannelListIsEmpty() async {
    await tester.waitUntilNotVisible(find.byType(ChannelListPage.channelTile));
    return this;
  }

  /// Asserts whether the channel row at [channelIndex] shows as muted.
  Future<UserRobot> assertChannelIsMuted({required bool isMuted, int channelIndex = 0}) async {
    final row = find.byType(ChannelListPage.channelTile).at(channelIndex);
    await tester.waitUntilVisible(row);
    bool muted() => tester.widget<StreamChannelListTile>(row).isMuted;
    final end = DateTime.now().add(const Duration(seconds: 30));
    while (muted() != isMuted && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(muted(), isMuted, reason: 'channel muted');
    return this;
  }

  Future<UserRobot> assertTypingIndicatorInChannelPreview({required bool isDisplayed, int channelIndex = 0}) async {
    final typing = _inChannel(ChannelListPage.channel.typingIndicator, channelIndex);
    if (isDisplayed) {
      await tester.waitUntilVisible(typing);
    } else {
      await tester.waitUntilNotVisible(typing);
    }
    return this;
  }

  /// Asserts the channel row at [channelIndex] is titled [name].
  Future<UserRobot> assertChannelName(String name, {required int channelIndex}) async {
    await tester.waitUntilVisible(_inChannel(find.text(name), channelIndex));
    return this;
  }

  /// Asserts the unread badge of the channel at [channelIndex] reads [count].
  Future<UserRobot> assertChannelUnreadCount(int count, {int channelIndex = 0}) async {
    final row = find.byType(ChannelListPage.channelTile).at(channelIndex);
    await tester.waitUntilVisible(row);
    final end = DateTime.now().add(const Duration(seconds: 30));
    int unread() => tester.widget<StreamChannelListTile>(row).unreadCount;
    while (unread() != count && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(unread(), count, reason: 'channel unread count');
    return this;
  }

  /// Asserts the channel list shows exactly [count] channels.
  Future<UserRobot> assertChannelCount(int count) async {
    final tiles = find.byType(ChannelListPage.channelTile);
    final end = DateTime.now().add(const Duration(seconds: 30));
    while (tiles.evaluate().length != count && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tiles, findsNWidgets(count));
    return this;
  }

  Future<UserRobot> assertChannelWithName(String name, {bool isDisplayed = true}) async {
    final channel = ChannelListPage.channelNamed(name);
    if (isDisplayed) {
      await tester.waitUntilVisible(channel);
    } else {
      await tester.waitUntilNotVisible(channel);
    }
    return this;
  }

  /// Scopes [finder] to the channel row at [channelIndex] (0 being the top of
  /// the list), so a neighbouring row can't satisfy an assertion.
  Finder _inChannel(Finder finder, int channelIndex) => find.descendant(
    of: find.byType(ChannelListPage.channelTile).at(channelIndex),
    matching: finder,
  );
}

/// Chainable counterparts to [UserRobotChannelListAsserts], so an assertion can
/// follow a fluent action chain.
extension UserRobotChannelListAssertsChain on Future<UserRobot> {
  Future<UserRobot> assertMessageInChannelPreview(
    String text, {
    bool? fromCurrentUser,
    int channelIndex = 0,
  }) => then(
    (it) => it.assertMessageInChannelPreview(text, fromCurrentUser: fromCurrentUser, channelIndex: channelIndex),
  );

  Future<UserRobot> assertMessagePreviewTimestamp({
    bool isDisplayed = true,
    int channelIndex = 0,
  }) => then((it) => it.assertMessagePreviewTimestamp(isDisplayed: isDisplayed, channelIndex: channelIndex));

  Future<UserRobot> assertChannelAvatar({int channelIndex = 0}) =>
      then((it) => it.assertChannelAvatar(channelIndex: channelIndex));

  Future<UserRobot> assertMessagePreviewDeliveryStatus(
    MessageDeliveryStatus status, {
    int channelIndex = 0,
  }) => then((it) => it.assertMessagePreviewDeliveryStatus(status, channelIndex: channelIndex));

  Future<UserRobot> assertChannelActionsSheetForGroupChannel() =>
      then((it) => it.assertChannelActionsSheetForGroupChannel());

  Future<UserRobot> assertGroupChannelInfoScreen() => then((it) => it.assertGroupChannelInfoScreen());

  Future<UserRobot> assertStartPageIsShown() => then((it) => it.assertStartPageIsShown());

  Future<UserRobot> assertChannelListIsLoading() => then((it) => it.assertChannelListIsLoading());

  Future<UserRobot> assertChannelListIsEmpty() => then((it) => it.assertChannelListIsEmpty());

  Future<UserRobot> assertChannelIsMuted({required bool isMuted, int channelIndex = 0}) =>
      then((it) => it.assertChannelIsMuted(isMuted: isMuted, channelIndex: channelIndex));

  Future<UserRobot> assertChannelUnreadCount(int count, {int channelIndex = 0}) =>
      then((it) => it.assertChannelUnreadCount(count, channelIndex: channelIndex));

  Future<UserRobot> assertTypingIndicatorInChannelPreview({required bool isDisplayed, int channelIndex = 0}) =>
      then((it) => it.assertTypingIndicatorInChannelPreview(isDisplayed: isDisplayed, channelIndex: channelIndex));

  Future<UserRobot> assertChannelName(String name, {required int channelIndex}) =>
      then((it) => it.assertChannelName(name, channelIndex: channelIndex));

  Future<UserRobot> assertChannelCount(int count) => then((it) => it.assertChannelCount(count));

  Future<UserRobot> assertChannelWithName(String name, {bool isDisplayed = true}) =>
      then((it) => it.assertChannelWithName(name, isDisplayed: isDisplayed));

  Future<UserRobot> assertChannelListPagination({required int channelsCount}) =>
      then((it) => it.assertChannelListPagination(channelsCount: channelsCount));
}

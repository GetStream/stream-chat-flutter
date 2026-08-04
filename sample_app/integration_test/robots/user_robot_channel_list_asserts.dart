import 'package:flutter/widgets.dart';
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

    final preview = _inChannel(ChannelListPage.channel.previewText, channelIndex);
    await tester.waitUntilVisible(preview);

    // The row is rebuilt as events land, so poll for the expected text and only
    // then assert — that way the failure message carries what it actually said.
    final end = DateTime.now().add(const Duration(seconds: 30));
    while (_renderedText(preview) != expected && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(_renderedText(preview), expected);
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

  /// Scopes [finder] to the channel row at [channelIndex] (0 being the top of
  /// the list), so a neighbouring row can't satisfy an assertion.
  Finder _inChannel(Finder finder, int channelIndex) => find.descendant(
    of: find.byType(ChannelListPage.channelTile).at(channelIndex),
    matching: finder,
  );

  /// The plain text the [Text] found by [finder] renders, or null when it isn't
  /// in the tree.
  ///
  /// A message preview is a `Text.rich` whose span can carry inline-icon
  /// [WidgetSpan]s (a deleted message, an attachment type). Dropping the
  /// placeholders leaves their separator spaces behind, hence collapsing the
  /// whitespace afterwards.
  String? _renderedText(Finder finder) {
    final elements = finder.evaluate();
    if (elements.isEmpty) return null;

    final text = elements.first.widget as Text;
    final rendered = text.data ?? text.textSpan?.toPlainText(includePlaceholders: false) ?? '';
    return rendered.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
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

  Future<UserRobot> assertChannelListPagination({required int channelsCount}) =>
      then((it) => it.assertChannelListPagination(channelsCount: channelsCount));
}

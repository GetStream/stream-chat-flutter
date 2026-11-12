import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

ScheduledMessage fakeScheduledMessage({
  String text = 'Can you review the venue shortlist?',
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  ScheduledMessageFailureReason? failureReason,
}) {
  return ScheduledMessage(
    cid: 'messaging:general',
    user: User(id: 'current-user-id'),
    message: Message(id: 'scheduled-id', text: text),
    scheduledAt: DateTime(2026, 10, 21, 8),
    status: status,
    failureReason: failureReason,
  );
}

/// Opens the actions on [scheduledMessage] and returns the list its result is
/// added to once the sheet resolves.
Future<List<ScheduledMessageAction?>> showActions(
  WidgetTester tester,
  ScheduledMessage scheduledMessage, {
  ScheduledMessageActionsBuilder? actionsBuilder,
  Map<String, Channel> channels = const {},
}) async {
  final results = <ScheduledMessageAction?>[];
  await tester.pumpWidget(
    wrapWithMaterialApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showStreamScheduledMessageActionsSheet(
            context: context,
            scheduledMessage: scheduledMessage,
            actionsBuilder: actionsBuilder,
          ).then(results.add),
          child: const Text('Open'),
        ),
      ),
      channels: channels,
    ),
  );

  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  return results;
}

List<String?> rowLabels(WidgetTester tester) {
  final actions = tester.widgetList<StreamScheduledMessageActionTile>(find.byType(StreamScheduledMessageActionTile));
  return [for (final action in actions) (action.label as Text).data];
}

/// Wraps [widget] in an app whose client has loaded [channels].
Widget wrapWithMaterialApp(Widget widget, {Map<String, Channel> channels = const {}}) {
  final client = MockClient();
  final clientState = MockClientState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));
  when(() => clientState.channels).thenReturn(channels);

  return MaterialApp(
    home: StreamChat(
      client: client,
      configData: StreamChatConfigurationData(),
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: Scaffold(body: Center(child: widget)),
    ),
  );
}

/// A loaded channel of the scheduled messages that allows scheduling unless
/// [canSchedule] is false.
Channel loadedChannel({bool canSchedule = true}) {
  final channel = MockChannel(
    type: 'messaging',
    id: 'general',
    ownCapabilities: [
      ChannelCapability.sendMessage,
      if (canSchedule) ChannelCapability.scheduleMessage,
    ],
  );
  final state = MockChannelState();
  when(() => channel.state).thenReturn(state);

  return channel;
}

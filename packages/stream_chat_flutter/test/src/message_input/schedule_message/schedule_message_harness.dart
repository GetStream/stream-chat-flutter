import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

/// A Wednesday morning in local time.
final wednesday = DateTime(2026, 10, 21, 10);

/// The cid of the [scheduleChannel].
const scheduleCid = 'test-chanel-type:test-channel-id';

/// The message the sheets schedule.
Message messageToSchedule() {
  return Message(id: 'message-id', text: 'Heads up: the launch moved to Monday.');
}

/// A message scheduled in the [scheduleChannel], or in the thread of
/// [parentId].
ScheduledMessage scheduledMessage(
  String id, {
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  String? parentId,
}) {
  return ScheduledMessage(
    id: id,
    cid: scheduleCid,
    user: User(id: 'current-user'),
    message: Message(id: id, text: 'Hello', parentId: parentId),
    scheduledAt: DateTime(2026, 10, 23, 9),
    status: status,
  );
}

/// A channel named "General", whose user holds [scheduledMessages].
///
/// Without [isCreated], the channel has no ID yet.
MockChannel scheduleChannel({
  bool canSchedule = true,
  bool isCreated = true,
  ChannelConfig? config,
  List<ScheduledMessage> scheduledMessages = const [],
  Stream<List<ScheduledMessage>>? scheduledMessagesStream,
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(
    // A channel that isn't created yet has no ID.
    id: isCreated ? 'test-channel-id' : null,
    ownCapabilities: [
      ChannelCapability.sendMessage,
      if (canSchedule) ChannelCapability.scheduleMessage,
    ],
  );
  final channelState = MockChannelState();
  final model = ChannelModel(
    cid: scheduleCid,
    config: config,
    extraData: const {'name': 'General'},
  );

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user'));
  when(() => clientState.scheduledMessages).thenReturn(scheduledMessages);
  when(
    () => clientState.scheduledMessagesStream,
  ).thenAnswer((_) => scheduledMessagesStream ?? Stream.value(scheduledMessages));
  when(() => channel.client).thenReturn(client);
  when(() => channel.config).thenReturn(config ?? ChannelConfig());
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.channelState).thenReturn(ChannelState(channel: model));
  when(() => channelState.members).thenReturn([]);

  return channel;
}

/// Wraps [widget] in an app with [channel] above its navigator, so the
/// sheets' routes are within it too.
Widget wrapWithMaterialApp(
  Widget widget, {
  required MockChannel channel,
  Brightness brightness = Brightness.light,
  StreamComponentBuilders? componentBuilders,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    builder: (context, child) => StreamChat(
      client: channel.client,
      componentBuilders: componentBuilders,
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: StreamChannel(channel: channel, child: child!),
    ),
    home: Builder(
      builder: (context) => Scaffold(
        backgroundColor: context.streamColorScheme.backgroundApp,
        body: Center(
          child: Padding(padding: const EdgeInsets.all(16), child: widget),
        ),
      ),
    ),
  );
}

/// A button labeled "Open" that calls [onPressed], for opening a sheet.
Widget openButton(void Function(BuildContext context) onPressed) {
  return Builder(
    builder: (context) => TextButton(
      onPressed: () => onPressed(context),
      child: const Text('Open'),
    ),
  );
}

/// Taps the [openButton] once the channel has loaded, and waits for the sheet
/// to settle.
Future<AsyncCallback?> tapOpenButton(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  return null;
}

/// Opens the schedule sheet for [channel] and returns the list its result is
/// added to once the sheet resolves.
Future<List<DateTime?>> showMessageSheet(
  WidgetTester tester,
  MockChannel channel,
) async {
  final results = <DateTime?>[];
  final button = openButton(
    (context) => showStreamScheduleMessageSheet(
      context: context,
      channel: channel,
      message: messageToSchedule(),
    ).then(results.add),
  );

  await tester.pumpWidget(wrapWithMaterialApp(button, channel: channel));
  await tapOpenButton(tester);
  return results;
}

/// Opens the custom time sheet for [channel] and returns the list its result
/// is added to once the sheet resolves.
Future<List<DateTime?>> showTimeSheet(
  WidgetTester tester,
  MockChannel channel, {
  DateTime? initialScheduledAt,
}) async {
  final results = <DateTime?>[];
  final button = openButton(
    (context) => showStreamScheduleTimeSheet(
      context: context,
      channel: channel,
      message: messageToSchedule(),
      initialScheduledAt: initialScheduledAt,
    ).then(results.add),
  );

  await tester.pumpWidget(wrapWithMaterialApp(button, channel: channel));
  await tapOpenButton(tester);
  return results;
}

/// The labels of the schedule sheet's rows, in order.
List<String?> rowLabels(WidgetTester tester) {
  final tiles = tester.widgetList<StreamListTile>(find.byType(StreamListTile));
  return [for (final tile in tiles) (tile.props.title! as Text).data];
}

/// The close button of the sheet on top.
Finder closeButton() => find.byTooltip('Close').last;

/// The custom time sheet's confirm button.
Finder confirmButton() => find.byTooltip('Schedule');

/// The custom time sheet's confirm button, as a widget.
StreamButton scheduleButton(WidgetTester tester) {
  final button = find.ancestor(of: confirmButton(), matching: find.byType(StreamButton));
  return tester.widget<StreamButton>(button.first);
}

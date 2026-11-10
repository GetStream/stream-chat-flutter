import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('offers edit, reschedule, send now and delete on a scheduled message', (tester) async {
    await _showActions(tester, _scheduledMessage());

    expect(_rowLabels(tester), ['Edit Message', 'Reschedule', 'Send now', 'Delete']);
  });

  testWidgets('offers edit and reschedule, and delete, on a failed message', (tester) async {
    final failed = _scheduledMessage(status: .failed, failureReason: .requestFailed);

    await _showActions(tester, failed);

    expect(_rowLabels(tester), ['Edit & reschedule', 'Delete']);
  });

  testWidgets('offers copy and delete on a message whose channel was deleted', (tester) async {
    final failed = _scheduledMessage(status: .failed, failureReason: .channelDeleted);

    await _showActions(tester, failed);

    expect(_rowLabels(tester), ['Copy Message', 'Delete']);
  });

  testWidgets('offers only delete on a message without text whose channel was deleted', (tester) async {
    final failed = _scheduledMessage(text: '', status: .failed, failureReason: .channelDeleted);

    await _showActions(tester, failed);

    expect(_rowLabels(tester), ['Delete']);
  });

  testWidgets('offers copy and delete on a message in an unknown status', (tester) async {
    await _showActions(tester, _scheduledMessage(status: const ScheduledMessageStatus('paused')));

    expect(_rowLabels(tester), ['Copy Message', 'Delete']);
  });

  for (final status in [
    ScheduledMessageStatus.preparingToSchedule,
    ScheduledMessageStatus.sending,
    ScheduledMessageStatus.sent,
    ScheduledMessageStatus.canceled,
  ]) {
    testWidgets('shows no sheet and resolves null for a message that is $status', (tester) async {
      final results = await _showActions(tester, _scheduledMessage(status: status));

      expect(find.byType(StreamListTile), findsNothing);
      expect(results, [null]);
    });
  }

  testWidgets('paints the delete row with the error color', (tester) async {
    await _showActions(tester, _scheduledMessage());

    final colorScheme = tester.element(find.byType(StreamListTile).first).streamColorScheme;
    expect(_labelColor(tester, 'Delete'), colorScheme.accentError);
    expect(_labelColor(tester, 'Edit Message'), isNot(colorScheme.accentError));
  });

  testWidgets('shows the rows added by actionsBuilder', (tester) async {
    await _showActions(
      tester,
      _scheduledMessage(),
      actionsBuilder: (context, defaultActions) => [
        ...defaultActions,
        StreamListTile(title: const Text('Pin'), onTap: () => Navigator.of(context).pop()),
      ],
    );

    expect(_rowLabels(tester), ['Edit Message', 'Reschedule', 'Send now', 'Delete', 'Pin']);
  });

  testWidgets('resolves null when a row added by actionsBuilder is tapped', (tester) async {
    final results = await _showActions(
      tester,
      _scheduledMessage(),
      actionsBuilder: (context, defaultActions) => [
        StreamListTile(title: const Text('Pin'), onTap: () => Navigator.of(context).pop()),
      ],
    );

    await tester.tap(find.text('Pin'));
    await tester.pumpAndSettle();

    expect(results, [null]);
  });

  testWidgets('resolves null when the sheet is dismissed', (tester) async {
    final results = await _showActions(tester, _scheduledMessage());

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byType(StreamListTile), findsNothing);
    expect(results, [null]);
  });

  for (final (label, actionType) in [
    ('Edit Message', EditScheduledMessage),
    ('Reschedule', RescheduleMessage),
    ('Send now', SendScheduledMessageNow),
    ('Delete', DeleteScheduledMessage),
  ]) {
    testWidgets('resolves $actionType carrying the message when "$label" is tapped', (tester) async {
      final scheduledMessage = _scheduledMessage();
      final results = await _showActions(tester, scheduledMessage);

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(results, hasLength(1));
      expect(results.single.runtimeType, actionType);
      expect(results.single?.scheduledMessage, scheduledMessage);
    });
  }

  testWidgets('resolves EditAndRescheduleMessage carrying the message when tapped', (tester) async {
    final failed = _scheduledMessage(status: .failed, failureReason: .requestFailed);
    final results = await _showActions(tester, failed);

    await tester.tap(find.text('Edit & reschedule'));
    await tester.pumpAndSettle();

    expect(results.single, isA<EditAndRescheduleMessage>());
    expect(results.single?.scheduledMessage, failed);
  });

  testWidgets('resolves CopyScheduledMessageText carrying the message when tapped', (tester) async {
    final failed = _scheduledMessage(status: .failed, failureReason: .channelDeleted);
    final results = await _showActions(tester, failed);

    await tester.tap(find.text('Copy Message'));
    await tester.pumpAndSettle();

    expect(results.single, isA<CopyScheduledMessageText>());
    expect(results.single?.scheduledMessage, failed);
  });
}

ScheduledMessage _scheduledMessage({
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

// Opens the actions on [scheduledMessage] and returns the list its result is
// added to once the sheet resolves.
Future<List<ScheduledMessageAction?>> _showActions(
  WidgetTester tester,
  ScheduledMessage scheduledMessage, {
  ScheduledMessageActionsBuilder? actionsBuilder,
}) async {
  final results = <ScheduledMessageAction?>[];
  await tester.pumpWidget(
    _wrapWithMaterialApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showStreamScheduledMessageActions(
            context,
            scheduledMessage: scheduledMessage,
            actionsBuilder: actionsBuilder,
          ).then(results.add),
          child: const Text('Open'),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  return results;
}

List<String?> _rowLabels(WidgetTester tester) {
  final tiles = tester.widgetList<StreamListTile>(find.byType(StreamListTile));
  return [for (final tile in tiles) (tile.props.title! as Text).data];
}

Color? _labelColor(WidgetTester tester, String label) {
  final text = tester.widget<RichText>(find.descendant(of: find.text(label), matching: find.byType(RichText)));
  return text.text.style?.color;
}

Widget _wrapWithMaterialApp(Widget widget) {
  final client = MockClient();
  final clientState = MockClientState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));

  return MaterialApp(
    home: StreamChat(
      client: client,
      configData: StreamChatConfigurationData(),
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: Scaffold(body: Center(child: widget)),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'showStreamScheduledMessageActionsSheet offers edit, reschedule, send now and delete on a scheduled message',
    (
      tester,
    ) async {
      await _showActions(tester, _scheduledMessage());

      expect(_rowLabels(tester), ['Edit Message', 'Reschedule', 'Send Now', 'Delete']);
    },
  );

  testWidgets('showStreamScheduledMessageActionsSheet offers edit and reschedule, and delete, on a failed message', (
    tester,
  ) async {
    final failed = _scheduledMessage(status: .failed, failureReason: .requestFailed);

    await _showActions(tester, failed);

    expect(_rowLabels(tester), ['Edit & Reschedule', 'Delete']);
  });

  testWidgets('showStreamScheduledMessageActionsSheet offers copy and delete on a message whose channel was deleted', (
    tester,
  ) async {
    final failed = _scheduledMessage(status: .failed, failureReason: .channelDeleted);

    await _showActions(tester, failed);

    expect(_rowLabels(tester), ['Copy Message', 'Delete']);
  });

  testWidgets(
    'showStreamScheduledMessageActionsSheet offers only delete on a message without text whose channel was deleted',
    (tester) async {
      final failed = _scheduledMessage(text: '', status: .failed, failureReason: .channelDeleted);

      await _showActions(tester, failed);

      expect(_rowLabels(tester), ['Delete']);
    },
  );

  for (final status in [
    ScheduledMessageStatus.preparingToSchedule,
    ScheduledMessageStatus.sending,
    ScheduledMessageStatus.sent,
    ScheduledMessageStatus.canceled,
    const ScheduledMessageStatus('paused'),
  ]) {
    testWidgets(
      'showStreamScheduledMessageActionsSheet shows no sheet and resolves null for a message that is $status',
      (
        tester,
      ) async {
        final results = await _showActions(tester, _scheduledMessage(status: status));

        expect(find.byType(_Action), findsNothing);
        expect(results, [null]);
      },
    );
  }

  testWidgets('showStreamScheduledMessageActionsSheet paints the delete row with the error color', (tester) async {
    await _showActions(tester, _scheduledMessage());

    final colorScheme = tester.element(find.byType(_Action).first).streamColorScheme;
    expect(_labelColor(tester, 'Delete'), colorScheme.accentError);
    expect(_labelColor(tester, 'Edit Message'), isNot(colorScheme.accentError));
  });

  testWidgets('showStreamScheduledMessageActionsSheet shows the rows added by actionsBuilder', (tester) async {
    await _showActions(
      tester,
      _scheduledMessage(),
      actionsBuilder: (context, defaultActions) => [
        ...defaultActions,
        const ListTile(title: Text('Pin')),
      ],
    );

    expect(_rowLabels(tester), ['Edit Message', 'Reschedule', 'Send Now', 'Delete']);
    expect(find.text('Pin'), findsOneWidget);
  });

  testWidgets('showStreamScheduledMessageActionsSheet lets actionsBuilder remove a default action by its value', (
    tester,
  ) async {
    await _showActions(
      tester,
      _scheduledMessage(),
      actionsBuilder: (context, defaultActions) => [
        ...defaultActions.where((it) => it.value is! SendScheduledMessageNow),
      ],
    );

    expect(_rowLabels(tester), ['Edit Message', 'Reschedule', 'Delete']);
  });

  testWidgets(
    'showStreamScheduledMessageActionsSheet resolves null when an added row closes the sheet without an action',
    (
      tester,
    ) async {
      final results = await _showActions(
        tester,
        _scheduledMessage(),
        actionsBuilder: (context, defaultActions) => [
          ListTile(title: const Text('Pin'), onTap: () => Navigator.of(context).pop()),
        ],
      );

      await tester.tap(find.text('Pin'));
      await tester.pumpAndSettle();

      expect(results, [null]);
    },
  );

  testWidgets('StreamScheduledMessageActionsBuilder offers no actions on a message being sent', (tester) async {
    late List<_Action> actions;
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        Builder(
          builder: (context) {
            actions = StreamScheduledMessageActionsBuilder.buildActions(
              context: context,
              scheduledMessage: _scheduledMessage(status: .sending),
            );
            return const SizedBox();
          },
        ),
      ),
    );

    expect(actions, isEmpty);
  });

  testWidgets('showStreamScheduledMessageActionsSheet resolves null when the sheet is dismissed', (tester) async {
    final results = await _showActions(tester, _scheduledMessage());

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byType(_Action), findsNothing);
    expect(results, [null]);
  });

  for (final (label, actionType) in [
    ('Edit Message', EditScheduledMessage),
    ('Reschedule', RescheduleMessage),
    ('Send Now', SendScheduledMessageNow),
    ('Delete', DeleteScheduledMessage),
  ]) {
    testWidgets(
      'showStreamScheduledMessageActionsSheet resolves $actionType carrying the message when "$label" is tapped',
      (
        tester,
      ) async {
        final scheduledMessage = _scheduledMessage();
        final results = await _showActions(tester, scheduledMessage);

        await tester.tap(find.text(label));
        await tester.pumpAndSettle();

        expect(results, hasLength(1));
        expect(results.single.runtimeType, actionType);
        expect(results.single?.scheduledMessage, scheduledMessage);
      },
    );
  }

  testWidgets(
    'showStreamScheduledMessageActionsSheet resolves EditAndRescheduleMessage carrying the message when tapped',
    (
      tester,
    ) async {
      final failed = _scheduledMessage(status: .failed, failureReason: .requestFailed);
      final results = await _showActions(tester, failed);

      await tester.tap(find.text('Edit & Reschedule'));
      await tester.pumpAndSettle();

      expect(results.single, isA<EditAndRescheduleMessage>());
      expect(results.single?.scheduledMessage, failed);
    },
  );

  testWidgets(
    'showStreamScheduledMessageActionsSheet resolves CopyScheduledMessageText carrying the message when tapped',
    (
      tester,
    ) async {
      final failed = _scheduledMessage(status: .failed, failureReason: .channelDeleted);
      final results = await _showActions(tester, failed);

      await tester.tap(find.text('Copy Message'));
      await tester.pumpAndSettle();

      expect(results.single, isA<CopyScheduledMessageText>());
      expect(results.single?.scheduledMessage, failed);
    },
  );
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
          onPressed: () => showStreamScheduledMessageActionsSheet(
            context: context,
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

typedef _Action = StreamScheduledMessageActionTile;

List<String?> _rowLabels(WidgetTester tester) {
  final actions = tester.widgetList<_Action>(find.byType(_Action));
  return [for (final action in actions) (action.label as Text).data];
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

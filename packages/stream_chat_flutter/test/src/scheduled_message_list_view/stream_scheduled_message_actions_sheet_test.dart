import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_actions_sheet_harness.dart';

void main() {
  testWidgets(
    'showStreamScheduledMessageActionsSheet resolves RetryScheduledMessage carrying the message when tapped',
    (
      tester,
    ) async {
      final failed = fakeScheduledMessage(status: .failed, failureReason: .requestFailed);
      final results = await showActions(tester, failed);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(results.single, isA<RetryScheduledMessage>());
      expect(results.single?.scheduledMessage, failed);
    },
  );

  testWidgets('showStreamScheduledMessageActionsSheet paints the delete row with the error color', (tester) async {
    await showActions(tester, fakeScheduledMessage());

    final colorScheme = tester.element(find.byType(StreamScheduledMessageActionTile).first).streamColorScheme;
    expect(_labelColor(tester, 'Delete'), colorScheme.accentError);
    expect(_labelColor(tester, 'Edit Message'), isNot(colorScheme.accentError));
  });

  testWidgets('showStreamScheduledMessageActionsSheet shows the rows added by actionsBuilder', (tester) async {
    await showActions(
      tester,
      fakeScheduledMessage(),
      actionsBuilder: (context, defaultActions) => [
        ...defaultActions,
        const ListTile(title: Text('Pin')),
      ],
    );

    expect(rowLabels(tester), ['Edit Message', 'Reschedule', 'Send Now', 'Delete']);
    expect(find.text('Pin'), findsOneWidget);
  });

  testWidgets('showStreamScheduledMessageActionsSheet lets actionsBuilder remove a default action by its value', (
    tester,
  ) async {
    await showActions(
      tester,
      fakeScheduledMessage(),
      actionsBuilder: (context, defaultActions) => [
        ...defaultActions.where((it) => it.value is! SendScheduledMessageNow),
      ],
    );

    expect(rowLabels(tester), ['Edit Message', 'Reschedule', 'Delete']);
  });

  testWidgets(
    'showStreamScheduledMessageActionsSheet resolves null when an added row closes the sheet without an action',
    (
      tester,
    ) async {
      final results = await showActions(
        tester,
        fakeScheduledMessage(),
        actionsBuilder: (context, defaultActions) => [
          ListTile(title: const Text('Pin'), onTap: () => Navigator.of(context).pop()),
        ],
      );

      await tester.tap(find.text('Pin'));
      await tester.pumpAndSettle();

      expect(results, [null]);
    },
  );

  testWidgets('showStreamScheduledMessageActionsSheet resolves null when the sheet is dismissed', (tester) async {
    final results = await showActions(tester, fakeScheduledMessage());

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byType(StreamScheduledMessageActionTile), findsNothing);
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
        final scheduledMessage = fakeScheduledMessage();
        final results = await showActions(tester, scheduledMessage);

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
      final failed = fakeScheduledMessage(status: .failed, failureReason: .requestFailed);
      final results = await showActions(tester, failed);

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
      final failed = fakeScheduledMessage(status: .failed, failureReason: .channelDeleted);
      final results = await showActions(tester, failed);

      await tester.tap(find.text('Copy Message'));
      await tester.pumpAndSettle();

      expect(results.single, isA<CopyScheduledMessageText>());
      expect(results.single?.scheduledMessage, failed);
    },
  );
}

Color? _labelColor(WidgetTester tester, String label) {
  final text = tester.widget<RichText>(find.descendant(of: find.text(label), matching: find.byType(RichText)));
  return text.text.style?.color;
}

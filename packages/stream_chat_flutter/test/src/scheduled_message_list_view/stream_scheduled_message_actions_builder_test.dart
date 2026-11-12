import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_actions_sheet_harness.dart';

void main() {
  testWidgets(
    'showStreamScheduledMessageActionsSheet offers edit, reschedule, send now and delete on a scheduled message',
    (
      tester,
    ) async {
      await showActions(tester, fakeScheduledMessage());

      expect(rowLabels(tester), ['Edit Message', 'Reschedule', 'Send Now', 'Delete']);
    },
  );

  testWidgets('showStreamScheduledMessageActionsSheet offers edit and reschedule, and delete, on a failed message', (
    tester,
  ) async {
    final failed = fakeScheduledMessage(status: .failed, failureReason: .internalError);

    await showActions(tester, failed);

    expect(rowLabels(tester), ['Edit & Reschedule', 'Delete']);
  });

  testWidgets('showStreamScheduledMessageActionsSheet also offers retry on a message whose request failed', (
    tester,
  ) async {
    final failed = fakeScheduledMessage(status: .failed, failureReason: .requestFailed);

    await showActions(tester, failed);

    expect(rowLabels(tester), ['Retry', 'Edit & Reschedule', 'Delete']);
  });

  testWidgets('showStreamScheduledMessageActionsSheet offers copy and delete on a message whose channel was deleted', (
    tester,
  ) async {
    final failed = fakeScheduledMessage(status: .failed, failureReason: .channelDeleted);

    await showActions(tester, failed);

    expect(rowLabels(tester), ['Copy Message', 'Delete']);
  });

  testWidgets(
    'showStreamScheduledMessageActionsSheet offers only delete on a message without text whose channel was deleted',
    (tester) async {
      final failed = fakeScheduledMessage(text: '', status: .failed, failureReason: .channelDeleted);

      await showActions(tester, failed);

      expect(rowLabels(tester), ['Delete']);
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
        final results = await showActions(tester, fakeScheduledMessage(status: status));

        expect(find.byType(StreamScheduledMessageActionTile), findsNothing);
        expect(results, [null]);
      },
    );
  }

  testWidgets('StreamScheduledMessageActionsBuilder offers no actions on a message being sent', (tester) async {
    late List<StreamScheduledMessageActionTile> actions;
    await tester.pumpWidget(
      wrapWithMaterialApp(
        Builder(
          builder: (context) {
            actions = StreamScheduledMessageActionsBuilder.buildActions(
              context: context,
              scheduledMessage: fakeScheduledMessage(status: .sending),
            );
            return const SizedBox();
          },
        ),
      ),
    );

    expect(actions, isEmpty);
  });
}

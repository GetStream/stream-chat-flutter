import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_list_item_harness.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessageListItem looks fine',
      fileName: 'stream_scheduled_message_list_item_scheduled_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      builder: () => wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage()),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessageListItem that failed looks fine',
      fileName: 'stream_scheduled_message_list_item_failed_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      builder: () => wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: failed()),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessageListItem uploading looks fine',
      fileName: 'stream_scheduled_message_list_item_uploading_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      // The spinner never settles, so pump a fixed frame instead.
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      },
      builder: () => wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: uploading()),
        brightness: brightness,
      ),
    );
  }
}

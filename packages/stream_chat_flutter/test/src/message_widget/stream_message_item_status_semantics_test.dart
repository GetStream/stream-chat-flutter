import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_semantics_scene.dart';

void main() {
  testWidgets('folds the sending status into the row label', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser),
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    final status = DefaultTranslations.instance.accessibility.messageSentStatusLabel;
    final labels = labelsOf(tester);

    // The status rides on the row phrase rather than costing a focus stop of
    // its own — an own text message is a single stop.
    expect(labels.single, endsWith(', $status'));

    handle.dispose();
  });

  testWidgets('omits the delivery status when the message does not show one', (tester) async {
    final handle = tester.ensureSemantics();

    // A stacked message hides its metadata, so there is no status on screen
    // for the announcement to mirror.
    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser),
        alignment: StreamMessageAlignment.end,
        stackPosition: StreamMessageStackPosition.middle,
      ),
    );
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('OUT:Are we still meeting tomorrow, AT-TIME'));
    expect(labelsOf(tester).where((it) => it.contains('Sent')), isEmpty);

    handle.dispose();
  });

  testWidgets('announces upload progress while attachments are sending', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(
          user: currentUser,
          state: MessageState.sending,
          attachments: [
            Attachment(type: AttachmentType.image, imageUrl: 'https://x/1.png'),
            Attachment(
              type: AttachmentType.image,
              imageUrl: 'https://x/2.png',
              uploadState: const UploadState.success(),
            ),
          ],
        ),
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    // The footer shows the progress count rather than a tick, so the phrase
    // carries it too instead of flattening to "Sending".
    expect(labelsOf(tester).first, endsWith(', UP:1/2'));
    expect(labelsOf(tester).first, isNot(contains('Sending')));

    handle.dispose();
  });

  testWidgets('announces a message that failed to send', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser, state: MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false)),
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    // The failure is shown as a badge on the bubble, which is a bare icon
    // with no text, so the row phrase is the only place it can be heard.
    final failed = DefaultTranslations.instance.accessibility.messageFailedStatusLabel;
    expect(labelsOf(tester).first, endsWith(', $failed'));

    handle.dispose();
  });

  testWidgets('renders an own message before the channel has been watched', (tester) async {
    // The row label tracks the read state to announce a delivery status, and
    // that state is null until the channel is watched. Reading it must not
    // cost the row the message it was wrapping.
    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser),
        alignment: StreamMessageAlignment.end,
        unwatchedChannel: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Are we still meeting tomorrow'), findsOneWidget);
  });

  testWidgets('announces an own message without a status before the channel has been watched', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser),
        alignment: StreamMessageAlignment.end,
        unwatchedChannel: true,
      ),
    );
    await tester.pumpAndSettle();

    // No read state means no status to mirror, so the row announces what it
    // does know rather than a status it cannot verify.
    expect(labelsOf(tester), contains('OUT:Are we still meeting tomorrow, AT-TIME'));

    handle.dispose();
  });
}

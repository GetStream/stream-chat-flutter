import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_semantics_scene.dart';

void main() {
  testWidgets('semanticsLabel replaces the composed label', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(buildMessageScene(testMessage(), semanticsLabel: 'CUSTOM'));
    await tester.pumpAndSettle();

    final labels = labelsOf(tester);
    expect(labels, contains('CUSTOM'));
    expect(labels.where((it) => it.startsWith('IN:')), isEmpty);
    // A custom label still speaks for the row, so the bubble stays silent.
    expect(find.bySemanticsLabel('Are we still meeting tomorrow'), findsNothing);

    handle.dispose();
  });

  testWidgets('excludeFromSemantics leaves the row unlabeled', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser),
        excludeFromSemantics: true,
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    // No composed phrase, so nothing appends a delivery status to one — an own
    // message would otherwise announce a bare ", Sent".
    expect(labelsOf(tester), isNot(contains(startsWith(','))));
    expect(labelsOf(tester), isNot(contains(startsWith('OUT:'))));

    handle.dispose();
  });

  testWidgets('excludeFromSemantics restores the pre-label node shape', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser),
        excludeFromSemantics: true,
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    // The row annotation is dropped entirely rather than applied with an empty
    // label: without `explicitChildNodes` holding them apart, the text and the
    // metadata merge back into the row's own tappable node. Opting out costs
    // no focus stop, where an empty label would have added several.
    final labels = labelsOf(tester);
    expect(labels, hasLength(1));
    expect(labels.single.split('\n'), containsAll(['Are we still meeting tomorrow', 'Sent', 'AT-TIME']));

    handle.dispose();
  });
}

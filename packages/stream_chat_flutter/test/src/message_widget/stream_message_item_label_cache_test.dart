import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_semantics_scene.dart';

// Counts how often the row asks the formatter for a body, which is the
// expensive half of composing the label: it runs after a full markdown parse.
class _CountingFormatter extends StreamMessagePreviewFormatter {
  int calls = 0;

  @override
  String formatMessageSemanticsLabel(
    BuildContext context,
    Message message, {
    ChannelModel? channel,
    User? currentUser,
    bool showCaption = true,
  }) {
    calls++;
    return super.formatMessageSemanticsLabel(
      context,
      message,
      channel: channel,
      currentUser: currentUser,
      showCaption: showCaption,
    );
  }
}

// Lets a test rebuild the row with the message unchanged, which a
// `ValueNotifier<Message>` cannot do: `Message` has value equality, so
// assigning an equal one notifies nobody.
class _MessageHolder extends ChangeNotifier implements ValueListenable<Message> {
  _MessageHolder(this._value);

  Message _value;

  @override
  Message get value => _value;

  set value(Message message) {
    _value = message;
    notifyListeners();
  }

  void rebuild() => notifyListeners();
}

void main() {
  testWidgets('composes the label once, not once per build', (tester) async {
    final handle = tester.ensureSemantics();
    final formatter = _CountingFormatter();

    final holder = _MessageHolder(testMessage(text: 'check [our docs](https://getstream.io) now'));
    addTearDown(holder.dispose);

    await tester.pumpWidget(
      buildMessageScene(
        holder.value,
        rebuildFrom: holder,
        configData: StreamChatConfigurationData(messagePreviewFormatter: formatter),
      ),
    );
    await tester.pumpAndSettle();

    final afterMount = formatter.calls;
    expect(afterMount, greaterThan(0));

    // Rebuilds that change nothing the label reads. Rows rebuild constantly in
    // a live channel — new messages, read receipts, typing events — and
    // re-parsing the markdown on each one is what this guards against.
    holder.rebuild();
    await tester.pumpAndSettle();
    holder.rebuild();
    await tester.pumpAndSettle();

    expect(formatter.calls, afterMount);

    handle.dispose();
  });

  testWidgets('recomposes the label when the message changes', (tester) async {
    final handle = tester.ensureSemantics();
    final formatter = _CountingFormatter();

    final holder = _MessageHolder(testMessage(text: 'first'));
    addTearDown(holder.dispose);

    await tester.pumpWidget(
      buildMessageScene(
        holder.value,
        rebuildFrom: holder,
        configData: StreamChatConfigurationData(messagePreviewFormatter: formatter),
      ),
    );
    await tester.pumpAndSettle();

    final afterMount = formatter.calls;
    expect(labelsOf(tester), contains('IN:Han Solo:first, AT-TIME'));

    // An edit has to move the announcement with it, so the cache cannot be
    // keyed on the row's identity alone.
    holder.value = testMessage(text: 'second');
    await tester.pumpAndSettle();

    expect(formatter.calls, greaterThan(afterMount));
    expect(labelsOf(tester), contains('IN:Han Solo:second, AT-TIME'));

    handle.dispose();
  });
}

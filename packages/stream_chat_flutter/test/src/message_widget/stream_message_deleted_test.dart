import 'package:alchemist/alchemist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_deleted.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  // The bubble is capped at the message item's max width, so the label has to
  // wrap rather than run past it. Guards the `Flexible` around the label.
  testWidgets('lays out a long label without overflowing', (tester) async {
    await tester.pumpWidget(_wrapWithApp(_deletedBubble(_longLabel)));

    expect(tester.takeException(), isNull);
  });

  testWidgets('lays out the default label without overflowing', (tester) async {
    await tester.pumpWidget(_wrapWithApp(_deletedBubble(_shortLabel)));

    expect(tester.takeException(), isNull);
  });

  testWidgets('wraps a long label onto more than one line', (tester) async {
    await tester.pumpWidget(_wrapWithApp(_deletedBubble(_shortLabel)));
    final singleLine = tester.getSize(find.byType(StreamMessageDeleted)).height;

    await tester.pumpWidget(_wrapWithApp(_deletedBubble(_longLabel)));
    final wrapped = tester.getSize(find.byType(StreamMessageDeleted)).height;

    expect(wrapped, greaterThan(singleLine));
  });

  testWidgets('keeps a long label within the bubble width', (tester) async {
    await tester.pumpWidget(_wrapWithApp(_deletedBubble(_longLabel)));

    final width = tester.getSize(find.byType(StreamMessageDeleted)).width;

    expect(width, lessThanOrEqualTo(_bubbleMaxWidth));
  });

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamMessageDeleted looks fine',
      fileName: 'stream_message_deleted_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 460, height: 420),
      // The app is themed once around the whole group; the scenarios below
      // vary only the label.
      builder: () => _wrapWithApp(
        brightness: brightness,
        GoldenTestGroup(
          columns: 1,
          children: [
            GoldenTestScenario(
              name: 'very short label — bubble hugs it',
              child: _deletedBubble(_tinyLabel, maxWidth: _goldenBubbleMaxWidth),
            ),
            GoldenTestScenario(
              name: 'short label',
              child: _deletedBubble(_shortLabel, maxWidth: _goldenBubbleMaxWidth),
            ),
            GoldenTestScenario(
              name: 'longest shipped translation',
              child: _deletedBubble(_longestShippedLabel, maxWidth: _goldenBubbleMaxWidth),
            ),
            GoldenTestScenario(
              name: 'long label wraps inside the bubble',
              child: _deletedBubble(_longLabel, maxWidth: _goldenBubbleMaxWidth),
            ),
          ],
        ),
      ),
    );
  }
}

// Mirrors the default `StreamMessageItemProps.maxWidth`, which is what caps
// the bubble in a real message list. Used by the layout tests, so they pin
// the real geometry.
const _bubbleMaxWidth = 272.0;

// The cap used by the goldens instead of [_bubbleMaxWidth].
//
// Every glyph in the test font is a square of the font size, so text measures
// far wider here than in a real app — at [_bubbleMaxWidth] even the English
// label would wrap, which is not what users see. Widening the cap absorbs that
// difference so the goldens show the line breaks a real font produces.
const _goldenBubbleMaxWidth = 350.0;

// Short enough that the bubble hugs it, showing it is not forced to full width.
const _tinyLabel = 'Del';

// The shipped English label.
const _shortLabel = 'Message deleted';

// The longest `messageDeletedLabel` in `stream_chat_localizations` that uses
// Latin script, so the golden renders it without needing extra fonts.
const _longestShippedLabel = 'Messaggio eliminato';

// Longer than any shipped translation, to show the wrapping behaviour.
const _longLabel = 'This message was deleted by a moderator';

// A [StreamMessageDeleted] reading [label], capped at [maxWidth].
Widget _deletedBubble(String label, {double maxWidth = _bubbleMaxWidth}) {
  return Builder(
    builder: (context) => Localizations.override(
      context: context,
      delegates: [_FixedLabelDelegate(label)],
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: const StreamMessageDeleted(),
        ),
      ),
    ),
  );
}

Widget _wrapWithApp(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: brightness,
      extensions: [StreamTheme(brightness: brightness)],
    ),
    home: Scaffold(
      backgroundColor: brightness == Brightness.dark ? const Color(0xFF101418) : const Color(0xFFF7F7F8),
      body: Center(child: child),
    ),
  );
}

// Serves a [StreamChatLocalizations] whose `messageDeletedLabel` is fixed.
class _FixedLabelDelegate extends LocalizationsDelegate<StreamChatLocalizations> {
  const _FixedLabelDelegate(this.label);

  final String label;

  @override
  bool isSupported(Locale locale) => true;

  @override
  SynchronousFuture<StreamChatLocalizations> load(Locale locale) {
    return SynchronousFuture(_FixedLabelTranslations(label));
  }

  @override
  bool shouldReload(_FixedLabelDelegate old) => old.label != label;
}

// A [StreamChatLocalizations] that only answers `messageDeletedLabel`.
//
// [StreamMessageDeleted] reads nothing else, so anything else reaching this
// stub is a mistake worth failing on rather than quietly defaulting.
class _FixedLabelTranslations implements StreamChatLocalizations {
  const _FixedLabelTranslations(this.messageDeletedLabel);

  @override
  final String messageDeletedLabel;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

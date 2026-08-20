import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamMessageTranslationState', () {
    test('shows the translation for every message by default', () {
      const state = StreamMessageTranslationState();

      expect(state.messagesShowingOriginalText, isEmpty);
      expect(state.isShowingOriginalText('message-1'), isFalse);
    });

    test('isShowingOriginalText only matches the tracked ids', () {
      const state = StreamMessageTranslationState(messagesShowingOriginalText: {'message-1'});

      expect(state.isShowingOriginalText('message-1'), isTrue);
      expect(state.isShowingOriginalText('message-2'), isFalse);
    });

    test('copyWith replaces the tracked ids', () {
      const state = StreamMessageTranslationState(messagesShowingOriginalText: {'message-1'});

      final copy = state.copyWith(messagesShowingOriginalText: const {'message-2'});

      expect(copy.messagesShowingOriginalText, const {'message-2'});
    });

    test('copyWith keeps the tracked ids when they are not provided', () {
      const state = StreamMessageTranslationState(messagesShowingOriginalText: {'message-1'});

      expect(state.copyWith().messagesShowingOriginalText, const {'message-1'});
    });

    test('compares equal by the tracked ids, not by set identity', () {
      const state = StreamMessageTranslationState(messagesShowingOriginalText: {'message-1', 'message-2'});
      final reorderedIds = {'message-2', 'message-1'};
      final equal = StreamMessageTranslationState(messagesShowingOriginalText: reorderedIds);
      const different = StreamMessageTranslationState(messagesShowingOriginalText: {'message-1'});

      expect(state, equal);
      expect(state.hashCode, equal.hashCode);
      expect(state, isNot(different));
    });
  });

  group('StreamMessageTranslationStore', () {
    late StreamMessageTranslationStore store;

    setUp(() => store = StreamMessageTranslationStore());
    tearDown(() => store.dispose());

    test('shows the translation for every message by default', () {
      expect(store.value, const StreamMessageTranslationState());
      expect(store.isShowingOriginalText('message-1'), isFalse);
    });

    test('toggleOriginalText switches a message to its original text', () {
      store.toggleOriginalText('message-1');

      expect(store.isShowingOriginalText('message-1'), isTrue);
    });

    test('toggleOriginalText switches a message back to its translation', () {
      store
        ..toggleOriginalText('message-1')
        ..toggleOriginalText('message-1');

      expect(store.isShowingOriginalText('message-1'), isFalse);
      expect(store.value.messagesShowingOriginalText, isEmpty);
    });

    test('tracks each message independently', () {
      store
        ..toggleOriginalText('message-1')
        ..toggleOriginalText('message-2')
        ..toggleOriginalText('message-1');

      expect(store.isShowingOriginalText('message-1'), isFalse);
      expect(store.isShowingOriginalText('message-2'), isTrue);
    });

    test('notifies listeners on every toggle', () {
      var notifications = 0;
      store
        ..addListener(() => notifications++)
        ..toggleOriginalText('message-1')
        ..toggleOriginalText('message-1');

      expect(notifications, 2);
    });

    test('does not notify listeners when the state is unchanged', () {
      store.toggleOriginalText('message-1');

      var notifications = 0;
      store
        ..addListener(() => notifications++)
        ..value = const StreamMessageTranslationState(messagesShowingOriginalText: {'message-1'});

      expect(notifications, 0);
    });
  });

  group('StreamMessageTranslations', () {
    late StreamMessageTranslationStore store;

    setUp(() => store = StreamMessageTranslationStore());
    tearDown(() => store.dispose());

    testWidgets('provides the store to its descendants', (tester) async {
      StreamMessageTranslationStore? found;

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: Builder(
            builder: (context) {
              found = StreamMessageTranslations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(found, same(store));
    });

    testWidgets('returns null without an ancestor scope', (tester) async {
      StreamMessageTranslationStore? found;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            found = StreamMessageTranslations.of(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(found, isNull);
    });

    testWidgets('a nested scope shadows the outer store, the way an open thread does', (tester) async {
      final threadStore = StreamMessageTranslationStore();
      addTearDown(threadStore.dispose);

      StreamMessageTranslationStore? found;

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: StreamMessageTranslations(
            store: threadStore,
            child: Builder(
              builder: (context) {
                found = StreamMessageTranslations.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(found, same(threadStore));

      // Toggling in the thread leaves the channel list's own state alone.
      threadStore.toggleOriginalText('message-1');

      expect(store.isShowingOriginalText('message-1'), isFalse);
    });

    testWidgets('keeps a toggle across a message item being disposed and recreated', (tester) async {
      var showsOriginalText = false;

      Widget buildScope({required bool itemIsInRenderWindow}) {
        return StreamMessageTranslations(
          store: store,
          child: switch (itemIsInRenderWindow) {
            false => const SizedBox.shrink(),
            true => Builder(
              builder: (context) {
                final store = StreamMessageTranslations.of(context)!;
                showsOriginalText = store.isShowingOriginalText('message-1');
                return const SizedBox.shrink();
              },
            ),
          },
        );
      }

      await tester.pumpWidget(buildScope(itemIsInRenderWindow: true));
      expect(showsOriginalText, isFalse);

      store.toggleOriginalText('message-1');
      await tester.pump();
      expect(showsOriginalText, isTrue);

      // The item scrolls out of the list's render window and is disposed...
      showsOriginalText = false;
      await tester.pumpWidget(buildScope(itemIsInRenderWindow: false));

      // ...then scrolls back in, rebuilt from scratch as a new element.
      await tester.pumpWidget(buildScope(itemIsInRenderWindow: true));

      expect(showsOriginalText, isTrue);
    });

    testWidgets('rebuilds its descendants when a message is toggled', (tester) async {
      var builds = 0;

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: Builder(
            builder: (context) {
              StreamMessageTranslations.of(context);
              builds++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(builds, 1);

      store.toggleOriginalText('message-1');
      await tester.pump();

      expect(builds, 2);
    });
  });
}

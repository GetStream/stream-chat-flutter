import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('StreamMessageTranslationState', () {
    /// Returns the state of a store that has toggled [messageIds], in order.
    StreamMessageTranslationState stateShowingOriginalText(List<String> messageIds) {
      final store = StreamMessageTranslationStore();
      addTearDown(store.dispose);
      messageIds.forEach(store.toggleOriginalText);
      return store.value;
    }

    test('shows the translation for every message by default', () {
      final state = stateShowingOriginalText([]);

      expect(state.messagesShowingOriginalText, isEmpty);
      expect(state.isShowingOriginalText('message-1'), isFalse);
    });

    test('isShowingOriginalText only matches the tracked ids', () {
      final state = stateShowingOriginalText(['message-1']);

      expect(state.isShowingOriginalText('message-1'), isTrue);
      expect(state.isShowingOriginalText('message-2'), isFalse);
    });

    test('exposes the tracked ids as an unmodifiable set', () {
      final state = stateShowingOriginalText(['message-1']);

      expect(() => state.messagesShowingOriginalText.add('message-2'), throwsUnsupportedError);
      expect(() => state.messagesShowingOriginalText.remove('message-1'), throwsUnsupportedError);
    });

    test('compares equal by the tracked ids, not by set identity', () {
      final state = stateShowingOriginalText(['message-1', 'message-2']);
      final equal = stateShowingOriginalText(['message-2', 'message-1']);
      final different = stateShowingOriginalText(['message-1']);

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
      expect(store.value.messagesShowingOriginalText, isEmpty);
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

      // An equal state from another store, so the dedup cannot rely on the
      // two being the same instance.
      final equivalent = StreamMessageTranslationStore()..toggleOriginalText('message-1');
      addTearDown(equivalent.dispose);

      var notifications = 0;
      store
        ..addListener(() => notifications++)
        ..value = equivalent.value;

      expect(notifications, 0);
    });

    test('clear switches every message back to its translation', () {
      store
        ..toggleOriginalText('message-1')
        ..toggleOriginalText('message-2')
        ..clear();

      expect(store.isShowingOriginalText('message-1'), isFalse);
      expect(store.isShowingOriginalText('message-2'), isFalse);
    });

    test('clear does not notify listeners when nothing is toggled', () {
      var notifications = 0;
      store
        ..addListener(() => notifications++)
        ..clear();

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

    testWidgets('maybeOf returns null without an ancestor scope', (tester) async {
      StreamMessageTranslationStore? found;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            found = StreamMessageTranslations.maybeOf(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(found, isNull);
    });

    testWidgets('of throws without an ancestor scope', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            StreamMessageTranslations.of(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (it) => it.message,
          'message',
          contains('StreamMessageTranslations was requested with a context that does not contain'),
        ),
      );
    });

    testWidgets('a nested scope shadows the outer store, isolating that subtree', (tester) async {
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

      // Toggling inside the nested scope leaves the outer store alone.
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
                final store = StreamMessageTranslations.of(context);
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

    testWidgets('StreamChat provides a store, so no explicit scope is needed', (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user'));

      StreamMessageTranslationStore? found;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
            child: Builder(
              builder: (context) {
                found = StreamMessageTranslations.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(found, isNotNull);
      expect(tester.takeException(), isNull);

      // The same store is handed to every subtree under StreamChat, which is
      // what lets a channel list and its open thread agree on a toggle.
      found!.toggleOriginalText('message-1');
      expect(found!.isShowingOriginalText('message-1'), isTrue);
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

    testWidgets('of narrows the dependency to the given message', (tester) async {
      var builds = 0;

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: Builder(
            builder: (context) {
              StreamMessageTranslations.of(context, messageId: 'message-1');
              builds++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(builds, 1);

      store.toggleOriginalText('message-2');
      await tester.pump();

      expect(builds, 1);

      store.toggleOriginalText('message-1');
      await tester.pump();

      expect(builds, 2);
    });

    testWidgets('isShowingOriginalTextOf reports the state of the given message', (tester) async {
      var showsOriginalText = false;

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: Builder(
            builder: (context) {
              showsOriginalText = StreamMessageTranslations.isShowingOriginalTextOf(context, 'message-1');
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(showsOriginalText, isFalse);

      store.toggleOriginalText('message-1');
      await tester.pump();

      expect(showsOriginalText, isTrue);
    });

    testWidgets('isShowingOriginalTextOf rebuilds only the message that was toggled', (tester) async {
      var firstBuilds = 0;
      var secondBuilds = 0;

      Widget messageBuilder(String messageId, VoidCallback onBuild) {
        return Builder(
          builder: (context) {
            StreamMessageTranslations.isShowingOriginalTextOf(context, messageId);
            onBuild();
            return const SizedBox.shrink();
          },
        );
      }

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: Column(
            children: [
              messageBuilder('message-1', () => firstBuilds++),
              messageBuilder('message-2', () => secondBuilds++),
            ],
          ),
        ),
      );

      expect((firstBuilds, secondBuilds), (1, 1));

      store.toggleOriginalText('message-1');
      await tester.pump();

      expect((firstBuilds, secondBuilds), (2, 1));
    });

    testWidgets('isShowingOriginalTextOf throws without an ancestor scope', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            StreamMessageTranslations.isShowingOriginalTextOf(context, 'message-1');
            return const SizedBox.shrink();
          },
        ),
      );

      expect(tester.takeException(), isFlutterError);
    });

    testWidgets('toggleOriginalText toggles through the nearest scope', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      StreamMessageTranslations.toggleOriginalText(capturedContext, 'message-1');
      expect(store.isShowingOriginalText('message-1'), isTrue);

      StreamMessageTranslations.toggleOriginalText(capturedContext, 'message-1');
      expect(store.isShowingOriginalText('message-1'), isFalse);
    });

    testWidgets('toggleOriginalText does not make its caller depend on the scope', (tester) async {
      var builds = 0;
      late BuildContext capturedContext;

      await tester.pumpWidget(
        StreamMessageTranslations(
          store: store,
          child: Builder(
            builder: (context) {
              capturedContext = context;
              builds++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(builds, 1);

      StreamMessageTranslations.toggleOriginalText(capturedContext, 'message-1');
      await tester.pump();

      expect(builds, 1);
    });

    testWidgets('toggleOriginalText throws without an ancestor scope', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(
        () => StreamMessageTranslations.toggleOriginalText(capturedContext, 'message-1'),
        throwsA(isFlutterError),
      );
    });
  });

  group('StreamMessageTranslationConfiguration', () {
    test('translates messages without annotating them by default', () {
      const config = StreamMessageTranslationConfiguration();

      expect(config.enabled, isTrue);
      expect(config.annotationEnabled, isFalse);
    });

    test('copyWith replaces only the given fields', () {
      const config = StreamMessageTranslationConfiguration();

      final annotated = config.copyWith(annotationEnabled: true);
      expect(annotated.enabled, isTrue);
      expect(annotated.annotationEnabled, isTrue);

      final disabled = annotated.copyWith(enabled: false);
      expect(disabled.enabled, isFalse);
      expect(disabled.annotationEnabled, isTrue);
    });

    test('copyWith without arguments keeps every field', () {
      const config = StreamMessageTranslationConfiguration(enabled: false, annotationEnabled: true);

      final copy = config.copyWith();
      expect(copy.enabled, isFalse);
      expect(copy.annotationEnabled, isTrue);
    });
  });
}

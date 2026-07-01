# Writing effective tests

This guide is about **how to write good tests**, not how to run them or which testing
tools to use. For repo-level testing conventions (mocking library, golden tests,
`mocktail`, `alchemist`, self-containment), see the
[Testing section of STYLE_GUIDE.md](STYLE_GUIDE.md#testing).

This document is adapted from Flutter's
[Writing-Effective-Tests](https://github.com/flutter/flutter/blob/master/docs/contributing/testing/Writing-Effective-Tests.md).

Tests are a critical tool for stability and education. They fulfill three roles:

- Automatically protect against regressions.
- Define an executable specification that captures original intent.
- Educate other developers about why and how to use an API.

To support those roles, four practices matter more than any others.

## Name tests based on the behavior being tested

Tests often get named after the object under test rather than the behavior. That
communicates nothing to the reader — the object is already visible from the file
being edited.

```dart
// BAD — the reader already knows we're testing StreamMessageListController.
test('StreamMessageListController', () { ... });

// BAD — same problem.
test('Channel.watch', () { ... });
```

Instead, name the test after the behavior or the expected outcome:

```dart
// GOOD
test('StreamMessageListController appends new messages to the end of the list', () { ... });

// GOOD
test('Channel.watch throws when called on a disposed channel', () { ... });

// GOOD
testWidgets('StreamMessageComposer disables the send button while a file is uploading', (tester) async { ... });
```

A reader scanning `flutter test`'s output should be able to tell what broke from the
test name alone, without opening the file.

## One behavior per test

A single test that exercises multiple behaviors turns a failure report into a mystery:
is one thing broken, or many? Is one method broken, or an interaction between three?

```dart
// BAD — this test exercises three behaviors.
test('Message state transitions', () {
  expect(Message().state, isA<MessageInitial>());
  final sending = Message().copyWith(state: MessageState.sending);
  expect(sending.state, isA<MessageOutgoing>());
  expect(() => sending.copyWith(state: null), throwsA(isA<AssertionError>()));
});
```

Split into one behavior per test:

```dart
// GOOD
test('Message defaults to MessageInitial state', () {
  expect(Message().state, isA<MessageInitial>());
});

test('Message.copyWith(state: sending) produces a MessageOutgoing state', () {
  final message = Message().copyWith(state: MessageState.sending);
  expect(message.state, isA<MessageOutgoing>());
});

test('Message.copyWith throws when state is null', () {
  expect(
    () => Message().copyWith(state: null),
    throwsA(isA<AssertionError>()),
  );
});
```

**What counts as "one behavior"?** Usually one method call with one assertion. There
are cases where multiple calls represent a single behavior (e.g. "when the WebSocket
disconnects and then reconnects, missed messages are re-fetched") — use your
judgment. A larger number of shorter tests beats a smaller number of longer ones.

## Only include relevant details in a test

Tests often need setup that isn't part of the behavior under test. When that setup
lives inline, readers can't easily tell which parts of the fixture matter and which
are noise.

```dart
// BAD — the setup dwarfs the behavior being tested.
testWidgets('StreamChannelListView shows an empty state when there are no channels', (tester) async {
  final client = MockStreamChatClient();
  when(() => client.state).thenReturn(MockClientState());
  when(() => client.wsConnectionStatus).thenReturn(ConnectionStatus.connected);
  when(() => client.on(any())).thenAnswer((_) => const Stream.empty());
  final controller = StreamChannelListController(client: client, filter: Filter.equal('type', 'messaging'));
  await controller.doInitialLoad();

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        child: Scaffold(
          body: StreamChannelListView(
            controller: controller,
            emptyBuilder: (context) => const Text('No channels'),
          ),
        ),
      ),
    ),
  );

  expect(find.text('No channels'), findsOneWidget);
});
```

Extract the setup into a helper named for its purpose. The behavior under test
becomes visible at a glance.

```dart
// GOOD — the test reads as a specification.
testWidgets('StreamChannelListView shows an empty state when there are no channels', (tester) async {
  final controller = await _emptyChannelListController();

  await _pumpChannelListView(tester, controller: controller);

  expect(find.text('No channels'), findsOneWidget);
});
```

The helpers (`_emptyChannelListController`, `_pumpChannelListView`) live at the bottom
of the test file. Their names tell the reader what they do; the reader doesn't need to
look inside unless something breaks.

## Optimize tests for comprehension

Even a well-factored test benefits from small edits that separate "the thing under
test" from "the actions we take on it".

```dart
// OK — but the widget-being-tested and the action-being-taken are entangled.
testWidgets('Tapping a message opens the reaction picker', (tester) async {
  await _pumpMessageWidget(
    tester,
    message: Message(id: 'm1', text: 'hi'),
    onReactionPicker: () {},
  );

  await tester.longPress(find.text('hi'));
  await tester.pumpAndSettle();

  expect(find.byType(StreamReactionPicker), findsOneWidget);
});
```

Extract the message and let the test name the two moving parts explicitly:

```dart
// GOOD — the message is named and the action is a separate line.
testWidgets('Tapping a message opens the reaction picker', (tester) async {
  final message = Message(id: 'm1', text: 'hi');

  await _pumpMessageWidget(tester, message: message);
  await tester.longPress(find.text('hi'));
  await tester.pumpAndSettle();

  expect(find.byType(StreamReactionPicker), findsOneWidget);
});
```

The difference is small but real: on a scan, the reader sees "here is the message,
here is the interaction, here is the assertion" as three separate ideas instead of
one blob of arguments to `_pumpMessageWidget`.

When writing a test, imagine the developer who will read it six months from now.
Anything you can do to help that reader understand what and why the test is checking
is worth doing.

## See also

- [STYLE_GUIDE.md — Testing](STYLE_GUIDE.md#testing) — repo-level testing conventions
  (mocktail, alchemist golden tests, self-contained tests, `addTearDown`).
- Flutter's [Writing-Effective-Tests](https://github.com/flutter/flutter/blob/master/docs/contributing/testing/Writing-Effective-Tests.md)
  — the source this guide was adapted from.

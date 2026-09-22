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
// BAD — the reader already knows we're testing StreamChannelListController.
test('StreamChannelListController', () { ... });

// BAD — same problem.
test('Channel.watch', () { ... });
```

Instead, name the test after the behavior or the expected outcome:

```dart
// GOOD
test('StreamChannelListController appends new channels when pagination advances', () { ... });

// GOOD
test('Channel.watch throws StateError when called after the channel is disposed', () { ... });

// GOOD
testWidgets('StreamMessageComposer clears its text after the message is sent', (tester) async { ... });
```

A reader scanning `flutter test`'s output should be able to tell what broke from the
test name alone, without opening the file.

## One behavior per test

A single test that exercises multiple behaviors turns a failure report into a mystery:
is one thing broken, or many? Is one method broken, or an interaction between three?

```dart
// BAD — this test exercises three behaviors.
test('Message.copyWith', () {
  final base = Message(text: 'hi');
  expect(base.copyWith(text: 'bye').text, equals('bye'));
  expect(base.copyWith().text, equals('hi'));
  expect(base.copyWith(text: 'bye').id, equals(base.id));
});
```

Split into one behavior per test:

```dart
// GOOD
test('Message.copyWith overrides the text field with the argument', () {
  final base = Message(text: 'hi');
  expect(base.copyWith(text: 'bye').text, equals('bye'));
});

test('Message.copyWith preserves the original text when text is omitted', () {
  final base = Message(text: 'hi');
  expect(base.copyWith().text, equals('hi'));
});

test('Message.copyWith preserves the id across copies', () {
  final base = Message(text: 'hi');
  expect(base.copyWith(text: 'bye').id, equals(base.id));
});
```

**What counts as "one behavior"?** Usually one method call with one assertion. There
are cases where multiple calls represent a single behavior (e.g. "when the WebSocket
disconnects and then reconnects, missed messages are re-fetched") — use your
judgment. A larger number of shorter tests beats a smaller number of longer ones.

## Assert thrown errors with `throwsA`, never a bare `try`/`catch`

A `try`/`catch` that asserts inside the `catch` asserts *nothing* when the code stops
throwing: the `catch` body never runs, and the test stays green.

```dart
// BAD — still passes after the `name` setter's guard is deleted.
test('should throw if trying to set `name`', () {
  try {
    channel.name = 'New name';
  } catch (e) {
    expect(e, isA<StateError>());
  }
});
```

Use `throwsA`, which fails when nothing is thrown:

```dart
// GOOD — synchronous throw.
expect(() => channel.name = 'New name', throwsA(isA<StateError>()));

// GOOD — asynchronous throw.
await expectLater(
  channel.markUnread('message-id-123'),
  throwsA(isA<StreamChatError>()),
);
```

An error can leave a call two ways, and they need different forms:

1. **Thrown synchronously** — the call raises before it returns a `Future` at all.
2. **Delivered asynchronously** — the call returns a `Future` that completes with an
   error.

`throwsA` covers both, but only when it can invoke the call itself. Passing a future
directly only ever covers the second case: in the first, the call throws while Dart is
still evaluating the argument, so `expectLater` never runs and the error escapes as a
raw failure instead of a matcher message.

The call site doesn't tell you which one you have: `async` is part of the declaration,
not the return type — `Future<T> foo()` can throw synchronously,
`Future<T> foo() async` never does. An `async` body's throws are captured into the
returned future even when they happen before the first `await`. So wrap the call in a
closure whenever it might throw synchronously, and whenever you are not sure:

```dart
// `pinMessage` is not `async`, and validates in an `assert` before its first
// `await` — so it throws synchronously even though it returns a `Future`.
await expectLater(
  () => channel.pinMessage(message, timeoutOrExpirationDate: 'invalid'),
  throwsA(isA<ArgumentError>()),
);
```

For an `async` method, which can only fail the second way, passing the future directly
(as in the `markUnread` example above) is fine and reads better.

To assert on the error's fields, compose the matcher with `having` instead of casting
inside a `catch`:

```dart
await expectLater(
  channel.sendMessage(message),
  throwsA(
    isA<StreamChatNetworkError>()
        .having((it) => it.code, 'code', ChatErrorCode.notAllowed.code),
  ),
);
```

Where `throwsA` does not fit — an error raised inside a widget `builder`, or one wrapped
in a type you have to unwrap before asserting — capture the error and assert **outside**
the `try`, so a missing throw leaves the variable `null` and the matcher fails:

```dart
Object? caught;
try {
  StreamChannel.of(context);
} catch (error) {
  caught = error;
}

expect(caught, isA<FlutterError>());
```

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
testWidgets('Long-pressing a message opens the reaction picker', (tester) async {
  await _pumpMessageWidget(
    tester,
    message: Message(id: 'm1', text: 'hi'),
    onReactionPicker: () {},
  );

  await tester.longPress(find.text('hi'));
  await tester.pumpAndSettle();

  expect(find.byType(StreamMessageReactionPicker), findsOneWidget);
});
```

Extract the message and let the test name the two moving parts explicitly:

```dart
// GOOD — the message is named and the action is a separate line.
testWidgets('Long-pressing a message opens the reaction picker', (tester) async {
  final message = Message(id: 'm1', text: 'hi');

  await _pumpMessageWidget(tester, message: message);
  await tester.longPress(find.text('hi'));
  await tester.pumpAndSettle();

  expect(find.byType(StreamMessageReactionPicker), findsOneWidget);
});
```

The difference is small but real: on a scan, the reader sees "here is the message,
here is the interaction, here is the assertion" as three separate ideas instead of
one blob of arguments to `_pumpMessageWidget`.

When writing a test, imagine the developer who will read it six months from now.
Anything you can do to help that reader understand what and why the test is checking
is worth doing.

## `group` is for shared preconditions, not for organizing a file

Reach for `group(...)` when several tests share a precondition that's worth stating
once: "when the message is outside the loaded window", "when the current user is
anonymous", "when the connection is offline". The group description names the
precondition; the test descriptions inside name the behaviors that follow from it.

```dart
group('when the message is outside the loaded window', () {
  test('does not insert an unknown message into the state', () async { ... });
  test('updates a known message in place', () async { ... });
});
```

Do not use `group` to organize a file by method or class — that's what the file
itself is for. If a `group` is doing the work a separate file should be doing,
[split the file instead](STYLE_GUIDE.md#prefer-more-test-files-avoid-long-test-files).
Nested groups more than one level deep are almost always a signal to split.

## A failing golden on a local run is not necessarily a regression

Committed goldens are always generated on CI, so they encode that host's font
hinting and antialiasing. A local `flutter test` renders differently, and will
report golden failures that have nothing to do with your change. Never conclude
"my change broke these goldens" from a local run alone, and never conclude the
opposite either — that a green local run means you changed nothing visually.

To find out what your change actually affected, compare **two local runs** instead
of comparing against the committed PNGs:

```bash
# 1. with your change reverted (git stash), regenerate and keep a copy
GITHUB_ACTIONS=true flutter test --update-goldens
cp -R <goldens/ci dirs> /tmp/baseline/

# 2. restore your change, regenerate again, and diff the two sets
GITHUB_ACTIONS=true flutter test --update-goldens
```

Whatever differs between the two sets is genuinely yours; everything else is host
drift. Amplifying the pixel diff (e.g. with PIL) makes a subtle change easy to
confirm.

Two things that make this easy to get wrong:

- Only `goldens/ci/` is committed — `goldens/<platform>/` is gitignored. A local
  run silently rewrites the platform goldens and `git status` stays clean, so an
  empty `git status` is not evidence that nothing changed.
- Alchemist picks CI goldens off the `GITHUB_ACTIONS` environment variable (see
  `test/flutter_test_config.dart`). Without it you are exercising the gitignored
  platform goldens, not the ones CI compares against.

Regenerate committed goldens with the `update_goldens` GitHub Action, never from
your machine — see [Golden tests in STYLE_GUIDE.md](STYLE_GUIDE.md#golden-tests).

## See also

- [STYLE_GUIDE.md — Testing](STYLE_GUIDE.md#testing) — repo-level testing conventions
  (mocktail, alchemist golden tests, self-contained tests, `addTearDown`).
- Flutter's [Writing-Effective-Tests](https://github.com/flutter/flutter/blob/master/docs/contributing/testing/Writing-Effective-Tests.md)
  — the source this guide was adapted from.

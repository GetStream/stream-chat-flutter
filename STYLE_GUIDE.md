# Style guide for stream-chat-flutter

This style guide is adapted from the [Flutter repository's style guide](https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md).
Where our conventions differ, the divergence is called out inline so readers understand
the choice was deliberate.

The primary audience is contributors (human and AI) working inside this monorepo. If you
are integrating the SDK into your own app, follow whatever style your app uses — this
guide is not meant to constrain SDK consumers.

## Summary

Optimize for readability. Write detailed documentation. Make error messages useful.
Never use timeouts or timers. Keep the LLC free of UI concepts. Use streams where the
data is a real-time feed; use `Listenable` for widget-owned state. Update the affected
package's `CHANGELOG.md` in the same PR.

## Introduction

This document describes high-level philosophy, policy decisions, and specific style
rules for the code in this monorepo. It applies to the SDK packages (`stream_chat`,
`stream_chat_persistence`, `stream_chat_flutter_core`, `stream_chat_flutter`,
`stream_chat_localizations`) and the sample apps under `sample_app/` and `packages/*/example/`.

For anything not covered here, follow the
[Effective Dart](https://dart.dev/effective-dart) guide. Where Effective Dart and this
guide disagree, this guide wins for code in this repo.

Sections below cover:

- [Quick rules](#quick-rules) — the short checklist to skim before every change
- [Philosophy](#philosophy) — the "why" behind the rules
- [Repository structure](#repository-structure) — monorepo layout, Melos, dependency management
- [Documentation](#documentation) — dartdoc conventions
- [Coding patterns](#coding-patterns) — asserts, dispose, equality, streams, etc.
- [Testing](#testing) — unit, widget, and golden tests
- [Naming](#naming) — identifiers, callbacks, booleans
- [Comments](#comments) — when to write them, when not to
- [Formatting](#formatting) — line length, class ordering
- [Widgets and state](#widgets-and-state) — theming, configuration, controllers
- [Localization](#localization) — adding new UI strings
- [Commits, PRs, and changelogs](#commits-prs-and-changelogs)


## Quick rules

The hard rules to check before opening a PR. Every rule below is expanded later in the
document; the section link is provided.

**Layering and package boundaries**

- `stream_chat` (the LLC / low-level client) never depends on Flutter and never names UI
  concepts in its API or docs (no "composer", "picker", "theme", "widget", etc.).
  → [LLC docs don't reference UI](#llc-docs-must-not-reference-ui)
- New public types from `stream_core_flutter` must be added to the `show` allowlist in
  `packages/stream_chat_flutter/lib/stream_chat_flutter.dart`. → [Repository structure](#repository-structure)
- Dependencies are centrally managed in `melos.yaml` under
  `command.bootstrap.dependencies`. Do not edit version constraints in individual
  `pubspec.yaml` files. → [Dependency management](#dependency-management)

**Code**

- Line width: **120 characters** (configured in `analysis_options.yaml`). Comments and
  docs follow the same limit.
- Single quotes, package imports (never relative), trailing commas preserved, `const`
  wherever possible, `final` for locals that aren't reassigned. These are enforced by
  the linter — do not disable them.
- Prefer named parameters for booleans (`avoid_positional_boolean_parameters`). A
  positional `bool` at a call site tells the reader nothing.
- File names are `snake_case.dart` (`file_names`). Imports follow the standard order:
  `dart:` → `package:` → relative — one blank line between groups (`directives_ordering`).
- Public API members require dartdoc (`///`). Private members (`_`-prefixed) use `//`
  block comments, not `///`. → [Private members use `//`](#private-members-use--not-)
- Default to zero inline `//` comments in implementation. Prefer well-named locals and
  early returns over a comment explaining what code does. → [Minimize inline comments](#minimize-inline-comments)
- Never call `InheritedWidget.of(context)` or `.maybeOf(context)` from `initState`; use
  `didChangeDependencies` or `didUpdateWidget` instead.
  → [No InheritedWidget lookup in initState](#no-inheritedwidget-lookup-in-initstate)
- Prefer early returns inside each conditional branch over reassigning a shared
  `child`/`result` variable. → [Prefer early returns](#prefer-early-returns)
- `// ignore: ...` directives do **not** require an explanatory comment in this repo.
  This intentionally diverges from Flutter's style guide.
  → [Bare ignore directives are fine](#bare-ignore-directives-are-fine)

**Real-time and reactive**

- `Stream` is the primary reactive primitive for real-time data (events, channel state,
  message updates). This intentionally diverges from Flutter's style guide.
  → [Use streams for real-time data](#use-streams-for-real-time-data)
- For widget-local reactive state that isn't a real-time feed, prefer
  `ValueNotifier` / `ChangeNotifier`.

**Docs and comments**

- Public dartdoc describes the contract, not the implementation. Do not name
  `BehaviorSubject`, "unmodifiable", "Stream emits X", or which internal type is used.
  → [Public docs describe the contract, not implementation](#public-docs-describe-the-contract-not-implementation)
- Comments must not justify code via cross-references to Flutter framework internals
  (e.g. "matching Flutter's AppBar"). → [No Flutter internals in comments](#no-flutter-internals-in-comments)

**Process**

- Update the affected package's `CHANGELOG.md` in the same PR. Each entry is one short
  bullet describing the functional change — no sub-bullets, no implementation details.
  → [Changelog policy](#changelog-policy)
- PR titles follow [Conventional Commits](https://www.conventionalcommits.org/):
  `fix(scope): …`, `feat(scope): …`, `refactor(scope)!: …` for breaking changes.
  → [PR titles and commits](#pr-titles-and-commits)
- When adding a new UI string, add it to `stream_chat_localizations` and to the
  `Translations` interface. → [Localization](#localization)


## A word on designing APIs

Designing an API is an art. Like all forms of art, one learns by practicing. The best
way to get good at designing APIs is to spend a decade or more designing them, while
working closely with people who are using your APIs.

In the absence of one's own experience, one can attempt to rely on the experience of
others. When receiving feedback about API design from an experienced API designer, they
will sometimes seem unhappy without being able to articulate why. When this happens,
seriously consider that your API should be scrapped and a new solution found.

This requires a different and equally important skill: not getting attached to your
creations. Try many wildly different APIs, then write code that uses those APIs, to see
how they work. Throw away APIs that feel frustrating, that lead to buggy code, or that
other people don't like. If it isn't elegant, it's usually better to try again than to
forge ahead.

An SDK API is for years, not just for the one PR you are working on. A signature
committed today is one we have to keep supporting until we ship a major version bump.


## Philosophy

### Lazy programming

Write what you need and no more, but when you write it, do it right.

Avoid implementing features you don't need. You can't design a feature without knowing
what the constraints are. Implementing features "for completeness" results in unused
code that is expensive to maintain, learn about, document, test, etc.

When you do implement a feature, implement it the right way. Avoid workarounds.
Workarounds merely kick the problem further down the road, but at a higher cost.
It's much better to take longer to fix a problem properly than to be the one who fixes
everything quickly but in a way that will require cleaning up later.

### Write Test, Find Bug

When you fix a bug, first write a test that fails, then fix the bug and verify the test
passes.

When you implement a new feature, write tests for it. If something isn't tested, it is
very likely to regress or to get "optimized away". If you want your code to remain in
the codebase, you should make sure to test it.

Don't submit code with the promise to "write tests later". Take the time to write the
tests properly and completely in the first place.

### Avoid duplicating state

There should be no objects that represent live state that reflect some state from
another source, since they are expensive to maintain. In other words, **keep only one
source of truth**, and **don't replicate live state**.

Concretely for this repo: the `Channel` state owned by `StreamChatClient` is the source
of truth for messages, members, watchers, etc. UI components subscribe to it; they do
not maintain parallel copies.

### Getters feel faster than methods

Property getters should be efficient (e.g. returning a cached value or an O(1) table
lookup). If an operation is inefficient, it should be a method instead.

Similarly, a getter that returns a `Future` or `Stream` should not kick off the work
represented by the future. Instead, the work should be started from a method or
constructor, and the getter should just return the preexisting future or stream.

### No synchronous slow work

There should be no public APIs that require synchronously completing an expensive
operation (e.g. blocking on a network call). Expensive work should be asynchronous, and
the fact that it is expensive should be visible in the type signature (returns
`Future`/`Stream`).

### Layers

The SDK is layered — each package builds on top of the previous:

```text
stream_chat                     # Pure Dart, no Flutter dependency
  └── stream_chat_persistence   # Local disk cache using Drift (optional)
      └── stream_chat_flutter_core   # Flutter business logic, no UI
          └── stream_chat_flutter    # Full UI component library
              └── stream_chat_localizations   # i18n for UI
```

Convenience APIs belong at the layer above the one they are simplifying. Do not push a
"convenience" API down a layer just to have it available to lower layers — that pulls
higher-level concepts into places they don't belong.

### LLC docs must not reference UI

Code and dartdoc in `stream_chat` (the "LLC" / low-level client) must not name UI
concepts: no "composer", "picker", "message input", "theme", or "widget". Describe
behavior in LLC terms: a `Draft`, a `Command`, a `Message`, a `Channel`. The LLC is a
pure-Dart package that can be used from CLIs, servers, and non-Flutter clients; if its
docs assume the caller is a Flutter widget, we've leaked the abstraction.

### Avoid interleaving multiple concepts together

Each API should be self-contained and should not know about other features. Interleaving
concepts leads to complexity.

- Widgets that take a `child` should be entirely agnostic about the type of that child.
  Don't use `is` checks to act differently based on the type of the child.
- Prefer immutable data models. `Message`, `Channel`, `User`, and friends are immutable
  (built via `copyWith`). Immutable data models can be passed around safely without any
  risk that a downstream consumer will mutate them.

### Avoid secret (or global) state

A function should operate only on its arguments and, if it is an instance method, data
stored on its object. Global state makes code hard to test, hard to reason about, and
hard to reuse.

The `StreamChatClient` is the single stateful object of the SDK. It's passed around
explicitly (via `StreamChat.of(context)` in Flutter, or via constructor injection in
plain Dart). We do not have global singletons for chat state.

### Prefer general APIs, but use dedicated APIs where there is a reason

Having dedicated APIs for performance reasons is fine. If one specific operation is
expensive using the general API but could be implemented more efficiently using a
dedicated API, that is where a dedicated API belongs.

### Avoid APIs that encourage bad practices

Don't provide APIs that walk entire trees, or that encourage O(N²) algorithms, or that
encourage sequential long-lived operations where the operations could be run
concurrently.

In particular:

- String manipulation to generate data or code that will subsequently be interpreted or
  parsed is a bad practice, as it leads to code injection vulnerabilities.
- If an operation is expensive, that expense should be represented in the API (e.g. by
  returning a `Future` or a `Stream`). Avoid providing APIs that hide the expense of
  tasks.

### Avoid exposing API cliffs

Convenience APIs that wrap an underlying service should expose the complete API, so
there's no cognitive cliff (where the caller is fine using the wrapper up to a point,
but beyond that has to learn all about the underlying service).

### Avoid heuristics and magic

Predictable APIs that give the developer control are generally preferred over APIs that
mostly do the right thing but don't give the developer any way to adjust the results.
Predictability is reassuring.

### Solve real problems by literally solving a real problem

Where possible, partner with a real customer who wants the feature and is willing to
help you test it. Only by actually using a feature in the real world can we be
confident it is ready.

If your first customer says the feature doesn't actually solve their use case, don't
dismiss the concerns as esoteric. What seems like the problem when you start a project
often turns out to be trivial compared to the real issues faced by real developers.

### Start designing APIs from the closest point to the developer

When we create a new feature that requires a change across the stack, it's tempting to
design the lowest-level API first, since that's the closest to the "interesting" code.
However, that then forces the higher-level APIs to be designed against the lower-level
API, which may or may not be a good fit.

Instead, always design the top-level API first. Consider what the most ergonomic API
would be at the level that most developers interact with. Then, once that API is
cleanly designed, build the lower levels so the higher level can be layered atop.

Concretely: design the `StreamChatFlutter` widget or `Channel` method first, then the
`stream_chat_flutter_core` controller, then the `stream_chat` API, then the network
protocol.

### Only log actionable messages to the console

If the logs contain messages users can safely ignore, they will do so, and eventually
their logs will be so chatty they'll miss the critical messages. Only log actual errors
and actionable warnings.

Never log informational messages by default. If a topic is worth logging while
debugging, gate it behind a `Logger` level (the LLC uses the `logging` package). Rely
on log levels/flags, not verbosity, when deciding whether to emit a message.

### Error messages should be useful

Every time you find the need to report an error (throwing an exception, handling bad
state, reporting invalid input), consider how you can make this the most useful and
helpful error message. Put yourself in the shoes of whoever sees that error. Why did
they see it? What can we do to help them? **Every error message is an opportunity to
make someone love our product.**


## Policies

### Workarounds

Temporary workarounds (`// ignore` hacks that don't fit our repo style, monkey-patches
of upstream APIs) should be documented with a link to the tracking issue and a plan for
removing them. Long-term workarounds should be turned into proper fixes.

### Avoid abandonware

Code that is no longer maintained should be deleted, not commented out. Commented-out
code will bitrot too fast to be useful and will confuse people maintaining the code.

If a feature is being deprecated, follow the deprecation policy: annotate with
`@Deprecated('use X instead')`, add a `CHANGELOG.md` entry, and keep the deprecated
API for at least one minor release before removal.

### Copyright and licensing

New source files should carry the standard header used elsewhere in the repo. Third-
party code must live in a `third_party/` subdirectory of the package with a `LICENSE`
file that describes the license and a `README` describing its provenance. The
third-party license must also be duplicated into the package's `LICENSE` file where
applicable.

We strongly recommend avoiding third-party code unless strictly necessary.


## Repository structure

### Monorepo layout

```text
stream-chat-flutter/
├── melos.yaml                # Workspace + centralized dependencies
├── analysis_options.yaml     # Shared lints
├── STYLE_GUIDE.md            # This file
├── CLAUDE.md                 # AI-agent pointer to this guide + repo overview
├── CONTRIBUTING.md           # How to contribute (setup, PRs)
├── docs/                     # Docs-related helpers (docs_screenshots app, etc.)
├── packages/
│   ├── stream_chat/          # LLC (pure Dart)
│   ├── stream_chat_persistence/
│   ├── stream_chat_flutter_core/
│   ├── stream_chat_flutter/
│   └── stream_chat_localizations/
├── sample_app/               # End-to-end sample app
└── tools/                    # Repo-level scripts
```

### Package structure

Each package should have a single public library at `lib/<package_name>.dart` that
re-exports its public API. Anything under `lib/src/` is considered private to that
package — importing from `lib/src/` in another package is a lint error
(`implementation_imports`).

Do not create a `lib/src/foo/foo_bar.dart` file whose only purpose is to be exported
from the top-level library — put the public members in a file that reflects the feature
they belong to, and re-export it.

### Dependency management

Dependencies for all packages are centrally managed in `melos.yaml` under
`command.bootstrap.dependencies`. Do **not** edit version constraints directly in an
individual package's `pubspec.yaml` — update `melos.yaml` and run `melos bootstrap`.

When you add a new dependency:

1. Add it to `melos.yaml` under `command.bootstrap.dependencies` (or `dev_dependencies`).
2. Add the bare package name to the affected `pubspec.yaml` files.
3. Run `melos bootstrap`.

### Cross-repo work with `stream_core_flutter`

`stream_core_flutter` is a sibling repository (not part of this monorepo) that provides
primitive UI building blocks shared across Stream products. Components in this repo can
wrap those primitives with chat-domain semantics.

When making changes that touch both repos, temporarily switch the dependency on
`stream_core_flutter` to a local `path:` dependency, verify end-to-end, then switch back
to a `git:` dependency on the appropriate branch before merging.

When a new type from `stream_core_flutter` is used in this repo, add it to the `show`
allowlist in `packages/stream_chat_flutter/lib/stream_chat_flutter.dart` so downstream
users don't need to add a second import.

### Generated code

Generated files (`*.g.dart`, `*.freezed.dart`) are excluded from analysis and must not
be edited by hand. If a generated file is stale, run:

```bash
melos run generate:all
```

Do not commit `.g.dart` or `.freezed.dart` files that were not regenerated as part of
your change — this indicates the generator ran with a different version of a dependency
than the CI expects.


## Documentation

We use dartdoc for public API documentation. All public members in SDK packages must
have documentation (`public_member_api_docs` lint is enabled).

In general, follow the [Effective Dart documentation guide](https://dart.dev/effective-dart/documentation)
except where this page contradicts it.

### Answer your own questions straight away

When working on the SDK, if you find yourself asking a question about our systems,
place whatever answer you subsequently discover into the documentation in the same
place you first looked. That way, the docs consist of answers to real questions, in
the places where people would look to find them.

### Avoid useless documentation

If someone could have written the same documentation without knowing anything about the
class other than its name, then it's useless.

```dart
// BAD:

/// The channel id.
final String cid;

// GOOD:

/// The unique channel identifier in the form `type:id`.
///
/// Constructed from [type] and [id] separated by a colon (e.g. `messaging:general`).
/// This is stable across sessions and can be persisted or shared.
final String cid;
```

### Public docs describe the contract, not implementation

Dartdoc describes the observable behavior of an API, not how it happens to be
implemented today. Skip mentions of:

- Specific implementation types the caller doesn't see (e.g. `BehaviorSubject`,
  `UnmodifiableListView`)
- Internal caching strategies unless the caller's code needs to know
- "Stream emits X" style — describe what values are produced and when, not the stream
  mechanics

```dart
// BAD:

/// A BehaviorSubject that emits an unmodifiable list of members whenever the channel
/// state changes.
Stream<List<Member>> get membersStream;

// GOOD:

/// The current members of the channel.
///
/// Emits the current value immediately on listen, then a new value each time
/// members are added, removed, or updated.
Stream<List<Member>> get membersStream;
```

### No Flutter internals in comments

Do not justify code by cross-referencing Flutter framework internals ("matching
Flutter's `AppBar`", "same behavior as `MaterialButton`"). Public dartdoc describes
the observable contract, not which internal widget tree we happen to mirror. If a
behavior only makes sense in the context of another Flutter widget, describe the
behavior directly; if that's impossible, the abstraction may be wrong.

### Writing prompts for good documentation

If you're stuck coming up with useful documentation, some prompts:

- If someone is looking at this documentation, it means they have a question they
  couldn't answer by guessing or reading the code. What could that question be?
- What might a caller want to know that isn't obvious from the type?
- Are there edge cases outside the normal range that should be discussed (negative
  numbers, empty lists, `null`, deleted messages, offline mode)?
- Does this member interact with any others? For example, is it only non-null if
  another is null? Does it only take effect if another has a particular value?
- Are there timing considerations or race conditions?
- Are there lifecycle considerations? Who owns the object? Who should `dispose()` it?
- If there are `Future` values involved, what are the guarantees? Can they complete
  with an error? Can they never complete?

### Introduce terms as if every piece of documentation is the first the reader has ever seen

Avoid using terms without first defining them, unless you're linking to more
fundamental documentation that defines the term.

Docs for `Channel` should not assume the reader already knows what a `Message` or a
`Member` is; either explain briefly, or link.

### Avoid empty prose

Avoid unnecessary words.

```dart
// BAD:
/// Note: It is important to be aware of the fact that in the absence of an explicit
/// value, this property defaults to 2.

// GOOD:
/// Defaults to 2.
```

Do not start sentences with "Note:" or "Note that". It adds nothing.

### Leave breadcrumbs in the comments

If a class is typically obtained via some mechanism other than its constructor, mention
that in the class documentation.

```dart
// GOOD:

/// The current state of a [Channel].
///
/// Obtained via [Channel.state]. Not intended to be constructed directly.
class ChannelState { ... }
```

Use `See also:` to link to related APIs:

```dart
/// See also:
///
///  * [Message], which is the primary unit of data in a channel.
///  * [Draft], which represents an unsent, in-progress message.
```

Each `See also:` line ends with a period. Prefer "which…" over parenthetical
descriptions.

### Refactor the code when the documentation would be incomprehensible

If writing the documentation proves difficult because the API is convoluted, rewrite
the API rather than trying to document it.

### Canonical terminology

Use consistent terminology:

- _method_ — a member of a class that is a non-anonymous closure
- _function_ — a callable non-anonymous closure that isn't a member of a class
- _parameter_ — a variable defined in a closure signature
- _argument_ — the value passed to a closure when calling it

Prefer "call" over "invoke" when talking about jumping to a closure. Typedef dartdocs
usually start with the phrase "Signature for…".

### Use correct grammar

Avoid starting a sentence with a lowercase letter. End all sentences with a period.

```dart
// BAD:
/// [foo] must not be null.

// GOOD:
/// The [foo] argument must not be null.
```

### Use the passive voice; recommend, do not require

Avoid "you" and "we". Avoid the imperative voice. Rather than telling someone to do
something, use "Consider", as in "To obtain the foo, consider using [bar].".

Never use "simply", or say the reader need "just" do something. By definition, if
they're looking at the docs, they aren't finding it easy.

### Private members use `//`, not `///`

`_`-prefixed members receive `//` block comments, not `///` dartdoc. Dartdoc machinery
(cross-references, IDE hover from outside the library) buys nothing for library-private
surfaces, and using `///` on private members makes the tooling suggest they should be
public.

This intentionally diverges from Flutter's guide, which uses `///` for
"public-quality" private docs. In this repo, if a private member is documented well
enough to be public, either make it public or use `//`.

```dart
// GOOD (private member):

// The last message id the composer had focus for.
//
// Used to detect when the composer switches to editing a different message so we can
// reset the input state.
String? _lastFocusedMessageId;

// GOOD (public member):

/// The unique identifier for this channel.
final String cid;
```

### Provide sample code

Include a short `dart` code block in the dartdoc for widgets and complex APIs. Longer,
runnable examples belong in `packages/*/example/` or `sample_app/`.

Do not use `{@tool dartpad}` — we don't have infrastructure to render it.

### Clearly mark deprecated APIs

Use `@Deprecated('Use X instead.')`. Add a `CHANGELOG.md` entry under `⚠️ Deprecated`
describing the deprecation and pointing at the replacement.

### Dartdoc-specific requirements

The first paragraph of any dartdoc section must be a short, self-contained sentence
explaining the purpose of the item. Subsequent paragraphs elaborate. Avoid having the
first paragraph contain multiple sentences (it gets extracted for tables of contents).

When referencing a parameter, use backticks. When referencing a parameter that also
corresponds to a property, use square brackets instead.

```dart
// GOOD:

/// Creates a channel.
///
/// The [type] argument identifies the channel type (e.g. `messaging`).
/// The `extraData` argument, if supplied, must be JSON-serializable.
Channel({required this.type, Map<String, Object?>? extraData});
```

Avoid using "above" or "below" to reference other dartdoc sections. Dartdoc pages are
often viewed in isolation; the surrounding context may not be there.


## Coding patterns

The linter enforces most of the rules in this section — see
[`analysis_options.yaml`](analysis_options.yaml) for the authoritative list. Rules
highlighted below either extend a lint (adding rationale or a repo-specific pattern)
or capture conventions the linter can't check.

### Use asserts liberally to detect contract violations

`assert()` lets us verify invariants without paying a cost in release mode, because
Dart only evaluates asserts in debug mode.

Use asserts for conditions that should be impossible unless there is a bug. Do not use
asserts to validate user input or network data (those must throw at runtime).

Every assert must include a message explaining the invariant
(`prefer_asserts_with_message`). A bare `assert(x != null)` is a lint error; write
`assert(x != null, 'x must be set before calling foo()')`.

```dart
void updateMessage(Message message) {
  assert(message.id != null, 'Cannot update a message that has not been sent yet.');
  // ...
}
```

### Prefer specialized functions, methods, and constructors

Use the most relevant constructor when there are multiple options.

```dart
// BAD:
const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0);

// GOOD:
const EdgeInsets.symmetric(vertical: 8.0);
```

### Minimize the visibility scope of constants

Prefer a local `const` or a `static const` in a relevant class over a global constant.

Global constants that _do_ need to exist should be prefixed with `k` (see
[Naming](#naming)).

### Avoid `if` chains or `?:` with enum values

Use `switch` (statement or expression) with exhaustive cases when examining an enum;
the analyzer will warn if you miss a value. Avoid `default:` unless the switched value
isn't statically known — a default clause silences the exhaustiveness check.

```dart
// GOOD:

final label = switch (state) {
  SendingState.sending => 'Sending…',
  SendingState.sent => 'Sent',
  SendingState.failed => 'Failed',
};
```

### Prefer explicit types and avoid `dynamic`

All public API members must have explicit type annotations — parameters, fields, and
return types (`type_annotate_public_apis`, `always_declare_return_types`). This
includes top-level declarations and static members. The linter will reject a public
member without a declared type.

Avoid `dynamic` in public APIs. If the type is unknown, prefer `Object?` and casting;
`dynamic` disables all static checking.

For local variables, follow the `omit_local_variable_types` lint — omit the annotation
when the type is obvious from the initializer, but keep it when the type isn't obvious.

### Guidelines for `extension`s

Extension methods let you add functionality to an existing type. Consider the
trade-offs before reaching for one:

- Extension methods are resolved statically and cannot be overridden.
- Misusing extensions can pollute IDE suggestions and cause naming collisions.

Rules:

- Don't declare an extension method when a regular method or a helper function will do.
- Don't use extensions if the caller might want to override the method's behavior.
- Extensions on collections of chat domain types (`Iterable<Message>`, `List<User>`,
  `Iterable<Read>`) are fine — they only apply when the caller is already working with
  those types.
- Avoid public extensions on unconstrained common types (`Object`, `Object?`,
  `List<T>`, `Map<K, V>`, `Future<T>`, `String`, `int`). Those show up on every value
  of that type in every file that imports our package, causing IDE-completion noise
  and potential collisions with other packages. A few (`StringExtension`,
  `IntExtension`, `SafeCastExtension`) predate this rule; new code should not add more.

### Dot shorthands

Dart 3.8+ allows dot shorthand for enum values and constructors where the target type
is known. This repo uses dot shorthand where the type is obvious; the full rule set
matches Flutter's guide.

```dart
// GOOD (named argument with obvious type):
Row(
  mainAxisAlignment: .start,
  crossAxisAlignment: .start,
  children: children,
),

// GOOD (implicit return):
MainAxisAlignment pickAlignment() => .start;

// BAD (positional argument — type is unclear at the call site):
Curve2DSample(0.5, .zero); // What's the type of .zero?

// BAD (top-level variable with inferred type):
final defaultAppBar = SliverAppBar(); // Public API needs an explicit type.
```

Concretely: use dot shorthand for named arguments and implicit returns; use the full
qualifier for positional arguments and public API declarations.

### Avoid `FutureOr<T>` in public APIs

`FutureOr` is a Dart-internal type used to explain aspects of the `Future` API. In
public APIs, avoid the temptation to create APIs that are both synchronous and
asynchronous by returning this type — it usually only results in the API being more
confusing and less type-safe.

You may use `FutureOr` for callback parameters where the caller's callback may or may
not be async.

### Avoid `@visibleForTesting`

The `@visibleForTesting` annotation marks a public API such that callers get a warning
outside `test/` directories. The API is still public — nothing prevents its use.

Rather than rely on `@visibleForTesting`, design APIs so they are testable through the
public API without exposing sensitive internals. If a member is _only_ used for
testing, prefix its name with `debug` or move it into the test file.

### Never add timeouts, and avoid other race conditions

If you look for an available port, then try to open it, several times a week some
other code will open that port between your check and your open. Similarly, timeouts
based on how long something "usually takes" will trigger spuriously.

Race conditions are the primary cause of flaky tests. Avoid timeouts entirely. Wait
for a triggering event.

### Avoid magic numbers

Numbers should be understandable. If the derivation isn't obvious, either restructure
the expression to be self-describing or add a comment.

```dart
// BAD:
expect(rect.left, 4.24264068712);

// GOOD:
expect(rect.left, 3.0 * math.sqrt(2));
```

### Perform dirty checks in setters

When defining mutable properties that require notifying listeners on change:

```dart
Message get message => _message;
Message _message;
set message(Message value) {
  if (_message == value) {
    return;
  }
  _message = value;
  notifyListeners();
}
```

Start setters with any asserts you need to validate the value. Do not perform side
effects in setters other than marking the object dirty and updating internal state.

### Common boilerplates for `operator ==` and `hashCode`

For value classes without generated equality (i.e. classes not using `equatable` or
`freezed`), use this shape:

```dart
@override
bool operator ==(Object other) {
  if (identical(other, this)) {
    return true;
  }
  return other is Foo
      && other.bar == bar
      && other.baz == baz;
}

@override
int get hashCode => Object.hash(bar, baz);
```

Most models in this repo use `equatable` (`class Message extends Equatable`) — for
those, provide `props` and let `Equatable` handle equality.

### Override `toString` on debuggable objects

For classes that appear in error messages or logs, override `toString`:

```dart
@override
String toString() => '${objectRuntimeType(this, 'Channel')}(cid: $cid)';
```

Avoid `$runtimeType` — it adds non-trivial cost in profile/release mode.
`objectRuntimeType` handles this correctly (fallback to the constant string when
asserts are disabled).

### Be explicit about `dispose()` and the object lifecycle

Even though Dart is garbage-collected, having a defined object lifecycle is important.
If your class holds a `StreamSubscription`, a `Listenable` listener, a controller, or
a persistent connection, provide a `dispose()` method and document who is responsible
for calling it.

The `close_sinks`, `cancel_subscriptions`, and `use_late_for_private_fields_and_variables`
lints catch some cases; the rest is a review responsibility.

### No InheritedWidget lookup in `initState`

`InheritedWidget.of(context)` and `.maybeOf(context)` use
`context.dependOnInheritedWidgetOfExactType`, which is forbidden inside `initState`.
Move the lookup to `didChangeDependencies` (for lifecycle-scoped lookups) or
`didUpdateWidget` (for reactions to prop changes). Reading the inherited widget in
`initState` throws in debug mode and returns the wrong value in release mode.

```dart
// BAD:
@override
void initState() {
  super.initState();
  final theme = StreamChatTheme.of(context); // Throws in debug mode.
  // ...
}

// GOOD:
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final theme = StreamChatTheme.of(context);
  // ...
}
```

### Prefer early returns

Return inside each branch of a conditional rather than reassigning a shared variable
that gets post-processed after the branches. Post-processing belongs scoped to its
branch.

```dart
// BAD:
Widget build(BuildContext context) {
  Widget child;
  if (isLoading) {
    child = const CircularProgressIndicator();
  } else if (hasError) {
    child = const ErrorView();
  } else {
    child = _content();
  }
  return Padding(padding: const EdgeInsets.all(8), child: child);
}

// GOOD:
Widget build(BuildContext context) {
  const padding = EdgeInsets.all(8);
  if (isLoading) return const Padding(padding: padding, child: CircularProgressIndicator());
  if (hasError) return const Padding(padding: padding, child: ErrorView());
  return Padding(padding: padding, child: _content());
}
```

If the post-processing is expensive enough that duplicating it hurts readability,
extract a helper method — don't reintroduce the shared-variable pattern.

### Use streams for real-time data

This repo builds a real-time chat SDK. `Stream` is the primary reactive primitive for
data that arrives asynchronously over time — WebSocket events, channel state updates,
new messages, typing indicators, and so on. This intentionally diverges from Flutter's
style guide, which recommends `Listenable` over `Stream` inside the Flutter framework.

Rules of thumb for choosing between `Stream` and `Listenable`:

- **`Stream`** — for data that originates outside the widget tree: server events,
  network responses, subscriptions to `Channel` state, `Draft` updates.
- **`ValueNotifier` / `ChangeNotifier`** — for widget-owned reactive state:
  `TextEditingController`-adjacent state, animation-driven state, expanded/collapsed
  toggles.

Consuming streams in widgets:

- Prefer `BetterStreamBuilder<T>` (from `stream_chat_flutter_core`) over `StreamBuilder`
  when the stream has a synchronously-available initial value. `BetterStreamBuilder`
  only rebuilds when the value changes.
- Always cancel `StreamSubscription`s in `dispose()`.


## Testing

This section covers repo-level testing conventions (tools, self-containment, golden
tests). For guidance on **how to write good tests** — naming, factoring, one behavior
per test — see [`TESTING.md`](TESTING.md).

### Make each test entirely self-contained

Embrace code duplication in tests. It makes it easier to create new tests by copying
and tweaking existing ones.

Avoid test-global variables or state shared between tests — they make maintenance,
debugging, and refactoring significantly harder. Instead of `setUp`, use local helper
functions called inside each test block. For cleanup, prefer `addTearDown` over the
global `tearDown` callback — `addTearDown` registers cleanup at the exact point a
resource is created, ensuring it only runs if initialization succeeded.

### Prefer more test files, avoid long test files

Organize tests into smaller files grouped by feature, widget, or behavior. It's easier
to understand a test file when it has only a few related tests than when it has an
entire test suite.

Instead of a single `channel_test.dart` covering everything, split into
`channel_watch_test.dart`, `channel_send_test.dart`, `channel_state_test.dart`, etc.

### Mock only at the seam

Prefer mocking at the boundary between your code and the outside world (HTTP client,
persistence client, WebSocket). Do not mock every collaborator.

- Use `mocktail` (no code generation required) for classes that need a full test
  double. `Mocktail` doesn't require `@GenerateMocks` or a `build_runner` step —
  extend `Mock` and stub the methods you exercise.
- For simple stubs, prefer explicit fake classes over `Mock` — they read better and
  survive interface changes without needing to re-stub every method.
- When mocking a class that takes named parameters, use `mocktail`'s `when(() =>
  mock.method(any(named: 'foo')))` pattern; do not hand-roll a fake that duplicates the
  full interface.

### Golden tests

Widget tests that verify pixel-level rendering use the `alchemist` package. Golden
files live alongside the test in a `goldens/` subdirectory. Locally, tests run against
platform goldens; CI runs against CI goldens (detected via `CI` / `GITHUB_ACTIONS`
environment variables).

To regenerate goldens:

```bash
melos run update:goldens
```

Regenerate goldens deliberately, in a separate commit from behavior changes, so
reviewers can see what visually changed. Do not check in a golden mismatch just because
a test "works locally".


## Naming

### Begin global constant names with the prefix `k`

```dart
const double kDefaultMessageMaxWidth = 300;
const String kMessageIdBottomOffset = 'v-bottom';
```

Prefer avoiding global constants — `Button.defaultColor` reads better than
`kDefaultButtonColor`. Reach for a class-scoped constant first.

### Avoid abbreviations

Unless the abbreviation is more recognizable than the expansion (e.g. `XML`, `HTTP`,
`JSON`, `URL`, `SDK`, `LLC`), expand it. Avoid one-character names unless idiomatic
(`i` for a loop counter is fine; `x` and `y` for coordinates are fine).

### Naming rules for callbacks and typedefs

For callbacks, use `FooCallback` for the typedef, `onFoo` for the property, and
`handleFoo` for the method that is called.

If `Foo` is a verb, prefer present tense over past tense (`onTap`, not `onTapped`).

Never call a method `onFoo`. If a property is called `onFoo` it must be a function type.

Prefer typedefs for callbacks — they can be documented and make it easier to grep for
common signatures.

### Spelling

Prefer US English spellings. `color`, not `colour`. `canceled`, not `cancelled`.
`labeled`, not `labelled`.

Avoid "cute" spellings (`colorz`, `klass`).

### Capitalization consistent with spelling

If a word is written as a single compound word (e.g. `toolbar`, `scrollbar`), keep it
compound: no inner capitalization. If it's two words (e.g. `app bar`, `tab bar`), use
camelCase: `appBar`, `tabBar`.

Avoid class names containing `iOS`. Prefer `Cupertino` or `UIKit`. If you must use
`iOS` in an identifier, capitalize it as `IOS`.

### Avoid double negatives in APIs

Name boolean variables positively, even if the default is `true`:

- `enabled: true` (default) — good; disabling reads `enabled: false`.
- `disabled: false` (default) — bad; enabling reads `disabled: false`, which is
  confusing.

### Prefer naming the argument to a setter `value`

Unless it causes problems, use `value` for the setter's argument. This makes it easier
to copy/paste the setter later.

### Qualify variables and methods used only for debugging

If a variable, method, or class is only used in debug mode, prefix its name with
`debug` (or `_debug`, or `_Debug` for a class). Don't use debug helpers in production
code paths.

### Avoid "new" / "old" modifiers

The definition of "new" changes as code grows. If a piece of code needed a replacement
once, it will likely need another. Name things after the idea, not the version.


## Comments

### Avoid checking in comments that ask questions

Find the answers to the questions, or describe the confusion, including references
where you found answers.

If commenting on a workaround for a bug, describe the constraint and (when one exists)
link the tracking issue:

```dart
// TODO: Remove this override once `type` is properly enriched on the backend.
// TODO: Add stacktrace as a parameter in v11.0.0.
```

TODOs are bare `// TODO:` — no username tag (this diverges from Flutter's guide, which
requires `TODO(handle):`). If the TODO groups a workstream, an optional short tag is
fine (`// TODO(perf-migration): …`), but it's a category label, not a GitHub handle.

Include an issue link when the deferred work is tracked; if the constraint is
self-explanatory ("wait for backend enrichment", "wait for next major"), a link isn't
required.

### Bare ignore directives are fine

`// ignore: rule_name` directives do not require an explanatory comment in this repo.
This intentionally diverges from Flutter's guide.

```dart
// GOOD (matches repo style):
foo(); // ignore: unnecessary_null_comparison

// UNNECESSARY (do not add):
foo(); // ignore: unnecessary_null_comparison, needed because ...
```

If an `// ignore` covers something genuinely subtle (e.g. an ignore that's temporary
because of an upstream bug), a comment is welcome. Do not add "explanatory" comments to
every ignore just to match Flutter's convention.

### Minimize inline comments

Default to zero `//` comments in implementation. Prefer named locals over rationale
comments; prefer early returns over "// handle the loading case" markers.

```dart
// BAD:

Widget build(BuildContext context) {
  // If the user is offline, show the offline banner.
  if (!isOnline) return const OfflineBanner();
  // Otherwise, show the message list.
  return const MessageList();
}

// GOOD:

Widget build(BuildContext context) {
  if (!isOnline) return const OfflineBanner();
  return const MessageList();
}
```

Comments earn their place when they explain _why_ something is done — a hidden
constraint, a subtle invariant, a workaround for a specific bug, behavior that would
surprise a reader. Pre-existing comments should not be removed as part of unrelated
changes.

### Comment all test skips

Every skipped test must carry a reason as its `skip` argument. Bare `skip: true` is a
lint-review red flag — the next person to look will not know whether the skip is
temporary, permanent, or forgotten.

```dart
// GOOD:
skip: 'Flakes on CI runners with <2 vCPUs; investigating.'
skip: 'Blocked on Flutter #12345 — remove once that ships.'

// BAD:
skip: true
```

Include an issue link when the skip is tied to a tracked bug or unlanded feature;
otherwise a plain reason is fine. If the skip becomes long-lived (weeks), file an
issue so it's tracked.

### Comment empty closures to `setState`

Usually the closure passed to `setState` includes all the state changes. Sometimes the
state changed elsewhere and `setState` is called in response — in those cases include
a comment describing what changed:

```dart
setState(() {
  // The message subscription fired; the state is already up to date.
});
```


## Formatting

Run the formatter via Melos, not directly:

```bash
melos run format        # dart format --set-exit-if-changed . in every package
melos run lint:all      # analyze + format, run this before opening a PR
```

`melos run format` wraps `dart format --set-exit-if-changed .` so every package is
checked with the same settings. Do not invoke `dart format` on a single file with ad-hoc
flags — the workspace-level config (line length, trailing commas) applies uniformly.

Line length is **120 characters** for both code and comments, configured in
`analysis_options.yaml`. Trailing commas are preserved rather than automatically added,
so include a trailing comma anywhere you want the formatter to break the argument list
onto multiple lines.

### Constructors come first

The default constructor comes first, followed by named constructors, followed by
everything else. This is enforced by `sort_constructors_first` and
`sort_unnamed_constructors_first`.

### Order other class members in a way that makes sense

If there's a clear lifecycle, order members chronologically (e.g. `initState` before
`build` before `dispose`).

If no order is obvious, use:

1. Constructors, default first.
2. Constants of the same type as the class.
3. Static methods that return the same type as the class.
4. Final fields set from the constructor.
5. Other static methods.
6. Static properties and constants.
7. Mutable-property members (getter, private field, setter — no blank lines separating
   the three).
8. Read-only properties (other than `hashCode`).
9. Operators (other than `==`).
10. Methods (other than `toString` and `build`).
11. The `build` method.
12. `operator ==`, `hashCode`, `toString`, and diagnostics methods.

### Use braces for long function bodies

Use a block (with braces) when a body would wrap onto more than one line — do not force
`=>` onto a multi-line expression.

### Prefer `+=` over `++`

`+=` reads as an assignment and is easier to change to a different increment. `++`
hides mutation inside larger expressions.

### Use double literals for double constants

Include a decimal point in double literals, even for whole numbers:

```dart
Padding(padding: EdgeInsets.all(8.0)); // good
Padding(padding: EdgeInsets.all(8));   // avoid — reads as int
```


## Widgets and state

### Theming

Theme data classes are generated via the `theme_extensions_builder` package. **Do not
hand-roll `copyWith`, `merge`, `lerp`, `==`, or `hashCode`** — annotate with `@themeGen`
(or `@ThemeExtensions` for the root theme) and let the generator produce them.
Hand-rolled implementations drift out of sync when fields are added.

`StreamChatThemeData` (accessed via `StreamChatTheme.of(context)`) is the root theme.
It composes per-component theme data (e.g. `StreamMessageListViewThemeData`,
`StreamChannelHeaderThemeData`). Each component reads its own theme from context.

When adding a new component theme:

1. Create a `<Component>ThemeData` class that:
   - Uses `with _$<Component>ThemeData` (the generated mixin) and is annotated with
     `@immutable` + `@themeGen`. Component themes do **not** extend `ThemeExtension`.
   - Declares `part '<snake_name>.g.theme.dart';` at the top of the file.
   - Has **all fields nullable** — defaults do not live here.

   The root `StreamChatThemeData` is an exception: it `extends ThemeExtension` and uses
   `@ThemeExtensions(constructor: 'raw', buildContextExtension: false)` so it can plug
   into Material's `ThemeData.extensions`. New component themes should follow the
   `@themeGen` pattern, not the root pattern.
2. Create a `<Component>Theme` `InheritedTheme` widget that exposes the data via a
   `static <Component>ThemeData of(BuildContext context)` lookup.
3. Add the new theme data as a field on `StreamChatThemeData`.
4. **Place defaults in the widget's implementation, not in the theme data class.**
   This mirrors Flutter's own convention (`AppBar`, `TabBar`, etc.): the theme data
   holds overrides with nullable fields; the widget's `build` resolves the effective
   value with a null-coalescing chain, falling back to hardcoded defaults or upstream
   Material/Cupertino theme values at the leaf.

   ```dart
   Widget build(BuildContext context) {
     final theme = StreamMessageListViewTheme.of(context);
     final backgroundColor = widget.backgroundColor
         ?? theme.backgroundColor
         ?? Theme.of(context).colorScheme.surface;
     // ...
   }
   ```

   Keeps `StreamChatThemeData`'s constructor lean, makes overrides composable, and
   avoids stale defaults getting baked into the root theme when a widget's design
   changes.
5. Run `melos run generate:flutter` to produce the `.g.theme.dart` part.
6. Read the theme from context via `StreamChatTheme.of(context).<component>Theme` in
   the component's `build` (or via `<Component>Theme.of(context)` when the widget
   lives inside its own theme scope).

Look at `stream_chat_theme.dart` and `message_list_view_theme.dart` for the reference
shape.

Do not thread theme values through constructor parameters when they belong in the
theme. If a caller wants to override, they can wrap the widget in a
`StreamChatTheme(data: ..., child: ...)`.

### Configuration vs. theme

`StreamChatConfigurationData` holds non-visual UI config (e.g. whether reactions are
enabled, whether polls are enabled). Anything that changes the _appearance_ belongs in
theme; anything that changes _behavior_ belongs in configuration.

### Controllers

List-view state is managed by controllers extending `PagedValueNotifier<Key, Value>`
from `stream_chat_flutter_core`:

- `StreamChannelListController`
- `StreamMessageListController` (via `MessageListCore`)
- `StreamUserListController`, `StreamMemberListController`
- `StreamThreadListController`, `StreamDraftListController`
- `StreamPollController`, `StreamMessageReminderListController`

Callers own the controller lifecycle — they create it, pass it in, and dispose it.
Widgets do not construct controllers internally unless there is no way for the caller
to influence pagination, filtering, or refresh.

### Immutable models with `freezed` / `equatable`

New models default to `equatable` (extending `Equatable` and defining `props`) unless
they need a union type or exhaustive pattern matching, in which case use `freezed`.

Generated code (`.g.dart`, `.freezed.dart`) is never hand-edited. If the generated
output is stale, run `melos run generate:all`.

### Widget essentials

Every new public widget in `stream_chat_flutter` should:

- Accept `Key? key` in its constructor and forward it to `super(key: key)`
  (`use_key_in_widget_constructors`). Use `super.key` shorthand where possible
  (`use_super_parameters`).
- Support accessibility on both Android (TalkBack) and iOS (VoiceOver). A `Tooltip` is
  usually sufficient as the accessible label — do not duplicate it with
  `Icon.semanticLabel` unless VoiceOver or TalkBack fails to read the tooltip.
- Support both LTR and RTL layouts.
- Support text scaling.
- Have documentation for every public member.
- Have a widget test covering the golden path and at least one edge case.


## Localization

UI strings live in `stream_chat_localizations`. Adding a new string means:

1. Add an abstract getter to the `Translations` interface in
   `packages/stream_chat_localizations/lib/src/translations.dart`.
2. Implement the getter for every supported locale in the corresponding
   `translations_*.dart` file.
3. Reference it via `StreamChatLocalizations.of(context)?.newString ?? 'fallback'` in
   the widget.
4. If the fallback isn't the same as the English translation, document why.

Do not hardcode English strings in widgets — even when the string is a `Tooltip` label,
route it through `StreamChatLocalizations`.


## Commits, PRs, and changelogs

### PR titles and commits

PR titles follow [Conventional Commits](https://www.conventionalcommits.org/):

- `fix(scope): description` — bug fix
- `feat(scope): description` — new feature
- `refactor(scope)!: description` — breaking change (note the `!`)
- `chore(scope): description`, `docs:`, `test:`, `ci:`

`scope` is usually the affected package (`llc` for `stream_chat`, `ui` for
`stream_chat_flutter`, `core`, `persistence`, `localizations`, or `repo` for
monorepo-wide changes).

### Changelog policy

Every PR that changes package behavior updates the affected package's `CHANGELOG.md`
under the `Upcoming` heading. Entries look like this:

```markdown
## Upcoming

✅ Added

- Added `StreamChatClient.searchRoles` for searching channel roles.

🐛 Fixed

- Fixed a crash when opening a channel with a pinned message that had been deleted.
```

The canonical section labels used across packages are `✅ Added`, `🔄 Changed`,
`⚠️ Deprecated`, `🐛 Fixed`, `🔄 Internal / Non-breaking`, and `🔒 Security`. Use them
verbatim — do not invent new headings.

Prefer **one short bullet** per entry, describing the functional change. Longer entries
are acceptable for user-visible multi-facet features where the extra context matters to
someone deciding whether to upgrade — but avoid sub-bullets, per-method enumeration,
and internal implementation notes. Reviewers reading a release should understand what
changed without reading the diff; details that only matter to the person writing the
PR belong in the PR description, not here.

### Cross-package PRs

If a PR touches multiple packages, update each package's `CHANGELOG.md` separately.
Cross-linking between packages ("bumps stream_chat to 10.0.0") is done by the release
tooling — do not write these entries by hand.


## Where to look when you're stuck

- **Repo-wide overview**: [`CLAUDE.md`](CLAUDE.md) — architecture, commands, package
  layout. Kept short; points here for style rules.
- **Contribution flow**: [`CONTRIBUTING.md`](CONTRIBUTING.md) — how to get set up, file
  an issue, and hand a PR over for review.
- **Melos commands**: `melos.yaml` — every task the repo runs (test, analyze, generate,
  goldens).
- **Design source**: the [Chat SDK Design System](https://www.figma.com/design/Us73erK1xFNcB5EH3hyq6Y/Chat-SDK-Design-System)
  Figma project — accessed via the Figma MCP server when implementing UI.

When something isn't covered here and isn't obvious from surrounding code, prefer to
ask in the PR rather than guessing. If a convention isn't documented, propose adding
it to this guide as part of the PR.

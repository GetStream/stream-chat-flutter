<!-- Synced from GetStream/stream-core-flutter/style_guides/API_DESIGN.md. Do not edit this copy; change it upstream and the sync opens a PR here. -->

# API design for forward compatibility

An SDK API is for years, not just for the one PR you are working on. A signature
committed today is one we have to keep supporting until we ship a major version bump.
This guide is about choosing shapes that let an API grow in a minor release.

It applies to every Stream Flutter SDK (core, chat, video, feeds). The other
repositories carry a copy, which the `sync_style_guides` workflow in
stream-core-flutter keeps up to date; edit it there, never in a copy. On the shape of
public API it takes precedence over a repository's own style guide; raise a
disagreement here rather than diverging locally.

The rules apply to new public API. Existing shapes that break them stay as they are
until the next major release, when they move to the shape described here; don't change
one in a minor release just to follow this guide.

## Design for the second version

Most breaking changes are not bugs; they come from an API that could not grow. When
you add a public member, ask what the next feature request will need from it — one
more value in a callback, one more state, one more option — and choose the shape that
takes that addition as a minor release. The sections below are the shapes that
have repeatedly forced breaking releases in `stream-chat-flutter` and
`stream-video-flutter`, and the shapes that would have avoided them.

What counts as breaking is wider than "a signature changed". All of these break a
consumer who compiled fine before:

- adding a parameter to a function type (typedef, callback, builder);
- adding a parameter, even an optional one, to a method consumers override;
- adding a value to an enum, or a subclass to a `sealed` class, that consumers switch
  on exhaustively;
- adding an abstract member to a class consumers `implements` or `extends`;
- adding a class modifier (`final`, `base`, `interface`, `sealed`) to an existing
  public class;
- adding a required parameter, or reordering or renaming a positional one;
- changing a return type (`void` → `Future<void>`, `T` → `T?`) or a field type —
  including widening a field from `EdgeInsets` to `EdgeInsetsGeometry`, which breaks
  every reader of `.left` or `.top`;
- renaming or adding a field on a record type that appears in the public API;
- overriding `==` on a type consumers use as a `const` map key or `const` set element.

Changing a default value breaks consumers too, without a compile error: their app
behaves differently and nothing tells them.

## Pass callbacks and builders a single details object

A callback or builder takes the `BuildContext` (if it needs one) plus **one** object
carrying everything else. New information is a new field on that object, which is not
a breaking change. Every positional argument beyond that is a promise that the
callback will never learn anything else.

```dart
// BAD: the next piece of information is a breaking change.
typedef StreamAttachmentTapCallback = void Function(Message message, Attachment attachment);

// GOOD: new information is a new field on StreamAttachmentTapDetails, and the SDK
// can tell whether the tap was handled.
typedef StreamAttachmentTapCallback =
    FutureOr<bool> Function(BuildContext context, StreamAttachmentTapDetails details);
```

The same applies to callbacks that start with no arguments: a `VoidCallback` that
later needs a reason or a source is a breaking change. If there is any plausible
payload, start with a details object, even an empty one.

Name the object after its role: `…Details` for callback payloads (Flutter's own
`TapUpDetails`, `DragEndDetails`) and `…Props` for builder inputs, matching
`StreamComponentBuilder<T> = Widget Function(BuildContext context, T props)`. Make it a
`final class` with a `const` constructor, so nobody can implement it or override its
`copyWith`; make every field added after the first release optional or defaulted, and
add `copyWith` when consumers are expected to tweak and forward it.

Builders that let a consumer wrap or adjust the default rendering should receive the
default's inputs (`props`) from day one, so they can rebuild the default widget with a
change rather than re-implementing it.

Decide the callback's return type up front too. If the SDK might ever need to know
whether the consumer handled the event, or wait for it, return `FutureOr<bool>` (or a
result object) from the first release; turning `void` into `bool` later breaks every
implementation.

History:

- Chat's attachment tap callback on `StreamMessageWidget` went from
  `void Function(Message message, Attachment attachment)` to
  `FutureOr<bool> Function(BuildContext context, Message message, Attachment attachment)`
  in one breaking change (10.0.1, [chat#2426]): it gained a context and a return value.
- Chat's message builder changed shape twice: 2.0.0 added a default widget argument,
  and v10 replaced it with `(context, message, defaultProps)`, renamed once more before
  10.0.1 ([chat#2643]). 5.2.0 added `bottomRowBuilderWithDefaultWidget` next to
  `bottomRowBuilder` rather than give the original typedef a third argument.
- Video's `(context, call, callState)`-style call-screen builders were deprecated and
  replaced by parallel `*WidgetBuilder` typedefs (0.10.0, [video#983], removed in
  1.0.0). The participants builders became
  `CallWidgetBuilderWithData<T extends CallbackData>`, whose doc comment carries the
  lesson: add properties to the data object, never to the function. The livestream
  builders kept the old shape and were deprecated separately ([video#1118]).
- Video's `onCallDisconnected` went from `VoidCallback` to
  `void Function(CallDisconnectedProperties)` (0.9.0).
- Core's `MarkdownTapMentionCallback = void Function(String displayText, String id)`
  could not take a mention type, so [core#120] added `MarkdownTapAnyMentionCallback`
  next to it — with three positional arguments, so the next piece of mention
  information needs a third typedef.

## Decide whether a set of values is closed before using an enum or `sealed`

Consumers switch exhaustively on public enums and sealed classes, because the
analyzer then reminds them of every case they missed. That makes adding a value or
subclass a breaking change for them. Use an `enum` or `sealed` hierarchy only when
the set is closed, or when adding a member is something we are willing to ship in a
major release.

A set is closed when it is **closed by definition**: no future value can exist
(`Axis`, `TextDirection`, ascending/descending, "delete for me" vs "for everyone").
A set is not closed because today's list is complete. Anything enumerated by a design
spec, a product decision, or the backend will grow, however settled it looks — so in
practice almost every design-system enum is open.

For sets that will grow, pick a type consumers cannot switch on exhaustively:

- **Design scales** (sizes, variants, emphasis levels): an `@immutable` class with a
  public `const` constructor and `static const` presets, where each preset carries
  the metrics that go with it. `StreamAvatarSize` is still an enum today; this is the
  shape it moves to.

  ```dart
  @immutable
  class StreamAvatarSize {
    const StreamAvatarSize({required this.diameter, required this.borderWidth});

    static const sm = StreamAvatarSize(diameter: 24, borderWidth: 1);
    static const lg = StreamAvatarSize(diameter: 40, borderWidth: 1);

    /// The predefined sizes, in ascending order.
    static const List<StreamAvatarSize> values = [sm, lg];

    final double diameter;
    final double borderWidth;

    // operator ==, hashCode, and a static lerp.
  }
  ```

  Adding a preset is not breaking, and a consumer who needs a size between two
  presets constructs one instead of waiting for a release. Required constructor
  parameters take over the job of the exhaustive `switch`: a size cannot be added
  without its metrics. A class can also be lerped in a theme, which an enum cannot.
  Keep a hand-maintained `values` list of the presets: tests and the gallery can
  check that every preset is covered, and adding one to the list never breaks a
  consumer's `switch`. Turning an existing enum into this shape keeps
  `StreamAvatarSize.lg`, `.lg` and `.values` compiling; `switch`, `.name`, and
  `.index` break, and so does using a preset as a `const` map key or `const` set
  element, because the class overrides `==`.
- **Values that come from the backend** (reasons, types, roles, statuses): an
  extension type over `String` with `static const` instances, like
  `StreamMentionType`.

  ```dart
  extension type const StreamMentionType(String value) implements String {
    static const user = StreamMentionType('user');
    static const channel = StreamMentionType('channel');
  }
  ```

  Unknown values from a newer backend still round-trip instead of failing to parse,
  and adding a constant is not breaking: a `switch` over the type is checked against
  `String`, so the compiler makes every consumer keep a wildcard (`_`) branch. Values
  keep primitive equality, so they still work as `const` map keys. Keep
  `implements String` when the value is passed straight into string APIs; drop it to
  keep the type opaque. An extension type has no runtime identity — any `String` is
  one — and no `.values`, so add a `static const values` list if the UI needs to show
  the options, and use a class instead when each value has to carry more than its
  name.
- **Values consumers may add themselves**: a non-sealed `base` class (or `abstract base`
  class) with `static const` instances or subclasses, so a custom value is a subclass
  rather than a fork.
- **States that may need to carry data**: a class hierarchy from the start. An enum
  value cannot hold a payload; a subclass can.

When an `enum` or `sealed` type that may grow has to stay one, say so in its dartdoc
and tell consumers to keep a wildcard (`_`) branch in their `switch`. Dart cannot
enforce this, so it is a fallback, not a substitute for choosing an open type.

History:

- Core's `enum StreamAvatarSize` was treated as closed because it matched the design
  spec, until the ringing screens needed a 104px avatar ([core#189]). The same PR
  added sizes to the avatar group, online indicator and badge count enums, and broke
  every exhaustive `switch` over them, our own gallery's and chat's included
  ([chat#2974]).
- Chat's `enum MessageSendingStatus` was replaced by a freezed `MessageState` (6.7.0,
  removed in 7.0.0), whose states can carry data, such as whether a delete is hard,
  that an enum value cannot.
- Chat's `enum AttachmentPickerType` became a `sealed class` with an open
  `CustomAttachmentPickerType` subclass (10.0.1, [chat#2293]), once consumers needed
  their own picker types.
- Video added `ActionCallIncomingFailed` to the sealed `RingingEvent` in a minor
  release (1.6.0, [video#1323]) — breaking for every exhaustive `switch (event)`.

## Model modes, not flags

A `bool` holds two states and its name fixes which one is `true`. When a third state
arrives, the parameter has to change type. Prefer an enum (or class, per the section
above) whenever a setting is a mode rather than an on/off switch, and name booleans
positively (`showX`, `includeX`) so they never need renaming.

History:

- Chat's `MessageState.deleting({required bool hard})` became
  `deleting({required MessageDeleteScope scope})` when "delete for me" arrived
  (10.0.1, [chat#2394]), breaking every `whenOrNull(deleting: (hard) => …)`.
- Video renamed `ignoreLocalParticipantVideo` to `includeLocalParticipantVideo`
  (0.8.0, [video#857]). Both default to `true`, so the rename silently changed the
  default behaviour from hiding local video to showing it.

## Group configuration into an options object

When a constructor or method takes a growing list of tuning knobs or builders, put
them on a dedicated options class (`…Options`, `…Configuration`, `…Builders`): a
`final class` with a `const` constructor, defaults for every field, and `copyWith`.
Adding a knob is then a new optional field. This only works if the object can grow:
required fields and positional constructor parameters on the options class bring the
problem back.

Separately, take the model or value object when the parameters describe an entity,
rather than spreading its fields over the signature.

History:

- Chat moved 17 `*Builder` parameters and 14 behaviour flags off
  `StreamMessageListView` into `StreamMessageListViewBuilders` and
  `StreamMessageListViewConfiguration` (10.0.1, [chat#2674]).
- Chat's `sendReaction(Message message, String type, {int score, Map extraData, …})`
  became `sendReaction(Message message, Reaction reaction, …)` when reactions gained
  `emojiCode` (10.0.1, [chat#2326]).
- Video moved `maxDuration` and `maxParticipants` on `Call.getOrCreate` into
  `StreamLimitsSettings` (0.6.0), which later gained two fields without a break, and
  moved `StreamVideo` constructor flags into `StreamVideoOptions` (0.1.0).

## Use named parameters for anything optional

Optional positional parameters (`[Message? message]`) cannot be followed by named
ones and cannot be reordered, so the second optional argument forces a break. Public
methods use named parameters for everything optional.

History: chat's `addMembers(List<String> memberIds, [Message? message])` gained a
second optional positional in 4.5.0 (`[Message? message, bool hideHistory = false]`),
and 5.0.0 had to break it to make both named:
`addMembers(memberIds, {Message? message, bool hideHistory = false})`, along with
`removeMembers`, `inviteMembers`, and `update`.

## Don't add abstract members to types consumers implement

Every class a consumer may `implements` is frozen: a new abstract member breaks every
implementation. Adding a modifier later is itself a breaking change, so the choice is
made once, at first release. Default new public classes to `final`, and loosen only
when consumers need more:

- `final class` for types consumers only use. We can add anything.
- `base class` (or `abstract base class`) for types consumers extend. New members
  ship with a default implementation, so subclasses keep compiling — unless one
  already declares a member with that name, so prefer specific names. Adding a
  parameter to a method subclasses override still breaks them.
- `abstract interface class` only for genuinely small contracts that will not grow.
  A plain `abstract class` can be both extended and implemented, the widest surface
  of all. If an interface has to grow, add the member with a default in a mixin or
  base class consumers extend, or add a separate capability interface.

Configuration that consumers override piecemeal belongs in an options object with
`copyWith`, not an interface.
→ [Group configuration into an options object](#group-configuration-into-an-options-object)

History:

- Chat added four abstract methods to `AttachmentFileUploader` (10.0.1, [chat#2396]),
  and earlier six to `ChatPersistenceClient` (3.0.0).
- Video's `abstract class CallPreferences` has gained about a dozen abstract getters
  over time; the 1.7.0 changelog tells implementers to "add the getter to your
  implementation".

## Accept the most general type that works

A theme field, constructor parameter, or property takes the most general type the
implementation can handle, not the one today's design happens to use:
`AlignmentGeometry` rather than `Alignment`, `EdgeInsetsGeometry` rather than
`EdgeInsets`, `BorderRadiusGeometry` rather than `BorderRadius`, `BoxBorder` rather
than `Border`, `Gradient` rather than `LinearGradient`, `Decoration` rather than
`BoxDecoration`. The `…Geometry` types let a caller pass the direction-aware
variant (`AlignmentDirectional`, `EdgeInsetsDirectional`), which RTL support needs
sooner or later; the implementation resolves it against `Directionality` where it
reads it.

Widening later is a breaking change: a field typed `EdgeInsets` becomes
`EdgeInsetsGeometry`, and every reader of `.left` or `.horizontal` stops compiling.
Narrowing is never needed, because the general type already accepts every value the
narrow one did.

When wrapping a Flutter widget, take at least the type the wrapped widget takes. A
narrower one only removes options; `Image.alignment` is `AlignmentGeometry`, so a
widget that forwards to it is too. Use the narrow type only when the implementation
genuinely needs the resolved values before it has a `BuildContext`, and say so in
the dartdoc.

Return types and callback arguments go the other way: hand out the most specific
type you can, so callers get the members they need without a cast.

History:

- Chat's `ScrollablePositionedList.padding` changed from `EdgeInsets` to
  `EdgeInsetsGeometry` so it could take directional padding.
- Core alignments that started as `Alignment` had to become `AlignmentGeometry` once
  `AlignmentDirectional` was needed for RTL.

## Wrap values that might grow

A public field, return value, or controller value that is a bare collection,
primitive, or record cannot gain a sibling. Wrap it in a named class when there is a
plausible second piece of information, even if it starts with one field. Never expose
a record type in the public API: records are structural, so adding or renaming a field
is always breaking. And return something meaningful from the start — a "nothing"
return type that later needs to carry a result is a breaking change.

History:

- Chat's `StreamAttachmentPickerController extends ValueNotifier<List<Attachment>>`
  became a controller of `AttachmentPickerValue` when polls were added (9.0.0).
- Video's `Call.stats` returned a record whose fields were renamed and retyped
  (0.11.0, [video#1053]).
- Video's `setScreenShareEnabled` went from `Future<Result<None>>` to
  `Future<Result<RtcLocalTrack>>` (0.9.0, [video#915]).

## Tolerate values from a newer backend

An app version stays installed for years against an API that keeps growing. Parsing
must not fail on anything a newer backend can send:

- an unknown value of a backend-defined set parses to a value (an extension type over
  `String` does this for free) or a documented fallback, never an exception;
- unknown keys in a response are ignored, and a missing optional key takes its
  default;
- a `sealed` hierarchy of events or states parsed from the wire has an `Unknown…`
  case that keeps the raw data, so a new event type is skipped rather than dropped
  with an error.

## When a break is unavoidable

Ship the new API next to the old one in a minor release and mark the old one
`@Deprecated('Use X instead.')`. Keep it for at least one minor release, and remove it
only in a major. When an old and a new parameter coexist, `assert` that at most one is
set and let the new one win. Record the deprecation in the package's `CHANGELOG.md`
with the migration spelled out, following the repository's deprecation policy.

[core#120]: https://github.com/GetStream/stream-core-flutter/pull/120
[core#189]: https://github.com/GetStream/stream-core-flutter/pull/189
[chat#2293]: https://github.com/GetStream/stream-chat-flutter/pull/2293
[chat#2326]: https://github.com/GetStream/stream-chat-flutter/pull/2326
[chat#2394]: https://github.com/GetStream/stream-chat-flutter/pull/2394
[chat#2396]: https://github.com/GetStream/stream-chat-flutter/pull/2396
[chat#2426]: https://github.com/GetStream/stream-chat-flutter/pull/2426
[chat#2643]: https://github.com/GetStream/stream-chat-flutter/pull/2643
[chat#2674]: https://github.com/GetStream/stream-chat-flutter/pull/2674
[chat#2974]: https://github.com/GetStream/stream-chat-flutter/pull/2974
[video#857]: https://github.com/GetStream/stream-video-flutter/pull/857
[video#915]: https://github.com/GetStream/stream-video-flutter/pull/915
[video#983]: https://github.com/GetStream/stream-video-flutter/pull/983
[video#1053]: https://github.com/GetStream/stream-video-flutter/pull/1053
[video#1118]: https://github.com/GetStream/stream-video-flutter/pull/1118
[video#1323]: https://github.com/GetStream/stream-video-flutter/pull/1323

# copyWith audit: moving a model to freezed's copyWith

A model moving onto `@freezed` gives up its hand-written `copyWith` for the generated one. The two treat `null`
differently, freezed can't generate every parameter a hand-written method takes, and most of the difference
compiles cleanly. Run this audit per model before deleting the old method. It lists every call site, in lib and in
tests, whose behaviour or compilation changes, and tells you when freezed's `copyWith` can't replace the model's
at all.

## What changes

| Parameter | v10 hand-written | freezed | How it shows up |
| --- | --- | --- | --- |
| Non-nullable field (`String name`) | `String? name`, null keeps | `String name` | Compile error where a nullable value is passed |
| Nullable field, no sentinel (`String? description`) | null keeps | null clears | Silent: same code, field now wiped |
| Nullable field with `_nullConst` sentinel | null clears | null clears | No change |
| Nullable constructor parameter on a non-nullable field (`String? id` → `id ?? Uuid().v4()`) | null keeps | null runs the constructor default | Silent: a new id or `DateTime.now()` |
| Constructor parameter with no field of the same name (a getter, a private field, a renamed field) | accepted | not generated | Compile error at every call passing it |
| Constructor parameter whose type differs from its field's (`String type` → `MessageType type`) | the field's type | the parameter's type | Compile error where the field's type is passed |

freezed builds `copyWith` from the class's constructor, and keeps a parameter only when a field (not a getter) has
the same name. That is why the last two rows exist.

## Run it

One model per run, named by its class, from anywhere in the repo after `melos bootstrap`:

```bash
python3 .claude/skills/openapi-migration/scripts/copywith_audit.py Poll
```

When two packages declare the class, pass the file: `packages/stream_chat/lib/src/core/models/poll.dart:Poll`. By
default it analyzes every bootstrapped package; `--packages packages/stream_chat packages/stream_chat_flutter …`
narrows it. A run over five packages takes about half a minute.

The model can be on `@Freezed(copyWith: false)` already, or not on freezed at all. For the second, the probe adds
`@freezed`, `with _$Model`, the `part` and the import for the run only. Either way it deletes the hand-written
`copyWith`, regenerates with the `.fvmrc`-pinned SDK, and analyzes twice:

1. As generated. Every error is a compile break.
2. With the `?` dropped from the generated `copyWith` interface. Every new error is a call site passing a value
   that may be null to a nullable parameter, which is exactly where "keeps" became "clears".

**What it touches.** Only the model's file and the generated `*.freezed.dart` / `*.g.dart` files of the model's
package, all restored at the end, even on failure. It refuses to start while any of those has uncommitted changes.
Edits anywhere else, including while it runs, are left alone.

## Read the report

A verdict line appears when freezed's `copyWith` can't replace the model's as it stands, because parameters are
missing or retyped (`Message` is the example: `createdAt` is a getter over server and local timestamps,
`quotedMessageId` a private field with a fallback, `type` a `String` turned into a `MessageType`). Then either keep
`@Freezed(copyWith: false)` with the hand-written method, or reshape the constructor so every parameter is a field
of the same name and type, which is a public API change of its own. The sections below the verdict still show what
each option would cost.

Nullable argument sites are tagged:

* **v10 sentinel, same result**: no action.
* **v10 kept on null; check**: decide whether the value can be null at runtime while the field is set. If it is
  only ever null when the field already is (`nameI18n: nameI18n ?? fallback`), the result is unchanged. Otherwise
  the site needs `value ?? model.field`, or the clear is the intended new behaviour.

Compile breaks in lib usually need a local to carry flow analysis (`translatedName(language)` called twice is not
promoted). Tests that pin the old "null keeps" behaviour flip to the new behaviour.

For a model not yet on freezed, the report covers `copyWith` only. freezed also replaces `==`, `hashCode` and
`toString` (for example, every field counts in `==`, where `Equatable` compared only `props`); check those
separately.

What a changed site means for apps goes in the changelog and the migration guide: list the model's fields under
the rows of the table that apply.

## Known limits

* It finds the hand-written `copyWith` by the shape `Type copyWith({`; a positional or oddly formatted one has to
  be removed by hand first.
* A call through `dynamic` or a tear-off isn't type-checked, so it isn't reported.
* A generated file that is untracked and rewritten by the build can't be restored; commit generated files first.

## Results on the poll models (PR #3037)

* `Poll`: 1 compile break in lib (`stream_message_preview_text.dart:96`), `withTranslationsOf` unchanged,
  sentinel sites unchanged, 1 test to rewrite (`poll_test.dart:40`). Constructor-default trap on `id`,
  `createdAt`, `updatedAt`.
* `PollOption`: no lib changes; 1 test no longer compiles (`poll_option_test.dart:43`).
* `PollVote`: no lib changes; 1 test to rewrite (`poll_vote_test.dart:23`).
* Applying the `Poll` switch for real: analyze clean in all packages, and the only failing non-golden test is the
  one pinning v10 behaviour.

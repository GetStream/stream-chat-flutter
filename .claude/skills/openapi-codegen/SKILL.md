---
name: openapi-codegen
description: >
  Regenerate `stream_chat`'s OpenAPI client into `lib/open_api/`, and fix the generator when its output is wrong.
  Use when the spec or the generator changed and you need new endpoints or fields, when `melos run gen:openapi`
  fails, when generated code does not compile, or when handling the `stream_core` git pin and the release blocker
  it creates. For migrating call sites onto the generated client, use the `openapi-migration` skill instead.
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - Grep
  - Glob
---

# openapi-codegen

The generated client is committed to the repo, so migration work never runs this. Regenerate only when the spec
or the generator changed — a new endpoint, a new field, or a generator fix you need. Land it as its own PR; never
fold a regeneration into a migration slice.

```bash
# preferred — pinned release spec from the protocol repo
PROTOCOL_DIR=/path/to/protocol CHAT_BACKEND_DIR=/path/to/chat melos run gen:openapi

# fresh 'dev' spec straight from the backend monolith
CHAT_BACKEND_DIR=/path/to/chat melos run gen:openapi
```

`scripts/generate.sh` resolves a spec, generates into `packages/stream_chat/lib/open_api`, patches it, runs
`build_runner`, then formats the package. `CHAT_BACKEND_DIR` is required either way — `generate-client` lives in
the monolith, and the protocol repo ships specs only.

After regenerating, refresh the migration plan:

```bash
python3 openapi-migration/tool/generate_plan.py
```

It rebuilds the scope tables in `openapi-migration/*.md` from the new client and reports any operation no group
claims — that is how a newly added endpoint gets noticed instead of sitting unowned.

If a regeneration renames or retypes a generated symbol that migrated code already exposes publicly, that is a
consumer-visible break: add the Symbol Map row to `migrations/v11-migration.md` in the same PR, exactly as a
feature migration would.

| Knob | Meaning |
|---|---|
| `CHAT_BACKEND_DIR` | **Always required.** Checkout of the backend monolith |
| `PROTOCOL_DIR` | Optional. Uses `openapi/v2/chat-clientside-api.json` as-is, skipping spec generation |
| `scripts/renamed-models.json` | Model renames. Currently `Response → DurationResponse` |
| `tools/rename_openapi_models.dart` | Applies those renames to a spec generated without them |
| `packages/stream_chat/build.yaml` | Builder order: freezed → json_serializable → retrofit_generator |

## Things that will bite you

- **Read the provenance line, and the stamp it writes.** The run prints
  `• Using spec …json (API v237.2.0, protocol @ openapi-v237.2.0)`, and `stamp_provenance` records the same facts
  at the top of `lib/open_api/api.dart`:

  ```dart
  // Spec:      chat-clientside-api (API v237.2.0)
  // Source:    protocol @ openapi-v237.2.0
  // Checksum:  0750cb0e…            // protocol's sha256 sidecar, verified before generating
  // Generator: GetStream/chat @ v237.3.0-135-g59094108e1
  ```

  `stream_feeds` stamps the same idea as a single `// Source: GetStream/protocol <path> @ <tag>` line; ours is
  the aligned form, and adds the checksum and generator, which feeds records neither of.

  So a checked-in client says which spec and which templates produced it. Two readings to get right:
  `Generator:` is a `git describe` of the backend checkout, not a release — `v237.3.0-135-g59094108e1` means 135
  commits past that tag — and a `-dirty` suffix on either line means the client came from uncommitted local edits
  and should not be committed. The checksum is verified against protocol's sidecar before generating, so a locally
  edited spec fails the run rather than reaching 1,477 files. The stamp carries no timestamp on
  purpose: regenerating from unchanged inputs must produce no diff, which is also how you tell a real template
  change from noise. Watch for drift between the two versions — a generator far ahead of the spec is worth
  knowing before you debug output.
- **`Response → DurationResponse` is load-bearing.** `stream_core` re-exports `package:dio/dio.dart` wholesale, so
  a generated `Response` collides with dio's inside retrofit's `.g.dart`. Protocol specs ship without the rename,
  which is why `tools/rename_openapi_models.dart` applies it to a temp copy of the JSON spec.
- **`--opt` does not work for Dart.** The Dart language in the monolith's generator does not implement
  `Configurable`, so anything you want configurable has to be added there first.
- **The format step covers the whole package on purpose.** `build_runner` rewrites every output it touches —
  including pre-existing `.g.dart` under `lib/src/` — at the dart_style default width. Narrowing that step to
  `lib/open_api` makes `melos run format` fail in CI.
- **`build_runner`'s output is the real correctness signal.** `analysis_options.yaml` excludes `**/*.g.dart` and
  `**/*.freezed.dart` repo-wide, so the retrofit `.g.dart` and every generated `.freezed.dart` are invisible to
  `melos run analyze`. Read the build log; don't infer success from a green analyze.

## Known generator gap: the call adapter

`client.tpl` emits `_ResultCallAdapter` over `runSafely`, but core's error layer expects `runApiSafely` — the
wrapper that turns a `DioException` into a `StreamException` and catches an undecodable body instead of letting a
`TypeError` escape. Until the template is changed upstream, a regenerated client keeps the old behaviour and every
`Failure` carries a raw `DioException`.

```
monolith/openapi/generator/templates/templates/dart/client.tpl
-  Future<Result<T>> adapt(Future<T> Function() call) => runSafely(call);
+  Future<Result<T>> adapt(Future<T> Function() call) => runApiSafely(call);
```

## When the generated code is wrong

Fix the templates in the monolith (`monolith/openapi/generator/templates/templates/dart/`) and link that PR from
ours. A post-generation patch in `scripts/generate.sh` is acceptable only against a reproducible failure, and only
while the upstream fix is in flight.

There is exactly one such patch today. `EventResponse.event` and `SyncResponse.events` are typed as the WSEvent
union, and the generator emits them broken twice over: a static `fromJson` with no `toJson` and no `@JsonKey`
converters, so json_serializable can't serialize the field; plus a `.freezed.dart` that writes the `WsEvent` type
argument without its `core.` prefix. `patch_ws_event_models()` fixes both in four edits — add `WsEvent` to the
barrel's `show` list, append converter functions to `ws_event.dart`, and point each field's `@JsonKey` at them.

The patch exits with an error if the `@JsonKey(name: 'event')` line it expects is gone. That is the signal upstream
landed the fix and the patch should be deleted, not repaired.

Don't propose "make `fromJson` a factory" — `WSEvent<T>` is generic, so a factory cannot return
`_CustomEvent extends WSEvent<CustomEvent>` where `WSEvent<T>` is expected. The upstream shape is converters
emitted by `model.tpl` / `discriminator.tpl` plus a `WsEvent` re-export from `models-barrel.tpl`.

## Dependencies and the release blocker

`stream_chat` depends on `retrofit`, `retrofit_generator`, `json_annotation ^4.12.0` and `stream_core`.

**`stream_core` is pinned to a git ref in 8 places** — `melos.yaml`, `packages/stream_chat/pubspec.yaml`, and 6
`dependency_overrides` blocks (`sample_app`, `docs/docs_screenshots`, `packages/stream_chat_flutter` and its
example, `packages/stream_chat_localizations` and its example). `stream_core_flutter` declares a *published*
`stream_core` and pub refuses git-vs-hosted for one package, so every consumer of both needs the override.

Bump all 8 together. Pub honors the override's ref over the declared one, so a partial bump silently compiles
against a different core commit than the pubspec claims. To find them all:

```bash
grep -rn "stream_core:" --include=pubspec.yaml packages docs sample_app melos.yaml
```

**`stream_chat` cannot be published while that git dep exists**, and the generator's output needs
`StreamDateTimeConverter`, which is not in the last published `stream_core`. So a `stream_core` release is a
prerequisite for any `stream_chat` release — and it collapses all 8 pins to one hosted constraint.

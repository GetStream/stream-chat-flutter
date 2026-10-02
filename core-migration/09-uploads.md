# 09 — Uploads & CDN

**Goal:** use core's upload machinery — `StreamAttachmentUploader`, `AttachmentUploadTask`,
`AttachmentUploadBatch` — for progress, cancellation and batching, without retyping the models
Drift persists.

**Size:** ~520 chat LOC in scope against ~1,400 core LOC. Gated on one decision, not on volume.

> **Coordinate with [`openapi-migration/12-uploads-cdn.md`](../openapi-migration/12-uploads-cdn.md)
> before either starts.** That group owns the *endpoints*; this phase owns the *machine*. They
> overlap on `CdnClient` and on who writes the multipart calls, and they must not both do it.

## Scope

| Chat today | Core |
| --- | --- |
| `abstract AttachmentFileUploader` — **8 methods**: `sendImage` / `sendFile` / `deleteImage` / `deleteFile` (channel-scoped, each taking `Map<String, Object?>? extraData`) and `uploadImage` / `uploadFile` / `removeImage` / `removeFile` (CDN-scoped) | `abstract interface CdnClient` — **4 methods**, CDN-scoped only, no `extraData` |
| `StreamAttachmentFileUploader` — thin `client.postFile` / `client.delete` wrappers | `StreamAttachmentUploader(cdn: CdnClient)` — returns running `AttachmentUploadTask`s |
| `AttachmentFileUploaderProvider = AttachmentFileUploader Function(StreamHttpClient)` — public pluggability, wired at `client.dart:94` | — |
| `@freezed sealed UploadState` — `UploadStatePreparing` / `UploadStateInProgress(uploaded, total)` / `UploadStateSuccess` / `UploadStateFailed(error: String)`, JSON-serialisable, **stored on the `Attachment` model** | `sealed AttachmentUploadState` — `UploadQueued` / `UploadPreparing` / `UploadInProgress(UploadProgress)` / `UploadSuccess` / `UploadFailed(StreamException)` / `UploadCancelled`, **stored on the task** |
| `AttachmentFile` — `@JsonSerializable`, nullable `path`, sync `size`, persisted to Drift | `AttachmentFile` — wraps `XFile`, non-nullable `path`, `Future<int> size`, not serialisable |

## The gating decision: channel-scoped uploads

Half of chat's uploads are channel-scoped (`/chat/channels/{type}/{id}/file`) and carry
`extraData`. Core's `CdnClient` has no such concept. Two ways forward:

**Option A — chat keeps its own uploader interface, uses core only for the task machinery.**
Keep `AttachmentFileUploader`'s 8 methods (retyped to return `Result`), implement a chat-side
`CdnClient` for the CDN-scoped half, and drive both through `StreamAttachmentUploader` for
progress/cancel/batch. No core release needed, no upstream negotiation, and the public
pluggability point survives in recognisable form.

**Option B — core grows channel-scoped operations.** Cleaner long-term if video and feeds ever
need scoped uploads; today they don't, so it is chat-shaped API in a product-agnostic package —
exactly the leak the README's non-goals warn about.

**A is decided.** It is cheaper, it does not block on a core release, and `CdnClient` is
explicitly a pluggable seam — using it for the part that fits and not for the part that doesn't
is the intended use.

The one thing that could have sunk it is checked: `CdnClient.uploadImage` takes **core's**
`AttachmentFile`, a different type of the same name from the one every chat model and the Drift
payload use, so implementing it means both in scope and a conversion at the seam. That
conversion is total — core ships `AttachmentFile.fromData(Uint8List bytes, {name})` for exactly
the web case chat's nullable `path` exists to serve. Adapter: `path` when there is one,
`fromData` otherwise.

## What core buys us either way

`AttachmentUploadTask` gives chat things it has no way to express today:

- `state` as a `StateEmitter<AttachmentUploadState>` — observable progress with
  `UploadProgress{sentBytes, totalBytes, fraction}`, and the task rescales dio's multipart byte
  counts back onto the file's own length (dio reports the envelope, not the file).
- `result` as a `Future<Result<UploadedAttachment>>` — **failures and cancellations arrive as
  values, never thrown**. A cancelled upload settles as
  `Result.failure(StreamNetworkException(isCancelled: true))`.
- `cancel()` per task.
- `uploadBatch(..., maxConcurrent: 3, eagerError: false)` → `AttachmentUploadBatch` with a sealed
  `BatchUploadResult` (`BatchUploadCompleted` / `BatchUploadStoppedOnError` / `BatchUploadCancelled`)
  and byte-weighted aggregate progress.

Feeds' `utils/uploader.dart` shows the request-glue pattern: an `abstract interface
HasAttachments<T>`, one batch across *all* of a request's attachments so `maxConcurrent` bounds
globally, then redistributing uploaded URLs back onto the request and leaving failures in place
for a retry.

## Keep the models, add the API

**Do not retype `AttachmentFile` or move `UploadState` off `Attachment`.** Core 0.5.0 deliberately
*removed* `StreamAttachment.uploadState` and moved state to the task — a good design for feeds,
and wrong for chat, because:

- **`path` nullable → non-nullable is not expressible.** Chat's `AttachmentFile` carries
  `String? path`, `Uint8List? bytes` and a sync `int? size`; a file picked on web has bytes and no
  path. Core's wraps a single `XFile` with a non-nullable `path` and an async `Future<int> size`.
- **`UploadState` on `Attachment` survives an app restart; task state does not.** It is how the UI
  renders a half-uploaded attachment after a cold start. This is the argument that decides it.
- It is also a `stream_chat` break and a `ChatPersistenceClient` one.

The persistence half is weaker than it looks, and worth stating accurately so nobody plans a
migration that isn't needed. `Attachment.toData()` serialises both `file` and `upload_state`, and
the whole attachment goes into Drift's `attachments` **`text()`** column as JSON — there is no
schema shaped around either type, so retyping them changes a payload, not a table. And any
release that bumps `schemaVersion` drops every table on upgrade, so stale payloads are never read
back by new code.

So expose the task-based API **additively**: `StreamAttachmentUploader` drives the upload and its
task state is *mirrored onto* `Attachment.uploadState` for persistence and rendering. That keeps
the existing surface working and adds progress and cancellation on top.

## Multipart stays hand-written

The spec declares uploads as `multipart/form-data`, but the generated `uploadFile` /
`uploadChannelFile` take a JSON `@Body()` with no progress and no cancellation — unusable. Feeds
hit the same wall and hand-wrote `CdnApi`
(`stream_feeds/lib/src/cdn/cdn_api.dart`) as a retrofit interface using `@MultiPart()`,
`@SendProgress()` and `@CancelRequest()` over the generated *response* models.

Do the same. `openapi-migration/12-uploads-cdn.md` already reaches this conclusion; this is the
phase that acts on it. A generator fix is worth filing upstream (see the `openapi-codegen` skill)
but is not a prerequisite.

**Group 12 landed it** as `lib/src/cdn/cdn_api.dart`, used by `StreamAttachmentFileUploader`. The
public changes: uploads return `Result<UploadedFile>` and deletes `Result<void>`; the provider
receives a `Dio`; `StreamChatApi.fileUploader` is gone. The [Symbol Map](../migrations/v11-migration.md#symbol-map) lists them. This phase builds on
that client rather than writing another.

## Design worked out for a later PR

Group 12 (FLU-885) first went further than the endpoints: it adopted `stream_core`'s upload types
end to end. That was pulled out to keep the endpoint migration small, and is recorded here so this
phase can pick it up.

### What the backend does, which shaped everything else

- **Channel and standalone uploads are a permission boundary, not two copies of one endpoint.**
  `/channels/{type}/{id}/file|image` checks the channel's `uploads` flag and its
  `UploadAttachment` permission, and runs image moderation; `/uploads/file|image` checks the user's
  `UploadAttachmentGlobal` permission (`monolith/utils/upload/upload.go:205-230`). The global routes
  live in `lib/core/api/file`, are tagged product `common` on v2, and are granted next to the feeds
  permissions, so they arrived for feeds and chat adopted them later (JS: "CHA-926 add global
  file/image upload methods"). Message attachments must stay on the channel routes.
- **A standalone URL stays valid only as a user's or channel's image.** The docs say it is re-signed
  only in an `image` / `image_url` field and expires anywhere else.
- **v1 and v2 are the same handlers**, the routes are neither gated nor deprecated, and neither
  reads a form field beyond `file`, `user` (server-side only) and `upload_sizes` — so chat's
  `extraData` parameter has never been sent.
- **A cid is `^[\w-]+:(!members-)?[\w-]+$`** (`ValidChannelCIDRe`): exactly one colon.

### Shape arrived at

```dart
client.fileUploader            // StreamFileUploader, @internal constructor, like ModerationClient
  └─ CdnApi                    // internal; the client takes an @internal CdnApi for tests, like DefaultApi

class StreamFileUploader implements CdnClient {
  Future<Result<UploadedFile>> uploadImage(AttachmentFile image, {ChannelCid? channel, ...});
  Future<Result<UploadedFile>> uploadFile(AttachmentFile file, {ChannelCid? channel, ...});
  Future<Result<void>> deleteImage(String url, {ChannelCid? channel, ...});
  Future<Result<void>> deleteFile(String url, {ChannelCid? channel, ...});
}

Channel.sendImage/sendFile/deleteImage/deleteFile   // unchanged names; pass ChannelCid.from(...)
```

- **One class, routing on the channel.** A null `channel` uses `/uploads`, a given one the channel
  routes. Android's `StreamFileUploader` and iOS's `StreamCDNStorage` are one class too, and internal.
- **It `implements` core's `CdnClient`.** Dart lets an override add optional parameters, so the
  channel is an extra optional parameter on core's four methods. Core's `StreamAttachmentUploader`
  can then drive it; called through `CdnClient` it cannot pass the channel, so message attachments
  need a channel-bound `CdnClient` adapter — verified with a probe: through `client.fileUploader` a
  message image reached `/uploads`, through a channel-bound client it reached the channel route and
  went `Queued → Preparing → InProgress → Success`, and `task.cancel()` settled `UploadCancelled`.
- **No custom-CDN seam.** `AttachmentFileUploader` and its provider go; an app storing files
  elsewhere uploads them itself and sends the attachment with its URL set. Android (`FileUploader`)
  and iOS (`CDNStorage`) keep such a seam, so this is a real loss: adding one back later is an
  interface `StreamFileUploader` implements, without a break.
- **`ChannelCid` and `ChannelType`** (`lib/src/core/models/channel_cid.dart`), both extension types
  over `String`:
  - `ChannelCid(String cid)` validates the shape — one colon, non-blank type and id — as iOS's
    `ChannelId(cid:)` does; it leaves characters to the server rather than copying its regex, so it
    can never reject a cid the backend accepts. `ChannelCid.from({required ChannelType type,
    required String id})` builds one, typed so `type: .messaging` reads as a dot shorthand.
  - `ChannelType` carries the five built-in types (`channel_config.go`) as constants and wraps any
    custom one, following STYLE_GUIDE's "Prefer extension types over enums for server-defined values"
    and the `PushProvider` precedent. iOS has the same set plus `.custom`.
  - Neither retypes the 78 existing `String` cid members; a `ChannelCid` is a `String`, so retyping a
    getter later is non-breaking, but retyping a parameter is not.

### Alternatives considered and set aside

| Alternative | Why not |
| --- | --- |
| Core's `CdnClient` alone as the seam | Cannot carry the channel, so every upload loses the channel's permission check |
| `StreamCdnClient` + `ChannelCdnClient` | Two classes for one concept; one class with an optional channel does the same |
| An `UploadsClient` facade in front of the uploader | A second public type that only renamed calls; the uploader itself is the field |
| A chat-owned `FileUploader` interface with a `ChannelUploadContext` | Context class replaced by `ChannelCid`; interface dropped with the custom seam |
| `ChannelCid.messaging(id)` and friends | Duplicates `ChannelType`'s list and does not cover custom types |
| `ChannelCid.from(type: String)` | Accepts any string, but loses the dot shorthand and the typo check |

### Moving `Attachment.file` onto core's `AttachmentFile`

Required for `StreamAttachmentUploader`, whose `StreamAttachment` carries core's file. Worked out:

- **Persistence** goes through a `@DataSerializable` `AttachmentFileData` (`path`, `name`,
  `mime_type`), restoring `AttachmentFile(path)` or `null` for a file made from bytes or picked on
  the web; `schemaVersion` bumps because the stored bytes change.
- **`file_size`** is no longer derived from the file (core's `size` is async): every builder of an
  attachment sets it in `extraData`, or `StreamAttachmentValidator`'s size limit silently passes.
- **Equality**: core's file has no `==`, so `file` leaves `Attachment.props`.
- **UI**: thumbnails read the path — a blob URL on the web, a file elsewhere (the picker caches
  every composer attachment to a temp file) — instead of synchronous bytes.

It surfaced three `stream_core` bugs, fixed in GetStream/stream-core-flutter#194:

- `toMultipartFile` guarded the async `MultipartFile.fromFile` with `runSafelySync`, so its bytes
  fallback never ran and a file made from bytes failed to upload on mobile and desktop.
- `AttachmentFile.fromData` lost its `name` on mobile and desktop: `XFile.fromData` ignores it
  there, documented as working as intended (flutter/flutter#147361, #87812). With it went the MIME
  type and extension, which broke keyboard-inserted images.
- `extension` returned the whole name for one without an extension (the same fix chat made in
  #3008).

### `cross_file` 0.4

`cross_file` 0.4.0 (flutter/packages#11010) removes `XFile.fromData`, `path`, `mimeType` and
`saveTo`, makes `name` async, and turns the package into a Flutter plugin. `stream_core` is pure
Dart and `image_picker` / `file_picker` still require 0.3, so core stays on `^0.3.4+2` for now. When
the pickers move, the plan is to stop exposing `cross_file` from core:

1. Core owns `AttachmentFile.path`, `.bytes` and `.source({name, mimeType, length, openRead})`, with
   a synchronous `name` and a streamed `toMultipartFile`; `source` covers Android `content://` and
   iOS security-scoped files.
2. An `XFile` → `AttachmentFile` adapter moves to the Flutter layer, the only code that changes
   when the pickers move; core's `AttachmentFile.fromXFile` is deprecated, then removed with the
   `cross_file` dependency.
3. Chat's stored form grows a `kind` and a `uri` for scoped-storage files.

## Decisions to make

Option A is settled, above. What is left:

- ~~Whether `AttachmentFileUploaderProvider` stays as it is or is replaced by a `CdnClient` injection
  point à la `FeedsConfig.cdnClient`.~~ **Answered by group 12:** the typedef is
  `AttachmentFileUploader Function(Dio dio)`, given the `Dio` `DefaultApi` runs on, so it no longer
  names `StreamHttpClient` and 05's last open item is unblocked. The history below is kept for why.

  **This decision changed shape, because phase [05](05-http-client.md) landed differently than
  assumed here.** The original framing was "retyped to `AttachmentFileUploader Function(Dio)` once
  05 removes `StreamHttpClient`". 05 did not remove it — it concluded `StreamHttpClient` *is* the
  verb facade, kept it, and gave it core's `StreamCoreHttpClient` as the `Dio` it builds. The
  typedef still reads `AttachmentFileUploader Function(StreamHttpClient httpClient)` and compiles
  fine, so **nothing forces a retype any more**.

  What remains is a choice, not an obligation: leave the typedef alone (no break for custom
  uploaders, and 09 stays purely additive), or take the break deliberately to move to a `CdnClient`
  injection point. Note 05's own last open item runs the other way — `StreamHttpClient` becomes
  `@internal` only once this typedef stops naming it, so leaving it alone keeps that box open.
- Whether `UploadState` gains a `cancelled` variant to mirror `UploadCancelled`. Today a cancelled
  upload has nowhere to land, which is why cancellation is invisible in the UI.
- Whether progress and cancellation become public API in this phase or stay internal until the UI
  uses them.

## Risks

- **The highest-traffic path in the SDK.** Every image, file, video and voice recording goes
  through it, and a regression is immediately visible to every user.
- **Cancellation semantics differ.** Core's task settles a cancelled upload as a `Failure`
  carrying `isCancelled: true`; chat currently treats cancellation as a thrown
  `DioException`/`StreamChatNetworkError` with `isRequestCancelledError`. Every call site that
  distinguishes cancel-from-error changes.
- **Persistence.** If anything about `Attachment` or `AttachmentFile` serialisation shifts,
  `stream_chat_persistence`'s Drift schema needs a migration — the reason the keep-the-models
  decision above is firm.
- Byte-count rescaling: if the task's rescaling and chat's existing progress reporting disagree,
  progress bars jump. Verify against a large file, not a small one.

## Upstream `stream_core` work

None under Option A. Under Option B: channel-scoped `CdnClient` operations with `extraData`.

Worth filing regardless: the generator emitting JSON bodies for `multipart/form-data` operations.

## Definition of done

- [ ] Option A/B decided and recorded, with the reason.
- [ ] A chat `CdnClient` implementation exists over a hand-written multipart retrofit interface
      with `@MultiPart()` / `@SendProgress()` / `@CancelRequest()`.
- [ ] Uploads run through `StreamAttachmentUploader`; task state is mirrored onto
      `Attachment.uploadState`.
- [ ] `AttachmentFile` and the Drift schema are **unchanged** — asserted by
      `stream_chat_persistence`'s tests passing without a migration.
- [ ] Progress reported correctly for a large file (>10 MB) — the rescaling check, verified against
      real byte counts rather than a mock.
- [ ] A cancelled upload mid-flight settles as a cancellation, not an error, everywhere it is
      observed.
- [ ] A batch upload with one failing member behaves per the chosen `eagerError` setting, and the
      survivors keep their URLs.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`,
      plus `stream_chat_persistence` tests.
- [ ] Hand-verified in `sample_app`: multi-attachment send, cancel mid-upload, upload failure and
      retry, and an app restart with a half-uploaded attachment.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entries, `migrations/v11-migration.md`
      Symbol Map rows plus a File Upload feature section — the guide already promises one.
- [ ] Decisions recorded here, status box ticked in `README.md`, and
      `openapi-migration/12-uploads-cdn.md` updated to point at what this phase settled.
- [ ] Public dartdoc follows [`STYLE_GUIDE.md` § Documentation](../STYLE_GUIDE.md#documentation)
      and [`EFFECTIVE_DART_DOC.md`](../EFFECTIVE_DART_DOC.md), including on symbols this phase
      retyped but whose docs it left alone.
- [ ] Tests follow [`TESTING.md`](../TESTING.md): no `group` organizing a file by method, each
      name states its subject and behaviour.

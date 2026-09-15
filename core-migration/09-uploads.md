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

## Decisions to make

Option A is settled, above. What is left:

- Whether `AttachmentFileUploaderProvider` is retyped (`AttachmentFileUploader Function(Dio)` once
  phase [05](05-http-client.md) removes `StreamHttpClient`) or replaced by a `CdnClient` injection
  point à la `FeedsConfig.cdnClient`. Either way it is a break for anyone with a custom uploader.
  Note phase 05 has **not** landed: the typedef still reads
  `AttachmentFileUploader Function(StreamHttpClient)` and carries no deprecation, so this phase
  either waits for 05 or breaks it itself.
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

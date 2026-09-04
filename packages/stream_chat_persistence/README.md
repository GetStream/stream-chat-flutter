# Official Persistence Client for [Stream Chat](https://getstream.io/chat/sdk/flutter/)

> The official persistence client for Stream Chat, a service for building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_persistence.svg)](https://pub.dartlang.org/packages/stream_chat_persistence)
[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Documentation](https://getstream.io/chat/docs/sdk/flutter/)
- [V10 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration-guide-10-0/)

## Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_persistence/changelog) to see the latest changes in the package.

## Overview

This package provides a persistence client for fetching and saving chat data locally. It is powered by [Drift](https://github.com/simolus3/drift) (SQLite) and plugs into any of the Stream Chat Flutter packages to add offline storage and optimistic UI updates.

## Add Dependency

Add this to your `pubspec.yaml`, using the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_persistence.svg)](https://pub.dartlang.org/packages/stream_chat_persistence):

```yaml
dependencies:
  stream_chat_persistence: ^11.0.0
```

Then run:

```shell
flutter pub get
```

## Usage

1. Create a new instance of `StreamChatPersistenceClient`, providing `logLevel` and `connectionMode`:

```dart
final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.regular,
);
```

2. Pass the instance to the `StreamChatClient`:

```dart
final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
)..chatPersistenceClient = chatPersistentClient;
```

And you are ready to go.

## Flutter Web

On the web, drift runs sqlite3 as WebAssembly inside a web worker. That needs two files which are not part of your
compiled app. Download them from the [drift release][drift-releases] matching the `drift` version your app resolves
— both are published in the same release, which is the only combination guaranteed to be compatible — and copy them
into your app's `web/` folder:

```text
web/
├── drift_worker.js
├── index.html
└── sqlite3.wasm
```

There is nothing to add to `index.html`. `drift_worker.js` is started by drift as a worker at runtime and must
**not** be loaded with a `<script>` tag.

That is the whole setup. drift probes the browser on startup and picks the most reliable storage it supports; the
choice is reported through the client's logger at `Level.INFO`, with a warning when the browser can only offer
storage that two open tabs could corrupt, and a severe record when it cannot persist at all.

### Serve your app cross-origin isolated

Which storage a browser can offer depends on whether your app is [cross-origin isolated][coi]. Serve it with these
two response headers:

```text
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

| Browser | Without the headers | With the headers |
| --- | --- | --- |
| Firefox | origin private file system | origin private file system |
| Chrome / Edge | IndexedDB, shared between tabs | origin private file system |
| Safari | IndexedDB, shared between tabs | origin private file system |

The headers make the browser expose `SharedArrayBuffer`, which is what lets drift turn the asynchronous file system
API into the synchronous one sqlite3 needs. Without them Chrome and Safari fall back to IndexedDB behind a shared
worker. Everything works either way; the headers only make it faster.

During development, `flutter run -d chrome --web-header=Cross-Origin-Opener-Policy=same-origin
--web-header=Cross-Origin-Embedder-Policy=require-corp` serves them.

### Serving the files from somewhere else

If the two files do not sit next to your `index.html` — a CDN, or a custom asset directory — say so with
`webOptions`:

```dart
final chatPersistentClient = StreamChatPersistenceClient(
  webOptions: StreamChatPersistenceWebOptions(
    sqlite3Uri: Uri.parse('/assets/sqlite3.wasm'),
    driftWorkerUri: Uri.parse('/assets/drift_worker.js'),
  ),
);
```

Both default to a path relative to your app's base href, so a non-root `<base href>` is handled for you. If
`sqlite3.wasm` cannot be fetched, `connect` throws with the URI it looked at; if `drift_worker.js` cannot be
fetched, drift falls back to a database that persists nothing and the client logs a severe record naming the file.

A cached database that cannot be opened at all — one left corrupt by a killed tab, say — is discarded and rebuilt
from an empty one, with a warning logged. The local database is only a cache, so this costs one extra sync rather
than blocking sign-in.

[drift-releases]: https://github.com/simolus3/drift/releases
[coi]: https://developer.mozilla.org/en-US/docs/Web/API/crossOriginIsolated

## Contributing

We welcome code changes that improve this library or fix a problem. Please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on GitHub.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.

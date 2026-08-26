# Stream Chat Flutter Sample App

A fully functional messenger built with [`stream_chat_flutter`](https://pub.dev/packages/stream_chat_flutter). The app lives inside this repository and consumes the SDK packages directly via Melos path overrides — making it the primary development playground for the SDK as well as the recommended reference when integrating Stream Chat into your own application.

## Features

- Channel and message lists
- Threads and quoted replies
- Message reactions
- Image, video, and file attachments with media gallery
- Message search
- Pinned messages
- Drafts
- Message reminders
- Static and live location sharing
- Push notifications (Firebase Cloud Messaging)
- Offline storage (powered by `stream_chat_persistence`)
- Light and dark themes
- Localization
- User authentication flow with selectable demo users

## Getting Started

### Prerequisites

Ensure [Flutter](https://flutter.dev/docs/get-started/install) is installed and configured on your machine. You also need [Melos](https://pub.dev/packages/melos) to bootstrap the monorepo:

```bash
dart pub global activate melos
```

### Clone and Bootstrap

```bash
git clone https://github.com/GetStream/stream-chat-flutter.git
cd stream-chat-flutter
melos bootstrap
```

### Run the App

```bash
cd sample_app
flutter run
```

The app connects to a demo Stream environment out of the box — no configuration required to get started. You can log in with any of the pre-configured demo users shown on the login screen.

### Configuration

The default API key and demo user credentials live in `lib/utils/app_config.dart`. You can override the API key at runtime via the **Advanced Options** button on the login screen; the key is stored securely and used for subsequent sessions.

#### Targeting a different Stream app

To point the sample app at another backend — a staging environment, or your own
Stream app — open **Advanced Options** on the login screen and fill in:

| Field | Notes |
| --- | --- |
| **Chat API Key** | Prefilled with the app's configured key. |
| **User ID** / **User Token** | A user on that app, with a token minted from its secret. The demo users on the login screen are signed for the demo app only. |
| **Base URL** | Optional. HTTP base URL of the Stream API; the WebSocket URL is derived from it. Leave empty for the SDK's own endpoint. |

Because these are entered at runtime, this works on an already-built
deployment — including the [hosted web demo](https://getstream.github.io/stream-chat-flutter/).

Whenever a custom API key or base URL is in use, the channel list drops the
`stream_chat_flutter_sample_app` predefined filter — a saved query that exists
only on the demo app — and uses a plain "channels I am a member of" filter
instead.

For local runs the same two settings have compile-time defaults:

```bash
flutter run \
  --dart-define=STREAM_API_KEY=your-api-key \
  --dart-define=STREAM_BASE_URL=https://chat-edge-us-east1-ce1.gcp.stream-io-api.com
```

### Push Notifications

Push notifications require a Firebase project. Add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) to the respective platform directories. See the [push notifications guide](https://getstream.io/chat/docs/sdk/flutter/advanced-guides/push-notifications/) for full setup instructions.

## Supported Platforms

The app primarily targets **Android** and **iOS**. Web and macOS platform scaffolding is present in the repository but is not the focus of the sample app.

# E2E Testing Infrastructure for Flutter (iOS + Android)

A detailed plan to port the Stream Chat **Android** e2e testing infrastructure
to the **Flutter** SDK's `sample_app`, using the
[Patrol](https://github.com/leancodepl/patrol) framework, while reusing the
existing `stream-chat-test-mock-server` and mimicking the Android Robot /
PageObject / test DSL as closely as possible.

The goal is a single shared test suite that runs on **both Flutter iOS and
Android** with maximal code sharing.

---

## 0. TL;DR

- Add Patrol-based integration tests to `sample_app/`.
- Recreate the Android DSL in Dart: **PageObjects** (selector definitions),
  **UserRobot** (fluent UI actions + assertion extensions), **BackendRobot** /
  **ParticipantRobot** (mock-server control), a **StreamTestCase** base, and
  the **mock server client**.
- Reuse `stream-chat-test-mock-server` **as-is** (Ruby/Sinatra driver +
  per-test server). Tests talk to it over HTTP from Dart. **Every test gets its
  own isolated mock-server process** (the driver forks one per `/start/:test`).
- **Decision: Option A — direct in-process configuration.** Because Patrol tests
  run **in-process** (Dart test code lives inside the app), point
  `StreamChatClient` at the mock server **directly from Dart** via a
  `debugConnectionOverride` on the `authController` singleton — no Intent extras
  / env vars needed (the big simplification vs. Android & iOS). Options B
  (`--dart-define`) and C (native bridge) stay documented as alternatives; a few
  cold-start/push tests may use a B-shaped escape hatch (§3.5).
- Add `Gemfile` + Fastlane lanes (`build_e2e`, `run_e2e`, `start/stop_mock_server`,
  Allure upload), mirroring the Android lanes.
- Wire up Allure TestOps reporting and a GitHub Actions e2e job.

---

## 1. Source material (what we are copying)

### Android (primary source)
- App-side suite: `stream-chat-android-compose-sample/src/androidTestE2eDebug/`
  - `pages/` — PageObjects (selector definitions only)
  - `robots/` — `UserRobot` + assertion extension files
  - `tests/` — test classes (`StreamTestCase` base + 11 feature suites)
  - `resources/allure.properties`
- Shared library: `stream-chat-android-e2e-test/src/main/kotlin/.../e2e/test/`
  - `uiautomator/` — thin DSL over UIAutomator (Base, Element, Wait, FindBy, Actions, Math, Permissions)
  - `mockserver/` — `MockServer`, `DataTypes` (enums)
  - `robots/` — `BackendRobot`, `ParticipantRobot`
  - `rules/` — `RetryRule`
- `fastlane/Fastfile`, `fastlane/Allurefile`, root `Gemfile`

### iOS / Swift (reference for the mock-server integration approach)
- `stream-chat-swift/TestTools/StreamChatTestMockServer/` (MockServer, Robots)
- Uses env vars + launch args to pass the mock URL to the app.

### Mock server (reused as-is)
- `stream-chat-test-mock-server/` — Ruby + Sinatra.
  - `driver.rb` (port `4567` by default): `GET /start/:test_name` spawns a fresh
    mock server and returns its port; `GET /stop` shuts the driver down.
  - `src/server.rb` (dynamic port): mocks the Stream REST API **and** the
    WebSocket (`/connect`) including periodic health events.
  - Control endpoints used by tests:
    - **Backend setup:** `POST /mock?channels=&messages=&replies=&messages_text=&attachments=`,
      `/fail_messages`, `/freeze_messages`, `/delay_messages?delay=`,
      `/jwt/revoke_token`, `/jwt/invalidate_token[_date|_signature]`,
      `/jwt/break_token_generation`, `/config/read_events`, `/config/cooldown`,
      `GET /ping`, `GET /jwt/get?platform=`.
    - **Participant actions:** `POST /participant/message` (+ `action`, `thread`,
      `giphy`, `image|video|file`, `delay`, `quote_first|quote_last`),
      `/participant/reaction` (`type`, `delete`, `delay`),
      `/participant/typing/start|stop`, `/participant/read`, `/participant/push`.

---

## 2. Key architectural difference: Patrol vs. UIAutomator / XCUITest

This is the most important thing to internalize before porting, because it
**simplifies** the design relative to Android/iOS.

| | Android (UIAutomator) | iOS (XCUITest) | **Flutter (Patrol)** |
|---|---|---|---|
| Where test code runs | Separate instrumentation process | Separate UI-test runner process | **In-process, inside the app (Dart)** |
| How it drives UI | OS-level accessibility tree | OS-level accessibility tree | Flutter `WidgetTester` finders (+ Patrol native automation for OS dialogs) |
| How app learns the mock URL | `Intent` extra `BASE_URL` | env vars + launch args | **Direct: Dart test builds the client with the mock URL** |
| Selector strategy | `By.res("Stream_X")` resource IDs | accessibility identifiers | `find.byKey` / `patrol.($('...'))` on widget `Key`s / semantics |

**Implications:**
1. **No IPC needed to inject the mock URL.** The Patrol test `main()` constructs
   the app widget itself, so it can pass the mock `baseURL`/`baseWsUrl` straight
   into `StreamChatClient`. We expose a test entrypoint (e.g.
   `runStreamApp(connectionOptions)`) the test calls directly.
2. **The mock-server client (`BackendRobot`/`ParticipantRobot`) runs in Dart**
   inside the same process — it just does HTTP calls to the driver/mock server.
3. **Selectors must be added to the production widgets.** UIAutomator relied on
   `Stream_*` testTags already present in Compose. In Flutter we must add `Key`s
   (or `Semantics(identifier:)`) to the relevant widgets in `stream_chat_flutter`
   and/or `sample_app`. This is the largest cross-cutting code change.
4. **Patrol's native automation** still handles OS-level concerns the in-process
   tester cannot: runtime permission dialogs (photos/camera/notifications),
   notifications, backgrounding the app, toggling wifi/airplane mode — these map
   to the Android `device.*` helpers (`grantPermission`, `disableInternetConnection`,
   `goToBackground`, etc.).

---

## 3. Mock server integration — DECISION + options

> **Decision: we go with Option A (Direct in-process configuration).** Options B
> and C are documented below as alternatives / escape hatches, but A is the
> primary approach the rest of this plan assumes. A handful of tests that need a
> true OS cold start or push-tap navigation may use a B-shaped variant (see
> §3.5).

Android passes the URL via an `Intent` extra; iOS passes it via environment
variables + launch arguments. Neither is necessary for Patrol because the test
runs in-process. Three viable options:

### Option A — Direct in-process configuration (CHOSEN)
The Patrol test resolves the mock-server URL (via the driver) and the app reads
it when it builds its `StreamChatClient`.

**The real seam (grounded in the current code).** The client is *not* passed
into the widget — `StreamChatSampleApp` takes no config (`const
StreamChatSampleApp({super.key})`), and the client is built inside a
**process-wide singleton** `authController` via the private
`_buildStreamChatClient(apiKey)` (`auth_controller.dart`, with `baseURL`/
`baseWsUrl` currently hardcoded-and-commented at lines ~54–55). So we inject the
override onto that singleton *before* the first `connect()` runs, rather than
threading a widget parameter:

```dart
// auth_controller.dart — test seam
StreamConnectionOverride? debugConnectionOverride; // null in production

StreamChatClient _buildStreamChatClient(String apiKey) {
  return StreamChatClient(
    apiKey,
    baseURL: debugConnectionOverride?.baseURL,    // null → SDK default (prod)
    baseWsUrl: debugConnectionOverride?.baseWsUrl,
    logLevel: logLevel,
    logHandlerFunction: _sampleAppLogHandler,
    retryPolicy: RetryPolicy(...),
  )..chatPersistenceClient = _chatPersistenceClient;
}
```

```dart
patrolTest('test_addsReaction', ($) async {
  final mock = await MockServer.start(testName: 'test_addsReaction');
  authController.debugConnectionOverride = StreamConnectionOverride(
    baseURL: mock.httpUrl,   // http://10.0.2.2:<port> (Android) / http://localhost:<port> (iOS)
    baseWsUrl: mock.wsUrl,   // ws://...
  );
  await $.pumpWidgetAndSettle(const StreamChatSampleApp());
  // ... robots/asserts
});
```

Because the URL is read at **client-build time** (first `connect()`), the
driver's per-test **dynamic port** works without any build-time configuration.

**Pros**
- **No IPC** — the single biggest win. Android needs an `Intent` extra and iOS
  needs env vars + launch args only because their runners are out-of-process;
  Patrol runs in-process, so the test sets the URL by direct assignment.
- **One code path for iOS + Android** — the seam is pure Dart; the only platform
  branch is the mock host (`10.0.2.2` vs `localhost`), which lives in
  `MockServer`, not in the app.
- **Trivial robots** — `BackendRobot`/`ParticipantRobot` are plain `http` calls
  in the same isolate as the test; no bridge, no serialization.
- **Prod-safe & tight** — when the override is null, behaviour is unchanged (SDK
  falls back to its default base URL); the shipped diff is a few lines.
- **Per-test dynamic ports work** — URL resolved at runtime from the driver
  (unlike Option B, which bakes a port at build time).

**Cons** (each is one-time setup, not per-test friction)
- **Seam touches a global singleton, not a widget** — `authController` is a
  process-wide `final`; the override is ambient global state (see next point).
- **In-process global state leaks between bundled tests** — Patrol runs all
  tests in one app process. `authController` persists, `tryAutoConnect()` reads
  `FlutterSecureStorage`, and `connect()` deliberately keeps `_client` alive
  (lines ~140–145). Each test must reset in teardown (clear secure storage,
  dispose/reset client, re-set override). Android sidesteps this with
  `clearPackageData true` per test; we emulate it in Dart `tearDown`. See §6.
- **Bypasses the real cold-start path** — the test pumps the widget tree and
  skips `main.dart` (Firebase init, push pipeline, deep-link / `_onNotificationTap`
  entry). Tests that must validate a true OS cold start or push-tap navigation
  don't fit A cleanly → use §3.5.
- **Boot-path side effects can fail under test** — `initState` runs
  `NotificationService.initialize()` and the log handler calls
  `FirebaseCrashlytics.instance.recordError`. Pumping the root widget without
  Firebase configured can throw; guard these behind the e2e flag (see §6).
- **JWT/auth suite needs extra wiring** — the override only covers
  `baseURL`/`baseWsUrl`; the token provider must separately be redirected to the
  mock server's `GET /jwt/get` for the token-expiry tests.

### Option B — `--dart-define` compile-time configuration
Pass `MOCK_HOST`/`MOCK_PORT` via `--dart-define`; the app reads
`String.fromEnvironment(...)` at startup and overrides the client URL.
- **Pros:** No widget param; closest analog to iOS env-var approach; production
  code path stays untouched at runtime (values baked at build).
- **Cons:** Port is dynamic per test (the driver assigns it), but `--dart-define`
  is fixed at build time — so you'd have to pin the mock server to a **fixed
  port per run** (skip the driver's per-test port allocation) or only define the
  host and resolve the port at runtime anyway. Less flexible than A.

### Option C — Native bridge (mimic Android/iOS exactly)
Replicate Android's `Intent`-extra / iOS's env-var mechanism through Patrol's
native layer.
- **Pros:** Most faithful to the existing mobile projects.
- **Cons:** Pointless indirection for Patrol (the test already runs in-process);
  more native plumbing, two platform paths. Not recommended.

### Option A.5 — escape hatch for cold-start / push tests (B-shaped)
A small minority of tests need a true OS launch (deep links, push-tap
navigation via `_onNotificationTap`). Those don't fit in-process pumping. For
them, launch the app natively via Patrol and pass the mock **host** through
`--dart-define` (the app reads `String.fromEnvironment('MOCK_HOST')` at
startup), pinning the driver/server to a known port for that run. The project
ends up **A-primary with a B-shaped escape hatch** for the few launch/push
tests.

### Per-test mock server isolation (independent of the chosen option)
This is determined by the mock-server *driver* design, not by Option A/B/C —
and **yes, every test gets its own dedicated, isolated mock server instance.**

Two processes, two roles:
1. **Driver** (`driver.rb`, one long-lived process on port `4567`) — started
   once per CI run by Fastlane. Stateless; only spawns/tracks servers.
2. **Mock server** (`server.rb`) — one **fresh OS process per test**, on its own
   dynamically-allocated port.

```
test_A → GET /start/test_A → driver forks server.rb → port 5012   (own channels/messages/JWT state)
test_B → GET /start/test_B → driver forks server.rb → port 5013   (completely separate)
```

So if `StreamTestEnv.setUp()` calls `MockServer.start(testName:)` per test (the
port of Android's `StreamTestCase`/`@Before`), no state leaks **at the server
layer**. The important caveat is the *app* side, because Patrol bundles all
tests into **one app process**:

| Layer | Per-test fresh? |
|---|---|
| Mock server process (driver-spawned) | ✅ Yes, automatically |
| Dart app process (Patrol bundle) | ❌ No — shared across all tests |
| `authController` singleton, secure storage, `_client` | ❌ No — must be reset in `tearDown` |

Therefore each test must (a) call `MockServer.start()` in `setUp` and re-inject
the *new* port via `debugConnectionOverride`, and (b) reset app-side globals in
`tearDown` (see §6). Server isolation is free; app isolation is manual.

### Networking detail (applies to all options)
- **Android emulator** reaches the host loopback at `10.0.2.2`; **iOS simulator**
  uses `localhost`/`127.0.0.1`. `MockServer` must pick the host per platform
  (`Platform.isAndroid ? '10.0.2.2' : 'localhost'`).
- The mock server is plain **HTTP/WS** (not TLS). Android needs cleartext
  permitted: add a debug `network_security_config` (or `usesCleartextTraffic`)
  for the e2e build. The Stream client already supports `http://` base URLs; no
  `forceInsecureConnection` equivalent is needed in Dart, but confirm Dio allows
  cleartext on the platform.
- **JWT:** the mock server issues tokens at `GET /jwt/get?platform=`. For
  parity, the sample app's token provider should fetch from the mock server when
  running e2e (needed for the auth/token-expiry suite). For non-auth tests the
  predefined static tokens in `app_config.dart` are sufficient.

---

## 4. Target directory layout (Flutter)

Two homes, mirroring Android's split between the shared lib
(`stream-chat-android-e2e-test`) and the app-side suite
(`androidTestE2eDebug`):

```
sample_app/
├── integration_test/
│   ├── tests/                         # ← androidTestE2eDebug/tests
│   │   ├── stream_test_case.dart      # StreamTestCase base (setUp/tearDown, robots)
│   │   ├── auth_test.dart
│   │   ├── message_list_test.dart
│   │   ├── reactions_test.dart
│   │   ├── quoted_reply_test.dart
│   │   ├── attachments_test.dart
│   │   ├── giphy_test.dart
│   │   ├── draft_messages_test.dart
│   │   ├── message_delivery_status_test.dart
│   │   ├── hyperlinks_test.dart
│   │   ├── channel_list_test.dart
│   │   └── backend_test.dart
│   ├── robots/                        # ← androidTestE2eDebug/robots
│   │   ├── user_robot.dart            # fluent UI actions
│   │   ├── user_robot_channel_list_asserts.dart
│   │   └── user_robot_message_list_asserts.dart
│   ├── pages/                         # ← androidTestE2eDebug/pages
│   │   ├── login_page.dart
│   │   ├── channel_list_page.dart
│   │   ├── message_list_page.dart
│   │   ├── thread_page.dart
│   │   └── jwt_page.dart
│   └── test_bundle.dart               # Patrol bundled-test entrypoint (generated)
│
├── test_driver/
│   └── integration_test.dart          # Patrol/integration_test driver
│
└── e2e/                               # shared helpers (≈ stream-chat-android-e2e-test)
    ├── mock_server/
    │   ├── mock_server.dart           # driver client + per-test server lifecycle
    │   └── data_types.dart            # AttachmentType / ReactionType / MessageDeliveryStatus enums
    ├── robots/
    │   ├── backend_robot.dart
    │   └── participant_robot.dart
    ├── patrol_ext/                    # thin DSL over Patrol (≈ uiautomator/)
    │   ├── waits.dart                 # waitToAppear/waitToDisappear/waitForText
    │   ├── actions.dart               # typeText/longPress/swipe/background/connectivity
    │   └── finders.dart               # selector → PatrolFinder helpers
    └── support/
        ├── retry.dart                 # retry harness (≈ RetryRule)
        ├── allure.dart                # Allure step() + attachments
        └── predefined_users.dart      # ≈ PredefinedUserCredentials
```

> Patrol can also live in a separate package if we want the e2e suite isolated
> from `sample_app`'s own `test/`. Recommendation: keep it inside `sample_app`
> (Patrol expects `integration_test/` next to the app) and add `e2e/` as plain
> Dart source compiled into the test binary.

---

## 5. Component-by-component port

### 5.1 PageObjects (`pages/`)
Android uses nested companion objects of `By.res("Stream_*")`. In Dart, model
the same hierarchy with nested classes exposing **Patrol selectors / Keys**.

Android:
```kotlin
class MessageListPage {
    class Composer {
        companion object {
            val inputField = By.res("Stream_ComposerInputField")
            val sendButton  = By.res("Stream_ComposerSendButton")
        }
    }
    class MessageList {
        companion object { val messages = By.res("Stream_MessageCell") }
        class Message {
            companion object {
                val text = By.res("Stream_MessageText")
                class Reactions {
                    companion object { fun reaction(t: ReactionType): BySelector = ... }
                }
            }
        }
    }
}
```

Dart (keep the same names/structure so the DSL reads identically):
```dart
abstract class MessageListPage {
  static const composer = _Composer();
  static const messageList = _MessageList();
}

class _Composer {
  const _Composer();
  Key get inputField => const Key('Stream_ComposerInputField');
  Key get sendButton => const Key('Stream_ComposerSendButton');
}

class _MessageList {
  const _MessageList();
  Key get messages => const Key('Stream_MessageCell');
  _Message get message => const _Message();
}

class _Message {
  const _Message();
  Key get text => const Key('Stream_MessageText');
  Key reaction(ReactionType type) => Key('Stream_MessageReaction_${type.reaction}');
}
```

**Required production change:** add these `Key`s to the corresponding widgets.
Build a mapping table (Compose `testTag` → Flutter widget → `Key`) and add keys
in `stream_chat_flutter` (and `sample_app` for app-specific screens). Prefer
`Key('Stream_*')` constants matching the Android resource-id strings so the
selector tables stay 1:1. Keep the constant strings in one shared file to avoid
drift between widget and page object.

### 5.2 The Patrol DSL layer (`e2e/patrol_ext/` ≈ `uiautomator/`)
Recreate the wait/action helpers as extensions on `PatrolTester`/`PatrolFinder`:
- `waitToAppear({Duration timeout})`, `waitToDisappear()`, `waitForText()`,
  `waitForCount()` → wrap `patrolTester.waitUntilVisible` / polling.
- `typeText`, `longPress`, `tap`, `swipeUp/Down`, `scrollUntilVisible`.
- Device/native (via Patrol native automator):
  `grantPermission`, `disableInternetConnection`/`enableInternetConnection`
  (Patrol `nativeAutomator` wifi/cellular toggles or `setAirplaneMode`),
  `goToBackground`/`goToForeground`, `tapOnNotification`.
- `defaultTimeout = Duration(seconds: 5)` constant, mirroring Android.

### 5.3 Data types (`e2e/mock_server/data_types.dart` ≈ `DataTypes.kt`)
Direct port of the enums:
```dart
enum AttachmentType { image, video, file }
enum ReactionType {
  love('love'), lol('haha'), wow('wow'), sad('sad'), like('like');
  const ReactionType(this.reaction);
  final String reaction;
}
enum MessageDeliveryStatus { read, pending, sent, failed, nil }
const forbiddenWord = 'wth';
```

### 5.4 Mock server client (`e2e/mock_server/mock_server.dart` ≈ `MockServer.kt`)
```dart
class MockServer {
  MockServer._(this.httpUrl, this.wsUrl);
  final String httpUrl;
  final String wsUrl;

  // Host differs per platform (emulator loopback vs simulator localhost).
  static String get _host => Platform.isAndroid ? '10.0.2.2' : 'localhost';

  // Single Flutter driver port, distinct from the native repos (android=4567,
  // swift=4566) so Flutter e2e can run alongside them. Flutter-iOS and
  // Flutter-Android SHARE this port: they aren't run simultaneously on the same
  // host (CI runs them as separate matrix jobs). Overridable via --dart-define
  // for the rare local case of running both platforms at once.
  static const _driverPort = String.fromEnvironment('MOCK_DRIVER_PORT', defaultValue: '4568');

  static Future<MockServer> start({required String testName}) async {
    final driver = 'http://$_host:$_driverPort';
    final res = await http.get(Uri.parse('$driver/start/$testName'));
    final port = res.body.trim();
    final http_ = 'http://$_host:$port';
    final ws = 'ws://$_host:$port';
    final server = MockServer._(http_, ws);
    // The driver spawns server.rb asynchronously; it needs ~0.5–1s to boot
    // puma before it answers. Poll /ping until ready (verified in the Phase 0
    // spike) so the app doesn't try to connect before the server is listening.
    await server._waitUntilReady();
    return server;
  }

  Future<void> _waitUntilReady({Duration timeout = const Duration(seconds: 10)}) async {
    // poll `GET $httpUrl/ping` until 200 or timeout
  }

  Future<void> stop() { /* optional per-test stop */ }
  Future<http.Response> post(String endpoint, [Object? body]) => ...;
  Future<http.Response> get(String endpoint) => ...;
}
```

### 5.5 BackendRobot / ParticipantRobot (`e2e/robots/` ≈ Android robots)
Faithful Dart ports of the Kotlin robots; each method is one HTTP call and
returns `this` for chaining.
```dart
class BackendRobot {
  BackendRobot(this._mock);
  final MockServer _mock;

  Future<BackendRobot> generateChannels({
    required int channelsCount,
    int messagesCount = 0,
    int repliesCount = 0,
    String? messagesText,
    String? repliesText,
    bool attachments = false,
  }) async { await _mock.post('/mock?channels=$channelsCount&messages=$messagesCount&...'); return this; }

  Future<BackendRobot> failNewMessages() async { await _mock.post('/fail_messages'); return this; }
  Future<BackendRobot> freezeNewMessages() async { ... }
  Future<BackendRobot> revokeToken({int duration = 5}) async { ... }
  Future<BackendRobot> invalidateToken({int duration = 5}) async { ... }
  // ...invalidateTokenDate / invalidateTokenSignature / breakTokenGeneration / setReadEvents / setCooldown
}

class ParticipantRobot {
  static const name = 'Count Dooku';
  Future<ParticipantRobot> sendMessage(String text, {int delay = 0}) async { ... }
  Future<ParticipantRobot> sendMessageInThread(String text, {bool alsoSendInChannel = false}) async { ... }
  Future<ParticipantRobot> editMessage(String text) async { ... }
  Future<ParticipantRobot> deleteMessage({bool hard = false}) async { ... }
  Future<ParticipantRobot> quoteMessage(String text, {bool last = true}) async { ... }
  Future<ParticipantRobot> addReaction(ReactionType type, {int delay = 0}) async { ... }
  Future<ParticipantRobot> deleteReaction(ReactionType type) async { ... }
  Future<ParticipantRobot> startTyping({bool thread = false}) async { ... }
  Future<ParticipantRobot> stopTyping({bool thread = false}) async { ... }
  Future<ParticipantRobot> readMessage({String? parentId}) async { ... }
}
```
> Dart note: the Android robots are synchronous (blocking HTTP); Dart HTTP is
> async, so robot methods return `Future<...>` and tests `await` them. Keep the
> fluent feel via `await robot.x(); await robot.y();` or chained `.then`. This is
> the one unavoidable deviation from the Kotlin DSL.

### 5.6 UserRobot (`robots/user_robot.dart` ≈ `UserRobot.kt`)
Fluent UI-action robot built on the Patrol DSL + page objects. Holds a reference
to the `PatrolTester`. Same method names as Android: `login`, `logout`,
`openChannel`, `sendMessage`, `typeText`, `editMessage`, `deleteMessage`,
`openContextMenu`, `addReaction`, `deleteReaction`, `quoteMessage`, `openThread`,
`sendMessageInThread`, `uploadAttachment`, `uploadGiphy`, `scrollMessageListUp/Down`,
`swipeMessage`, `mentionParticipant`, etc.
```dart
class UserRobot {
  UserRobot(this.$);
  final PatrolTester $;

  Future<UserRobot> login() async {
    await $(LoginPage.loginButton).waitToAppear().tap();
    return this;
  }
  Future<UserRobot> openChannel({int index = 0}) async { ... }
  Future<UserRobot> sendMessage(String text) async {
    await $(MessageListPage.composer.inputField).enterText(text);
    await $(MessageListPage.composer.sendButton).tap();
    return this;
  }
}
```
Assertions go in **extension** files (`user_robot_message_list_asserts.dart`,
`user_robot_channel_list_asserts.dart`), mirroring `UserRobotMessageListAsserts.kt`:
```dart
extension MessageListAsserts on UserRobot {
  Future<UserRobot> assertMessage(String text, {bool isDisplayed = true}) async {
    if (isDisplayed) {
      expect($(MessageListPage.messageList.message.text).$(text), findsOneWidget);
    } else {
      expect($(text), findsNothing);
    }
    return this;
  }
  Future<UserRobot> assertReaction(ReactionType type, {required bool isDisplayed}) async { ... }
  Future<UserRobot> assertMessageDeliveryStatus(MessageDeliveryStatus status, {int? count}) async { ... }
}
```

### 5.7 StreamTestCase base (`tests/stream_test_case.dart` ≈ `StreamTestCase.kt`)
Provide a helper that owns the mock server + robots and the app boot, so each
test reads like the Android one. Implemented as a setup function used inside
`patrolTest`:
```dart
class StreamTestEnv {
  late final MockServer mockServer;
  late final BackendRobot backendRobot;
  late final ParticipantRobot participantRobot;
  late final UserRobot userRobot;

  Future<void> setUp(PatrolTester $, {required String testName, InitActivity init = InitActivity.userLogin}) async {
    mockServer = await MockServer.start(testName: testName);   // fresh per-test server (own port)
    backendRobot = BackendRobot(mockServer);
    participantRobot = ParticipantRobot(mockServer);
    userRobot = UserRobot($);

    // Option A seam: inject this test's mock URL into the global singleton
    // BEFORE the app boots and calls connect().
    authController.debugConnectionOverride = StreamConnectionOverride(
      baseURL: mockServer.httpUrl,
      baseWsUrl: mockServer.wsUrl,
      jwtFromMockServer: init is JwtActivity, // token provider → /jwt/get
    );

    await $.pumpWidgetAndSettle(const StreamChatSampleApp());
    await grantAppPermissions($); // notifications, media
  }

  // App-side reset (Patrol shares one process across bundled tests).
  Future<void> tearDown() async {
    await authController.debugReset();      // clear secure storage, dispose/null client
    authController.debugConnectionOverride = null;
    await mockServer.stop();
  }
}
```
`InitActivity` ports the Android `InitTestActivity` sealed class
(`UserLogin` / `Jwt(baseUrl)`).

### 5.8 Tests (`tests/*.dart`)
Port the 11 Android suites. Use Patrol's `patrolTest` + an Allure-style `step()`
helper to keep the GIVEN/WHEN/THEN structure and Allure IDs.

Android:
```kotlin
@AllureId("5675")
@Test fun test_addsReaction() {
    step("GIVEN user opens the channel") { userRobot.login().openChannel() }
    step("WHEN user sends the message")  { userRobot.sendMessage(sampleText) }
    step("AND user adds the reaction")   { userRobot.addReaction(type = ReactionType.LIKE) }
    step("THEN the reaction is added")   { userRobot.assertReaction(ReactionType.LIKE, isDisplayed = true) }
}
```
Dart (mimicked DSL):
```dart
patrolTest('test_addsReaction', tags: ['AllureId:5675'], ($) async {
  final env = StreamTestEnv();
  await env.setUp($, testName: 'test_addsReaction');
  addTearDown(env.tearDown);

  await step('GIVEN user opens the channel', () async { await env.userRobot.login(); await env.userRobot.openChannel(); });
  await step('WHEN user sends the message',  () async => env.userRobot.sendMessage(sampleText));
  await step('AND user adds the reaction',   () async => env.userRobot.addReaction(ReactionType.like));
  await step('THEN the reaction is added',   () async => env.userRobot.assertReaction(ReactionType.like, isDisplayed: true));
});
```

### 5.9 Retry + Allure (`e2e/support/`)
- **Retry:** Android's `RetryRule(3)` retries failures, clears DB, and captures
  artifacts. Port as a wrapper around `patrolTest` (or use `flutter test`'s
  `retry:` arg / a custom loop). On failure capture: screenshot
  (`$.native.takeScreenshot` / `binding.takeScreenshot`), the widget tree dump,
  and logs; attach to Allure.
- **Allure:** add `allure.properties`, emit results in the
  `allure-results` format. `step(name, body)` records a step + timing; on
  teardown write the `*-result.json`. Reuse the Fastlane `Allurefile` lanes
  (`allure_upload`, `allure_launch`) unchanged — they're tool-agnostic.

---

## 6. Production-code changes required in `sample_app` / `stream_chat_flutter`

1. **Connection-override seam (Option A).** Add a nullable
   `debugConnectionOverride` (a tiny `StreamConnectionOverride` holding
   `baseURL`/`baseWsUrl`) to `AuthController`, and have
   `auth_controller.dart::_buildStreamChatClient` read it (replacing the
   hardcoded-commented lines ~54–55). Null in production → SDK default base URL,
   so the shipped diff is inert. The Patrol test sets
   `authController.debugConnectionOverride` before `pumpWidget`.
2. **App-side reset for bundled tests.** Because Patrol shares one app process
   and `authController` is a process-wide singleton that keeps `_client` alive
   and auto-connects from `FlutterSecureStorage`, add a test-only reset path
   used in `tearDown`: clear secure storage, `dispose()`/null the client, and
   clear `debugConnectionOverride`. (Mirrors Android's per-test
   `clearPackageData true`.) Server-side state is already fresh per test via the
   driver — this only covers app-side leakage.
3. **Guard boot-path side effects under e2e.** When `debugConnectionOverride` is
   set, skip/stub the side effects that assume a full native launch:
   `NotificationService.initialize()` (in `app.dart` `initState`), push device
   registration (`PushTokenManager`), and `FirebaseCrashlytics.recordError` (in
   `_sampleAppLogHandler`). Otherwise pumping the root widget without Firebase
   configured can throw.
4. **JWT via mock server (auth suite only).** When the e2e override indicates a
   mock JWT flow, make the token provider fetch from `GET /jwt/get?platform=flutter`.
5. **Widget `Key`s / semantics identifiers.** Add `Stream_*` keys to the widgets
   the page objects target (composer input/send, message cell/text, reactions,
   channel list tile, avatar, headers, context-menu items, thread items, scroll
   buttons, login button, JWT/connection screen). This touches
   `stream_chat_flutter` components and some `sample_app` screens.
6. **Android cleartext for e2e build.** Add a debug `network_security_config`
   permitting cleartext to `10.0.2.2` (mock server is HTTP/WS).
7. **iOS ATS exception** for `localhost` HTTP in the test build (Info.plist
   `NSAppTransportSecurity` / `NSAllowsLocalNetworking`).

---

## 7. Tooling: Gemfile + Fastlane + Patrol CLI

### 7.1 Gemfile (root of repo or `sample_app/`)
Port the Android root `Gemfile`, dropping Sinatra deps (the mock server has its
own `Gemfile`):
```ruby
source 'https://rubygems.org'
gem 'fastlane', '2.225.0'
gem 'json'
gem 'rubocop', '1.38', group: :rubocop_dependencies
eval_gemfile('fastlane/Pluginfile')   # include allure-testops plugin
```
The mock server's own gems (`sinatra`, `puma`, `faye-websocket`, `eventmachine`,
`rackup`) come from cloning `stream-chat-test-mock-server` (its Gemfile).

### 7.2 Fastlane lanes (port `Fastfile` + `Allurefile`)
New lanes under `sample_app/fastlane/` (or root), composing existing build lanes:
- `start_mock_server(local_server:, branch:)` — clone (or use local)
  `stream-chat-test-mock-server`, `bundle install`, run `ruby driver.rb 4567 &`,
  log to `logs/`. (Port from Android `start_mock_server`; Swift uses port 4566 —
  pick one, e.g. **4567**, and keep it consistent in `MockServer._driverPort`.)
- `stop_mock_server` — `GET http://localhost:4567/stop`.
- `build_e2e_test` — `patrol build android` / `patrol build ios` (or
  `flutter build` of the integration test target). Gate with the Android-style
  `is_check_required` if desired.
- `run_e2e_test(batch:, batch_count:, device:, local_server:, mock_server_branch:)`:
  1. `start_mock_server`
  2. grant permissions / boot emulator-simulator (Patrol handles app perms; OS
     setup via `adb`/`xcrun simctl` as on Android)
  3. `patrol test --target integration_test/tests/<...> [--dart-define ...]`
     (Patrol drives both platforms; supports test sharding for batching)
  4. collect `allure-results`
  5. `stop_mock_server`
- `build_and_run_e2e_test` — convenience wrapper (port of Android lane).
- Reuse `Allurefile` lanes verbatim: `allure_launch`, `allure_upload`,
  `allure_start_regression`.

### 7.3 Patrol CLI
Add `patrol_cli` as a tool dependency; `patrol` + `integration_test` as
`dev_dependencies` in `sample_app/pubspec.yaml`. Create `patrol.yaml` with the
app id (`io.getstream.chat.android.flutter.sample` / `io.getstream.flutter`) and
test target config.

---

## 8. CI (GitHub Actions)

Add an `e2e` job (new workflow `e2e_test.yml`, or a job in
`stream_flutter_workflow.yml`), modeled on the Android pipeline:
- Matrix over `{android-emulator, ios-simulator}` and optional test batches.
- Steps: checkout → setup Ruby + `bundle install` → setup Flutter + `melos bootstrap`
  → boot emulator/simulator → `bundle exec fastlane run_e2e_test` (which starts
  the mock server, runs Patrol, gathers Allure results) → `allure_upload`.
- Use `allure_launch` to create the TestOps launch and pass `LAUNCH_ID` between
  jobs (as Android does).
- Keep it off the default PR path initially (manual / nightly / label-gated) to
  avoid flakiness blocking PRs, matching how heavy e2e usually runs.

---

## 9. melos wiring
- Add an `e2e` script group in `melos.yaml`, e.g.
  `e2e:build`, `e2e:run` that `cd sample_app && patrol ...`, so it's invokable
  like the existing `test:*` scripts.
- Ensure `sample_app` `integration_test/` doesn't get swept into the regular
  `test:flutter` melos filter (it targets `dirExists: test`, so
  `integration_test/` is naturally excluded — verify).

---

## 10. Phased implementation

1. **Foundations**
   - Add Patrol + integration_test deps, `patrol.yaml`, `test_driver/`.
   - Add the connection-options test seam in `sample_app` (Option A) and verify a
     trivial Patrol test boots the app pointed at a manually-started mock server.
2. **Mock server client + robots**
   - Port `MockServer`, `data_types.dart`, `BackendRobot`, `ParticipantRobot`.
   - Validate against a locally running `driver.rb` (channels generate, participant
     sends a message that appears in the app).
3. **Selectors**
   - Add `Stream_*` `Key`s to widgets; build the page object files.
4. **DSL + base**
   - Port the Patrol-ext helpers, `UserRobot` + assertion extensions,
     `StreamTestEnv`/`StreamTestCase`, `step()`/Allure, retry harness.
5. **Tests**
   - Port suites in order of value: `MessageListTests`, `ReactionsTests`,
     `QuotedReplyTests`, `ChannelListTests`, then `Attachments`, `Giphy`,
     `Drafts`, `DeliveryStatus`, `HyperLinks`, `Auth`, `Backend`.
6. **Tooling + CI**
   - Gemfile, Fastlane lanes, Allure config, GitHub Actions job; get green on
     both an Android emulator and an iOS simulator.

---

## 11. Risks / open questions
- **Selector coverage** is the biggest effort: every Android `Stream_*` testTag
  needs a Flutter `Key`/semantics equivalent; some widgets may need upstream
  changes in `stream_chat_flutter`.
- **Async robots:** Dart's async HTTP means `BackendRobot`/`ParticipantRobot`
  methods are `Future`s — slightly less terse than Kotlin's blocking chains.
- **Connectivity toggling** (offline/online for the auth/token tests) depends on
  Patrol's native automator support per platform; verify wifi/airplane toggles
  work on both iOS simulator and Android emulator (Android emulator can toggle;
  iOS simulator network toggling is more limited — may need a host-level toggle
  or to mock via the server's `freeze/delay` endpoints instead).
- **Driver port — one Flutter port, distinct from the native repos.** The port
  is just the CLI arg to `driver.rb`, so we're free to choose. Flutter uses a
  single port shared by both its platforms:

  | Suite | Host | Driver port |
  |---|---|---|
  | stream-chat-android (native) | `10.0.2.2` | 4567 *(existing)* |
  | stream-chat-swift (native) | `localhost` | 4566 *(existing)* |
  | **Flutter (iOS + Android)** | `10.0.2.2` / `localhost` | **4568** |

  - Distinct from 4566/4567 → Flutter e2e never clashes with the native repos if
    a developer runs them together.
  - Flutter-iOS and Flutter-Android **share** 4568: in CI they're separate
    matrix jobs on separate runners, so they never share a host. Note the
    `10.0.2.2`/`localhost` split does *not* prevent a collision if both ran on
    one host — both drivers bind the host's port — so for the rare local case of
    running both platforms at once, override via `--dart-define=MOCK_DRIVER_PORT=...`
    (and pass the matching port to `driver.rb` in that run).
  - Keep `MockServer._driverPort` and the Fastlane lanes in sync on `4568`.
- **Cleartext/ATS:** must be enabled only for the e2e build flavor, not release.
- **JWT flow** for the auth suite requires the token provider to call the mock
  server — confirm the sample app's auth path can be redirected in test mode.

---

## 12. Implementation checklist

Work top-to-bottom. Each phase ends in something runnable/verifiable so we never
go more than a step or two without feedback. Decision is **Option A** (§3).

### Phase 0 — Spike: prove the seam end-to-end
- [x] Add a `Gemfile` (fastlane) + Fastlane skeleton, and port the
      `start_mock_server` / `stop_mock_server` lanes from the native repos'
      Fastfiles (clone-or-local mock-server repo → `bundle install` → launch
      `ruby driver.rb 4568` in the background → `/stop` on teardown).
      → Done in `sample_app/Fastfile` (shared, imported by both platform Fastfiles).
      Verified end-to-end against the real driver on 4568: `/start/:test` spawns a
      per-test server that answers `/ping` 200 after ~0.6s; `/stop` tears it down.
- [x] Add `patrol` + `integration_test` to `sample_app/pubspec.yaml` dev deps (and `patrol` to melos.yaml); `melos bootstrap`. → patrol 4.6.1 resolved. `patrol_cli` is a global CLI (`dart pub global activate patrol_cli`, 4.4.0 used) — not a package dep.
- [x] Add Patrol config as a `patrol:` section **in `pubspec.yaml`** with `test_directory: integration_test` and app ids `io.getstream.chat.android.flutter.sample` / `io.getstream.flutter`.
- [x] Add `StreamConnectionOverride` + `debugConnectionOverride` to `AuthController`; wire into `_buildStreamChatClient` (§6.1). Plus an `isE2eTestRun` flag guarding Firebase/Crashlytics, push registration, and notifications (§6.3 pulled forward — required for in-process pumping).
- [x] Add platform host helper (`10.0.2.2` Android / `localhost` iOS). → in `integration_test/_spike/mock_server.dart`.
- [x] Write one throwaway `patrolTest` that starts a mock server, sets the override, pumps `StreamChatSampleApp`, asserts the channel list loads. → `integration_test/spike_seam_test.dart` (asserts `StreamChannelListHeader`). Analyzes clean.
- Connection config: **already satisfied** — iOS `Info.plist` has `NSAllowsArbitraryLoads=true`; Android **debug** manifest has `usesCleartextTraffic="true"` (Patrol uses a debug build). §6.6/§6.7 need no work.
- [x] **Native Patrol test-target integration.**
      - Android: `PatrolJUnitRunner` as `testInstrumentationRunner` + `ANDROIDX_TEST_ORCHESTRATOR` + `androidx.test:orchestrator` (`android/app/build.gradle`); `MainActivityTest.java` entry class under `android/app/src/androidTest/`.
      - iOS: `RunnerUITests` UI-testing target added to `Runner.xcodeproj` via the `xcodeproj` gem (script `ios/add_patrol_target.rb`), `RunnerUITests/RunnerUITests.m` bridge (`PATROL_INTEGRATION_TEST_IOS_RUNNER`), and the `target 'RunnerUITests'` block in the Podfile.
- [x] Run on an Android emulator. **✅ PASS** — `patrol test` built, installed, ran the instrumentation, and the spike connected to the mock server and rendered the channel list. (Fix: placeholder token must be a structurally-valid JWT — reused qatest1's.)
- [x] Run on an iOS simulator. **✅ PASS** — `TEST EXECUTE SUCCEEDED`, same spike. Two scripted-target gaps fixed (now baked into `ios/add_patrol_target.rb`): UI test bundle needs `GENERATE_INFOPLIST_FILE = YES` and `PRODUCT_NAME = $(TARGET_NAME)` (else the nameless `.xctest` collides as "Multiple commands produce …/PlugIns/.xctest").
- **✅ Phase 0 gate met: the Option A seam is proven on both Android emulator and iOS simulator.** Connection config (§6.6/§6.7) already satisfied — iOS `NSAllowsArbitraryLoads`, Android debug `usesCleartextTraffic`.
- ⚠️ **Toolchain note:** system Java is 26.0.1, which Gradle 8.13 rejects. Android builds need a supported JDK — set `JAVA_HOME=/opt/homebrew/opt/openjdk@21/...` (or `flutter config --jdk-dir`). Record this for CI.

### Phase 1 — Foundations & app-side plumbing
- [ ] Create the directory layout from §4 (`integration_test/{tests,robots,pages}`, `e2e/{mock_server,robots,patrol_ext,support}`, `test_driver/`).
- [ ] Implement `AuthController.debugReset()` (clear secure storage, dispose/null client) for per-test teardown (§6.2).
- [ ] Guard boot-path side effects under the e2e flag: `NotificationService.initialize()`, `PushTokenManager`, `FirebaseCrashlytics.recordError` (§6.3).
- [ ] Android: add debug `network_security_config` allowing cleartext to `10.0.2.2` (§6.6).
- [ ] iOS: add ATS / `NSAllowsLocalNetworking` exception in the test build (§6.7).
- [ ] **Gate:** Phase 0 spike still green after globals are reset between two dummy tests in one bundle.

### Phase 2 — Mock server client + control robots
- [ ] Port `data_types.dart` (`AttachmentType`, `ReactionType`, `MessageDeliveryStatus`, `forbiddenWord`).
- [ ] Implement `MockServer` (driver `/start/:test`, dynamic port, per-platform host, `get`/`post`, `stop`).
- [ ] Port `BackendRobot` (generateChannels, fail/freeze/delay, JWT revoke/invalidate/break, read_events, cooldown).
- [ ] Port `ParticipantRobot` (message/thread/edit/delete/quote, reactions, typing, read, giphy, attachments).
- [ ] **Gate:** a test calls `backendRobot.generateChannels(...)` + `participantRobot.sendMessage(...)` and the message appears in the app.

### Phase 3 — Selectors (the big one)
- [ ] Build the mapping table: Android `Stream_*` testTag → Flutter widget → `Key`.
- [ ] Add `Key('Stream_*')` (or `Semantics(identifier:)`) to targeted widgets in `stream_chat_flutter` (composer, message cell/text, reactions, context menu, headers, avatars, scroll buttons, thread items).
- [ ] Add keys to `sample_app` screens (login/choose-user, JWT/connection screen, channel list tile).
- [ ] Keep the selector strings in one shared constants file to avoid widget/page-object drift.
- [ ] Implement the `pages/` PageObjects (`login`, `channel_list`, `message_list`, `thread`, `jwt`) referencing those keys.
- [ ] **Gate:** a test finds and taps the composer input + send button via page objects.

### Phase 4 — DSL, robots & base
- [ ] Implement `patrol_ext/` helpers: `waits.dart`, `actions.dart`, `finders.dart` (+ `defaultTimeout`).
- [ ] Implement `support/`: `allure.dart` (`step()` + attachments), `retry.dart` (≈ `RetryRule`), `predefined_users.dart`.
- [ ] Implement `UserRobot` (fluent UI actions) + assertion extensions (`message_list`, `channel_list`).
- [ ] Implement `StreamTestEnv` (`setUp`/`tearDown` per §5.7) and `InitActivity` (userLogin / jwt).
- [ ] **Gate:** one fully-ported test (`test_addsReaction`) passes on both platforms using the full DSL.

### Phase 5 — Port the test suites
Port in value order; each is a checkpoint:
- [ ] `MessageListTests`
- [ ] `ReactionsTests`
- [ ] `QuotedReplyTests`
- [ ] `ChannelListTests`
- [ ] `AttachmentsTests`
- [ ] `GiphyTests`
- [ ] `DraftMessagesTests`
- [ ] `MessageDeliveryStatusTests`
- [ ] `HyperLinksTests`
- [ ] `AuthTests` (needs JWT-from-mock-server + connectivity toggling)
- [ ] `BackendTests`
- [ ] **Gate:** full suite green locally on Android emulator + iOS simulator.

### Phase 6 — Tooling, Allure & CI
> `Gemfile` + Fastlane skeleton and `start_mock_server`/`stop_mock_server` were
> already added in Phase 0. This phase adds the build/run/Allure lanes that
> depend on the test suite existing.
- [ ] Flesh out the `Gemfile` (add rubocop + Pluginfile w/ allure-testops plugin) (§7.1).
- [ ] Add the remaining Fastlane lanes: `build_e2e_test`, `run_e2e_test`, `build_and_run_e2e_test` (composing the existing `start_mock_server`/`stop_mock_server`) (§7.2).
- [ ] Reuse Android `Allurefile` lanes: `allure_launch`, `allure_upload`, `allure_start_regression`.
- [ ] Add `allure.properties` + emit `allure-results`; attach screenshots/logs on failure.
- [ ] Add melos `e2e:build` / `e2e:run` scripts; verify `integration_test/` is excluded from `test:flutter` (§9).
- [ ] Add GitHub Actions `e2e_test.yml` (matrix android/ios, mock server + Patrol + Allure upload); start label-gated/nightly, not on default PR path (§8).
- [ ] Use a single Flutter driver port `4568` (distinct from native repos' 4566/4567; shared by iOS+Android, overridable via `--dart-define=MOCK_DRIVER_PORT`) in both `MockServer._driverPort` and the Fastlane lanes (§11).
- [ ] **Gate:** CI run green on both platforms with results visible in Allure TestOps.

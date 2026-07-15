# Flutter AI components by [Stream](https://getstream.io/chat/sdk/flutter/)

> A standalone set of Flutter components for building LLM-driven chat experiences:
> streaming text, animated typing indicators, syntax-highlighted code blocks, charts,
> a purpose-built AI composer, and speech-to-text input. This package has **no
> dependency on `stream_chat`, `stream_chat_flutter`, or any other Stream Chat
> package** — every widget operates on plain strings, callbacks, and controllers, so
> it can be dropped into any Flutter app or paired with any backend/LLM provider. See
> [Using with Stream Chat](#using-with-stream-chat) below for wiring it up to a Stream
> Chat channel.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter_ai.svg)](https://pub.dartlang.org/packages/stream_chat_flutter_ai)
[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Flutter AI Assistant Tutorial](https://getstream.io/blog/flutter-assistant/)

---

## Components

### `StreamingMessageView`

Renders markdown text with a character-by-character typewriter animation — ideal for
displaying streaming AI responses as they arrive. Markdown is fully parsed: code fences
get a dark-themed `CodeBlockView` (with copy button), and JSON/chart fences are rendered
as interactive charts via `ChartView`.

```dart
StreamingMessageView(
  text: markdownText,          // updated in real time as chunks arrive
  typingSpeed: Duration(milliseconds: 10),
  onTypewriterStateChanged: (state) {
    // TypewriterState.typing | idle | paused | stopped
  },
);
```

### `AITypingIndicatorView`

Shows the current AI state ("Thinking…", "Checking sources…") with animated pulsing dots.

```dart
AITypingIndicatorView(
  text: 'AI is thinking',
  dotColor: Colors.blue,
  dotCount: 3,
  dotSize: 8,
);
```

### `TypewriterController`

Low-level controller for driving the typewriter effect independently of
`StreamingMessageView`. Use with `TypewriterBuilder` for custom layouts.

```dart
final controller = TypewriterController(text: '');

// As new chunks arrive from the LLM:
controller.updateText(accumulatedText);

// In your widget tree:
TypewriterBuilder(
  controller: controller,
  builder: (context, value, child) => Text(value.text),
);
```

### `AIMarkdownBody`

Segment-based markdown renderer used internally by `StreamingMessageView`. Use it
directly when you need markdown rendering without the typewriter animation.

```dart
AIMarkdownBody(
  data: markdownText,
  selectable: true,          // enables text selection on desktop / web
  onTapLink: (text, href, title) { /* handle link tap */ },
);
```

### `CodeBlockView`

Renders a fenced code block with a dark background, monospace font, optional language
label, and a copy-to-clipboard button.

```dart
CodeBlockView(
  code: 'void main() => print("hello");',
  language: 'dart',
);
```

### `ChartView` + `USpec`

Renders a `USpec` chart as a line, bar, or pie chart powered by `fl_chart`. Parse AI
responses that contain JSON chart data with `USpecParser`:

```dart
final spec = USpecParser.tryParse(jsonString);   // supports USpec and Chart.js formats
if (spec != null) ChartView(spec: spec);
```

---

### `ChatComposer`

A message composer designed for AI-powered conversations. Features:

- **Suggestion chips** (`ChatOption`) shown above the input when no option is selected.
- An **inline selected-option badge** (with dismiss button) inside the input box.
- A **send / stop toggle** — the send button (↑) becomes a stop button (⏹) while the
  AI is generating a response.
- An optional **voice / send toggle** (`enableSpeechToText: true`) — a single control that
  shows a microphone while the field is empty and swaps to send as soon as you type.
- Factory-based slot customisation via `ChatComposerFactory`.

```dart
ChatComposer(
  controller: controller,
  enableSpeechToText: true, // requires the platform permissions documented below
  onSendPressed: (text, selectedOption) async {
    await myBackend.sendMessage(text);
  },
  onStopPressed: () => myBackend.stopGenerating(),
);
```

### `ChatComposerController`

`ChangeNotifier` that manages all mutable state for `ChatComposer`.

```dart
final controller = ChatComposerController(
  chatOptions: [
    ChatOption(id: 'summarize', text: 'Summarize this', icon: Icons.summarize),
    ChatOption(id: 'email',     text: 'Write an email',  icon: Icons.email),
  ],
);

// While the AI is generating:
controller.isGenerating = true;

// When the response finishes:
controller.isGenerating = false;
```

### `ChatComposerFactory`

Subclass to override the leading and/or trailing regions of the composer — for slots other
than the send button itself (e.g. an attachment picker):

```dart
class MyComposerFactory extends ChatComposerFactory {
  @override
  Widget buildLeading(BuildContext context, ChatComposerController controller) {
    return IconButton(icon: const Icon(Icons.attach_file), onPressed: () { ... });
  }
}

// Pass to the composer:
ChatComposer(
  factory: MyComposerFactory(),
  ...
);
```

---

### `AISuggestionsView`

A horizontally-scrolling row of free-text quick-reply chips, independent of `ChatOption`. Typically
docked above the composer on a "new chat" landing screen — tapping a chip fires the callback with
its exact text, and you decide what happens next (e.g. send it immediately).

```dart
Column(
  children: [
    const Spacer(),
    AISuggestionsView(
      suggestions: const [
        'Create a painting in Renaissance-style',
        'Help me study vocabulary for an exam',
      ],
      onSuggestionSelected: (text) => sendMessage(text),
    ),
  ],
)
```

---

### `SpeechToTextButton`

A microphone button that feeds partial and final speech recognition results directly
into an `ChatComposerController`'s text field. The button hides itself automatically
when the AI is generating or the text field is non-empty. Prefer
`ChatComposer(enableSpeechToText: true, ...)` over placing this widget manually — that
swaps it into the send button's own slot for a single toggling control, rather than a
separate button alongside send.

```dart
SpeechToTextButton(
  controller: controller,
  localeId: 'en-US',                             // optional; defaults to device locale
  listenFor: Duration(seconds: 30),
  pauseFor: Duration(seconds: 3),
  onError: (error) => print(error.errorMsg),
);
```

#### Required platform permissions

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is needed for voice input.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Speech recognition is used to convert your voice to text.</string>
```

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

**macOS** — `macos/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is needed for voice input.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Speech recognition is used to convert your voice to text.</string>
```

`macos/Runner/DebugProfile.entitlements` (and `Release.entitlements`):
```xml
<key>com.apple.security.device.audio-input</key>
<true/>
<key>com.apple.security.device.microphone</key>
<true/>
```

---

## Installation

`stream_chat_flutter_ai` has no dependency on Stream Chat — install it on its own:

```yaml
dependencies:
  stream_chat_flutter_ai: ^0.0.1
```

## Using with Stream Chat

The components in this package are provider-agnostic: they take plain text, callbacks,
and controllers, so you decide how to source and stream AI responses. If you're building
on top of [Stream Chat](https://getstream.io/chat/sdk/flutter/), here's how the pieces
typically connect to a `Channel` from `stream_chat_flutter`. This requires adding
`stream_chat_flutter` as a dependency of your app (not of this package):

```dart
channel.on(EventType.aiIndicatorUpdate).listen((event) {
  final state = event.aiState;     // AITypingState enum
  final msgId = event.aiMessage;   // ID of the message being generated
  controller.isGenerating = state == AITypingState.generating;
  // show AITypingIndicatorView / switch to StreamingMessageView
});

channel.on(EventType.aiIndicatorClear).listen((_) {
  controller.isGenerating = false;
  // hide the indicator, show the final message
});
```

Stop an in-progress AI response:

```dart
await channel.stopAIResponse();
```

Send the composer's text as a new message:

```dart
ChatComposer(
  controller: controller,
  onSendPressed: (text, selectedOption) => channel.sendMessage(Message(text: text)),
  onStopPressed: () => channel.stopAIResponse(),
);
```

See the [Flutter AI sample app](https://github.com/GetStream/chat-ai-samples/tree/main/flutter)
for a complete, working integration.

## Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_flutter_ai/changelog) to see the latest changes in the package.

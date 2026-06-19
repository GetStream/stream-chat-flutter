# Official Flutter AI components for [Stream Chat](https://getstream.io/chat/sdk/flutter/)

> AI-powered Flutter components for Stream Chat. Build LLM-driven chat experiences with
> streaming text, animated typing indicators, syntax-highlighted code blocks, charts,
> a purpose-built AI composer, and speech-to-text input.

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
`StreamingMessageView`. Use with `StreamTypewriterBuilder` for custom layouts.

```dart
final controller = TypewriterController(text: '');

// As new chunks arrive from the LLM:
controller.updateText(accumulatedText);

// In your widget tree:
StreamTypewriterBuilder(
  controller: controller,
  builder: (context, value, child) => Text(value.text),
);
```

### `AiMarkdownBody`

Segment-based markdown renderer used internally by `StreamingMessageView`. Use it
directly when you need markdown rendering without the typewriter animation.

```dart
AiMarkdownBody(
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

### `StreamAIComposer`

A message composer designed for AI-powered channels. Features:

- **Suggestion chips** (`ChatOption`) shown above the input when no option is selected.
- An **inline selected-option badge** (with dismiss button) inside the input box.
- A **send / stop toggle** — the send button (↑) becomes a stop button (⏹) while the
  AI is generating a response.
- Factory-based slot customisation via `StreamAIComposerFactory`.

```dart
StreamAIComposer(
  controller: controller,
  onSendPressed: (text, selectedOption) async {
    await channel.sendMessage(Message(text: text));
  },
  onStopPressed: () => channel.stopAIResponse(),
);
```

### `AiComposerController`

`ChangeNotifier` that manages all mutable state for `StreamAIComposer`.

```dart
final controller = AiComposerController(
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

### `StreamAIComposerFactory`

Subclass to override the leading and/or trailing regions of the composer.

```dart
class MyComposerFactory extends StreamAIComposerFactory {
  @override
  Widget buildLeading(BuildContext context, AiComposerController controller) {
    return SpeechToTextButton(controller: controller);
  }
}

// Pass to the composer:
StreamAIComposer(
  factory: MyComposerFactory(),
  ...
);
```

---

### `SpeechToTextButton`

A microphone button that feeds partial and final speech recognition results directly
into an `AiComposerController`'s text field. The button hides itself automatically
when the AI is generating or the text field is non-empty.

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

## Listening to AI events

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

---

## Installation

```yaml
dependencies:
  stream_chat_flutter: ^10.0.1
  stream_chat_flutter_ai: ^0.0.1
```

## Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_flutter_ai/changelog) to see the latest changes in the package.

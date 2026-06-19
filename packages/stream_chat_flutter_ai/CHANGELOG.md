## Upcoming

✅ Added

- Initial implementation of `stream_chat_flutter_ai`:
  - `AITypingIndicatorView` — animated dots indicator for AI states (thinking, checking sources, etc.).
  - `AnimatedDots` — standalone animated dots widget.
  - `TypewriterController` / `TypewriterValue` / `TypewriterState` — controller for character-by-character text reveal.
  - `StreamTypewriterBuilder` — `ValueListenableBuilder` wrapper for `TypewriterController`.
  - `StreamingMessageView` — renders markdown with a typewriter animation, used for streaming AI responses.
  - `AiMarkdownBody` — segment-based markdown renderer that handles text, fenced code blocks, and chart blocks.
  - `CodeBlockView` — dark-themed code block with copy-to-clipboard button and language label.
  - `ChartView` — renders `USpec` chart data as line, bar, or pie charts via `fl_chart`.
  - `USpec` / `USeries` / `UPoint` / `USpecKind` — chart data model.
  - `USpecParser` — parses JSON code fences in USpec or Chart.js format into `USpec`.
  - `StreamAIComposer` — AI-aware message composer with suggestion chips, send/stop toggle, and factory-based slot overrides.
  - `AiComposerController` — `ChangeNotifier` that manages input text, AI generating state, and chat option selection.
  - `ChatOption` — data class for suggestion chips shown above the composer.
  - `StreamAIComposerFactory` — subclass to override the leading and trailing regions of the composer.
  - `SpeechToTextButton` — microphone button that streams partial speech-to-text results into the composer's text field; hidden while AI is generating or text is non-empty.

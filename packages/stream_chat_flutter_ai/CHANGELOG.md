## Upcoming

🔄 Changed

- `stream_chat_flutter_ai` no longer depends on `stream_chat_flutter` (or any `stream_chat*` package). The package is fully standalone and can be used in any Flutter app, independent of Stream Chat. Wiring it up to a Stream Chat channel is now shown in the docs as an optional integration, not a dependency.
- Redesigned `StreamAIComposer` to match spacing and sizing in the reference Android/iOS AI samples: 8dp gaps around the leading/input/trailing row, and a single 40x40 circular trailing control that morphs between mic, send, and stop instead of stacking a bare-icon mic button underneath a differently-styled send button.
- `AIComposerSendCallback` (the type of `StreamAIComposer.onSendPressed`) now takes a third `List<XFile> attachments` parameter — **breaking change** for existing callers.
- `StreamAIComposerFactory.buildLeading`/`buildTrailing` now return `Widget?` instead of `Widget`, and default to the "+" attachment button / `null` respectively — **breaking change** for factory subclasses overriding either method. Returning `null` (rather than an empty `SizedBox.shrink()`) is also how a slot now opts out of the composer's 8px gap; passing an empty widget no longer works for that, since two separately-constructed `SizedBox.shrink()`s aren't guaranteed `identical`/`==` and using one as an "empty" sentinel silently doubled the composer's trailing-edge margin.
- `StreamAIComposerFactory.buildLeading` now defaults to an outlined circular "+" button that opens `ComposerAttachmentSheet` (see below), instead of an empty `SizedBox.shrink()`.
- Removed the always-visible row of `ChatOption` chips that used to render above the input whenever `AIComposerController.chatOptions` was non-empty — **breaking change in behavior** (no API removed, but the row no longer renders). Confirmed against `stream-chat-swift-ai`: chat options aren't shown as a standalone chip row there either — they're listed inside the composer's attachment sheet (`ComposerPickerView` in `ComposerView.swift`), alongside the photo picker. `StreamAIComposer`'s inline selected-option chip (shown inside the input box once an option is chosen) is unaffected and still matches iOS.
- Fixed vertical alignment of the leading/trailing circles against the input pill: both Rows now use `CrossAxisAlignment.center` instead of `.end`. The pill is naturally taller than the fixed-size 40x40 circles, so bottom-aligning them dumped 100% of that extra height above the circles as a lopsided gap — visually different from the reference Android layout, where the "+" and mic sit evenly inset within the pill's height. Centering fixes this without needing to change either the pill's or the circles' size.
- The input pill and the default "+" attachment button now use the same, lighter `colorScheme.surfaceContainerHigh` fill and `outlineVariant` border (previously the pill used the darker/more-tinted `surfaceContainerHighest` while the button used plain `surface`, so the two visibly didn't match). The text field's hint text now uses `onSurfaceVariant` at 60% opacity instead of the theme's default (near-black) hint color, matching the muted placeholder look of the reference Android/iOS composers.
- The inline selected-option chip (shown inside the input box once a `ChatOption` is chosen) is now a proper pill badge — `colorScheme.primaryContainer` background, larger icon/text/dismiss-button — instead of plain icon+text directly on the input's own background.

✅ Added

- `StreamAISuggestionsView` — a horizontally-scrolling row of free-text quick-reply chips, independent of `ChatOption`. Mirrors `stream-chat-swift-ai`'s `SuggestionsView`, which the reference iOS sample docks above the composer on the "new chat" landing screen.
- `AIComposerController` gained attachment support: `attachments`, `addAttachments`, `removeAttachment`, and `hasText` (pure-text check, separate from `hasContent` which also considers attachments). `clear()` now also clears attachments.
- `StreamAIComposer` renders picked images as a row of removable thumbnails inside the input box, and now depends on `package:image_picker` for attachment picking.
- `StreamAIComposer.enableSpeechToText` — when `true`, the composer's single trailing control shows a mic while the text field is empty and morphs into send/stop as content changes or the AI starts generating, instead of two separate buttons.
- `ComposerAttachmentSheet` — the combined bottom sheet opened by the composer's default "+" button, mirroring `stream-chat-swift-ai`'s `ComposerPickerView`: a camera tile, a horizontal strip of recent photos (via the new `package:photo_manager` dependency) with tap-to-toggle multi-select, an "All Photos" full-library picker button, and — if `AIComposerController.chatOptions` is non-empty — the chat-option list below, replacing the removed chip row.
- `ChatOption.description` — an optional subtitle shown under `text` in `ComposerAttachmentSheet`'s option rows (e.g. `"Visualize anything"` under `"Create image"`), matching `stream-chat-swift-ai`'s `ChatOption.description`.
- Initial implementation of `stream_chat_flutter_ai`:
  - `AITypingIndicatorView` — animated dots indicator for AI states (thinking, checking sources, etc.).
  - `AnimatedDots` — standalone animated dots widget.
  - `TypewriterController` / `TypewriterValue` / `TypewriterState` — controller for character-by-character text reveal.
  - `StreamTypewriterBuilder` — `ValueListenableBuilder` wrapper for `TypewriterController`.
  - `StreamingMessageView` — renders markdown with a typewriter animation, used for streaming AI responses.
  - `AIMarkdownBody` — segment-based markdown renderer that handles text, fenced code blocks, and chart blocks.
  - `CodeBlockView` — dark-themed code block with copy-to-clipboard button and language label.
  - `ChartView` — renders `USpec` chart data as line, bar, or pie charts via `fl_chart`.
  - `USpec` / `USeries` / `UPoint` / `USpecKind` — chart data model.
  - `USpecParser` — parses JSON code fences in USpec or Chart.js format into `USpec`.
  - `StreamAIComposer` — AI-aware message composer with a selected-option chip, send/stop toggle, attachment thumbnails, and factory-based slot overrides.
  - `AIComposerController` — `ChangeNotifier` that manages input text, AI generating state, chat option selection, and pending image attachments.
  - `ChatOption` — data class for the selectable options shown in `ComposerAttachmentSheet`.
  - `StreamAIComposerFactory` — subclass to override the leading and trailing regions of the composer.
  - `SpeechToTextButton` — microphone button that streams partial speech-to-text results into the composer's text field; hidden while AI is generating or text is non-empty.

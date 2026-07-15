# `stream_chat_flutter_ai` parity roadmap

This document tracks feature parity between `stream_chat_flutter_ai` and
[`stream-chat-swift-ai`](https://github.com/GetStream/stream-chat-swift-ai), Stream's equivalent
standalone AI-chat UI package for iOS/Swift.

> **Note:** Parity is measured against the Swift package's actual source (`Sources/`), not its
> README — the README undersells the package and omits two subsystems (chart rendering and MCP
> tool-calling) entirely.

Status legend: ⬜ Not started · 🚧 In progress · ✅ Done · 🅾️ Optional / won't-do

| # | Feature | Phase | Effort | Status |
|---|---|---|---|---|
| 1.1 | Standalone suggested-prompt chips (`SuggestionsView`) | 1 | S | ✅ |
| 1.2 | Chart schema & kind breadth (`USpec`) | 1 | M | ⬜ |
| 2.1 | Code syntax highlighting (`CodeBlockView`) | 2 | M | ⬜ |
| 2.2 | Composer factory slot coverage | 2 | M | ⬜ |
| 2.3 | Localization scaffolding | 2 | M | ⬜ |
| 3.1 | MCP client-tool / agentic tool-calling | 3 | L | ⬜ |
| 3.2 | Generic sidebar / split-view (`SidebarView`) | 3 | S–M | 🅾️ |

---

## Phase 1 — Quick parity wins (low effort, high value)

### 1.1 Standalone suggested-prompt chips (`SuggestionsView`) ✅

**Gap:** Swift ships `SuggestionsView` — a horizontally-scrolling row of free-text quick-reply
chips, independent of `ChatOption`. Flutter had no equivalent; its only suggestion surface was
`ChatOption` rows inside `ComposerAttachmentSheet`. The reference Flutter sample
(`chat-ai-samples/flutter`) had already hand-rolled an equivalent inline `_LandingView` widget —
this work extracted that into the package and rewired the sample to consume it, matching how the
iOS sample docks `SuggestionsView` above its composer (`ContentView.swift`'s
`VStack { Spacer(); SuggestionsView(...) }`).

**Shipped API:** `lib/src/composer/suggestions_view.dart`:

```dart
StreamAISuggestionsView({
  required List<String> suggestions,
  required ValueChanged<String> onSuggestionSelected,
  double itemMaxWidth = 160,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
})
```

Theme-driven (`Theme.of(context).colorScheme`), consistent with the composer pill tokens
(`surfaceContainerHigh`/`outlineVariant`).

- **Files:** new `suggestions_view.dart`; exported from `lib/stream_chat_flutter_ai.dart`; consumed
  by `chat-ai-samples/flutter`'s `_LandingView` (`chat_ai_assistant_home_page.dart`).
- **Note:** naming — Swift's only AI-token type is `AITypingIndicatorView` (capital "AI",
  consistently); the package's `AiComposerController`/`AiComposerSendCallback`/`AiMarkdownBody` were
  renamed to `AIComposerController`/`AIComposerSendCallback`/`AIMarkdownBody` to match, and the new
  widget is `StreamAISuggestionsView` (not the originally-drafted `StreamAiSuggestionsView`).
- **Acceptance:** tapping a chip fires the callback with its text; row scrolls; long text
  truncates to 2 lines; widget test covering render + tap — see `suggestions_view_test.dart`.
- **Effort:** S (½ day).

### 1.2 Chart schema & kind breadth (`USpec`)

**Gap:** Swift's `parseUSpec` auto-detects **7 schemas** (Chart.js, Plotly single + full figure,
ECharts, Highcharts, Vega-Lite, a legacy custom schema, flat pie) and renders **8 kinds** (line,
bar, area, scatter, bubble, pie, heatmap, histogram). Flutter's `USpecParser.tryParse`
(`lib/src/chart/uspec.dart`) recognises only **2 schemas** (native USpec + Chart.js) and **5
kinds**, and `ChartView` (`lib/src/chart/chart_view.dart`) silently renders **scatter as a line
chart** (the `switch` default case, `_ => _buildLineChart()`).

**Proposed work** (incremental, land independently):

- [ ] 1.2.1 Implement a real scatter render in `ChartView` (fl_chart `ScatterChart`) instead of the
      line fallback.
- [ ] 1.2.2 Add a Vega-Lite adapter to `USpecParser` (mark + encoding subset) — the most common
      LLM output after Chart.js.
- [ ] 1.2.3 Add ECharts + Highcharts adapters.
- [ ] 1.2.4 Add Plotly adapter (single-spec + first-trace-of-figure).
- [ ] 1.2.5 Add `USpecKind.histogram` (auto-bin into ~10 buckets, mirroring Swift's `makeBins`) and
      `USpecKind.bubble` (point size from a `size`/`z` field — requires an optional `size` field
      on `UPoint`).
- [ ] 1.2.6 Add heatmap (fl_chart has no native heatmap — render as a `GridView`/`CustomPaint`
      grid, or document as deferred if the cost isn't justified).

Fence-language routing already exists in `lib/src/ai_markdown_body.dart`
(`json, chart, chartjs, echarts, plotly, vega`) — extend the language set as needed, the hook is
already there.

- **Acceptance:** a unit test per new schema, feeding a representative JSON payload and asserting
  the resulting `USpec.kind`/series; scatter/bubble/histogram render visibly distinct from a plain
  line chart.
- **Effort:** M overall — schemas are independent, land 1.2.1–1.2.2 first, the rest as follow-ups.
  Heatmap (1.2.6) is the one most likely to warrant deferral.

---

## Phase 2 — Core parity (medium effort)

### 2.1 Code syntax highlighting (`CodeBlockView`)

**Gap:** Swift uses `Splash` for tokenized, per-language colored highlighting. Flutter's
`CodeBlockView` (`lib/src/code_block_view.dart`) shows plain monospace `SelectableText` with a
decorative language label — no token coloring.

**Proposed work:** introduce a highlighting dependency and colorize the code body, keeping the
existing dark theme (`_kBgColor 0xFF1E1E1E`), header, and copy button intact.

- Evaluate `re_highlight` (actively maintained, highlight.js grammars) vs. `flutter_highlight` +
  `highlight` (popular but stale) vs. `syntax_highlight` (Dart-team maintained, fewer languages).
  Recommend `re_highlight` for language breadth. Add it to `melos.yaml`'s bootstrap dependencies
  per repo convention — **do not** edit the package `pubspec.yaml` version constraint directly.
- Replace the `SelectableText` body with a highlighted `TextSpan` tree; when `language` is null or
  unrecognized, fall back to the current plain rendering (must stay selectable and horizontally
  scrollable).

- **Files:** `lib/src/code_block_view.dart`; `melos.yaml`.
- **Acceptance:** a `dart`/`json`/`python` block renders multi-colored tokens; unknown language
  still renders plain; copy button + text selection still work; widget test asserting a themed
  span tree is produced.
- **Effort:** M (1–2 days including dependency vetting).

### 2.2 Composer factory slot coverage (`StreamAIComposerFactory`)

**Gap:** Swift's `ComposerViewFactory` exposes **4** overridable slots (leading, trailing, input
view, picker sheet). Flutter's `StreamAIComposerFactory`
(`lib/src/composer/stream_ai_composer_factory.dart`) exposes only **2** (leading, trailing) — the
text input and the attachment sheet are hardcoded inside `stream_ai_composer.dart` and
`_AttachmentButton`.

**Proposed work:** add two nullable slot methods mirroring the existing pattern:

- `Widget? buildInput(BuildContext, AIComposerController)` — defaults to the current
  `_InputContainer` (promote it out of private, or wrap it). Lets hosts fully replace the input
  field.
- `Widget buildAttachmentSheet(BuildContext, AIComposerController)` — defaults to
  `ComposerAttachmentSheet`; `_AttachmentButton` calls the factory instead of constructing the
  sheet directly.

- **Files:** `stream_ai_composer_factory.dart`, `stream_ai_composer.dart` (wire
  `_InputContainer`/`_TrailingControl` through the factory).
- **Constraint:** keep the established `Widget?`-null-to-opt-out convention — no
  `SizedBox.shrink()` sentinels (two separately-constructed instances aren't `identical`/`==`,
  which is exactly the bug the existing `buildLeading`/`buildTrailing` nullability fix addressed).
- **Acceptance:** a custom factory can swap both the input and the sheet; existing default
  behavior is unchanged; extend `stream_ai_composer_test.dart` with an override test.
- **Effort:** M (1 day).

### 2.3 Localization scaffolding

**Gap:** Swift externalizes strings via an `L10n` enum backed by a `.strings` bundle (English-only
today, but the seam exists for adding locales). Flutter hardcodes every user-facing string —
`'Photos'`, `'All Photos'`, `'Copy code'`, `'Send'`, `'Stop generating'`, `'Add photos'`,
`'Allow photo access'`, the default hint text, etc.

**Proposed work:** introduce a single injectable translations object — a `StreamAiTranslations`
abstract class plus a `DefaultStreamAiTranslations` implementation holding today's English
literals — passed via constructor/`InheritedWidget` rather than pulling in
`flutter_localizations` (keeps the package dependency-light and framework-agnostic, matching its
standalone design goal). Replace hardcoded literals with lookups against this object.

- **Files:** new `lib/src/localization/stream_ai_translations.dart`; touch every widget currently
  holding a literal (`code_block_view.dart`, `composer_attachment_sheet.dart`,
  `stream_ai_composer.dart`, `stream_ai_composer_factory.dart`).
- **Acceptance:** all user-facing strings resolve through the translations object; a test injecting
  a custom translations instance observes the overridden strings.
- **Effort:** M (1 day). Ships no non-English translations yet — just the seam for adding them
  later.

---

## Phase 3 — Large / optional

### 3.1 MCP client-tool / agentic tool-calling — largest effort, needs a design spike

**Gap:** Swift ships `Tools/ClientToolRegistry.swift` (`ClientTool` protocol, `ClientToolRegistry`,
`ClientToolInvocation`, `ClientToolAction`, `ToolRegistrationPayload`) built on Anthropic's official
MCP `swift-sdk`, letting a host app register client-side tools the AI can invoke. Flutter has
nothing in this space.

**Proposed work** (spike first, then build):

1. **Design spike** — decide the Dart MCP surface. Options: adopt an existing Dart MCP client
   package (e.g. `dart_mcp` / `mcp_dart`), or build a minimal hand-rolled registry mirroring
   Swift's shape (`StreamAiClientTool` interface with a tool schema + `handleInvocation`, a
   registry keyed by tool name, a `registrationPayloads()` serializer). **Recommendation:** start
   with the minimal registry to stay decoupled and avoid a heavy transport dependency; wire it to
   a real MCP transport in a follow-up once the shape is validated.
2. Define types: `StreamAiClientTool`, `StreamAiToolRegistry`, `ClientToolInvocation`,
   `ToolRegistrationPayload`.
3. Provide a worked example + README section showing registration and invocation routing.

- **Files:** new `lib/src/tools/` directory; barrel export from
  `lib/stream_chat_flutter_ai.dart`.
- **Acceptance:** register a sample tool, feed a synthetic invocation, assert the tool's handler
  runs and produces the expected action; documented example in the README.
- **Effort:** L (multi-day; blocked on the design spike landing first). This is the highest-value
  strategic gap if the AI story is meant to cover agentic/tool-use scenarios, but also the biggest
  lift — schedule accordingly.

### 3.2 Generic sidebar / split-view (`SidebarView`) — optional 🅾️

**Gap:** Swift ships `SidebarView` — a swipeable drawer/split-view (edge-drag gestures, spring
animation, dimming overlay) for a ChatGPT-style conversation-list drawer. It is **not
chat-specific**.

**Recommendation:** mark optional / won't-do by default. Flutter already has first-class
`Drawer`/`NavigationDrawer` and `Scaffold.drawer` with built-in edge-swipe support, so a bespoke
widget adds little value. Only build if a sample app specifically needs the exact split-view
offset behavior Swift's version has. If it is built, it belongs in a shared UI package (mirroring
the `stream_core_flutter` split from the chat-specific packages), not in
`stream_chat_flutter_ai`.

- **Effort:** S–M if pursued.

---

## Where Flutter already leads

Recorded here so future parity work doesn't regress these — they are intentional improvements over
Swift, not gaps:

- **Image-only sends:** `AIComposerController.hasContent` gates the send button on text **or**
  attachments; Swift's send button only appears when text is non-empty.
- **Unified morphing trailing control:** a single 40×40 control that morphs between mic/send/stop
  is a more deliberate design than Swift's separately-styled buttons.
- **Grapheme-cluster-aware typewriter:** `TypewriterController` uses `Characters`, which is safer
  for emoji/multi-byte text during streaming than Swift's raw `Character` array indexing.

## At parity (no work needed)

Streaming/typewriter text rendering, the AI typing indicator, the composer state controller
(`AIComposerController` ↔ Swift's `ComposerViewModel`), the `ChatOption` model (including its
`description` field), speech-to-text, and the attachment picker (camera + recent photos + full
library picker).

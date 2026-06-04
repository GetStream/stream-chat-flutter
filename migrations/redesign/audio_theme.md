# Audio Waveform Theme Migration Guide

This guide covers the migration for the audio waveform theming changes in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [Overview](#overview)
- [What Changed](#what-changed)
- [New Theming Approach](#new-theming-approach)
- [Migration Checklist](#migration-checklist)

---

## Overview

The audio waveform theme types and the `StreamAudioWaveform` / `StreamAudioWaveformSlider` widgets have moved from `stream_chat_flutter` to `stream_core_flutter`. The widgets are re-exported via `stream_chat_flutter` so import paths remain unchanged, but theming is no longer done through `StreamChatThemeData`.

---

## What Changed

| Item                               | Before                                                                 | After                                                              |
| ---------------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `StreamAudioWaveformTheme`         | Defined in `stream_chat_flutter`                                       | Moved to `stream_core_flutter`; no longer in `StreamChatThemeData` |
| `StreamAudioWaveformSliderTheme`   | Defined in `stream_chat_flutter`                                       | Deleted; thumb/track styling is now configured via `StreamAudioWaveformThemeData` |
| `StreamAudioWaveform` widget       | In `stream_chat_flutter`                                               | Re-exported from `stream_core_flutter` via `stream_chat_flutter`   |
| `StreamAudioWaveformSlider` widget | In `stream_chat_flutter`                                               | Re-exported from `stream_core_flutter` via `stream_chat_flutter`   |
| Theming entry point                | `StreamChatThemeData.audioWaveformTheme` / `.audioWaveformSliderTheme` | `StreamAudioWaveformThemeData` via `StreamTheme` (added to `MaterialApp.theme.extensions`) |

---

## New Theming Approach

Audio waveform theming is now part of `StreamTheme` from `stream_core_flutter`. Configure it by adding `StreamTheme` as a theme extension to your `MaterialApp`:

**Before:**
```dart
StreamChat(
  client: client,
  themeData: StreamChatThemeData(
    audioWaveformTheme: StreamAudioWaveformThemeData(
      waveColor: Colors.blue,
      playedWaveColor: Colors.blueAccent,
    ),
  ),
  child: ...,
)
```

**After:**
```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      StreamTheme(
        brightness: Brightness.light,
        // Audio waveform theming is now part of StreamTheme's component themes.
        // Refer to StreamThemeData for available audio waveform properties.
      ),
    ],
  ),
  home: StreamChat(client: client, child: ...),
)
```

> **Note:** If no `StreamTheme` extension is provided, a default theme is automatically derived from `Theme.of(context).brightness`.

---

## Migration Checklist

- [ ] Remove any `StreamChatThemeData.audioWaveformTheme` usages
- [ ] Remove any `StreamChatThemeData.audioWaveformSliderTheme` usages — `StreamAudioWaveformSliderTheme` was deleted; thumb/track styling is now configured via `StreamAudioWaveformThemeData`
- [ ] Remove `audioWaveformTheme` and `audioWaveformSliderTheme` from any `StreamChatThemeData.copyWith()` calls — these parameters no longer exist and will cause a compile error
- [ ] Move audio waveform color / style customizations into a `StreamTheme` extension on `MaterialApp`
- [ ] Import paths for `StreamAudioWaveform` and `StreamAudioWaveformSlider` remain the same (`package:stream_chat_flutter/stream_chat_flutter.dart`)

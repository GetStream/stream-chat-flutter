# Stream Chat Flutter UI Redesign Migration Guide

This folder contains migration guides for the redesigned UI components in Stream Chat Flutter SDK.

## Overview

The redesigned components aim to provide:
- Simplified and consistent APIs
- Better theme integration
- Improved developer experience
- Reduced boilerplate

Each component migration guide contains specific details about the changes and how to migrate.

## Theming

The redesigned components use `StreamTheme` for theming. If no `StreamTheme` is provided, a default theme is automatically created based on `Theme.of(context).brightness` (light or dark mode).

To customize the default theming, add `StreamTheme` as a theme extension to your `MaterialApp`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      StreamTheme(
        brightness: Brightness.light,
        colorScheme: StreamColorScheme.light().copyWith(
          // Customize colors...
        ),
        avatarTheme: const StreamAvatarThemeData(
          // Customize avatar defaults...
        ),
      ),
    ],
  ),
  // ...
)
```

You can also use the convenience factories `StreamTheme.light()` or `StreamTheme.dark()` as a starting point.

## Components

| Component | Migration Guide |
|-----------|-----------------|
| Stream Avatar | [stream_avatar.md](stream_avatar.md) |

## Need Help?

If you encounter any issues during migration or have questions, please [open an issue](https://github.com/GetStream/stream-chat-flutter/issues) on GitHub.

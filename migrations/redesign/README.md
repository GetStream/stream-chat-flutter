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


## Component factories

In the redesigned components we don't use builders in the constructors anymore, but have a centralized component factory.
The component factory contains product agnotic component builders, such as the button and the avatar, and also product specific component builders, such as the channel list item.
You can supply your component factory at any point in the widget tree, but you would usually wrap your full app around it.

An example of a component factory with custom buttons and a custom channel list item:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamComponentFactory(
      builders: StreamComponentBuilders(
        button: (context, props) => switch (props.type) {
          StreamButtonType.solid => ElevatedButton(
            onPressed: props.onPressed,
            child: props.child ?? const SizedBox.shrink(),
          ),
          StreamButtonType.outline => OutlinedButton(onPressed: props.onPressed, child: props.child ?? const SizedBox.shrink()),
          StreamButtonType.ghost => TextButton(onPressed: props.onPressed, child: props.child ?? const SizedBox.shrink()),
        },
        extensions: streamChatComponentBuilders(
          channelListItem: (context, props) => StreamChannelListTile(
            title: Text(props.channel.name ?? ''),
            avatar: StreamChannelAvatar(channel: props.channel),
            onTap: props.onTap,
            onLongPress: props.onLongPress,
            selected: props.selected,
          ),
        ),
      ),
      child: ...
    );
  }
}
```

You should make the builder themselves as simple as possible by extracting this into separate widgets, such as this:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamComponentFactory(
      builders: StreamComponentBuilders(
        button: (context, props) => MyCustomButton(props: props),
      ),
      child: ...
    );
  }
}

class MyCustomButton extends StatelessWidget {
  const MyCustomButton({super.key, required this.props});

  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    return switch (props.type) {
      StreamButtonType.solid => ElevatedButton(
        onPressed: props.onPressed,
        child: props.child ?? const SizedBox.shrink(),
      ),
      StreamButtonType.outline => OutlinedButton(onPressed: props.onPressed, child: props.child ?? const SizedBox.shrink()),
      StreamButtonType.ghost => TextButton(onPressed: props.onPressed, child: props.child ?? const SizedBox.shrink()),
    };
  }
}
```

## Components

| Component | Migration Guide |
|-----------|-----------------|
| Stream Avatar | [stream_avatar.md](stream_avatar.md) |
| Channel List Item | [channel_list_item.md](channel_list_item.md) |
| Message Actions | [message_actions.md](message_actions.md) |
| Reaction Picker / Reactions | [reaction_picker.md](reaction_picker.md) |
| Image CDN & Thumbnails | [image_cdn.md](image_cdn.md) |
| Message Widget & Message List | [message_widget.md](message_widget.md) |
| Message Composer | [message_composer.md](message_composer.md) |
| Unread Indicator | [unread_indicator.md](unread_indicator.md) |
| Unread Indicator Button | [unread_indicator_button.md](unread_indicator_button.md) |
| Reaction List & Detail Sheet | [reaction_list.md](reaction_list.md) |
| Audio Waveform Theme | [audio_theme.md](audio_theme.md) |
| Attachments & Polls | [attachments_and_polls.md](attachments_and_polls.md) |
| Media Viewer (Full-screen Media) | [media_viewer.md](media_viewer.md) |
| Headers, Icons & Configuration | [headers_and_icons.md](headers_and_icons.md) |
| Localizations | [localizations.md](localizations.md) |

## Need Help?

If you encounter any issues during migration or have questions, please [open an issue](https://github.com/GetStream/stream-chat-flutter/issues) on GitHub.

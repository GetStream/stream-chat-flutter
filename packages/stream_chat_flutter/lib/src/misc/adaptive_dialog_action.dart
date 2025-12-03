import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// A platform-adaptive dialog action button that renders appropriately based on
/// the platform.
///
/// This widget uses [CupertinoDialogAction] on iOS and macOS platforms,
/// and [TextButton] on all other platforms, maintaining the appropriate
/// platform design language.
///
/// The styling is influenced by the [StreamChatTheme] to ensure consistent
/// appearance with other Stream Chat components.
class AdaptiveDialogAction extends StatelessWidget {
  /// Creates an adaptive dialog action.
  const AdaptiveDialogAction({
    super.key,
    this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    required this.child,
  });

  /// The callback that is called when the action is tapped.
  final VoidCallback? onPressed;

  /// Whether this action is the default choice in the dialog.
  ///
  /// Default actions use emphasized styling (bold text) on iOS/macOS.
  /// This has no effect on other platforms.
  final bool isDefaultAction;

  /// Whether this action performs a destructive action like deletion.
  ///
  /// Destructive actions are displayed with red text on iOS/macOS.
  /// This has no effect on other platforms.
  final bool isDestructiveAction;

  /// The widget to display as the content of the action.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return switch (Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => CupertinoTheme(
          data: CupertinoTheme.of(context).copyWith(
            primaryColor: theme.colorTheme.accentPrimary,
          ),
          child: CupertinoDialogAction(
            onPressed: onPressed,
            isDefaultAction: isDefaultAction,
            isDestructiveAction: isDestructiveAction,
            child: child,
          ),
        ),
      _ => TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            textStyle: theme.textTheme.body,
            foregroundColor: theme.colorTheme.accentPrimary,
            disabledForegroundColor: theme.colorTheme.disabled,
          ),
          child: child,
        ),
    };
  }
}

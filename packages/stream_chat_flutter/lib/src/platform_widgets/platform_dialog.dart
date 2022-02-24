import 'package:fluent_ui/fluent_ui.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stream_chat_flutter/src/platform_widgets/desktop_widget_builder.dart';

/*class PlatformDialog extends StatefulWidget {
  const PlatformDialog.macOS({
    Key? key,
    required Widget appIcon,
    required Widget title,
    required Widget message,
    required Widget primaryButton,
    Widget? secondaryButton,
    bool horizontalActions = true,
    Widget? suppress,
  }) : super(key: key);

  const PlatformDialog.windows({
    Key? key,
  }) : super(key: key);

  @override
  State<PlatformDialog> createState() => _PlatformDialogState();
}

class _PlatformDialogState extends State<PlatformDialog> {
  @override
  Widget build(BuildContext context) {
    return DesktopWidgetBuilder(
      macOS: (context, child) => MacosAlertDialog(
        key: widget.key,
        appIcon: appIcon,
        title: title,
        message: message,
        primaryButton: primaryButton,
      ),
      windows: (context, child) => ContentDialog(
        key: widget.key,
        title: title,
        content: content,
        actions: [],
        backgroundDismiss: backgroundDismiss,
        constraints: constraints,
        style: style,
      ),
    );
  }
}*/

///
class PlatformDialog extends StatelessWidget {
  ///
  const PlatformDialog({
    Key? key,
    this.title,
    this.appIcon,
    this.message,
    this.primaryButton,
    this.secondaryButton,
    this.horizontalActions = true,
    this.suppress,
    this.actions,
    this.backgroundDismiss = true,
    this.constraints = const BoxConstraints(maxWidth: 368),
    this.style,
  }) : super(key: key);

  /// The title of the message being shown.
  ///
  /// Can be shared across dialogs for macOS, Windows, and Linux.
  final Widget? title;

  /// The app icon to display in the dialog.
  ///
  /// Should ONLY be used for macOS dialogs.
  final Widget? appIcon;

  /// The message to be shown. Typically a [Text] widget.
  ///
  /// Can be shared across dialogs for macOS, Windows, and Linux.
  final Widget? message;

  /// The primary action button in a macOS-style dialog.
  ///
  /// Should ONLY be used for macOS dialogs.
  final Widget? primaryButton;

  /// The secondary, optional, action button in a macOS-style dialog.
  ///
  /// Should ONLY be used for macOS dialogs.
  final Widget? secondaryButton;

  /// Determines whether to lay out [primaryButton] and [secondaryButton]
  /// horizontally or vertically.
  ///
  /// Defaults to `true`.
  ///
  /// Should ONLY be used for macOS dialogs.
  final bool? horizontalActions;

  /// A widget to allow users to suppress alerts of this type.
  ///
  /// See [MacosAlertDialog] for more information.
  ///
  /// Should ONLY be used for macOS dialogs.
  final Widget? suppress;

  /// The actions buttons in a Windows-style dialog.
  ///
  /// Should ONLY be used for Windows dialogs.
  final List<Widget>? actions;

  /// Whether the dialog should be dismissible by clicking the background.
  ///
  /// Defaults to `true`.
  ///
  /// Should ONLY be used for Windows dialogs.
  final bool? backgroundDismiss;

  /// The constraints of the dialog.
  ///
  /// Defaults to `const BoxConstraints(maxWidth: 368)`.
  ///
  /// Should ONLY be used for Windows dialogs.
  final BoxConstraints? constraints;

  /// The styling to use for the dialog.
  ///
  /// Should ONLY be used for Windows dialogs.
  final ContentDialogThemeData? style;

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return DesktopWidgetBuilder(
      macOS: (context, child) => MacosTheme(
        data: isDark ? MacosThemeData.dark() : MacosThemeData.light(),
        child: MacosAlertDialog(
          key: key,
          appIcon: appIcon!,
          title: title!,
          message: message!,
          primaryButton: primaryButton!,
          secondaryButton: secondaryButton,
          horizontalActions: horizontalActions,
          suppress: suppress,
        ),
      ),
      windows: (context, child) => FluentTheme(
        data: isDark ? ThemeData.dark() : ThemeData.light(),
        child: ContentDialog(
          key: key,
          title: title,
          content: message,
          actions: actions,
          backgroundDismiss: backgroundDismiss!,
          constraints: constraints!,
          style: style,
        ),
      ),
    );
  }
}

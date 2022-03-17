import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ThemeData;
import 'package:macos_ui/macos_ui.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

/// {@template platformDialog}
/// A Dialog that adapts itself to the visual style of whichever desktop
/// platform an application is being executed on.
///
/// This widget makes use of the [DesktopWidgetBuilder] to build widgets only
/// for the specified platform.
///
/// On macOS, a [MacosAlertDialog] will be built. On Windows, a [ContentDialog]
/// will be built. On Linux, a [YaruAlertDialog] will be built.
/// {@endtemplate}
class PlatformDialog extends StatelessWidget {
  /// {@macro platformDialog}
  const PlatformDialog({
    Key? key,
    this.titleWidget,
    this.title,
    this.appIcon,
    this.message,
    this.primaryButton,
    this.secondaryButton,
    this.horizontalActions = true,
    this.suppress,
    this.windowsActions,
    this.backgroundDismiss = true,
    this.constraints = const BoxConstraints(maxWidth: 368),
    this.style,
    this.child,
    this.linuxActions,
    this.height,
    this.width,
    this.closeIconData,
    this.alignment,
    this.titleTextAlign,
    this.scrollable,
  }) : super(key: key);

  /// The title of the message being shown.
  ///
  /// Can be shared across dialogs for macOS and Windows.
  final Widget? titleWidget;

  /// The title of the message bring shown in Linux-style dialogs.
  ///
  /// Used ONLY for Linux dialogs.
  final String? title;

  /// The app icon to display in the dialog.
  ///
  /// Should ONLY be used for macOS dialogs.
  final Widget? appIcon;

  /// The message to be shown. Typically a [Text] widget.
  ///
  /// Can be shared across dialogs for macOS and Windows.
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

  /// The action buttons in a Windows-style dialog.
  ///
  /// Should ONLY be used for Windows dialogs.
  final List<Widget>? windowsActions;

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

  /// The content to display underneath the [title] in Linux dialogs.
  ///
  /// Use ONLY for Linux dialogs.
  final Widget? child;

  /// The action buttons in a Linux-style dialogs.
  ///
  /// Use ONLY for Linux dialogs
  final List<Widget>? linuxActions;

  /// The icon used in the dialogs 'close' button.
  ///
  /// Defaults to [Icons.close].
  ///
  /// Used ONLY for Linux dialogs.
  final IconData? closeIconData;

  /// How to align a Linux dialog on the screen.
  ///
  /// If null, then [DialogTheme.alignment] is used. If that is also null, the
  /// default is [Alignment.center].
  ///
  /// Used ONLY for Linux dialogs.
  final AlignmentGeometry? alignment;

  /// The optional width of a Linux dialog.
  ///
  /// Constrains all children with the same width.
  ///
  /// Used ONLY for Linux dialogs.
  final double? width;

  /// The optional height of a Linux dialog.
  ///
  /// Can be used to limit the height of a [SingleChildScrollView] used as
  /// the [child].
  ///
  /// Used ONLY for Linux dialogs.
  final double? height;

  /// The [TextAlign] used for the [YaruDialogTitle].
  ///
  /// [YaruAlertDialog]s use [YaruDialogTitle] as their title widgets.
  /// This [TextAlign] is used there.
  ///
  /// Used ONLY for Linux dialogs.
  final TextAlign? titleTextAlign;

  /// Whether to make [YaruAlertDialog]'s underlying [AlertDialog] scrollable.
  ///
  /// Used ONLY for Linux dialogs.
  final bool? scrollable;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DesktopWidgetBuilder(
      macOS: (context, child) => MacosTheme(
        data: isDark ? MacosThemeData.dark() : MacosThemeData.light(),
        child: MacosAlertDialog(
          key: key,
          appIcon: appIcon!,
          title: titleWidget!,
          message: message ?? const SizedBox.shrink(),
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
          title: titleWidget,
          content: message,
          actions: windowsActions,
          backgroundDismiss: backgroundDismiss!,
          constraints: constraints!,
          style: style,
        ),
      ),
      linux: (context, _) => YaruAlertDialog(
        title: title!,
        actions: linuxActions,
        height: height,
        width: width,
        alignment: alignment,
        closeIconData: closeIconData,
        titleTextAlign: titleTextAlign,
        scrollable: scrollable,
        child: child!,
      ),
    );
  }
}

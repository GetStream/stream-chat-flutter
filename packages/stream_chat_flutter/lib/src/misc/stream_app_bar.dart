import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template streamAppBar}
/// A styled [AppBar] with Stream Chat defaults applied.
///
/// Usually you would not use this widget directly, but rather use
/// [StreamChannelHeader], [StreamChannelListHeader],
/// [StreamThreadHeader], or [StreamGalleryHeader].
/// {@endtemplate}
class StreamAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro streamAppBar}
  const StreamAppBar({
    super.key,
    this.leading,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
    this.title,
    this.titleSpacing,
    this.titleTextStyle,
    this.actions,
    this.actionsPadding,
    this.centerTitle = true,
    this.bottom,
    this.bottomOpacity = 1.0,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
    this.backgroundColor,
    this.surfaceTintColor,
    this.shape,
  });

  /// A widget to display before the toolbar's [title].
  final Widget? leading;

  /// Defines the width of [leading] widget.
  final double? leadingWidth;

  /// Controls whether we should try to imply the leading widget if null.
  final bool automaticallyImplyLeading;

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// The spacing around [title] content on the horizontal axis.
  final double? titleSpacing;

  /// The text style for the [title].
  ///
  /// Defaults to [StreamTextTheme.headingSm].
  final TextStyle? titleTextStyle;

  /// {@macro flutter.material.appbar.actions}
  final List<Widget>? actions;

  /// Defines the padding for [actions].
  final EdgeInsetsGeometry? actionsPadding;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// An app bar bottom widget, displayed below the [title].
  final PreferredSizeWidget? bottom;

  /// The opacity of the [bottom] widget.
  final double bottomOpacity;

  /// The z-coordinate at which to place this app bar.
  ///
  /// Defaults to `0`.
  final double elevation;

  /// The elevation when content is scrolled underneath the app bar.
  ///
  /// Defaults to `0`.
  final double scrolledUnderElevation;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The surface tint color of the app bar.
  final Color? surfaceTintColor;

  /// The shape of the app bar's [Material].
  ///
  /// Defaults to a [LinearBorder] with a bottom edge using
  /// `borderSubtle` color from the Stream color scheme.
  final ShapeBorder? shape;

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streamTextTheme = context.streamTextTheme;
    final streamColorScheme = context.streamColorScheme;

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarTextStyle: theme.textTheme.bodyMedium,
      titleTextStyle: titleTextStyle ?? streamTextTheme.headingSm,
      systemOverlayStyle: theme.brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      backgroundColor: backgroundColor,
      surfaceTintColor: surfaceTintColor,
      centerTitle: centerTitle,
      leading: leading,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      actions: actions,
      actionsPadding: actionsPadding,
      title: title,
      bottom: bottom,
      bottomOpacity: bottomOpacity,
      shape:
          shape ??
          LinearBorder(
            side: BorderSide(
              color: streamColorScheme.borderSubtle,
              width: 1,
            ),
            bottom: const LinearBorderEdge(),
          ),
    );
  }
}

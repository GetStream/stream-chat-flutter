import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Component builders that render the SDK's floating chrome as liquid glass:
/// floating buttons (app bar actions, back button, scroll-to-bottom, jump to
/// unread) and the floating composer pill become glass, the floating bottom
/// navigation bar becomes a [GlassTabBar], and switches become [GlassSwitch]es.
///
/// Docked (regular) chrome keeps the default look: glass only reads as glass
/// when content scrolls behind it, which the floating surface style provides.
///
/// Pass [extensions] to keep the app's own chat component overrides; build
/// them with [liquidGlassComposerInput] as the `messageComposerInput` builder.
StreamComponentBuilders liquidGlassComponentBuilders({
  Iterable<StreamComponentBuilderExtension<Object>>? extensions,
}) {
  return StreamComponentBuilders(
    button: (context, props) => LiquidGlassStreamButton(props: props),
    bottomNavBar: (context, props) => LiquidGlassBottomNavBar(props: props),
    toggleSwitch: (context, props) => GlassSwitch(
      value: props.value,
      onChanged: props.onChanged ?? (_) {},
      activeColor: context.streamColorScheme.accentSuccess,
      useOwnLayer: true,
      semanticLabel: props.semanticLabel,
    ),
    extensions: extensions,
  );
}

/// A [StreamButton] that renders on a glass capsule when it floats.
///
/// Solid buttons keep their fill (a tinted glass button is still opaque), and
/// docked buttons render as usual.
class LiquidGlassStreamButton extends StatelessWidget {
  /// Creates a liquid glass button from the SDK's button [props].
  const LiquidGlassStreamButton({super.key, required this.props});

  /// The properties the SDK passed for this button.
  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final isFloating = props.isFloating ?? false;
    if (!isFloating || props.type == StreamButtonType.solid) return DefaultStreamButton(props: props);

    // The glass replaces the floating fill, border and shadow, so the button
    // itself draws as a ghost on top of it.
    final ghost = StreamButtonProps(
      onPressed: props.onPressed,
      style: props.style,
      type: StreamButtonType.ghost,
      size: props.size,
      iconLeft: props.iconLeft,
      iconRight: props.iconRight,
      isFloating: false,
      isSelected: props.isSelected,
      autofocus: props.autofocus,
      tooltip: props.tooltip,
      themeStyle: props.themeStyle,
      child: props.child,
    );

    return GlassContainer(
      useOwnLayer: true,
      // Icon buttons are glass circles; labelled ones are capsules.
      shape: props.child == null ? const LiquidOval() : LiquidRoundedSuperellipse(borderRadius: props.size.value / 2),
      child: DefaultStreamButton(props: ghost),
    );
  }
}

/// A [StreamBottomNavBar] rendered as a liquid glass [GlassTabBar] when it
/// floats, with the glass indicator sliding between tabs; the docked bar
/// renders as usual.
class LiquidGlassBottomNavBar extends StatelessWidget {
  /// Creates a liquid glass bottom navigation bar from the SDK's [props].
  const LiquidGlassBottomNavBar({super.key, required this.props});

  /// The properties the SDK passed for this navigation bar.
  final StreamBottomNavBarProps props;

  @override
  Widget build(BuildContext context) {
    final surfaceStyle = StreamBottomNavBar.resolveSurfaceStyle(context, style: props.style);
    if (!surfaceStyle.isFloating) return DefaultStreamBottomNavBar(props: props);

    final colorScheme = context.streamColorScheme;
    return GlassTabBar.bottom(
      selectedIndex: props.currentIndex,
      onTabSelected: props.onTap,
      selectedIconColor: colorScheme.accentPrimary,
      selectedLabelColor: colorScheme.accentPrimary,
      unselectedIconColor: colorScheme.textPrimary,
      unselectedLabelColor: colorScheme.textPrimary,
      tabs: [
        for (final item in props.items)
          GlassTab(
            icon: item.icon,
            activeIcon: item.selectedIcon,
            label: item.label,
            semanticLabel: item.semanticsLabel ?? item.tooltip,
          ),
      ],
    );
  }
}

/// A `messageComposerInput` builder that puts the floating composer pill on
/// liquid glass; the docked composer renders as usual.
Widget liquidGlassComposerInput(BuildContext context, MessageComposerInputProps props) {
  if (!props.isFloating) return DefaultStreamMessageComposerInput(props: props);

  // The default input paints an elevated, bordered surface. Clear its fill,
  // border and shadow so the glass behind it shows through.
  final theme = Theme.of(context);
  final streamTheme = context.streamTheme;
  final glassTheme =
      streamTheme.copyWith(
            colorScheme: streamTheme.colorScheme.copyWith(
              backgroundElevation1: Colors.transparent,
              borderDefault: Colors.transparent,
            ),
            elevation: streamTheme.elevation.copyWith(level3: 0),
          )
          as StreamTheme;

  return GlassContainer(
    useOwnLayer: true,
    shape: LiquidRoundedSuperellipse(borderRadius: context.streamRadius.xxxl.x),
    child: Theme(
      data: theme.copyWith(
        extensions: [
          for (final extension in theme.extensions.values)
            if (extension is! StreamTheme) extension,
          glassTheme,
        ],
      ),
      child: DefaultStreamMessageComposerInput(props: props),
    ),
  );
}

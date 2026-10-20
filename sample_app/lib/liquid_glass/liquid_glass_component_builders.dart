import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'liquid_glass_switch.dart';

/// Component builders that render the SDK's floating chrome as liquid glass:
/// floating buttons (app bar actions, back button, scroll-to-bottom, jump to
/// unread) and the floating composer pill become glass, the floating bottom
/// navigation bar becomes a [LiquidGlassTabBar], and switches become
/// [LiquidGlassSwitch]es.
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
    toggleSwitch: (context, props) => LiquidGlassSwitch(
      value: props.value,
      onChanged: props.onChanged,
      semanticLabel: props.semanticLabel,
    ),
    extensions: extensions,
  );
}

const _glassShadows = [
  BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8)),
];

/// The iOS 27 "regular" glass material (toolbars, tab bars, glass buttons) on
/// its own layer, matched to the theme's brightness.
///
/// Each floating control samples the backdrop separately because they sit in
/// unrelated parts of the widget tree; the SDK gives no shared ancestor to
/// hang a single layer on.
class LiquidGlassSurface extends StatelessWidget {
  /// Creates a glass surface of [shape] behind [child].
  const LiquidGlassSurface({super.key, required this.shape, required this.child, this.interactionScale = 1.05});

  /// The outline of the glass.
  final LiquidShape shape;

  /// How much the glass swells while pressed.
  final double interactionScale;

  /// The content painted on top of the glass.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return LiquidStretch(
      interactionScale: interactionScale,
      child: LiquidGlass.withOwnLayer(
        settings: LiquidGlassSettings.ios27Regular(brightness: brightness),
        appearance: LiquidGlassAppearance.ios27Regular(brightness: brightness),
        shape: shape,
        shadows: _glassShadows,
        child: child,
      ),
    );
  }
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

    return LiquidGlassSurface(
      // Icon buttons are glass circles; labelled ones are capsules.
      shape: props.child == null ? const LiquidOval() : LiquidRoundedSuperellipse(borderRadius: props.size.value / 2),
      child: DefaultStreamButton(props: ghost),
    );
  }
}

/// A [StreamBottomNavBar] rendered as a [LiquidGlassTabBar] when it floats; the
/// docked bar renders as usual.
class LiquidGlassBottomNavBar extends StatelessWidget {
  /// Creates a liquid glass bottom navigation bar from the SDK's [props].
  const LiquidGlassBottomNavBar({super.key, required this.props});

  /// The properties the SDK passed for this navigation bar.
  final StreamBottomNavBarProps props;

  @override
  Widget build(BuildContext context) {
    final surfaceStyle = StreamBottomNavBar.resolveSurfaceStyle(context, style: props.style);
    if (!surfaceStyle.isFloating) return DefaultStreamBottomNavBar(props: props);

    return LiquidGlassTabBar(items: props.items, currentIndex: props.currentIndex, onTap: props.onTap);
  }
}

/// An iOS 27-style tab bar: a floating glass capsule with a soft pill behind
/// the selected tab that slides when the selection changes.
class LiquidGlassTabBar extends StatelessWidget {
  /// Creates a glass tab bar for [items] with [currentIndex] selected.
  const LiquidGlassTabBar({super.key, required this.items, required this.currentIndex, required this.onTap});

  /// The height of the capsule.
  static const barHeight = 62.0;

  /// The tabs, in order.
  final List<StreamBottomNavBarItem> items;

  /// The index of the selected tab.
  final int currentIndex;

  /// Called with the index of a tapped tab.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final count = items.length;
    // -1 is the first tab and 1 the last.
    final indicatorX = count < 2 ? 0.0 : -1 + 2 * currentIndex / (count - 1);

    final bar = SizedBox(
      height: barHeight,
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(indicatorX, 0),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            child: FractionallySizedBox(
              widthFactor: 1 / count,
              heightFactor: 1,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: colorScheme.textPrimary.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final (index, item) in items.indexed)
                Expanded(
                  child: _Tab(
                    item: item,
                    selected: index == currentIndex,
                    color: index == currentIndex ? colorScheme.accentPrimary : colorScheme.textPrimary,
                    labelStyle: textTheme.metadataEmphasis,
                    onTap: () => onTap(index),
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    // Rests on the home indicator inset like the SDK's floating bar, with a
    // margin standing in where there is no inset.
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: LiquidGlassSurface(
          interactionScale: 1.02,
          shape: const LiquidRoundedSuperellipse(borderRadius: barHeight / 2),
          child: bar,
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.item,
    required this.selected,
    required this.color,
    required this.labelStyle,
    required this.onTap,
  });

  final StreamBottomNavBarItem item;
  final bool selected;
  final Color color;
  final TextStyle labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget tab = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2,
        children: [
          IconTheme.merge(
            data: IconThemeData(color: color, size: 24),
            child: selected ? (item.selectedIcon ?? item.icon) : item.icon,
          ),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: labelStyle.copyWith(color: color),
          ),
        ],
      ),
    );

    tab = Semantics(
      button: true,
      selected: selected,
      label: item.semanticsLabel ?? item.label,
      excludeSemantics: true,
      child: tab,
    );

    if (item.tooltip case final tooltip?) tab = Tooltip(message: tooltip, child: tab);
    return tab;
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

  return LiquidGlassSurface(
    interactionScale: 1,
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

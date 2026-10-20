import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// An iOS 27-style switch: a colored track with a white thumb that turns into
/// a clear glass lens and swells while it is pressed or dragged.
///
/// The glass is only mounted while the thumb is active, so a page of switches
/// doesn't keep a glass layer per switch at rest.
class LiquidGlassSwitch extends StatefulWidget {
  /// Creates a liquid glass switch.
  const LiquidGlassSwitch({super.key, required this.value, required this.onChanged, this.semanticLabel});

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value when the user flips the switch; null disables
  /// the switch.
  final ValueChanged<bool>? onChanged;

  /// The accessibility label.
  final String? semanticLabel;

  @override
  State<LiquidGlassSwitch> createState() => _LiquidGlassSwitchState();
}

class _LiquidGlassSwitchState extends State<LiquidGlassSwitch> with TickerProviderStateMixin {
  static const _trackWidth = 64.0;
  static const _trackHeight = 28.0;
  static const _inset = 2.0;
  static const _thumbWidth = 38.0;
  static const _thumbHeight = _trackHeight - 2 * _inset;
  static const _pressedScale = 1.45;
  static const _travel = _trackWidth - 2 * _inset - _thumbWidth;

  // 0 is off (thumb left) and 1 is on (thumb right).
  late final _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
    value: widget.value ? 1 : 0,
  );

  // 0 at rest and 1 while the thumb is held as glass.
  late final _press = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));

  bool get _enabled => widget.onChanged != null;

  @override
  void didUpdateWidget(LiquidGlassSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _press.value == 0) _animatePosition(widget.value);
  }

  @override
  void dispose() {
    _position.dispose();
    _press.dispose();
    super.dispose();
  }

  void _animatePosition(bool on) {
    _position.animateTo(on ? 1 : 0, curve: Curves.easeOutBack);
  }

  void _release(bool newValue) {
    _press.reverse();
    _animatePosition(newValue);
    if (newValue != widget.value) {
      HapticFeedback.lightImpact();
      widget.onChanged?.call(newValue);
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final delta = details.primaryDelta! / _travel;
    _position.value += rtl ? -delta : delta;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final brightness = Theme.of(context).brightness;
    final offColor = brightness == Brightness.light ? const Color(0x29787880) : const Color(0x52787880);

    final switchBody = AnimatedBuilder(
      animation: Listenable.merge([_position, _press]),
      builder: (context, _) {
        final position = _position.value.clamp(0.0, 1.0);
        final press = _press.value;
        final trackColor = Color.lerp(offColor, colorScheme.accentSuccess, position)!;

        Widget thumb = SizedBox(
          width: _thumbWidth,
          height: _thumbHeight,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: Colors.white.withValues(alpha: 1 - press),
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15 * (1 - press)),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );

        if (press > 0) {
          thumb = LiquidGlass.withOwnLayer(
            settings: LiquidGlassSettings.ios27Clear(),
            appearance: LiquidGlassAppearance.ios27Clear(visibility: press),
            shape: const LiquidRoundedSuperellipse(borderRadius: _thumbHeight / 2),
            child: thumb,
          );
        }

        return SizedBox(
          width: _trackWidth,
          height: _trackHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: ShapeDecoration(shape: const StadiumBorder(), color: trackColor),
                ),
              ),
              PositionedDirectional(
                start: _inset + _travel * position,
                top: _inset,
                child: Transform.scale(scale: 1 + (_pressedScale - 1) * press, child: thumb),
              ),
            ],
          ),
        );
      },
    );

    return Semantics(
      toggled: widget.value,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: _enabled ? () => widget.onChanged!(!widget.value) : null,
      child: Opacity(
        opacity: _enabled ? 1 : 0.5,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled ? (_) => _press.forward() : null,
          onTapUp: _enabled ? (_) => _release(!widget.value) : null,
          onTapCancel: _enabled ? _press.reverse : null,
          onHorizontalDragStart: _enabled ? (_) => _press.forward() : null,
          onHorizontalDragUpdate: _enabled ? _onDragUpdate : null,
          onHorizontalDragEnd: _enabled ? (_) => _release(_position.value >= 0.5) : null,
          onHorizontalDragCancel: _enabled ? () => _release(widget.value) : null,
          // Pads the 28px track to a 48px tap target, like the SDK's switch.
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: switchBody),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A fixed-size, circular filled icon button.
///
/// Used for every state of the composer's trailing control (mic, send, and
/// stop) so that switching between them reads as one control morphing in
/// place, rather than several differently-sized buttons swapping out.
class ComposerActionButton extends StatelessWidget {
  /// Creates a [ComposerActionButton].
  const ComposerActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.color,
  });

  /// The icon shown inside the button.
  final IconData icon;

  /// Called when the button is tapped. A `null` value disables the button.
  final VoidCallback? onPressed;

  /// The tooltip message shown on long-press/hover.
  final String tooltip;

  /// The button's fill color when enabled.
  ///
  /// Automatically dimmed when [onPressed] is `null`.
  final Color color;

  /// The button's fixed diameter.
  ///
  /// Shared across every trailing-control state so mic/send/stop occupy
  /// exactly the same footprint.
  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: enabled ? color : color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

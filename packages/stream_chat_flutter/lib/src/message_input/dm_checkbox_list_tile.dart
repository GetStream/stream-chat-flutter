import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template dmCheckboxListTile}
/// A widget that represents a checkbox list tile for direct message input.
/// {@endtemplate}
class DmCheckboxListTile extends StatelessWidget {
  /// {@macro dmCheckboxListTile}
  const DmCheckboxListTile({
    super.key,
    required this.value,
    this.onChanged,
    this.contentPadding,
  });

  /// The current value of the checkbox.
  final bool value;

  /// The callback to perform when the checkbox value is changed.
  final ValueChanged<bool>? onChanged;

  /// The padding around the checkbox list tile.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    // NOTE: Only squeeze the vertical axis. `ListTile` computes its effective
    // horizontal title gap as `horizontalTitleGap + visualDensity.horizontal * 2`
    // so a negative horizontal density would silently cancel out our `xs` gap
    // (and even produce a negative gap, overlapping the checkbox and title).
    const visualDensity = VisualDensity(vertical: VisualDensity.minimumDensity);

    final checkbox = ExcludeFocus(
      child: StreamCheckbox(
        value: value,
        size: StreamCheckboxSize.sm,
        onChanged: switch (onChanged) {
          final onChanged? => onChanged.call,
          _ => null,
        },
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: MergeSemantics(
        child: ListTile(
          dense: true,
          leading: checkbox,
          minLeadingWidth: 0,
          horizontalTitleGap: spacing.xs,
          visualDensity: visualDensity,
          enabled: onChanged != null,
          onTap: () => onChanged?.call(!value),
          contentPadding: contentPadding,
          title: Text(
            context.translations.alsoSendAsDirectMessageLabel,
            style: textTheme.metadataDefault.copyWith(
              color: onChanged != null ? colorScheme.textPrimary : colorScheme.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
    final textTheme = context.streamTextTheme;

    const visualDensity = VisualDensity(
      vertical: VisualDensity.minimumDensity,
      horizontal: VisualDensity.minimumDensity,
    );

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

    return MergeSemantics(
      child: ListTile(
        dense: true,
        leading: checkbox,
        horizontalTitleGap: 16,
        visualDensity: visualDensity,
        enabled: onChanged != null,
        onTap: () => onChanged?.call(!value),
        contentPadding: contentPadding,
        title: Text(
          context.translations.alsoSendAsDirectMessageLabel,
          style: textTheme.metadataDefault,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

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
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    const visualDensity = VisualDensity(
      vertical: VisualDensity.minimumDensity,
      horizontal: VisualDensity.minimumDensity,
    );

    final checkbox = ExcludeFocus(
      child: CheckboxTheme(
        data: CheckboxThemeData(
          overlayColor: WidgetStatePropertyAll(
            colorTheme.accentPrimary.withAlpha(kRadialReactionAlpha),
          ),
        ),
        child: Checkbox(
          value: value,
          visualDensity: visualDensity,
          activeColor: colorTheme.accentPrimary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(width: 2, color: colorTheme.textLowEmphasis),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          onChanged: switch (onChanged) {
            final onChanged? => (value) {
              if (value == null) return;
              return onChanged.call(value);
            },
            _ => null,
          },
        ),
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
          style: textTheme.footnote.copyWith(
            // ignore: deprecated_member_use
            color: colorTheme.textHighEmphasis.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

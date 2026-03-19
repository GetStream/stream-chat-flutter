import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_command_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template commands_overlay}
/// Overlay for displaying commands that can be used
/// to interact with the channel.
/// {@endtemplate}
class StreamCommandAutocompleteOptions extends StatelessWidget {
  /// Constructor for creating a [StreamCommandAutocompleteOptions]
  const StreamCommandAutocompleteOptions({
    required this.query,
    required this.channel,
    this.onCommandSelected,
    this.style = AutocompleteOptionsStyle.fixed,
    super.key,
  });

  /// Query for searching commands.
  final String query;

  /// The channel to search for users.
  final Channel channel;

  /// Callback called when a command is selected.
  final ValueSetter<Command>? onCommandSelected;

  /// The visual style of the autocomplete options overlay.
  ///
  /// Defaults to [AutocompleteOptionsStyle.fixed].
  final AutocompleteOptionsStyle style;

  @override
  Widget build(BuildContext context) {
    final commands = channel.config?.commands.where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedName = it.name.toUpperCase();
      return normalizedName.contains(normalizedQuery);
    });

    if (commands == null || commands.isEmpty) return const Empty();

    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final (elevation, margin, shape) = switch (style) {
      AutocompleteOptionsStyle.fixed => (
        0.0,
        EdgeInsets.zero,
        _TopBorderShape(BorderSide(color: colorScheme.borderDefault)) as ShapeBorder,
      ),
      AutocompleteOptionsStyle.floating => (
        4.0,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            )
            as ShapeBorder,
      ),
    };

    return StreamAutocompleteOptions<Command>(
      options: commands,
      elevation: elevation,
      margin: margin,
      shape: shape,
      headerBuilder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: context.streamSpacing.sm,
            right: context.streamSpacing.sm,
            top: context.streamSpacing.md,
            bottom: context.streamSpacing.xs,
          ),
          child: Align(
            alignment: .centerStart,
            child: Text(
              context.translations.instantCommandsLabel,
              style: textTheme.headingXs.copyWith(color: colorScheme.textTertiary),
            ),
          ),
        );
      },
      optionBuilder: (context, command) {
        return ListTile(
          dense: true,
          horizontalTitleGap: context.streamSpacing.sm,
          leading: StreamCommandIcon(command: command),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                command.name.sentenceCase,
                style: textTheme.bodyDefault,
              ),
              const SizedBox(width: 8),
              Text(
                command.description,
                style: textTheme.captionDefault.copyWith(
                  color: colorScheme.textTertiary,
                ),
              ),
            ],
          ),
          onTap: onCommandSelected == null ? null : () => onCommandSelected!(command),
        );
      },
    );
  }
}

/// A [ShapeBorder] that paints only a top border, with no rounding or sides.
class _TopBorderShape extends ShapeBorder {
  const _TopBorderShape(this.top);

  final BorderSide top;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(top: top.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = top.toPaint()..strokeCap = StrokeCap.square;
    final y = rect.top + top.width / 2;
    canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
  }

  @override
  ShapeBorder scale(double t) => _TopBorderShape(top.scale(t));
}

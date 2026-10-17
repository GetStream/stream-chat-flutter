import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:yaru/yaru.dart';

/// Component builders that render the SDK's core components with Yaru:
/// Material buttons styled by the Yaru theme, [YaruCheckbox], [YaruSwitch] and
/// the Yaru progress indicators.
///
/// Pass [extensions] to keep the app's own chat component overrides.
StreamComponentBuilders yaruComponentBuilders({
  Iterable<StreamComponentBuilderExtension<Object>>? extensions,
}) {
  return StreamComponentBuilders(
    button: (context, props) => YaruStreamButton(props: props),
    checkbox: (context, props) => Semantics(
      checked: props.value,
      label: props.semanticLabel,
      child: YaruCheckbox(value: props.value, onChanged: _nullable(props.onChanged)),
    ),
    toggleSwitch: (context, props) => Semantics(
      toggled: props.value,
      label: props.semanticLabel,
      child: YaruSwitch(value: props.value, onChanged: props.onChanged),
    ),
    progressBar: (context, props) => YaruLinearProgressIndicator(
      value: props.value,
      color: props.fillColor,
      trackColor: props.trackColor,
    ),
    loadingSpinner: (context, props) {
      final dimension = switch (props.size ?? StreamLoadingSpinnerSize.md) {
        StreamLoadingSpinnerSize.lg => 32.0,
        StreamLoadingSpinnerSize.md => 24.0,
        StreamLoadingSpinnerSize.sm => 20.0,
        StreamLoadingSpinnerSize.xs => 16.0,
      };
      return SizedBox.square(
        dimension: dimension,
        child: YaruCircularProgressIndicator(
          value: props.value,
          color: props.color,
          trackColor: props.trackColor,
          strokeWidth: dimension / 8,
        ),
      );
    },
    extensions: extensions,
  );
}

// YaruCheckbox is tristate-capable, so its callback takes a nullable value.
ValueChanged<bool?>? _nullable(ValueChanged<bool>? onChanged) {
  if (onChanged == null) return null;
  return (value) => onChanged(value ?? false);
}

/// A [StreamButton] rendered as the Material button the Yaru theme styles for
/// its type: elevated (the accent fill) for solid primary, filled for other
/// solid buttons, outlined and text buttons for the outline and ghost types.
class YaruStreamButton extends StatelessWidget {
  /// Creates a Yaru button from the SDK's button [props].
  const YaruStreamButton({super.key, required this.props});

  /// The properties the SDK passed for this button.
  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDestructive = props.style == StreamButtonStyle.destructive;
    final height = props.size.value;

    Widget button;
    if (props.child == null) {
      final icon = props.iconLeft ?? props.iconRight ?? const SizedBox.shrink();
      final style = IconButton.styleFrom(
        fixedSize: Size.square(height),
        foregroundColor: isDestructive ? colorScheme.error : null,
      );
      button = switch ((props.type, props.isSelected ?? false)) {
        (StreamButtonType.solid, _) || (_, true) => IconButton.filled(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.outline, _) => IconButton.outlined(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.ghost, _) => IconButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: style,
          icon: icon,
        ),
      };
    } else {
      final child = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          ?props.iconLeft,
          Flexible(child: props.child!),
          ?props.iconRight,
        ],
      );
      final minimumSize = Size(0, height);
      button = switch ((props.type, props.style)) {
        (StreamButtonType.solid, StreamButtonStyle.primary) => ElevatedButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: ElevatedButton.styleFrom(minimumSize: minimumSize),
          child: child,
        ),
        (StreamButtonType.solid, StreamButtonStyle.destructive) => ElevatedButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: ElevatedButton.styleFrom(
            minimumSize: minimumSize,
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          child: child,
        ),
        (StreamButtonType.solid, _) => FilledButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: FilledButton.styleFrom(minimumSize: minimumSize),
          child: child,
        ),
        (StreamButtonType.outline, _) => OutlinedButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: OutlinedButton.styleFrom(
            minimumSize: minimumSize,
            foregroundColor: isDestructive ? colorScheme.error : null,
          ),
          child: child,
        ),
        (StreamButtonType.ghost, _) => TextButton(
          onPressed: props.onPressed,
          autofocus: props.autofocus,
          style: TextButton.styleFrom(
            minimumSize: minimumSize,
            foregroundColor: isDestructive ? colorScheme.error : null,
          ),
          child: child,
        ),
      };
    }

    if (props.tooltip case final tooltip?) {
      button = Tooltip(message: tooltip, child: button);
    }
    return Semantics(selected: props.isSelected, child: button);
  }
}

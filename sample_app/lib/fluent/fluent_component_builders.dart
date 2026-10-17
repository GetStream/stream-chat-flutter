import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../utils/tap_target.dart';

/// Component builders that render the SDK's core components with `fluent_ui`
/// controls: buttons, toggle switches, checkboxes, text boxes, progress bars
/// and progress rings.
///
/// These controls read a [fluent.FluentTheme], which the app provides above
/// the router. Pass [extensions] to keep the app's own chat component
/// overrides.
StreamComponentBuilders fluentComponentBuilders({
  Iterable<StreamComponentBuilderExtension<Object>>? extensions,
}) {
  return StreamComponentBuilders(
    button: (context, props) => FluentStreamButton(props: props),
    checkbox: (context, props) => fluent.Checkbox(
      checked: props.value,
      semanticLabel: props.semanticLabel,
      onChanged: switch (props.onChanged) {
        final onChanged? => (value) => onChanged(value ?? false),
        null => null,
      },
    ),
    toggleSwitch: (context, props) => fluent.ToggleSwitch(
      checked: props.value,
      semanticLabel: props.semanticLabel,
      onChanged: props.onChanged,
    ),
    textInput: (context, props) => FluentTextInput(props: props),
    // fluent_ui progress values run from 0 to 100.
    progressBar: (context, props) => fluent.ProgressBar(
      value: props.value == null ? null : props.value! * 100,
      activeColor: props.fillColor,
      backgroundColor: props.trackColor,
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
        child: fluent.ProgressRing(
          value: props.value == null ? null : props.value! * 100,
          strokeWidth: dimension / 8,
          activeColor: props.color,
          backgroundColor: props.trackColor,
        ),
      );
    },
    extensions: extensions,
  );
}

/// A [StreamButton] rendered as a Fluent button: the accent [fluent.FilledButton]
/// for solid buttons, the standard [fluent.Button] for outlined ones and a
/// subtle [fluent.IconButton] / text button for ghost ones.
class FluentStreamButton extends StatelessWidget {
  /// Creates a Fluent button from the SDK's button [props].
  const FluentStreamButton({super.key, required this.props});

  /// The properties the SDK passed for this button.
  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final isDestructive = props.style == StreamButtonStyle.destructive;
    final height = props.size.value;
    final isIconOnly = props.child == null;

    final destructiveStyle = isDestructive
        ? fluent.ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              props.type == StreamButtonType.solid ? colorScheme.textOnAccent : colorScheme.accentError,
            ),
            backgroundColor: props.type == StreamButtonType.solid
                ? WidgetStatePropertyAll(colorScheme.accentError)
                : null,
          )
        : null;

    final content = isIconOnly
        ? (props.iconLeft ?? props.iconRight ?? const SizedBox.shrink())
        : Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              ?props.iconLeft,
              Flexible(child: props.child!),
              ?props.iconRight,
            ],
          );

    Widget button = switch (props.type) {
      StreamButtonType.solid when props.style != StreamButtonStyle.secondary => fluent.FilledButton(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: destructiveStyle,
        child: content,
      ),
      StreamButtonType.ghost when isIconOnly => fluent.IconButton(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: destructiveStyle,
        icon: content,
      ),
      StreamButtonType.ghost => fluent.HyperlinkButton(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: destructiveStyle,
        child: content,
      ),
      _ => fluent.Button(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        style: destructiveStyle,
        child: content,
      ),
    };

    button = isIconOnly
        ? SizedBox.square(dimension: height, child: button)
        : ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Center(widthFactor: 1, heightFactor: 1, child: button),
          );

    if (props.tooltip case final tooltip?) {
      button = fluent.Tooltip(message: tooltip, child: button);
    }
    return Semantics(button: true, selected: props.isSelected, child: padToTapTarget(context, button));
  }
}

/// A [StreamTextInput] rendered as a [fluent.TextBox], with the label and
/// helper text laid out the way Fluent's `InfoLabel` does.
///
/// [fluent.TextBox] has no initial-value parameter, so an input that only
/// passes an initial value falls back to the default SDK input.
class FluentTextInput extends StatelessWidget {
  /// Creates a Fluent text input from the SDK's text input [props].
  const FluentTextInput({super.key, required this.props});

  /// The properties the SDK passed for this text input.
  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    if (props.controller == null && props.initialValue != null) return DefaultStreamTextInput(props: props);

    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    Widget input = fluent.TextBox(
      controller: props.controller,
      focusNode: props.focusNode,
      placeholder: props.hintText,
      prefix: props.leading,
      suffix: props.trailing,
      enabled: props.enabled,
      readOnly: props.readOnly,
      autofocus: props.autofocus,
      autocorrect: props.autocorrect,
      keyboardType: props.keyboardType,
      textInputAction: props.textInputAction,
      textCapitalization: props.textCapitalization,
      textAlign: props.textAlign,
      textAlignVertical: props.textAlignVertical,
      inputFormatters: props.inputFormatters,
      maxLines: props.maxLines,
      minLines: props.minLines,
      maxLength: props.maxLength,
      onChanged: props.onChanged,
      onEditingComplete: props.onEditingComplete,
      onSubmitted: props.onSubmitted,
      onTap: props.onTap,
    );

    if (props.labelText case final label?) {
      input = fluent.InfoLabel(label: label, child: input);
    }

    if (props.helperText case final helper?) {
      input = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          input,
          Text(
            helper,
            style: textTheme.captionDefault.copyWith(
              color: switch (props.helperState) {
                StreamHelperState.error => colorScheme.accentError,
                StreamHelperState.success => colorScheme.accentSuccess,
                _ => colorScheme.textSecondary,
              },
            ),
          ),
        ],
      );
    }

    return input;
  }
}

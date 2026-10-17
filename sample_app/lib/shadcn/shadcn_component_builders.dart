import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../utils/tap_target.dart';

/// Component builders that render the SDK's core components with `shadcn_ui`:
/// buttons, icon buttons, switches, checkboxes, inputs and progress bars.
///
/// These controls read a [ShadTheme], which the app provides above the router.
/// Pass [extensions] to keep the app's own chat component overrides.
StreamComponentBuilders shadcnComponentBuilders({
  Iterable<StreamComponentBuilderExtension<Object>>? extensions,
}) {
  return StreamComponentBuilders(
    button: (context, props) => ShadcnStreamButton(props: props),
    checkbox: (context, props) => Semantics(
      checked: props.value,
      label: props.semanticLabel,
      child: ShadCheckbox(
        value: props.value,
        enabled: props.onChanged != null,
        onChanged: props.onChanged,
      ),
    ),
    toggleSwitch: (context, props) => Semantics(
      toggled: props.value,
      label: props.semanticLabel,
      child: ShadSwitch(
        value: props.value,
        enabled: props.onChanged != null,
        onChanged: props.onChanged,
      ),
    ),
    textInput: (context, props) => ShadcnTextInput(props: props),
    progressBar: (context, props) => ShadProgress(
      value: props.value,
      color: props.fillColor,
      backgroundColor: props.trackColor,
    ),
    extensions: extensions,
  );
}

/// A [StreamButton] rendered as the matching [ShadButton] / [ShadIconButton]
/// variant: primary, secondary or destructive for solid buttons, outline and
/// ghost for the others.
class ShadcnStreamButton extends StatelessWidget {
  /// Creates a shadcn button from the SDK's button [props].
  const ShadcnStreamButton({super.key, required this.props});

  /// The properties the SDK passed for this button.
  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final variant = switch ((props.type, props.style)) {
      (_, StreamButtonStyle.destructive) when props.type == StreamButtonType.solid => ShadButtonVariant.destructive,
      (StreamButtonType.solid, StreamButtonStyle.primary) => ShadButtonVariant.primary,
      (StreamButtonType.solid, _) => ShadButtonVariant.secondary,
      (StreamButtonType.outline, _) => ShadButtonVariant.outline,
      (StreamButtonType.ghost, _) => ShadButtonVariant.ghost,
    };
    // A destructive outline / ghost button keeps its variant but reads red.
    final foreground = props.style == StreamButtonStyle.destructive && props.type != StreamButtonType.solid
        ? ShadTheme.of(context).colorScheme.destructive
        : null;
    final height = props.size.value;

    Widget button;
    if (props.child == null) {
      button = ShadIconButton.raw(
        variant: (props.isSelected ?? false) ? ShadButtonVariant.secondary : variant,
        icon: props.iconLeft ?? props.iconRight ?? const SizedBox.shrink(),
        onPressed: props.onPressed,
        enabled: props.onPressed != null,
        autofocus: props.autofocus,
        width: height,
        height: height,
        foregroundColor: foreground,
      );
    } else {
      button = ShadButton.raw(
        variant: variant,
        leading: props.iconLeft,
        trailing: props.iconRight,
        onPressed: props.onPressed,
        enabled: props.onPressed != null,
        autofocus: props.autofocus,
        height: height,
        foregroundColor: foreground,
        child: props.child,
      );
    }

    if (props.tooltip case final tooltip?) {
      button = Tooltip(message: tooltip, child: button);
    }
    return Semantics(selected: props.isSelected, child: padToTapTarget(context, button));
  }
}

/// A [StreamTextInput] rendered as a [ShadInput], with the label and helper
/// text laid out the way shadcn's form fields do.
class ShadcnTextInput extends StatelessWidget {
  /// Creates a shadcn text input from the SDK's text input [props].
  const ShadcnTextInput({super.key, required this.props});

  /// The properties the SDK passed for this text input.
  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    final shad = ShadTheme.of(context);

    final input = ShadInput(
      controller: props.controller,
      initialValue: props.initialValue,
      focusNode: props.focusNode,
      placeholder: props.hintText == null ? null : Text(props.hintText!),
      leading: props.leading,
      trailing: props.trailing,
      enabled: props.enabled,
      readOnly: props.readOnly,
      autofocus: props.autofocus,
      autocorrect: props.autocorrect,
      keyboardType: props.keyboardType,
      textInputAction: props.textInputAction,
      textCapitalization: props.textCapitalization,
      textAlign: props.textAlign,
      inputFormatters: props.inputFormatters,
      maxLines: props.maxLines,
      minLines: props.minLines,
      maxLength: props.maxLength,
      onChanged: props.onChanged,
      onEditingComplete: props.onEditingComplete,
      onSubmitted: props.onSubmitted,
      onPressed: props.onTap,
    );

    final label = props.labelText;
    final helper = props.helperText;
    if (label == null && helper == null) return input;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        if (label != null) Text(label, style: shad.textTheme.small),
        input,
        if (helper != null)
          Text(
            helper,
            style: shad.textTheme.muted.copyWith(
              color: switch (props.helperState) {
                StreamHelperState.error => shad.colorScheme.destructive,
                _ => null,
              },
            ),
          ),
      ],
    );
  }
}

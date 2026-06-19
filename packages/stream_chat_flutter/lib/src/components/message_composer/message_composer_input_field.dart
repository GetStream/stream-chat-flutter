import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

/// A widget that represents the actual text input field for the message
/// composer.
///
/// Renders the [TextField] used by [DefaultStreamMessageComposerInputCenter],
/// along with an optional [StreamCommandChip] when a slash command is active.
class StreamMessageComposerInputField extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInputField].
  const StreamMessageComposerInputField({
    super.key,
    required this.controller,
    this.placeholder,
    this.focusNode,
    this.command,
    this.onDismissCommand,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autocorrect = true,
    this.enabled = true,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The placeholder text shown when the field is empty.
  final String? placeholder;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// The active command label displayed as a chip.
  final String? command;

  /// Called when the user dismisses the command chip.
  final VoidCallback? onDismissCommand;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// Whether the text field should be focused initially.
  final bool autofocus;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether the text field is enabled.
  ///
  /// When false the text field cannot be edited and the placeholder remains
  /// visible regardless of the underlying [controller] text. Used by the
  /// composer to lock input while slow mode is active.
  ///
  /// Defaults to true.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    final inputStyle = context.streamTextInputTheme.style;
    final inputDefaults = _InputThemeDefaults(context: context).style;

    final effectiveStyle = inputStyle?.textStyle ?? inputDefaults.textStyle;
    final effectiveHintStyle = inputStyle?.hintStyle ?? inputDefaults.hintStyle;
    final effectiveCursorColor = inputStyle?.cursorColor ?? inputDefaults.cursorColor;
    final effectiveCursorWidth = inputStyle?.cursorWidth ?? inputDefaults.cursorWidth ?? 2.0;
    final effectiveCursorHeight = inputStyle?.cursorHeight ?? inputDefaults.cursorHeight;
    final effectiveCursorRadius = inputStyle?.cursorRadius ?? inputDefaults.cursorRadius;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 124),
      child: Padding(
        padding: EdgeInsets.all(spacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing.xxs,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (command case final command?)
              core.StreamCommandChip(
                label: command,
                onDismiss: onDismissCommand,
              ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                textInputAction: textInputAction,
                keyboardType: keyboardType,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                autocorrect: autocorrect,
                style: effectiveStyle,
                cursorColor: effectiveCursorColor,
                cursorWidth: effectiveCursorWidth,
                cursorHeight: effectiveCursorHeight,
                cursorRadius: effectiveCursorRadius,
                maxLines: null,
                decoration: InputDecoration(
                  isCollapsed: true,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: placeholder,
                  hintStyle: effectiveHintStyle,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: spacing.xxs,
                    vertical: spacing.xxxs,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputThemeDefaults {
  _InputThemeDefaults({required this.context})
    : _colorScheme = context.streamColorScheme,
      _textTheme = context.streamTextTheme;

  final BuildContext context;
  final StreamColorScheme _colorScheme;
  final core.StreamTextTheme _textTheme;

  StreamTextInputStyle get style => StreamTextInputStyle(
    cursorWidth: 2,
    cursorColor: _colorScheme.accentPrimary,
    cursorErrorColor: _colorScheme.accentError,
    textStyle: _textTheme.bodyDefault.copyWith(color: _colorScheme.textPrimary),
    hintStyle: _textTheme.bodyDefault.copyWith(color: _colorScheme.textTertiary),
  );
}

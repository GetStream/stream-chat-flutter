import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _kTransitionDuration = Duration(milliseconds: 167);

/// {@template streamPollTextField}
/// A widget that represents a text field for poll input.
/// {@endtemplate}
class StreamPollTextField extends StatefulWidget {
  /// {@macro streamPollTextField}
  const StreamPollTextField({
    super.key,
    this.initialValue,
    this.style,
    this.enabled = true,
    this.hintText,
    this.fillColor,
    this.errorText,
    this.errorStyle,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 18,
      horizontal: 16,
    ),
    this.borderRadius,
    this.focusNode,
    this.keyboardType,
    this.autoFocus = false,
    this.onChanged,
  });

  /// The initial value of the text field.
  ///
  /// If `null`, the text field will be empty.
  final String? initialValue;

  /// The style to use for the text field.
  final TextStyle? style;

  /// Whether the text field is enabled.
  final bool enabled;

  /// The hint text to be displayed in the text field.
  final String? hintText;

  /// The fill color of the text field.
  final Color? fillColor;

  /// The error text to be displayed below the text field.
  ///
  /// If `null`, no error text will be displayed.
  final String? errorText;

  /// The style to use for the error text.
  final TextStyle? errorStyle;

  /// The padding around the text field content.
  final EdgeInsetsGeometry contentPadding;

  /// The border radius of the text field.
  final BorderRadius? borderRadius;

  /// The keyboard type of the text field.
  final TextInputType? keyboardType;

  /// Whether the text field should autofocus.
  final bool autoFocus;

  /// The focus node of the text field.
  final FocusNode? focusNode;

  /// Callback called when the text field value is changed.
  final ValueChanged<String>? onChanged;

  @override
  State<StreamPollTextField> createState() => _StreamPollTextFieldState();
}

class _StreamPollTextFieldState extends State<StreamPollTextField> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void didUpdateWidget(covariant StreamPollTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller value if the updated initial value is different
    // from the current value.
    final currValue = _controller.text;
    final newValue = widget.initialValue;
    if (currValue != newValue) {
      _controller.value = switch (newValue) {
        final value? => TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          ),
        _ => TextEditingValue.empty,
      };
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    // Reduce vertical padding if there is an error text.
    var contentPadding = widget.contentPadding;
    final verticalPadding = contentPadding.vertical;
    final horizontalPadding = contentPadding.horizontal;
    if (widget.errorText != null) {
      contentPadding = contentPadding.subtract(
        EdgeInsets.symmetric(vertical: verticalPadding / 4),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PollTextFieldError(
          padding: EdgeInsets.only(
            top: verticalPadding / 4,
            left: horizontalPadding / 2,
            right: horizontalPadding / 2,
          ),
          errorText: widget.errorText,
          errorStyle: widget.errorStyle ??
              theme.textTheme.footnote.copyWith(
                color: theme.colorTheme.accentError,
              ),
        ),
        TextField(
          autocorrect: false,
          controller: _controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          style: widget.style ?? theme.textTheme.headline,
          keyboardType: widget.keyboardType,
          autofocus: widget.autoFocus,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
          decoration: InputDecoration(
            filled: true,
            isCollapsed: true,
            enabled: widget.enabled,
            fillColor: widget.fillColor,
            hintText: widget.hintText,
            hintStyle: (widget.style ?? theme.textTheme.headline).copyWith(
              color: theme.colorTheme.textLowEmphasis,
            ),
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// {@template pollTextFieldError}
/// A widget that displays an error text around a text field with a fade
/// transition.
///
/// Usually used with [StreamPollTextField].
/// {@endtemplate}
class PollTextFieldError extends StatefulWidget {
  /// {@macro pollTextFieldError}
  const PollTextFieldError({
    super.key,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.textAlign,
    this.padding,
  });

  /// The error text to be displayed.
  final String? errorText;

  /// The maximum number of lines for the error text.
  final int? errorMaxLines;

  /// The alignment of the error text.
  final TextAlign? textAlign;

  /// The style of the error text.
  final TextStyle? errorStyle;

  /// The padding around the error text.
  final EdgeInsetsGeometry? padding;

  @override
  State<PollTextFieldError> createState() => _PollTextFieldErrorState();
}

class _PollTextFieldErrorState extends State<PollTextFieldError>
    with SingleTickerProviderStateMixin<PollTextFieldError> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
    )..addListener(() => setState(() {}));

    if (widget.errorText != null) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant PollTextFieldError oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate the error text if the error text state has changed.
    final newError = widget.errorText;
    final currError = oldWidget.errorText;
    final errorTextStateChanged = (newError != null) != (currError != null);
    if (errorTextStateChanged) {
      if (newError != null) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorText = widget.errorText;
    if (errorText == null) return const Empty();

    return Container(
      padding: widget.padding,
      child: Semantics(
        container: true,
        child: FadeTransition(
          opacity: _controller,
          child: FractionalTranslation(
            translation: Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).evaluate(_controller.view),
            child: Text(
              errorText,
              style: widget.errorStyle,
              textAlign: widget.textAlign,
              overflow: TextOverflow.ellipsis,
              maxLines: widget.errorMaxLines,
            ),
          ),
        ),
      ),
    );
  }
}

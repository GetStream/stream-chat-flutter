import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

/// {@template typewriterState}
/// The current typing state of a typewriter.
/// {@endtemplate}
enum TypewriterState {
  /// The typewriter is not typing.
  idle,

  /// The typewriter is currently typing.
  typing,

  /// The typewriter is paused at the current char index.
  paused,

  /// The typewriter has stopped typing and has reset the current char index.
  stopped,
}

/// {@template typewriterValue}
/// A value class that holds the current text and typing state of a typewriter.
///
/// The [text] field holds the current text that has been typed out. The [state]
/// field holds the current typing state of the typewriter.
/// {@endtemplate}
class TypewriterValue {
  /// {@macro typewriterValue}
  const TypewriterValue({
    this.text = '',
    this.state = TypewriterState.idle,
  });

  /// The current text that has been typed out.
  final String text;

  /// The current typing state of the typewriter.
  final TypewriterState state;

  /// Creates a copy of this [TypewriterValue] with the given fields replaced
  /// by the new values.
  TypewriterValue copyWith({
    String? text,
    TypewriterState? state,
  }) {
    return TypewriterValue(
      text: text ?? this.text,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypewriterValue &&
        other.text == text &&
        other.state == state;
  }

  @override
  int get hashCode => text.hashCode ^ state.hashCode;
}

/// {@template typewriterController}
/// A controller for a [StreamTypewriterBuilder]. It allows you to control the
/// typing state of the typewriter. You can start, pause, and stop typing the
/// target text.
///
/// To use a [TypewriterController], simply create one and pass it to a
/// [StreamTypewriterBuilder]. The builder will listen to the controller and
/// rebuild whenever the value changes. You can then control the typing state
/// by calling [startTyping], [pauseTyping], and [stopTyping] on the controller.
///
/// ```dart
/// final controller = TypewriterController(text: 'Hello, World!');
///
/// @override
/// Widget build(BuildContext context) {
///  return StreamTypewriterBuilder(
///    controller: controller,
///    builder: (context, value, child) {
///      return Text(value.text);
///    },
///   );
///  }
///
/// // Start typing the target text.
/// controller.startTyping();
///
/// // Pause typing at the current char index.
/// controller.pauseTyping();
///
/// // Stop typing and reset the current char index.
/// controller.stopTyping();
///
/// // Update the target text.
/// controller.updateText('Hello, Flutter!');
/// ```
/// {@endtemplate}
class TypewriterController extends ValueNotifier<TypewriterValue> {
  /// {@macro typewriterController}
  TypewriterController({
    String text = '',
    this.typingSpeed = const Duration(milliseconds: 10),
  }) : super(TypewriterValue(text: text)) {
    // Set the target text and the current char index.
    _targetText = value.text.characters;
    _currentCharIndex = _targetText.length - 1;
  }

  /// The speed at which the text should be typed out.
  ///
  /// Defaults to `10 milliseconds` per character.
  final Duration typingSpeed;

  Timer? _timer;

  late int _currentCharIndex;
  late Characters _targetText;

  /// Cancels the current typing timer and displays the target text immediately.
  ///
  /// This is useful when you want to display the target text immediately
  /// without typing it out.
  set text(String newText) {
    _timer?.cancel();
    _targetText = newText.characters;
    _currentCharIndex = _targetText.length;
    value = value.copyWith(text: newText, state: TypewriterState.idle);
  }

  /// Updates the target text to [newText].
  ///
  /// If the controller is currently typing, the new text will be typed out
  /// automatically. If it is not typing, the new text will be typed out only
  /// if [autoStart] is true.
  void updateText(String newText, {bool autoStart = true}) {
    // Update the target text.
    _targetText = newText.characters;

    // Start typing the new text if autoStart is true.
    //
    // This is only needed if the controller is currently not typing. If it is
    // typing, the new text will be typed out automatically.
    if (autoStart) startTyping();
  }

  /// Starts typing the target text.
  ///
  /// If the target text is already being typed out or is already all typed out,
  /// this method does nothing.
  ///
  /// To pause or stop typing, call [pauseTyping] or [stopTyping] respectively.
  void startTyping() {
    // If already typing, return.
    if (value.state == TypewriterState.typing) return;

    // If target text is already all typed out, return.
    if (_currentCharIndex >= _targetText.length) return;

    value = value.copyWith(state: TypewriterState.typing);

    _timer = Timer.periodic(typingSpeed, (timer) {
      if (_currentCharIndex < _targetText.length) {
        _currentCharIndex = min(_currentCharIndex + 1, _targetText.length);
        final newDisplayedText = _targetText.take(_currentCharIndex).string;
        value = value.copyWith(text: newDisplayedText);
      } else {
        timer.cancel();
        value = value.copyWith(state: TypewriterState.idle);
      }
    });
  }

  /// Pauses typing at the current char index.
  ///
  /// To resume typing, call [startTyping].
  void pauseTyping() {
    if (value.state != TypewriterState.typing) return;

    _timer?.cancel();
    value = value.copyWith(state: TypewriterState.paused);
  }

  /// Stops typing and resets the current char index.
  ///
  /// To start typing again, call [startTyping].
  void stopTyping() {
    _timer?.cancel();
    value = value.copyWith(state: TypewriterState.stopped);

    _currentCharIndex = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// {@template typewriterWidgetBuilder}
/// A widget builder for a [StreamTypewriterBuilder]. It allows you to build a
/// widget depending on the [TypewriterValue]'s value.
/// {@endtemplate}
typedef TypewriterWidgetBuilder = Widget Function(
  BuildContext context,
  TypewriterValue value,
  Widget? child,
);

/// {@template streamTypewriterBuilder}
/// A widget that listens to a [TypewriterController] and rebuilds whenever the
/// value changes. It allows you to build a widget depending on the controller's
/// value.
/// {@endtemplate}
class StreamTypewriterBuilder extends StatelessWidget {
  /// {@macro streamTypewriterBuilder}
  const StreamTypewriterBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.child,
  });

  /// The TypewriterController to listen to.
  final TypewriterController controller;

  /// The builder to build the widget depending on the controller's value.
  final TypewriterWidgetBuilder builder;

  /// The child widget to pass to the builder.
  ///
  /// This is typically used to pass a widget that does not depend on the
  /// controller's value.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: builder,
      child: child,
    );
  }
}

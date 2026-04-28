import 'dart:async' show Timer;

import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/src/message_text_field_controller.dart';

/// {@template stream_chat_flutter_core.StreamMessageInputController}
/// Controller for the message composer input field.
///
/// Manages the text editing state, command label, cooldown timer, and
/// focus node. Chat-domain concerns (messages, attachments, mentions, etc.)
/// live in [StreamMessageComposerController].
/// {@endtemplate}
class StreamMessageInputController extends ChangeNotifier {
  /// Creates a [StreamMessageInputController].
  ///
  /// Optionally inject an existing [textFieldController] or [focusNode].
  /// When not provided, both are created and owned (and disposed) internally.
  StreamMessageInputController({
    MessageTextFieldController? textFieldController,
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
    FocusNode? focusNode,
  }) : _ownedTextFieldController = textFieldController == null,
       _textFieldController =
           textFieldController ??
           MessageTextFieldController(textPatternStyle: textPatternStyle),
       _ownedFocusNode = focusNode == null,
       _focusNode = focusNode {
    _textFieldController.addListener(_textFieldListener);
  }

  // ---------- text field ----------

  final bool _ownedTextFieldController;

  /// The underlying [MessageTextFieldController].
  MessageTextFieldController get textFieldController => _textFieldController;
  final MessageTextFieldController _textFieldController;

  void _textFieldListener() => notifyListeners();

  /// The current text in the input field.
  String get text => _textFieldController.text;

  /// Sets the text in the input field.
  set text(String value) {
    _textFieldController.text = value;
  }

  /// The current text selection.
  TextSelection get selection => _textFieldController.selection;

  /// Sets the text selection.
  set selection(TextSelection newSelection) {
    _textFieldController.selection = newSelection;
  }

  /// The full [TextEditingValue] (text + selection + composing region).
  TextEditingValue get textEditingValue => _textFieldController.value;

  /// Sets the full [TextEditingValue].
  set textEditingValue(TextEditingValue value) {
    _textFieldController.value = value;
  }

  // ---------- command ----------

  /// The currently active command label, or `null` when not in command mode.
  String? get command => _command;
  String? _command;

  /// Sets the active command label.
  ///
  /// Passing `null` is equivalent to calling [clearCommand].
  set command(String? value) {
    if (value == null) return clearCommand();
    if (_command == value) return;
    _command = value;
    notifyListeners();
  }

  /// Clears the active command and resets the text field.
  void clearCommand() {
    if (_command == null) return;
    _command = null;
    _textFieldController.clear();
    notifyListeners();
  }

  // ---------- cooldown ----------

  /// Whether slow-mode cooldown is currently active.
  bool get isSlowModeActive => _cooldownTimeOut > 0;

  /// Remaining cooldown in seconds.
  ///
  /// Defaults to 0, meaning no active cooldown.
  int get cooldownTimeOut => _cooldownTimeOut;
  var _cooldownTimeOut = 0;

  Timer? _cooldownTimer;

  /// Starts the slow-mode countdown from [cooldown] seconds.
  ///
  /// If [cooldown] is 0 or negative, this is a no-op.
  void startCooldown(int cooldown) {
    if (cooldown <= 0) return;

    _cooldownTimer ??= _setPeriodicTimer(
      immediate: true,
      const Duration(seconds: 1),
      (timer) {
        final elapsed = timer.tick;
        if (elapsed >= cooldown) return cancelCooldown();

        final updatedTimeOut = cooldown - elapsed;
        if (_cooldownTimeOut == updatedTimeOut) return;

        _cooldownTimeOut = updatedTimeOut;
        if (hasListeners) notifyListeners();
      },
    );
  }

  /// Cancels the slow-mode countdown timer.
  void cancelCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = null;

    _cooldownTimeOut = 0;
    if (hasListeners) notifyListeners();
  }

  // ---------- focus node ----------

  final bool _ownedFocusNode;
  FocusNode? _focusNode;

  /// The [FocusNode] for the input field.
  ///
  /// Lazily created and owned internally if none was injected at construction.
  FocusNode get focusNode => _focusNode ??= FocusNode();

  // ---------- lifecycle ----------

  /// Clears the text and any active command.
  ///
  /// Does **not** reset the cooldown or the focus node.
  void clear() {
    _command = null;
    _textFieldController.clear();
  }

  /// Resets the controller to an empty state.
  ///
  /// Clears text, command, and cancels the cooldown timer.
  void reset() {
    _command = null;
    _textFieldController.clear();
    cancelCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    _textFieldController.removeListener(_textFieldListener);
    if (_ownedTextFieldController) _textFieldController.dispose();
    if (_ownedFocusNode) _focusNode?.dispose();
    super.dispose();
  }
}

Timer _setPeriodicTimer(
  Duration duration,
  void Function(Timer) callback, {
  bool immediate = false,
}) {
  final timer = Timer.periodic(duration, callback);
  if (immediate) callback.call(timer);
  return timer;
}

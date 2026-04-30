import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template pollQuestion}
/// A data class that represents a poll question.
/// {@endtemplate}
class PollQuestion {
  /// {@macro pollQuestion}
  PollQuestion({
    String? id,
    this.text = '',
    this.error,
  }) : id = id ?? const Uuid().v4();

  /// The unique id of the poll this question belongs to.
  final String id;

  /// The text of the poll question.
  final String text;

  /// Optional error message based on the validation of the poll question.
  ///
  /// If the poll question is valid, this will be `null`.
  final String? error;

  /// A copy of the current [PollQuestion] with the provided values.
  PollQuestion copyWith({
    String? id,
    String? text,
    Object? error = _nullConst,
  }) {
    return PollQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      error: error == _nullConst ? this.error : error as String?,
    );
  }
}

/// {@template pollQuestionTextField}
/// A widget that represents a text field for poll question input.
/// {@endtemplate}
class PollQuestionTextField extends StatefulWidget {
  /// {@macro pollQuestionTextField}
  const PollQuestionTextField({
    super.key,
    required this.initialQuestion,
    this.title,
    this.hintText,
    this.questionRange = const (min: 1, max: 80),
    this.onChanged,
  });

  /// An optional title to be displayed above the text field.
  final String? title;

  /// The hint text to be displayed in the text field.
  final String? hintText;

  /// The length constraints of the poll question.
  ///
  /// If `null`, there are no constraints on the length of the question.
  final Range<int>? questionRange;

  /// The poll question.
  final PollQuestion initialQuestion;

  /// Callback called when the poll question is changed.
  final ValueChanged<PollQuestion>? onChanged;

  @override
  State<PollQuestionTextField> createState() => _PollQuestionTextFieldState();
}

class _PollQuestionTextFieldState extends State<PollQuestionTextField> {
  late var _question = widget.initialQuestion;

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void didUpdateWidget(covariant PollQuestionTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update the question if the updated initial question is different from
    // the current question.
    final currQuestion = _question;
    final newQuestion = widget.initialQuestion;
    final questionEquality = EqualityBy<PollQuestion, (String, String)>(
      (it) => (it.id, it.text),
    );

    if (questionEquality.equals(currQuestion, newQuestion) case false) {
      _question = newQuestion;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String? _validateQuestion(String question) {
    if (widget.questionRange case final range?) {
      return context.translations.pollQuestionValidationError(question.length, range);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);
    final defaults = _PollQuestionTextFieldDefaults(context);

    final spacing = context.streamSpacing;

    final effectiveHeaderStyle = theme.headerTextStyle ?? defaults.headerTextStyle;
    final effectiveInputStyle = theme.questionInputStyle ?? defaults.questionInputStyle;

    return Column(
      spacing: spacing.xs,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title case final title?) Text(title, style: effectiveHeaderStyle),
        StreamTextInput(
          focusNode: _focusNode,
          initialValue: _question.text,
          hintText: widget.hintText,
          helperText: _question.error,
          helperState: _question.error != null ? .error : null,
          textCapitalization: TextCapitalization.sentences,
          style: effectiveInputStyle,
          onChanged: (text) {
            _question = _question.copyWith(
              text: text,
              error: _validateQuestion(text),
            );

            widget.onChanged?.call(_question);
          },
        ),
      ],
    );
  }
}

class _PollQuestionTextFieldDefaults extends StreamPollCreatorThemeData {
  _PollQuestionTextFieldDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;

  @override
  TextStyle get headerTextStyle => _textTheme.headingSm.copyWith(color: _colorScheme.textPrimary);
}

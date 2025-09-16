import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat/stream_chat.dart';

part 'stream_poll_controller.freezed.dart';

/// {@template minMax}
/// A generic type representing a minimum and maximum value.
/// {@endtemplate}
typedef Range<T> = ({T? min, T? max});

/// {@template pollConfig}
/// Configurations used while validating a poll.
/// {@endtemplate}
class PollConfig {
  /// {@macro pollConfig}
  const PollConfig({
    this.nameRange = const (min: 1, max: 80),
    this.optionsRange = const (min: 1, max: 10),
    this.allowDuplicateOptions = false,
    this.allowedVotesRange = const (min: 2, max: 10),
  });

  /// The minimum and maximum length of the poll question.
  /// if `null`, there is no limit to the length of the question.
  ///
  /// Defaults to `1` and `80`.
  final Range<int>? nameRange;

  /// The minimum and maximum length of the poll options.
  /// if `null`, there is no limit to the length of the options.
  ///
  /// Defaults to `2` and `10`.
  final Range<int>? optionsRange;

  /// Whether the poll allows duplicate options.
  ///
  /// Defaults to `false`.
  final bool allowDuplicateOptions;

  /// The minimum and maximum number of votes allowed.
  /// if `null`, there is no limit to the number of votes allowed.
  ///
  /// Defaults to `2` and `10`.
  final Range<int>? allowedVotesRange;
}

/// {@template streamPollController}
/// Controller used to manage the state of a poll.
/// {@endtemplate}
class StreamPollController extends ValueNotifier<Poll> {
  /// {@macro streamPollController}
  factory StreamPollController({
    Poll? poll,
    PollConfig? config,
  }) =>
      StreamPollController._(
        config ?? const PollConfig(),
        poll ?? Poll(name: '', options: const [PollOption(text: '')]),
      );

  StreamPollController._(this.config, super.poll) : _initialValue = poll;

  // Initial poll passed to the controller, or modified with a new id when the
  // controller is marked reset.
  Poll _initialValue;

  /// The configuration used to validate the poll.
  final PollConfig config;

  /// Returns a sanitized version of the poll.
  ///
  /// The sanitized poll is a copy of the current poll with the following
  /// modifications:
  /// - The id of the new options is set to `null`. This is because the id is
  ///   a reserved field and should not be set by the user.
  Poll get sanitizedPoll {
    final initialOptions = _initialValue.options.map((it) => it.id);
    return value.copyWith(
      options: [
        ...value.options.map((option) {
          // Skip if the option is already present in the initial poll.
          if (initialOptions.contains(option.id)) return option;

          // Remove the id from the new added options.
          return option.copyWith(id: null);
        })
      ],
    );
  }

  /// Resets the poll to the initial value.
  void reset({bool resetId = true}) {
    if (resetId) {
      final newId = const Uuid().v4();
      _initialValue = _initialValue.copyWith(id: newId);
    }
    value = _initialValue;
  }

  /// Returns `true` if the poll is valid.
  ///
  /// The poll is considered valid if it passes all the validations specified
  /// in the [config].
  ///
  /// See also:
  /// * [validateGranularly], which returns a [Set] of [PollValidationError] if
  ///   there are any errors.
  bool validate() => validateGranularly().isEmpty;

  /// Validates the poll with the validation specified in the [config], and
  /// returns a [Set] of [PollValidationError] only, if any.
  ///
  /// See also:
  /// * [validate], which also validates the poll and returns true if there are
  ///   no errors.
  Set<PollValidationError> validateGranularly() {
    final invalidErrors = <PollValidationError>{};

    // Validate the name length
    if (config.nameRange case final nameRange?) {
      final name = value.name;
      final (:min, :max) = nameRange;

      if (min != null && name.length < min ||
          max != null && name.length > max) {
        invalidErrors.add(
          PollValidationError.nameRange(name, range: nameRange),
        );
      }
    }

    // Validate if the poll options are unique.
    if (config.allowDuplicateOptions case false) {
      final options = value.options;
      final uniqueOptions = options.map((it) => it.text).toSet();
      if (uniqueOptions.length != options.length) {
        invalidErrors.add(
          PollValidationError.duplicateOptions(options),
        );
      }
    }

    // Validate the poll options count
    if (config.optionsRange case final optionsRange?) {
      final options = value.options;
      final nonEmptyOptions = [...options.where((it) => it.text.isNotEmpty)];
      final (:min, :max) = optionsRange;

      if (min != null && nonEmptyOptions.length < min ||
          max != null && nonEmptyOptions.length > max) {
        invalidErrors.add(
          PollValidationError.optionsRange(options, range: optionsRange),
        );
      }
    }

    // Validate the max number of votes allowed if enforceUniqueVote is false.
    if (value.enforceUniqueVote case false) {
      if (value.maxVotesAllowed case final maxVotesAllowed?) {
        if (config.allowedVotesRange case final allowedVotesRange?) {
          final (:min, :max) = allowedVotesRange;

          if (min != null && maxVotesAllowed < min ||
              max != null && maxVotesAllowed > max) {
            invalidErrors.add(
              PollValidationError.maxVotesAllowed(
                maxVotesAllowed,
                range: allowedVotesRange,
              ),
            );
          }
        }
      }
    }

    return invalidErrors;
  }

  /// Adds a new option with the provided [text] and [extraData].
  ///
  /// The new option will be added to the end of the list of options.
  void addOption(
    String text, {
    Map<String, Object?> extraData = const {},
  }) {
    final options = [...value.options];
    final newOption = PollOption(text: text, extraData: extraData);
    value = value.copyWith(options: [...options, newOption]);
  }

  /// Updates the option at the provided [index] with the provided [text] and
  /// [extraData].
  void updateOption(
    String text, {
    required int index,
    Map<String, Object?> extraData = const {},
  }) {
    final options = [...value.options];
    options[index] = options[index].copyWith(
      text: text,
      extraData: extraData,
    );

    value = value.copyWith(options: options);
  }

  /// Removes the option at the provided [index].
  PollOption removeOption(int index) {
    final options = [...value.options];
    final removed = options.removeAt(index);
    value = value.copyWith(options: options);

    return removed;
  }

  /// Sets the poll question.
  set question(String question) {
    value = value.copyWith(name: question);
  }

  /// Sets the poll options.
  set options(List<PollOption> options) {
    value = value.copyWith(options: options);
  }

  /// Sets the poll enforce unique vote.
  set enforceUniqueVote(bool enforceUniqueVote) {
    value = value.copyWith(enforceUniqueVote: enforceUniqueVote);
  }

  /// Sets the poll max votes allowed.
  ///
  /// If `null`, there is no limit to the number of votes allowed.
  set maxVotesAllowed(int? maxVotesAllowed) {
    value = value.copyWith(maxVotesAllowed: maxVotesAllowed);
  }

  set allowSuggestions(bool allowSuggestions) {
    value = value.copyWith(allowUserSuggestedOptions: allowSuggestions);
  }

  /// Sets the poll voting visibility.
  set votingVisibility(VotingVisibility visibility) {
    value = value.copyWith(votingVisibility: visibility);
  }

  /// Sets whether the poll allows comments.
  set allowComments(bool allowComments) {
    value = value.copyWith(allowAnswers: allowComments);
  }
}

/// {@template pollValidationError}
/// Union representing the possible validation errors while creating a poll.
///
/// The errors are used to provide feedback to the user about what went wrong
/// while creating a poll.
/// {@endtemplate}
@freezed
sealed class PollValidationError with _$PollValidationError {
  /// Occurs when the poll contains duplicate options.
  const factory PollValidationError.duplicateOptions(
    List<PollOption> options,
  ) = _PollValidationErrorDuplicateOptions;

  /// Occurs when the poll question length is not within the allowed range.
  const factory PollValidationError.nameRange(
    String name, {
    required Range<int> range,
  }) = _PollValidationErrorNameRange;

  /// Occurs when the poll options count is not within the allowed range.
  const factory PollValidationError.optionsRange(
    List<PollOption> options, {
    required Range<int> range,
  }) = _PollValidationErrorOptionsRange;

  /// Occurs when the poll max votes allowed is not within the allowed range.
  const factory PollValidationError.maxVotesAllowed(
    int maxVotesAllowed, {
    required Range<int> range,
  }) = _PollValidationErrorMaxVotesAllowed;
}

// coverage:ignore-start

/// @nodoc
extension PollValidationErrorPatternMatching on PollValidationError {
  /// @nodoc
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<PollOption> options) duplicateOptions,
    required TResult Function(String name, Range<int> range) nameRange,
    required TResult Function(List<PollOption> options, Range<int> range)
        optionsRange,
    required TResult Function(int maxVotesAllowed, Range<int> range)
        maxVotesAllowed,
  }) {
    final error = this;
    return switch (error) {
      _PollValidationErrorDuplicateOptions() => duplicateOptions(error.options),
      _PollValidationErrorNameRange() => nameRange(error.name, error.range),
      _PollValidationErrorOptionsRange() =>
        optionsRange(error.options, error.range),
      _PollValidationErrorMaxVotesAllowed() =>
        maxVotesAllowed(error.maxVotesAllowed, error.range),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<PollOption> options)? duplicateOptions,
    TResult? Function(String name, Range<int> range)? nameRange,
    TResult? Function(List<PollOption> options, Range<int> range)? optionsRange,
    TResult? Function(int maxVotesAllowed, Range<int> range)? maxVotesAllowed,
  }) {
    final error = this;
    return switch (error) {
      _PollValidationErrorDuplicateOptions() =>
        duplicateOptions?.call(error.options),
      _PollValidationErrorNameRange() =>
        nameRange?.call(error.name, error.range),
      _PollValidationErrorOptionsRange() =>
        optionsRange?.call(error.options, error.range),
      _PollValidationErrorMaxVotesAllowed() =>
        maxVotesAllowed?.call(error.maxVotesAllowed, error.range),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<PollOption> options)? duplicateOptions,
    TResult Function(String name, Range<int> range)? nameRange,
    TResult Function(List<PollOption> options, Range<int> range)? optionsRange,
    TResult Function(int maxVotesAllowed, Range<int> range)? maxVotesAllowed,
    required TResult orElse(),
  }) {
    final error = this;
    final result = switch (error) {
      _PollValidationErrorDuplicateOptions() =>
        duplicateOptions?.call(error.options),
      _PollValidationErrorNameRange() =>
        nameRange?.call(error.name, error.range),
      _PollValidationErrorOptionsRange() =>
        optionsRange?.call(error.options, error.range),
      _PollValidationErrorMaxVotesAllowed() =>
        maxVotesAllowed?.call(error.maxVotesAllowed, error.range),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PollValidationErrorDuplicateOptions value)
        duplicateOptions,
    required TResult Function(_PollValidationErrorNameRange value) nameRange,
    required TResult Function(_PollValidationErrorOptionsRange value)
        optionsRange,
    required TResult Function(_PollValidationErrorMaxVotesAllowed value)
        maxVotesAllowed,
  }) {
    final error = this;
    return switch (error) {
      _PollValidationErrorDuplicateOptions() => duplicateOptions(error),
      _PollValidationErrorNameRange() => nameRange(error),
      _PollValidationErrorOptionsRange() => optionsRange(error),
      _PollValidationErrorMaxVotesAllowed() => maxVotesAllowed(error),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult? Function(_PollValidationErrorNameRange value)? nameRange,
    TResult? Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult? Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
  }) {
    final error = this;
    return switch (error) {
      _PollValidationErrorDuplicateOptions() => duplicateOptions?.call(error),
      _PollValidationErrorNameRange() => nameRange?.call(error),
      _PollValidationErrorOptionsRange() => optionsRange?.call(error),
      _PollValidationErrorMaxVotesAllowed() => maxVotesAllowed?.call(error),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult Function(_PollValidationErrorNameRange value)? nameRange,
    TResult Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    final error = this;
    final result = switch (error) {
      _PollValidationErrorDuplicateOptions() => duplicateOptions?.call(error),
      _PollValidationErrorNameRange() => nameRange?.call(error),
      _PollValidationErrorOptionsRange() => optionsRange?.call(error),
      _PollValidationErrorMaxVotesAllowed() => maxVotesAllowed?.call(error),
    };

    return result ?? orElse();
  }
}

// coverage:ignore-end

import 'package:freezed_annotation/freezed_annotation.dart';

part 'action.freezed.dart';

/// An interactive control attached to a message, such as the Send, Shuffle and Cancel buttons of a giphy preview.
@freezed
class Action with _$Action {
  /// Creates a new [Action].
  const Action({
    required this.name,
    this.style = 'default',
    required this.text,
    required this.type,
    this.value,
  });

  /// The name the action is submitted under.
  @override
  final String name;

  /// The visual style of the action, such as `primary` or `default`.
  @override
  final String style;

  /// The label shown for the action.
  @override
  final String text;

  /// The kind of control, such as `button`.
  @override
  final String type;

  /// The value the action submits, or null if it submits none.
  @override
  final String? value;
}

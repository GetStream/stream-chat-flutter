import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_text_field.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template pollSwitchListTile}
/// A widget that represents a switch list tile for poll input.
///
/// The switch list tile contains a title and a switch.
///
/// Optionally, it can contain a list of children widgets that are displayed
/// below the switch when the switch is enabled.
///
/// see also:
/// - [PollSwitchTextField], a widget that represents a toggleable text field
///   for poll input.
/// {@endtemplate}
class PollSwitchListTile extends StatelessWidget {
  /// {@macro pollSwitchListTile}
  const PollSwitchListTile({
    super.key,
    this.value = false,
    required this.title,
    this.children = const [],
    this.onChanged,
  });

  /// The current value of the switch.
  final bool value;

  /// The title of the switch list tile.
  final String title;

  /// Optional list of children widgets to be displayed when the switch is
  /// enabled.
  ///
  /// If `null`, no children will be displayed.
  final List<Widget> children;

  /// Callback called when the switch value is changed.
  final ValueSetter<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);
    final fillColor = theme.switchListTileFillColor;
    final borderRadius = theme.switchListTileBorderRadius;

    final listTile = SwitchListTile(
      value: value,
      onChanged: onChanged,
      tileColor: fillColor,
      title: Text(title, style: theme.switchListTileTitleStyle),
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listTile,
          if (value) ...children,
        ],
      ),
    );
  }
}

/// {@template pollSwitchItem}
/// A data class that represents a poll boolean item.
/// {@endtemplate}
class PollSwitchItem<T> {
  /// {@macro pollSwitchItem}
  PollSwitchItem({
    String? id,
    this.value = false,
    this.inputValue,
    this.error,
  }) : id = id ?? const Uuid().v4();

  /// The unique id of the poll option item.
  final String id;

  /// The boolean value of the poll switch item.
  final bool value;

  /// Optional input value linked to the poll switch item.
  final T? inputValue;

  /// Optional error message based on the validation of the poll switch item
  /// and its input value.
  ///
  /// If the poll switch item is valid, this will be `null`.
  final String? error;

  /// A copy of the current [PollSwitchItem] with the provided values.
  PollSwitchItem<T> copyWith({
    String? id,
    bool? value,
    Object? error = _nullConst,
    Object? inputValue = _nullConst,
  }) {
    return PollSwitchItem<T>(
      id: id ?? this.id,
      value: value ?? this.value,
      error: error == _nullConst ? this.error : error as String?,
      inputValue: inputValue == _nullConst ? this.inputValue : inputValue as T?,
    );
  }
}

/// {@template pollSwitchTextField}
/// A widget that represents a toggleable text field for poll input.
///
/// Generally used as one of the children of [PollSwitchListTile].
/// {@endtemplate}
class PollSwitchTextField extends StatefulWidget {
  /// {@macro pollSwitchTextField}
  const PollSwitchTextField({
    super.key,
    required this.item,
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  /// The current value of the switch text field.
  final PollSwitchItem<int> item;

  /// The hint text to be displayed in the text field.
  final String? hintText;

  /// The keyboard type of the text field.
  final TextInputType? keyboardType;

  /// Callback called when the switch text field is changed.
  final ValueChanged<PollSwitchItem<int>>? onChanged;

  /// The validator function to validate the input value.
  final String? Function(PollSwitchItem<int>)? validator;

  @override
  State<PollSwitchTextField> createState() => _PollSwitchTextFieldState();
}

class _PollSwitchTextFieldState extends State<PollSwitchTextField> {
  late var _item = widget.item.copyWith(
    error: widget.validator?.call(widget.item),
  );

  @override
  void didUpdateWidget(covariant PollSwitchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the item if the updated item is different from the current item.
    final currItem = _item;
    final newItem = widget.item;
    final itemEquality = EqualityBy<PollSwitchItem<int>, (bool, int?)>(
      (it) => (it.value, it.inputValue),
    );

    if (itemEquality.equals(currItem, newItem) case false) {
      _item = newItem;
    }
  }

  void _onSwitchToggled(bool value) {
    setState(() {
      // Update the switch value.
      _item = _item.copyWith(value: value);
      // Validate the switch value.
      _item = _item.copyWith(error: widget.validator?.call(_item));

      // Notify the parent widget about the change
      widget.onChanged?.call(_item);
    });
  }

  void _onFieldChanged(String text) {
    setState(() {
      // Update the input value.
      _item = _item.copyWith(inputValue: int.tryParse(text));
      // Validate the input value.
      _item = _item.copyWith(error: widget.validator?.call(_item));

      // Notify the parent widget about the change
      widget.onChanged?.call(_item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);
    final fillColor = theme.switchListTileFillColor;
    final borderRadius = theme.switchListTileBorderRadius;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: StreamPollTextField(
              hintText: widget.hintText,
              enabled: _item.value,
              fillColor: fillColor,
              style: theme.switchListTileTitleStyle,
              keyboardType: widget.keyboardType,
              borderRadius: borderRadius,
              errorText: _item.value ? _item.error : null,
              errorStyle: theme.switchListTileErrorStyle,
              initialValue: _item.inputValue?.toString(),
              onChanged: _onFieldChanged,
            ),
          ),
          Switch(
            value: _item.value,
            onChanged: _onSwitchToggled,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

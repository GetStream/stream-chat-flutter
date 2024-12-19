import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/separated_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/poll/poll_text_field.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template pollOptionItem}
/// A data class that represents a poll option item
/// {@endtemplate}
class PollOptionItem {
  /// {@macro pollOptionItem}
  PollOptionItem({
    String? id,
    this.text = '',
    this.error,
  }) : id = id ?? const Uuid().v4();

  /// The unique id of the poll option item.
  final String id;

  /// The text of the poll option item.
  final String text;

  /// Optional error message based on the validation of the poll option item.
  ///
  /// If the poll option item is valid, this will be `null`.
  final String? error;

  /// A copy of the current [PollOptionItem] with the provided values.
  PollOptionItem copyWith({
    String? id,
    String? text,
    Object? error = _nullConst,
  }) {
    return PollOptionItem(
      id: id ?? this.id,
      text: text ?? this.text,
      error: error == _nullConst ? this.error : error as String?,
    );
  }
}

/// {@template pollOptionListItem}
/// A widget that represents a poll option list item.
/// {@endtemplate}
class PollOptionListItem extends StatelessWidget {
  /// {@macro pollOptionListItem}
  const PollOptionListItem({
    super.key,
    required this.option,
    this.hintText,
    this.onChanged,
  });

  /// The poll option item.
  final PollOptionItem option;

  /// Hint to be displayed in the poll option list item.
  final String? hintText;

  /// Callback called when the poll option item is changed.
  final ValueSetter<PollOptionItem>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);
    final fillColor = theme.optionsTextFieldFillColor;
    final borderRadius = theme.optionsTextFieldBorderRadius;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: PollTextField(
              initialValue: option.text,
              hintText: hintText,
              style: theme.optionsTextFieldStyle,
              fillColor: fillColor,
              borderRadius: borderRadius,
              errorText: option.error,
              errorStyle: theme.optionsTextFieldErrorStyle,
              onChanged: (text) => onChanged?.call(option.copyWith(text: text)),
            ),
          ),
          const SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.drag_handle_rounded),
          ),
        ],
      ),
    );
  }
}

/// {@template pollOptionReorderableListView}
/// A widget that represents a reorderable list view of poll options.
/// {@endtemplate}
class PollOptionReorderableListView extends StatefulWidget {
  /// {@macro pollOptionReorderableListView}
  const PollOptionReorderableListView({
    super.key,
    this.title,
    this.itemHintText,
    this.allowDuplicate = false,
    this.initialOptions = const [],
    this.onOptionsChanged,
  });

  /// An optional title to be displayed above the list of poll options.
  final String? title;

  /// The hint text to be displayed in the poll option list item.
  final String? itemHintText;

  /// Whether the poll options allow duplicates.
  ///
  /// If `true`, the poll options can be duplicated.
  final bool allowDuplicate;

  /// The initial list of poll options.
  final List<PollOptionItem> initialOptions;

  /// Callback called when the items are updated or reordered.
  final ValueSetter<List<PollOptionItem>>? onOptionsChanged;

  @override
  State<PollOptionReorderableListView> createState() =>
      _PollOptionReorderableListViewState();
}

class _PollOptionReorderableListViewState
    extends State<PollOptionReorderableListView> {
  late var _options = <String, PollOptionItem>{
    for (final option in widget.initialOptions) option.id: option,
  };

  @override
  void didUpdateWidget(covariant PollOptionReorderableListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the options if the updated options are different from the current
    // set of options.
    final currOptions = [..._options.values];
    final newOptions = widget.initialOptions;

    final optionItemEquality = ListEquality<PollOptionItem>(
      EqualityBy((it) => (it.id, it.text)),
    );

    if (optionItemEquality.equals(currOptions, newOptions) case false) {
      _options = <String, PollOptionItem>{
        for (final option in widget.initialOptions) option.id: option,
      };
    }
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final animValue = Curves.easeInOut.transform(animation.value);
        final elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          borderRadius: BorderRadius.circular(12),
          elevation: elevation,
          child: child,
        );
      },
      child: child,
    );
  }

  String? _validateOption(PollOptionItem option) {
    final translations = context.translations;

    // Check if the option is empty.
    if (option.text.isEmpty) return translations.pollOptionEmptyError;

    // Check for duplicate options if duplicates are not allowed.
    if (widget.allowDuplicate case false) {
      if (_options.values.any((it) {
        // Skip if it's the same option
        if (it.id == option.id) return false;

        return it.text == option.text;
      })) {
        return translations.pollOptionDuplicateError;
      }
    }

    return null;
  }

  void _onOptionChanged(PollOptionItem option) {
    setState(() {
      // Update the changed option.
      _options[option.id] = option.copyWith(
        error: _validateOption(option),
      );

      // Validate every other option to check for duplicates.
      _options.updateAll((key, value) {
        // Skip the changed option as it's already validated.
        if (key == option.id) return value;

        return value.copyWith(error: _validateOption(value));
      });

      // Notify the parent widget about the change
      widget.onOptionsChanged?.call([..._options.values]);
    });
  }

  void _onOptionReorder(int oldIndex, int newIndex) {
    setState(() {
      final options = [..._options.values];

      // Move the dragged option to the new index
      final option = options.removeAt(oldIndex);
      options.insert(newIndex, option);

      // Update the options map
      _options = <String, PollOptionItem>{
        for (final option in options) option.id: option,
      };

      // Notify the parent widget about the change
      widget.onOptionsChanged?.call([..._options.values]);
    });
  }

  void _onAddOptionPressed() {
    setState(() {
      // Create a new option and add it to the map.
      final option = PollOptionItem();
      _options[option.id] = option;

      // Notify the parent widget about the change
      widget.onOptionsChanged?.call([..._options.values]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);
    final borderRadius = theme.optionsTextFieldBorderRadius;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title case final title?) ...[
          Text(title, style: theme.optionsHeaderStyle),
          const SizedBox(height: 8),
        ],
        Flexible(
          child: SeparatedReorderableListView(
            shrinkWrap: true,
            itemCount: _options.length,
            physics: const NeverScrollableScrollPhysics(),
            proxyDecorator: _proxyDecorator,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            onReorder: _onOptionReorder,
            itemBuilder: (context, index) {
              final option = _options.values.elementAt(index);
              return PollOptionListItem(
                key: Key(option.id),
                option: option,
                hintText: widget.itemHintText,
                onChanged: _onOptionChanged,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: _onAddOptionPressed,
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              textStyle: theme.optionsTextFieldStyle,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
              backgroundColor: theme.optionsTextFieldFillColor,
            ),
            child: Text(context.translations.addAnOptionLabel),
          ),
        ),
      ],
    );
  }
}

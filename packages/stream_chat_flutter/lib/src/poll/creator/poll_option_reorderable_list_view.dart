import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/separated_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_delete_option_dialog.dart';
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

enum _PollOptionVariant { option, addOption }

/// {@template pollOptionListItem}
/// A widget that represents a poll option list item.
/// {@endtemplate}
class PollOptionListItem extends StatelessWidget {
  /// {@macro pollOptionListItem}
  const PollOptionListItem({
    super.key,
    required PollOptionItem this.option,
    this.hintText,
    this.focusNode,
    this.onRemove,
    this.onChanged,
  }) : onAddOptionPressed = null,
       _variant = .option;

  /// Creates an "add an option" button styled to match the option list.
  const PollOptionListItem.addOption({
    super.key,
    this.hintText,
    VoidCallback? onPressed,
  }) : option = null,
       focusNode = null,
       onRemove = null,
       onChanged = null,
       onAddOptionPressed = onPressed,
       _variant = .addOption;

  final _PollOptionVariant _variant;

  /// The poll option item.
  ///
  /// Required for the default constructor, `null` for [addOption].
  final PollOptionItem? option;

  /// Hint to be displayed in the poll option list item or as the button label.
  final String? hintText;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// Callback called when the poll option item is removed.
  final ValueSetter<PollOptionItem>? onRemove;

  /// Callback called when the poll option item is changed.
  final ValueSetter<PollOptionItem>? onChanged;

  /// Callback called when the "add an option" button is pressed.
  ///
  /// If `null`, the button is disabled.
  /// Only used by the [addOption] constructor.
  final VoidCallback? onAddOptionPressed;

  @override
  Widget build(BuildContext context) {
    return switch (_variant) {
      _PollOptionVariant.option => _buildOption(context),
      _PollOptionVariant.addOption => _buildAddOption(context),
    };
  }

  Widget _buildOption(BuildContext context) {
    assert(option != null, 'option must not be null');

    final icons = context.streamIcons;
    final a11y = context.translations.accessibility;

    return StreamTextInput(
      initialValue: option!.text,
      hintText: hintText,
      focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,
      helperText: option!.error,
      helperState: option!.error != null ? StreamHelperState.error : null,
      leading: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Icon(icons.reorder),
      ),
      trailing: StreamButton.icon(
        type: .ghost,
        style: .secondary,
        icon: Icon(icons.minusCircle),
        tooltip: a11y.removePollOptionTooltip(optionText: option!.text),
        themeStyle: .from(
          fixedSize: const .square(20),
          tapTargetSize: .shrinkWrap,
        ),
        onPressed: switch (onRemove) {
          final onRemove? => () => onRemove.call(option!),
          _ => null,
        },
      ),
      onChanged: switch (onChanged) {
        final onChanged? => (text) {
          final updated = option!.copyWith(text: text);
          return onChanged.call(updated);
        },
        _ => null,
      },
    );
  }

  Widget _buildAddOption(BuildContext context) {
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final inputStyle = StreamPollCreatorTheme.of(context).optionInputStyle;

    final effectiveTextStyle = inputStyle?.textStyle ?? textTheme.bodyDefault;
    final effectivePadding = inputStyle?.contentPadding ?? .symmetric(vertical: spacing.sm, horizontal: spacing.md);
    final effectiveBorderColor = inputStyle?.border?.color ?? colorScheme.borderDefault;
    final effectiveBorderRadius = inputStyle?.borderRadius ?? .all(radius.lg);

    return SizedBox(
      width: .infinity,
      child: StreamButton(
        type: .outline,
        style: .secondary,
        onPressed: onAddOptionPressed,
        themeStyle: .from(
          fixedSize: .infinite,
          textStyle: effectiveTextStyle,
          padding: effectivePadding,
          tapTargetSize: .shrinkWrap,
          borderColor: effectiveBorderColor,
          alignment: AlignmentDirectional.centerStart,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
        ),
        child: Text(hintText ?? context.translations.addAnOptionLabel),
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
    this.optionsRange,
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

  /// The range of allowed options (min and max).
  ///
  /// If `null`, there are no limits. If only min or max is specified,
  /// the other bound is unlimited.
  final Range<int>? optionsRange;

  /// Callback called when the items are updated or reordered.
  final ValueSetter<List<PollOptionItem>>? onOptionsChanged;

  @override
  State<PollOptionReorderableListView> createState() => _PollOptionReorderableListViewState();
}

class _PollOptionReorderableListViewState extends State<PollOptionReorderableListView> {
  late Map<String, FocusNode> _focusNodes;
  late Map<String, PollOptionItem> _options;

  @override
  void initState() {
    super.initState();
    _initializeOptions();
  }

  @override
  void dispose() {
    _disposeOptions();
    super.dispose();
  }

  void _initializeOptions() {
    _focusNodes = <String, FocusNode>{};
    _options = <String, PollOptionItem>{};

    for (final option in widget.initialOptions) {
      _options[option.id] = option;
      _focusNodes[option.id] = FocusNode();
    }

    // Ensure we have at least the minimum number of options
    _ensureMinimumOptions(notifyParent: true);
  }

  void _ensureMinimumOptions({bool notifyParent = false}) {
    // Ensure we have at least the minimum number of options
    final minOptions = widget.optionsRange?.min ?? 1;

    var optionsAdded = false;
    while (_options.length < minOptions) {
      final option = PollOptionItem();
      _options[option.id] = option;
      _focusNodes[option.id] = FocusNode();
      optionsAdded = true;
    }

    // Notify parent if we added options and it's requested
    if (optionsAdded && notifyParent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onOptionsChanged?.call([..._options.values]);
      });
    }
  }

  void _disposeOptions() {
    _focusNodes.values.forEach((it) => it.dispose());
    _focusNodes.clear();
    _options.clear();
  }

  @override
  void didUpdateWidget(covariant PollOptionReorderableListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the options if the updated options are different from the current
    // set of options.
    final currOptions = [..._options.values];
    final newOptions = widget.initialOptions;

    final optionItemEquality = ListEquality<PollOptionItem>(
      EqualityBy((it) => it.id),
    );

    if (optionItemEquality.equals(currOptions, newOptions) case false) {
      _disposeOptions();
      _initializeOptions();
    }
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final radius = context.streamRadius;
        final colorScheme = context.streamColorScheme;
        return Material(
          color: colorScheme.backgroundElevation3,
          borderRadius: BorderRadius.all(radius.lg),
          elevation: 3,
          child: child,
        );
      },
      child: child,
    );
  }

  // Revalidates all options for empty-text and duplicate errors.
  //
  // Empty options always receive an error. Duplicate checking is skipped
  // when [PollOptionReorderableListView.allowDuplicate] is true.
  //
  // Uses a two-pass approach when [changedOptionId] is provided:
  //
  // 1. **Unchanged options first** — scanned in order to build the "seen"
  //    set. Among these, the first occurrence of a text is clean and every
  //    subsequent duplicate gets an error.
  // 2. **Changed option last** — checked against the "seen" set built in
  //    pass 1. This ensures the just-edited option always yields to
  //    pre-existing ones, so the error appears on the option the user is
  //    actively typing in rather than jumping to an older field.
  //
  // Without [changedOptionId] (e.g. after reorder or remove), all options
  // are validated in a single pass where the first occurrence wins.
  void _revalidateOptions({String? changedOptionId}) {
    final translations = context.translations;
    final checkDuplicates = !widget.allowDuplicate;
    final seen = <String>{};

    String? _errorFor(String normalized) {
      if (normalized.isEmpty) return translations.pollOptionEmptyError;
      if (checkDuplicates) {
        if (seen.add(normalized)) return null;
        return translations.pollOptionDuplicateError;
      }

      return null;
    }

    // Pass 1 — validate every option except the one being edited.
    _options.updateAll((key, option) {
      if (key == changedOptionId) return option;

      final normalized = option.text.trim().toLowerCase();
      return option.copyWith(error: _errorFor(normalized));
    });

    // Pass 2 — validate the edited option against the pre-existing texts.
    if (changedOptionId case final id? when _options.containsKey(id)) {
      final option = _options[id]!;
      final normalized = option.text.trim().toLowerCase();
      _options[id] = option.copyWith(error: _errorFor(normalized));
    }
  }

  Future<void> _onOptionRemoved(PollOptionItem option) async {
    final confirm = await showPollDeleteOptionDialog(context: context);
    if (!mounted || confirm != true) return;

    setState(() {
      _options.remove(option.id);
      _focusNodes.remove(option.id)?.dispose();
      _revalidateOptions();
    });

    // Ensure we have at least the minimum number of options
    _ensureMinimumOptions();

    // Notify the parent widget about the change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onOptionsChanged?.call([..._options.values]);
    });
  }

  void _onOptionChanged(PollOptionItem option) {
    setState(() {
      // Update the changed option and revalidate all for duplicates.
      _options[option.id] = option;
      _revalidateOptions(changedOptionId: option.id);
    });

    // Notify the parent widget about the change
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

      _revalidateOptions();
    });

    // Notify the parent widget about the change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onOptionsChanged?.call([..._options.values]);
    });
  }

  void _onAddOptionPressed() {
    // Check if we've reached the maximum number of options allowed
    if (widget.optionsRange?.max case final maxOptions?) {
      // Don't add more options if we've reached the limit
      if (_options.length >= maxOptions) return;
    }

    // Create a new option item
    final option = PollOptionItem();

    setState(() {
      _options[option.id] = option;
      _focusNodes[option.id] = FocusNode();
    });

    // Notify the parent widget about the change and request focus on the
    // newly added option text field.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onOptionsChanged?.call([..._options.values]);
      _focusNodes[option.id]?.requestFocus();
    });
  }

  bool get _canAddMoreOptions {
    // Don't allow adding if there's already an empty option
    final hasEmptyOption = _options.values.any((it) => it.text.isEmpty);
    if (hasEmptyOption) return false;

    // Check max options limit
    if (widget.optionsRange?.max case final maxOptions?) {
      return _options.length < maxOptions;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);
    final defaults = _PollOptionListViewDefaults(context);

    final spacing = context.streamSpacing;

    final effectiveTitleStyle = theme.headerTextStyle ?? defaults.headerTextStyle;
    final effectiveInputStyle = theme.optionInputStyle ?? defaults.optionInputStyle;

    return Column(
      spacing: spacing.xs,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title case final title?)
          Semantics(
            header: true,
            child: Text(title, style: effectiveTitleStyle),
          ),
        Flexible(
          child: StreamTextInputTheme(
            data: .new(style: effectiveInputStyle),
            child: SeparatedReorderableListView(
              shrinkWrap: true,
              itemCount: _options.length,
              physics: const NeverScrollableScrollPhysics(),
              proxyDecorator: _proxyDecorator,
              separatorBuilder: (_, __) => SizedBox(height: spacing.xs),
              onReorderStart: (_) => FocusScope.of(context).unfocus(),
              onReorder: _onOptionReorder,
              itemBuilder: (context, index) {
                final option = _options.values.elementAt(index);
                return PollOptionListItem(
                  key: Key(option.id),
                  option: option,
                  hintText: widget.itemHintText,
                  focusNode: _focusNodes[option.id],
                  onRemove: _onOptionRemoved,
                  onChanged: _onOptionChanged,
                );
              },
            ),
          ),
        ),
        if (_canAddMoreOptions)
          PollOptionListItem.addOption(
            hintText: widget.itemHintText,
            onPressed: _onAddOptionPressed,
          ),
      ],
    );
  }
}

class _PollOptionListViewDefaults extends StreamPollCreatorThemeData {
  _PollOptionListViewDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;

  @override
  TextStyle get headerTextStyle => _textTheme.headingSm.copyWith(color: _colorScheme.textPrimary);
}

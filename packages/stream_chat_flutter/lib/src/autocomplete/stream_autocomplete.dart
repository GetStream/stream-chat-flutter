// ignore_for_file: no-empty-block

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

export 'stream_command_autocomplete_options.dart';
export 'stream_mention_autocomplete_options.dart';

/// {@macro stream_chat_flutter.StreamMessageInputController}
typedef StreamMessageEditingController = StreamMessageInputController;

/// Positions the [AutocompleteTrigger] options around the [TextField] or
/// [TextFormField] that triggered the autocomplete.
enum OptionsAlignment {
  /// The options are displayed below the field.
  below,

  /// The options are displayed above the field.
  ///
  /// This is the default.
  above;

  Anchor _toAnchor() {
    switch (this) {
      case OptionsAlignment.below:
        return const Aligned(
          widthFactor: 1,
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
        );
      case OptionsAlignment.above:
        return const Aligned(
          widthFactor: 1,
          follower: Alignment.bottomCenter,
          target: Alignment.topCenter,
        );
    }
  }
}

/// The type of the Autocomplete callback which returns the widget that
/// contains the input [TextField] or [TextFormField].
///
/// See also:
///
///   * [StreamAutocomplete.fieldViewBuilder], which is of this type.
typedef StreamAutocompleteFieldViewBuilder = Widget Function(
  BuildContext context,
  StreamMessageEditingController messageEditingController,
  FocusNode focusNode,
);

/// The type of the [StreamAutocompleteTrigger] callback which returns a
/// [Widget] that displays the specified [options].
///
/// See also:
///
///   * [StreamAutocompleteTrigger.optionsViewBuilder], which is of this type.
typedef StreamAutocompleteOptionsViewBuilder = Widget Function(
  BuildContext context,
  StreamAutocompleteQuery autocompleteQuery,
  StreamMessageEditingController messageEditingController,
);

/// The query to determine the autocomplete options.
class StreamAutocompleteQuery {
  /// Creates a [StreamAutocompleteQuery] with the specified [query] and
  /// [selection].
  const StreamAutocompleteQuery({
    required this.query,
    required this.selection,
  });

  /// The query string.
  final String query;

  /// The selection in the text field.
  final TextSelection selection;
}

class _StreamAutocompleteInvokedTriggerWithQuery {
  const _StreamAutocompleteInvokedTriggerWithQuery(this.trigger, this.query);

  final StreamAutocompleteTrigger trigger;
  final StreamAutocompleteQuery query;
}

/// The class responsible for triggering autocomplete suggestions and
/// displaying the options.
class StreamAutocompleteTrigger {
  /// Creates a [StreamAutocompleteTrigger] which can be used to trigger
  /// autocomplete suggestions.
  const StreamAutocompleteTrigger({
    required this.trigger,
    required this.optionsViewBuilder,
    this.triggerOnlyAfterSpace = false,
    this.triggerOnlyAtStart = false,
    this.minimumRequiredCharacters = 0,
  });

  /// The trigger character.
  ///
  /// eg. '@', '#', ':'
  final String trigger;

  /// Whether the [trigger] should only be recognised at the start of the input.
  final bool triggerOnlyAtStart;

  /// Whether the [trigger] should only be recognised after a space.
  final bool triggerOnlyAfterSpace;

  /// The minimum required characters for the [trigger] to start recognising
  /// a autocomplete options.
  final int minimumRequiredCharacters;

  /// Builds the widget responsible for querying and displaying the
  /// autocomplete options.
  ///
  /// See also:
  ///  * [StreamAutocompleteOptions], which helps in displaying the options.
  final StreamAutocompleteOptionsViewBuilder optionsViewBuilder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamAutocompleteTrigger &&
          runtimeType == other.runtimeType &&
          trigger == other.trigger &&
          triggerOnlyAtStart == other.triggerOnlyAtStart &&
          triggerOnlyAfterSpace == other.triggerOnlyAfterSpace &&
          minimumRequiredCharacters == other.minimumRequiredCharacters;

  @override
  int get hashCode =>
      trigger.hashCode ^
      triggerOnlyAtStart.hashCode ^
      triggerOnlyAfterSpace.hashCode ^
      minimumRequiredCharacters.hashCode;

  /// Checks if the user is invoking the recognising [trigger] and returns
  /// the autocomplete query if so.
  StreamAutocompleteQuery? invokingTrigger(
    Message message,
    TextEditingValue textEditingValue,
  ) {
    final text = textEditingValue.text;
    final cursorPosition = textEditingValue.selection.baseOffset;

    // Find the first [trigger] location before the input cursor.
    final firstTriggerIndexBeforeCursor =
        text.substring(0, cursorPosition).lastIndexOf(trigger);

    // If the [trigger] is not found before the cursor, then it's not a trigger.
    if (firstTriggerIndexBeforeCursor == -1) return null;

    // If the [trigger] is found before the cursor, but the [trigger] is only
    // recognised at the start of the input, then it's not a trigger.
    if (triggerOnlyAtStart && firstTriggerIndexBeforeCursor != 0) {
      return null;
    }

    // Only show typing suggestions after a space, or at the start of the input
    // valid examples: "@user", "Hello @user"
    // invalid examples: "Hello@user"
    final textBeforeTrigger = text.substring(0, firstTriggerIndexBeforeCursor);
    if (triggerOnlyAfterSpace &&
        textBeforeTrigger.isNotEmpty &&
        !textBeforeTrigger.endsWith(' ')) {
      return null;
    }

    // The suggestion range. Protect against invalid ranges.
    final suggestionStart = firstTriggerIndexBeforeCursor + trigger.length;
    final suggestionEnd = cursorPosition;
    if (suggestionStart > suggestionEnd) return null;

    // Fetch the suggestion text. The suggestions can't have spaces.
    // valid example: "@luke_skywa..."
    // invalid example: "@luke skywa..."
    final suggestionText = text.substring(suggestionStart, suggestionEnd);
    if (suggestionText.contains(' ')) return null;

    // A minimum number of characters can be provided to only show
    // suggestions after the customer has input enough characters.
    if (suggestionText.length < minimumRequiredCharacters) return null;

    return StreamAutocompleteQuery(
      query: suggestionText,
      selection: TextSelection(
        baseOffset: suggestionStart,
        extentOffset: suggestionEnd,
      ),
    );
  }
}

/// A widget that provides a text field with autocomplete functionality.
class StreamAutocomplete extends StatefulWidget {
  /// Create an instance of StreamAutocomplete.
  ///
  /// [displayStringForOption], [optionsBuilder] and [optionsViewBuilder] must
  /// not be null.
  const StreamAutocomplete({
    super.key,
    this.focusNode,
    this.messageEditingController,
    required this.autocompleteTriggers,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.optionsAlignment = OptionsAlignment.above,
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : assert((focusNode == null) == (messageEditingController == null), '');

  /// The triggers that trigger autocomplete.
  final Iterable<StreamAutocompleteTrigger> autocompleteTriggers;

  /// Builds the field whose input is used to get the options.
  ///
  /// Pass the provided [StreamMessageEditingController] to the field built
  /// here so that StreamAutocomplete can listen for changes.
  final StreamAutocompleteFieldViewBuilder fieldViewBuilder;

  /// The [FocusNode] that is used for the text field.
  ///
  /// The main purpose of this parameter is to allow the use of a separate text
  /// field located in another part of the widget tree instead of the text
  /// field built by [fieldViewBuilder]. For example, it may be desirable to
  /// place the text field in the AppBar and the options below in the main body.
  ///
  /// When following this pattern, [fieldViewBuilder] can return
  /// `SizedBox.shrink()` so that nothing is drawn where the text field would
  /// normally be. A separate text field can be created elsewhere, and a
  /// FocusNode and StreamMessageEditingController can be passed both to that
  /// text field and to StreamAutocomplete.
  ///
  /// If this parameter is not null, then [messageEditingController] must also
  /// be not null.
  final FocusNode? focusNode;

  /// The [StreamMessageEditingController] that is used for the text field.
  ///
  /// If this parameter is not null, then [focusNode] must also be not null.
  final StreamMessageEditingController? messageEditingController;

  /// The alignment of the options.
  ///
  /// The default value is [OptionsAlignment.above].
  final OptionsAlignment optionsAlignment;

  /// The duration of the debounce period for the
  /// [StreamMessageEditingController].
  ///
  /// The default value is [300ms].
  final Duration debounceDuration;

  static Widget _defaultFieldViewBuilder(
    BuildContext context,
    StreamMessageEditingController messageEditingController,
    FocusNode focusNode,
  ) {
    return _StreamAutocompleteField(
      focusNode: focusNode,
      messageEditingController: messageEditingController,
    );
  }

  /// Returns the nearest [StreamAutocomplete] ancestor of the given context.
  static _StreamAutocompleteState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_StreamAutocompleteState>();
    assert(state != null, 'StreamAutocomplete not found in the widget tree');
    return state!;
  }

  @override
  _StreamAutocompleteState createState() => _StreamAutocompleteState();
}

class _StreamAutocompleteState extends State<StreamAutocomplete> {
  late StreamMessageEditingController _messageEditingController;
  late FocusNode _focusNode;

  StreamAutocompleteQuery? _currentQuery;
  StreamAutocompleteTrigger? _currentTrigger;

  bool _hideOptions = false;
  String _lastFieldText = '';

  // True if the state indicates that the options should be visible.
  bool get _shouldShowOptions {
    return !_hideOptions &&
        _focusNode.hasFocus &&
        _currentQuery != null &&
        _currentTrigger != null;
  }

  /// Accepts and replaces the current query with the given [option] and closes
  /// the suggested options.
  ///
  /// Optionally, pass [keepTrigger] false to remove the trigger from the text.
  void acceptAutocompleteOption(
    String option, {
    bool keepTrigger = true,
  }) {
    if (option.isEmpty) return;

    final query = _currentQuery;
    final trigger = _currentTrigger;
    if (query == null || trigger == null) return;

    final querySelection = query.selection;
    final text = _messageEditingController.text;

    var start = querySelection.baseOffset;
    if (!keepTrigger) start -= 1;

    final end = querySelection.extentOffset;

    final alreadyContainsSpace = text.substring(end).startsWith(' ');
    // Having extra space helps dismissing the auto-completion view.
    // ignore: parameter_assignments
    if (!alreadyContainsSpace) option += ' ';

    var selectionOffset = start + option.length;
    // In case the extra space is already there, we need to move the cursor
    // after the space.
    if (alreadyContainsSpace) selectionOffset += 1;

    final newText = text.replaceRange(start, end, option);
    final newSelection = TextSelection.collapsed(offset: selectionOffset);

    _messageEditingController.textEditingValue = TextEditingValue(
      text: newText,
      selection: newSelection,
    );

    return closeSuggestions();
  }

  /// Closes the suggestions and resets the current query.
  void closeSuggestions() {
    final prev = _currentQuery;
    if (prev == null) return;

    _currentQuery = null;
    if (mounted) setState(() {});
  }

  /// Starts showing the suggestions for the given [query].
  void showSuggestions(
    StreamAutocompleteQuery query,
    StreamAutocompleteTrigger trigger,
  ) {
    final prevQuery = _currentQuery;
    final prevTrigger = _currentTrigger;
    if (prevQuery == query && prevTrigger == trigger) return;

    _currentQuery = query;
    _currentTrigger = trigger;
    if (mounted) setState(() {});
  }

  // Checks if there is any invoked autocomplete trigger and returns the first
  // one along with the query that matches the current input.
  _StreamAutocompleteInvokedTriggerWithQuery? _getInvokedTriggerWithQuery(
    Message messageValue,
    TextEditingValue textEditingValue,
  ) {
    final autocompleteTriggers = widget.autocompleteTriggers.toSet();
    for (final trigger in autocompleteTriggers) {
      final query = trigger.invokingTrigger(messageValue, textEditingValue);
      if (query != null) {
        return _StreamAutocompleteInvokedTriggerWithQuery(trigger, query);
      }
    }
    return null;
  }

  // Called when _textEditingController changes.
  late final _onChangedField = debounce(
    () {
      final messageValue = _messageEditingController.message;
      final textEditingValue = _messageEditingController.textEditingValue;

      // If the content has not changed, then there is nothing to do.
      if (textEditingValue.text == _lastFieldText) return;

      // Make sure the options are no longer hidden if the content of the
      // field changes.
      _hideOptions = false;
      _lastFieldText = textEditingValue.text;

      // If the text field is empty, then there is no need to do anything.
      if (textEditingValue.text.isEmpty) return closeSuggestions();

      // If the text field is not empty, then we need to check if the
      // text field contains a trigger.
      final _triggerWithQuery = _getInvokedTriggerWithQuery(
        messageValue,
        textEditingValue,
      );

      // If the text field does not contain a trigger, then there is no need
      // to do anything.
      if (_triggerWithQuery == null) return closeSuggestions();

      // If the text field contains a trigger, then we need to open the
      // portal.
      final trigger = _triggerWithQuery.trigger;
      final query = _triggerWithQuery.query;
      return showSuggestions(query, trigger);
    },
    widget.debounceDuration,
  );

  // Called when the field's FocusNode changes.
  void _onChangedFocus() {
    // Options should no longer be hidden when the field is re-focused.
    _hideOptions = !_focusNode.hasFocus;
    if (mounted) setState(() {});
  }

  // Handle a potential change in textEditingController by properly disposing of
  // the old one and setting up the new one, if needed.
  void _updateTextEditingController(
    StreamMessageEditingController? old,
    StreamMessageEditingController? current,
  ) {
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _messageEditingController
        ..removeListener(_onChangedField)
        ..dispose();
      _messageEditingController = current!;
    } else if (current == null) {
      _messageEditingController.removeListener(_onChangedField);
      _messageEditingController = StreamMessageEditingController();
    } else {
      _messageEditingController.removeListener(_onChangedField);
      _messageEditingController = current;
    }
    _messageEditingController.addListener(_onChangedField);
  }

  // Handle a potential change in focusNode by properly disposing of the old one
  // and setting up the new one, if needed.
  void _updateFocusNode(FocusNode? old, FocusNode? current) {
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _focusNode
        ..removeListener(_onChangedFocus)
        ..dispose();
      _focusNode = current!;
    } else if (current == null) {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode = FocusNode();
    } else {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode = current;
    }
    _focusNode.addListener(_onChangedFocus);
  }

  @override
  void initState() {
    super.initState();
    _messageEditingController =
        widget.messageEditingController ?? StreamMessageEditingController();
    _messageEditingController.addListener(_onChangedField);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onChangedFocus);
  }

  @override
  void didUpdateWidget(StreamAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTextEditingController(
      oldWidget.messageEditingController,
      widget.messageEditingController,
    );
    _updateFocusNode(oldWidget.focusNode, widget.focusNode);
  }

  @override
  void dispose() {
    _messageEditingController.removeListener(_onChangedField);
    if (widget.messageEditingController == null) {
      _messageEditingController.dispose();
    }
    _focusNode.removeListener(_onChangedFocus);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _onChangedField.cancel();
    closeSuggestions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adding additional builder so that [.of] works.
    return Builder(
      builder: (context) {
        final anchor = widget.optionsAlignment._toAnchor();
        final shouldShowOptions = _shouldShowOptions;
        final optionViewBuilder = shouldShowOptions
            ? _currentTrigger!.optionsViewBuilder(
                context,
                _currentQuery!,
                _messageEditingController,
              )
            : null;

        return PortalTarget(
          anchor: anchor,
          visible: shouldShowOptions,
          portalFollower: optionViewBuilder,
          child: widget.fieldViewBuilder(
            context,
            _messageEditingController,
            _focusNode,
          ),
        );
      },
    );
  }
}

// The default Material-style Autocomplete text field.
class _StreamAutocompleteField extends StatelessWidget {
  const _StreamAutocompleteField({
    required this.focusNode,
    required this.messageEditingController,
  });

  final FocusNode focusNode;

  final StreamMessageEditingController messageEditingController;

  @override
  Widget build(BuildContext context) {
    return StreamMessageTextField(
      controller: messageEditingController,
      focusNode: focusNode,
    );
  }
}

const _kDefaultStreamAutocompleteOptionsShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

/// A helper widget used to show the options of a [StreamAutocomplete].
class StreamAutocompleteOptions<T extends Object> extends StatelessWidget {
  /// Creates a [StreamAutocompleteOptions] widget.
  const StreamAutocompleteOptions({
    super.key,
    this.color,
    this.elevation = 2,
    this.margin = const EdgeInsets.all(8),
    this.clipBehavior = Clip.hardEdge,
    required this.options,
    this.maxHeight,
    required this.optionBuilder,
    this.headerBuilder,
    this.shape = _kDefaultStreamAutocompleteOptionsShape,
  });

  /// The background color of the options card.
  ///
  /// Defaults to [StreamColorTheme.barsBg].
  final Color? color;

  /// The elevation of the options card.
  ///
  /// The default value is 2.
  final double elevation;

  /// The margin of the options card.
  ///
  /// The default value is [EdgeInsets.all(8)].
  final EdgeInsetsGeometry margin;

  /// The clip behavior of the options card.
  ///
  /// The default value is [Clip.hardEdge].
  final Clip clipBehavior;

  /// The shape of the options card.
  final ShapeBorder shape;

  /// The options to display.
  final Iterable<T> options;

  /// The maximum height of the options card.
  ///
  /// Defaults to half the height of the screen.
  final double? maxHeight;

  /// The builder for the options.
  final Widget Function(BuildContext context, T option) optionBuilder;

  /// The builder for the header of the options.
  final WidgetBuilder? headerBuilder;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return Card(
      margin: margin,
      elevation: elevation,
      color: color ?? colorTheme.barsBg,
      shape: shape,
      clipBehavior: clipBehavior,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (headerBuilder != null) ...[
            headerBuilder!(context),
            const Divider(height: 0),
          ],
          LimitedBox(
            maxHeight: maxHeight ?? height * 0.5,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return optionBuilder(context, option);
              },
            ),
          ),
        ],
      ),
    );
  }
}

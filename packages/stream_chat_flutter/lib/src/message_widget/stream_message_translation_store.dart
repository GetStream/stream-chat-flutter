import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

/// The translation display state of the messages within a single message
/// list.
///
/// Showing the translation is the default, so this holds only the
/// exceptions — see [messagesShowingOriginalText].
///
/// Instances are created only by a [StreamMessageTranslationStore] — read
/// one from its value, and change it through the store.
@immutable
class StreamMessageTranslationState {
  const StreamMessageTranslationState._({
    this.messagesShowingOriginalText = const {},
  });

  /// The ids of the messages the user has switched back to their original
  /// text.
  ///
  /// Empty while every message shows its translation.
  final Set<String> messagesShowingOriginalText;

  /// Whether [messageId] is currently showing its original text instead of
  /// its translation.
  bool isShowingOriginalText(String messageId) {
    return messagesShowingOriginalText.contains(messageId);
  }

  StreamMessageTranslationState _copyWith({
    Set<String>? messagesShowingOriginalText,
  }) {
    return StreamMessageTranslationState._(
      messagesShowingOriginalText: messagesShowingOriginalText ?? this.messagesShowingOriginalText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StreamMessageTranslationState &&
        const SetEquality<String>().equals(
          other.messagesShowingOriginalText,
          messagesShowingOriginalText,
        );
  }

  @override
  int get hashCode => const SetEquality<String>().hash(messagesShowingOriginalText);
}

/// Tracks which messages the user has switched back to their original text.
///
/// Mirrors `MessageOriginalTranslationsStore` in the Swift and Android SDKs,
/// which likewise key this state by message id above the individual list.
///
/// [StreamChat] owns one store for the whole app and provides it through a
/// [StreamMessageTranslations] scope, so every message list shares it. That
/// matters because the same message can render in more than one list at
/// once — a thread's parent message also appears in the channel list — and
/// both should agree on which text it shows. Holding the state here rather
/// than on the message widget is also what makes a toggle survive message
/// items being disposed and recreated as they scroll out of and back into a
/// list's render window.
///
/// Nest another [StreamMessageTranslations] to give a subtree its own
/// isolated toggle state.
class StreamMessageTranslationStore extends ValueNotifier<StreamMessageTranslationState> {
  /// Creates a store in which every message shows its translation.
  StreamMessageTranslationStore() : super(const StreamMessageTranslationState._());

  /// Whether [messageId] is currently showing its original text instead of
  /// its translation.
  bool isShowingOriginalText(String messageId) => value.isShowingOriginalText(messageId);

  /// Switches [messageId] between showing its original text and its
  /// translation.
  void toggleOriginalText(String messageId) {
    final showingOriginalText = value.messagesShowingOriginalText;

    value = value._copyWith(
      messagesShowingOriginalText: Set<String>.unmodifiable(
        switch (showingOriginalText.contains(messageId)) {
          true => {...showingOriginalText}..remove(messageId),
          false => {...showingOriginalText, messageId},
        },
      ),
    );
  }

  /// Switches every message back to showing its translation.
  ///
  /// Useful when the state should not outlive a session — for example after
  /// the connected user changes.
  void clear() {
    if (value.messagesShowingOriginalText.isEmpty) return;
    value = value._copyWith(messagesShowingOriginalText: const {});
  }
}

/// Provides a [StreamMessageTranslationStore] to the widget tree.
///
/// Reads through [isShowingOriginalTextOf] depend on a single message, so a
/// toggle rebuilds only the message that changed rather than every message
/// sharing the store.
///
/// See also:
///
///  * [StreamMessageTranslationStore], the store this scope provides.
class StreamMessageTranslations extends StatefulWidget {
  /// Creates a message translation scope.
  const StreamMessageTranslations({
    super.key,
    required this.store,
    required this.child,
  });

  /// The store holding the translation state of this scope's messages.
  final StreamMessageTranslationStore store;

  /// The widget below this scope in the tree.
  final Widget child;

  /// Whether [messageId] is currently showing its original text instead of
  /// its translation, in the nearest ancestor scope.
  ///
  /// The given [context] is rebuilt when *this* message is toggled, and not
  /// when another message in the same scope is.
  ///
  /// This will throw a [FlutterError] if no [StreamMessageTranslations] is
  /// found in the widget tree above the given context.
  static bool isShowingOriginalTextOf(BuildContext context, String messageId) {
    final store = of(context, messageId: messageId);
    return store.isShowingOriginalText(messageId);
  }

  /// Switches [messageId] between showing its original text and its
  /// translation, in the nearest ancestor scope.
  ///
  /// A convenience for `StreamMessageTranslations.of(context)
  /// .toggleOriginalText(messageId)` that does not make [context] depend on
  /// the scope, so it is safe to call from a callback.
  ///
  /// This will throw a [FlutterError] if no [StreamMessageTranslations] is
  /// found in the widget tree above the given context.
  static void toggleOriginalText(BuildContext context, String messageId) {
    // Deliberately not `of`: a tap handler wants the store, not a dependency
    // on the scope it came from.
    final scope = context.getInheritedWidgetOfExactType<_StreamMessageTranslationsScope>();
    final store = scope?.store ?? _missingScope(context);
    return store.toggleOriginalText(messageId);
  }

  /// Returns the [StreamMessageTranslationStore] from the nearest ancestor
  /// [StreamMessageTranslations] that encloses the given [context].
  ///
  /// Pass a [messageId] to depend on that message alone — the given [context]
  /// is then rebuilt only when that message is toggled. Left null, [context]
  /// is rebuilt whenever *any* message in the scope is.
  ///
  /// This will throw a [FlutterError] if no [StreamMessageTranslations] is
  /// found in the widget tree above the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// final store = StreamMessageTranslations.of(context);
  /// ```
  ///
  /// If you want to return null instead of throwing, use [maybeOf].
  static StreamMessageTranslationStore of(BuildContext context, {String? messageId}) {
    return maybeOf(context, messageId: messageId) ?? _missingScope(context);
  }

  /// Returns the [StreamMessageTranslationStore] from the nearest ancestor
  /// [StreamMessageTranslations] that encloses the given context.
  ///
  /// Returns null if no such ancestor exists.
  ///
  /// See also:
  ///  * [of], which throws if no [StreamMessageTranslations] is found, and
  ///    documents how [messageId] narrows the dependency.
  static StreamMessageTranslationStore? maybeOf(BuildContext context, {String? messageId}) {
    // A null aspect falls through to `dependOnInheritedWidgetOfExactType`,
    // which depends on the scope as a whole.
    final scope = InheritedModel.inheritFrom<_StreamMessageTranslationsScope>(context, aspect: messageId);
    return scope?.store;
  }

  // The single failure path for every accessor above, so each one reads as a
  // plain lookup.
  static Never _missingScope(BuildContext context) {
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamMessageTranslations was requested with a context that does '
        'not contain a StreamMessageTranslations.',
      ),
      ErrorDescription(
        'No StreamMessageTranslations ancestor could be found starting from '
        'the context that was passed. StreamChat provides one for its whole '
        'subtree, so this usually happens when a message widget is built '
        'outside of a StreamChat.',
      ),
      ErrorHint(
        'To fix this, wrap the subtree in a StreamMessageTranslations with a '
        'store you own:\n\n'
        '  StreamMessageTranslations(\n'
        '    store: _translationStore,\n'
        '    child: StreamMessageItem(message: message),\n'
        '  )',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  @override
  State<StreamMessageTranslations> createState() => _StreamMessageTranslationsState();
}

class _StreamMessageTranslationsState extends State<StreamMessageTranslations> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.store,
      // Passed through untouched, so a change only rebuilds the scope itself
      // and the messages depending on the ids that changed.
      child: widget.child,
      builder: (context, state, child) => _StreamMessageTranslationsScope(
        store: widget.store,
        state: state,
        child: child!,
      ),
    );
  }
}

// Does the actual providing, keyed by message id so a dependent only rebuilds
// for the message it asked about.
class _StreamMessageTranslationsScope extends InheritedModel<String> {
  const _StreamMessageTranslationsScope({
    required this.store,
    required this.state,
    required super.child,
  });

  final StreamMessageTranslationStore store;
  final StreamMessageTranslationState state;

  @override
  bool updateShouldNotify(_StreamMessageTranslationsScope oldWidget) {
    return oldWidget.store != store || oldWidget.state != state;
  }

  @override
  bool updateShouldNotifyDependent(
    _StreamMessageTranslationsScope oldWidget,
    Set<String> messageIds,
  ) {
    // A different store means every message's state may have changed.
    if (oldWidget.store != store) return true;

    return messageIds.any((it) {
      return oldWidget.state.isShowingOriginalText(it) != state.isShowingOriginalText(it);
    });
  }
}

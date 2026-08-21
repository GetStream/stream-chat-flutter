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

/// Tracks, for messages within a single message list, which ones the user
/// has switched back to their original text.
///
/// Mirrors `MessageOriginalTranslationsStore` in the Swift SDK.
///
/// One store is owned per [StreamMessageListView] instance — a channel view
/// and an open thread each get independent toggle state, since opening a
/// thread creates its own [StreamMessageListView]. The store, rather than
/// the individual message widget, is what makes the toggle survive message
/// items being disposed and recreated as they scroll out of and back into
/// the list's render window.
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
}

/// Provides a [StreamMessageTranslationStore] to the widget tree.
///
/// See also:
///
///  * [StreamMessageTranslationStore], the store this scope provides.
class StreamMessageTranslations extends InheritedNotifier<StreamMessageTranslationStore> {
  /// Creates a message translation scope.
  const StreamMessageTranslations({
    super.key,
    required StreamMessageTranslationStore store,
    required super.child,
  }) : super(notifier: store);

  /// Returns the [StreamMessageTranslationStore] from the nearest ancestor
  /// [StreamMessageTranslations] that encloses the given [context].
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
  static StreamMessageTranslationStore of(BuildContext context) {
    final result = maybeOf(context);
    if (result != null) return result;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamMessageTranslations.of() called with a context that does not '
        'contain a StreamMessageTranslations.',
      ),
      ErrorDescription(
        'No StreamMessageTranslations ancestor could be found starting from '
        'the context that was passed to StreamMessageTranslations.of(). '
        'StreamMessageListView provides one for the messages it hosts, so '
        'this usually happens when a message widget is built outside of a '
        'message list.',
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

  /// Returns the [StreamMessageTranslationStore] from the nearest ancestor
  /// [StreamMessageTranslations] that encloses the given context.
  ///
  /// Returns null if no such ancestor exists.
  ///
  /// See also:
  ///  * [of], which throws if no [StreamMessageTranslations] is found.
  static StreamMessageTranslationStore? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<StreamMessageTranslations>();
    return widget?.notifier;
  }
}

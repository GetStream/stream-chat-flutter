import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

/// The translation display state of the messages within a single message
/// list.
///
/// Showing the translation is the default, so this holds only the
/// exceptions — see [messagesShowingOriginalText].
@immutable
class StreamMessageTranslationState {
  /// Creates a state in which every message shows its translation.
  const StreamMessageTranslationState({
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

  /// Copies the state, replacing the provided fields.
  StreamMessageTranslationState copyWith({
    Set<String>? messagesShowingOriginalText,
  }) {
    return StreamMessageTranslationState(
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
  StreamMessageTranslationStore() : super(const StreamMessageTranslationState());

  /// Whether [messageId] is currently showing its original text instead of
  /// its translation.
  bool isShowingOriginalText(String messageId) => value.isShowingOriginalText(messageId);

  /// Switches [messageId] between showing its original text and its
  /// translation.
  void toggleOriginalText(String messageId) {
    final showingOriginalText = value.messagesShowingOriginalText;

    value = value.copyWith(
      messagesShowingOriginalText: switch (showingOriginalText.contains(messageId)) {
        true => {...showingOriginalText}..remove(messageId),
        false => {...showingOriginalText, messageId},
      },
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
  /// [StreamMessageTranslations], or `null` if there isn't one.
  static StreamMessageTranslationStore? of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<StreamMessageTranslations>();
    return widget?.notifier;
  }
}

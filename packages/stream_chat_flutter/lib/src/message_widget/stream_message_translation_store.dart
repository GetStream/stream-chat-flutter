import 'package:flutter/widgets.dart';

/// Tracks, for messages within a single message list, which ones the user
/// has switched back to their original text.
///
/// Showing the translation is the default, so [value] holds only the
/// exceptions — the ids of messages switched to their original text. It is
/// empty while every message shows its translation. This mirrors
/// `MessageOriginalTranslationsStore` in the Swift SDK.
///
/// One store is owned per [StreamMessageListView] instance — a channel view
/// and an open thread each get independent toggle state, since opening a
/// thread creates its own [StreamMessageListView]. The store, rather than
/// the individual message widget, is what makes the toggle survive message
/// items being disposed and recreated as they scroll out of and back into
/// the list's render window.
class StreamMessageTranslationStore extends ValueNotifier<Set<String>> {
  /// Creates a store in which every message shows its translation.
  StreamMessageTranslationStore() : super(const {});

  /// Whether [messageId] is currently showing its original text instead of
  /// its translation.
  bool isShowingOriginalText(String messageId) => value.contains(messageId);

  /// Switches [messageId] between showing its original text and its
  /// translation.
  void toggleOriginalText(String messageId) {
    value = switch (value.contains(messageId)) {
      true => {...value}..remove(messageId),
      false => {...value, messageId},
    };
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

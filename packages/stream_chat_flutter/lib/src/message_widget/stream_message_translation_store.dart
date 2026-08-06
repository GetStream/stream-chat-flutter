import 'package:flutter/widgets.dart';

/// Tracks, for messages within a single message list, which ones are
/// currently showing their original text instead of a translation.
///
/// One store is owned per [StreamMessageListView] instance — a channel view
/// and an open thread each get independent toggle state, since opening a
/// thread creates its own [StreamMessageListView]. The store, rather than
/// the individual message widget, is what makes the toggle survive message
/// items being disposed and recreated as they scroll out of and back into
/// the list's render window.
class StreamMessageTranslationStore extends ChangeNotifier {
  final _originalTextMessageIds = <String>{};

  /// Whether [messageId] is currently showing its original text instead of
  /// a translation.
  bool isShowingOriginalText(String messageId) => _originalTextMessageIds.contains(messageId);

  /// Switches [messageId] between showing its original text and its
  /// translation.
  void toggleOriginalText(String messageId) {
    if (!_originalTextMessageIds.remove(messageId)) {
      _originalTextMessageIds.add(messageId);
    }
    notifyListeners();
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

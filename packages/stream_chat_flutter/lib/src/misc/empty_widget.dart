import 'package:flutter/widgets.dart';

/// A widget that renders nothing and takes up no space.
///
/// This is a type-safe wrapper around [EmptyWidget()] that can be used
/// when a widget is required but no visible content should be rendered.
///
/// Example:
/// ```dart
/// Widget buildContent(bool hasContent) {
///   return hasContent ? ContentWidget() : const Empty();
/// }
/// ```
///
/// See also:
///  * [SizedBox.shrink], the underlying widget used by this extension type
extension type const Empty._(Widget widget) implements Widget {
  /// Creates a widget that renders nothing and takes up no space.
  const Empty() : this._(const SizedBox.shrink());
}

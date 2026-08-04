import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Resolves the effective [StreamAppBarBehavior] for a widget.
///
/// Precedence, highest first:
///
/// 1. [override] — a widget-local value, such as
///    [StreamAppBarStyle.behavior] passed to a header.
/// 2. [StreamAppBarStyle.behavior] from the ambient [StreamAppBarTheme].
/// 3. The ambient [StreamAppStyle] — [StreamAppStyle.floating] maps to
///    [StreamAppBarBehavior.floating], [StreamAppStyle.regular] to
///    [StreamAppBarBehavior.regular].
///
/// Internal: shared by [StreamChannelHeader], [StreamChannelListHeader] and
/// [StreamBackButton] so the chain stays in one place. A natural home for this
/// is next to [StreamAppBarBehavior] in `stream_core_flutter`.
StreamAppBarBehavior resolveAppBarBehavior(
  BuildContext context, {
  StreamAppBarBehavior? override,
}) {
  return override ??
      StreamAppBarTheme.of(context).style?.behavior ??
      (StreamTheme.of(context).appStyle.isFloating ? .floating : .regular);
}

/// Whether the effective [StreamAppBarBehavior] is
/// [StreamAppBarBehavior.floating].
///
/// Convenience over [resolveAppBarBehavior] for the common case of driving a
/// boolean — a floating app bar, avatar shadow, or outlined back button.
bool isFloatingAppBar(
  BuildContext context, {
  StreamAppBarBehavior? override,
}) {
  return switch (resolveAppBarBehavior(context, override: override)) {
    .floating => true,
    .regular => false,
  };
}

import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Reads the surrounding [StreamScaffold]'s floating-chrome insets.
///
/// Both getters return `0` when there is no [StreamScaffoldInsets] ancestor, or
/// when the chrome is not floating — so a page can add them unconditionally and
/// get the right layout in either app style.
extension StreamScaffoldInsetsContext on BuildContext {
  /// Space taken by a floating app bar at the top, including the status bar.
  double get streamTopInset => StreamScaffoldInsets.maybeOf(this)?.topPadding ?? 0;

  /// Space taken by a floating bottom widget, including the home indicator.
  double get streamBottomInset => StreamScaffoldInsets.maybeOf(this)?.bottomPadding ?? 0;
}

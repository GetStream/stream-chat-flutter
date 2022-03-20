import 'package:flutter/rendering.dart';
import 'package:stream_chat_flutter/src/video/vlc/vlc_manager.dart';

/// The web implementation of [VlcManager]. Naturally, it does nothing. It
/// exists simply to satisfy the requirements of conditional imports.
class VlcManagerWeb extends VlcManager {
  @override
  void initialize() {
    debugPrint('Stub initialization for VLC.');
  }
}

/// Allows [VlcManager] to return the correct implementation.
VlcManager getVlc() => VlcManagerWeb();

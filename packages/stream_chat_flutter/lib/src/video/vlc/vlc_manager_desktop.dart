import 'package:media_kit/media_kit.dart';
import 'package:stream_chat_flutter/src/video/vlc/vlc_manager.dart';

/// The desktop implementation of [VlcManager]. It simply initializes VLC.
class VlcManagerDesktop extends VlcManager {
  @override
  void initialize() {
    MediaKit.ensureInitialized();
  }
}

/// Allows [VlcManager] to return the correct implementation.
VlcManager getVlc() => VlcManagerDesktop();

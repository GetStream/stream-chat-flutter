import 'package:stream_chat_flutter/src/vlc/vlc_stub.dart'
    if (dart.library.io) 'vlc_manager_desktop.dart'
    if (dar.library.html) 'vlc_manager_web.dart';

abstract class VlcManager {
  static VlcManager? _instance;

  static VlcManager get instance {
    _instance = getVlc();

    return _instance!;
  }

  void initialize();
}

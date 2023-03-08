import 'package:stream_chat_flutter/src/video/vlc/vlc_stub.dart'
    if (dart.library.io) 'vlc_manager_desktop.dart'
    if (dart.library.html) 'vlc_manager_web.dart';

/// {@template vlcManager}
/// An abstract class for the purpose of ensuring Flutter applications that
/// target both desktop & web do not crash when building for web targets.
/// {@endtemplate}
abstract class VlcManager {
  // ignore: use_late_for_private_fields_and_variables
  static VlcManager? _instance;

  /// The current instance of [VlcManager].
  static VlcManager get instance {
    _instance = getVlc();

    return _instance!;
  }

  /// Initializes VLC.
  void initialize();
}

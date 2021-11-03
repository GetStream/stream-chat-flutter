import 'package:stream_chat/src/client/client.dart';

/// Current package version
/// Used in [StreamChatClient] to build the `x-stream-client` header
// ignore: constant_identifier_names
const PACKAGE_VERSION = '3.2.0';

/// Possible packages
enum Package {
  /// The Low Level Client
  llc,

  /// The Core package
  core,

  /// The UI package
  ui,
}

///
extension XPackage on Package {
  ///
  String get name => {
        Package.llc: 'llc',
        Package.core: 'core',
        Package.ui: 'ui',
      }[this]!;
}

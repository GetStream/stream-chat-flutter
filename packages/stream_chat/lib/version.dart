import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';

/// Current package version
/// Used in [StreamChatClient] to build the `x-stream-client` header
// ignore: constant_identifier_names
const PACKAGE_VERSION = '3.2.0';

/// Default user agent used for the 'x-stream-client' header
final defaultUserAgent = 'stream-chat-dart-client-'
    '${CurrentPlatform.name}-'
    '${PACKAGE_VERSION.split('+')[0]}';

/// Current used package
/// This is used to set the `x-stream-client` header using info about
/// the package in use
/// For example: llc/core/ui
Package usedPackage = Package.llc;

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

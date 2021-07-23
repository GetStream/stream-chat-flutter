import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';

/// Current package version
/// Used in [StreamChatClient] to build the `x-stream-client` header
// ignore: constant_identifier_names
const PACKAGE_VERSION = '2.0.0';

/// Get the current user agent
String get userAgent => 'stream-chat-dart-client-'
    '${CurrentPlatform.name}-'
    '${PACKAGE_VERSION.split('+')[0]}';

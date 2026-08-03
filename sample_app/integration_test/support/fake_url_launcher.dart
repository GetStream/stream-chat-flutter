import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// A [UrlLauncherPlatform] that records launches instead of performing them.
///
/// `integration_test` runs the app with its real plugins, so mocking the
/// `plugins.flutter.io/url_launcher` method channel does nothing — the iOS and
/// Android implementations talk over their own Pigeon channels and would open
/// the real browser, suspending the app and hanging the run. Swapping the
/// platform instance intercepts the launch in Dart, above any channel.
class FakeUrlLauncher extends UrlLauncherPlatform {
  /// Every URL the app asked to open, in order.
  final launchedUrls = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrls.add(url);
    return true;
  }

  // Pre-6.x entrypoint; `launchUrl` above supersedes it, but the SDK is free to
  // reach it through an older url_launcher, so record there too.
  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async {
    launchedUrls.add(url);
    return true;
  }

  @override
  Future<void> closeWebView() async {}

  @override
  Future<bool> supportsMode(PreferredLaunchMode mode) async => true;

  @override
  Future<bool> supportsCloseForMode(PreferredLaunchMode mode) async => false;
}

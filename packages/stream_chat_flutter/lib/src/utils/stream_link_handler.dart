import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../stream_chat_flutter.dart';

/// A handler that opens links tapped in messages, attachments and AI replies.
///
/// Opens a link whose scheme is in [schemes] in an external app, and leaves
/// every other link unopened. A link without a scheme, such as `example.com`,
/// is opened as `http`.
///
/// To open more kinds of link, consider passing more [schemes], or extending
/// this class and overriding [open]:
///
/// ```dart
/// class MyLinkHandler extends StreamLinkHandler {
///   const MyLinkHandler();
///
///   @override
///   Future<bool> open(BuildContext context, Uri uri) async {
///     if (uri.scheme == 'myapp') return openInApp(context, uri);
///     return super.open(context, uri);
///   }
/// }
/// ```
///
/// See also:
///
///  * [StreamChatConfigurationData.linkHandler], which sets the handler used
///    by the chat widgets.
class StreamLinkHandler {
  /// Creates a link handler that opens the links whose scheme is in [schemes].
  const StreamLinkHandler({this.schemes = defaultSchemes});

  /// The schemes opened by default: `http`, `https` and `mailto`.
  static const defaultSchemes = {'http', 'https', 'mailto'};

  /// The lowercase schemes of the links that are opened.
  ///
  /// Replaces [defaultSchemes]; to keep them, include them, as in
  /// `{...StreamLinkHandler.defaultSchemes, 'tel'}`.
  final Set<String> schemes;

  /// Opens [uri], and returns whether it was opened.
  ///
  /// Returns false for a link whose scheme isn't in [schemes], or that no app
  /// on the device can open.
  Future<bool> open(BuildContext context, Uri uri) async {
    final target = uri.withScheme;
    if (!schemes.contains(target.scheme)) return false;

    try {
      return await launchUrl(target, mode: LaunchMode.externalApplication);
    } on Exception {
      return false;
    }
  }
}

/// Opens [url] with the configured [StreamChatConfigurationData.linkHandler].
///
/// Shows a snack bar if [url] is not opened.
@internal
Future<void> openLink(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  final config = StreamChatConfiguration.maybeOf(context);
  final linkHandler = config?.linkHandler ?? const StreamLinkHandler();
  final opened = uri != null && await linkHandler.open(context, uri);
  if (opened || !context.mounted) return;

  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(content: Text(context.translations.launchUrlError)),
  );
}

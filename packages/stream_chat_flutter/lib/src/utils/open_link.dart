import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';

/// Opens [url] with the configured [StreamChatConfigurationData.linkHandler].
///
/// Shows a snack bar if [url] is not opened.
Future<void> openLink(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  final linkHandler = StreamChatConfiguration.maybeOf(context)?.linkHandler ?? const StreamLinkHandler();
  final opened = uri != null && await linkHandler.open(context, uri);
  if (opened || !context.mounted) return;

  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(content: Text(context.translations.launchUrlError)),
  );
}

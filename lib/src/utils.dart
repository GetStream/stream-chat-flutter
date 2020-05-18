import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Cannot launch the url'),
      ),
    );
  }
}

String getAttachmentHeroTag(Message message, Attachment attachment) {
  return '${message.id}-${attachment.imageUrl ?? attachment.assetUrl ?? attachment.thumbUrl ?? attachment.ogScrapeUrl}';
}

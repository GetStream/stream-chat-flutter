import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UrlAttachment extends StatelessWidget {
  final Attachment urlAttachment;
  final String hostDisplayName;
  final EdgeInsets textPadding;

  UrlAttachment({
    @required this.urlAttachment,
    @required this.hostDisplayName,
    @required this.textPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchURL(
        context,
        urlAttachment.ogScrapeUrl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (urlAttachment.imageUrl != null)
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: urlAttachment.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: -1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                        ),
                        color: StreamChatTheme.of(context).colorTheme.blueAlice,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Text(
                          hostDisplayName,
                          style: StreamChatTheme.of(context)
                              .textTheme
                              .bodyBold
                              .copyWith(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .accentBlue,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: textPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (urlAttachment.title != null)
                  Text(
                    urlAttachment.title.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StreamChatTheme.of(context)
                        .textTheme
                        .body
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                if (urlAttachment.text != null)
                  Text(
                    urlAttachment.text,
                    style: StreamChatTheme.of(context)
                        .textTheme
                        .body
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

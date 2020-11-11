import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UrlAttachment extends StatelessWidget {
  Attachment urlAttachment;
  String hostDisplayName;
  EdgeInsets textPadding;

  UrlAttachment({
    @required this.urlAttachment,
    @required this.hostDisplayName,
    @required this.textPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (urlAttachment.imageUrl != null)
              SizedBox(
                height: 16.0,
              ),
            if (urlAttachment.imageUrl != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: urlAttachment.imageUrl,
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: -1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Text(
                            hostDisplayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF006CFF),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.0),
                          ),
                          color: Color(0xFFE9F2FF),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              ),
            Padding(
              padding: textPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (urlAttachment.title != null)
                    Text(
                      urlAttachment.title,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                      ),
                    ),
                  if (urlAttachment.text != null)
                    Text(
                      urlAttachment.text,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => launchURL(
                context,
                urlAttachment.ogScrapeUrl,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

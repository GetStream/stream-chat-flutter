import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../stream_chat_flutter.dart';
import 'stream_svg_icon.dart';

Future<void> launchURL(BuildContext context, String? url) async {
  if (url != null && await canLaunch(url)) {
    await launch(url);
  } else {
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Cannot launch the url'),
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String okText,
  Widget? icon,
  String? question,
  String? cancelText,
}) {
  return showModalBottomSheet(
      backgroundColor: StreamChatTheme.of(context).colorTheme.white,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      )),
      builder: (context) {
        final effect = StreamChatTheme.of(context).colorTheme.borderTop;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 26),
              if (icon != null) icon,
              SizedBox(height: 26),
              Text(
                title,
                style: StreamChatTheme.of(context).textTheme.headlineBold,
              ),
              SizedBox(height: 7),
              if (question != null)
                Text(
                  question,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 36),
              Container(
                color: effect.color!.withOpacity(effect.alpha ?? 1),
                height: 1,
              ),
              Row(
                children: [
                  if (cancelText != null)
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            cancelText,
                            style: StreamChatTheme.of(context)
                                .textTheme
                                .bodyBold
                                .copyWith(
                                    color: StreamChatTheme.of(context)
                                        .colorTheme
                                        .black
                                        .withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          okText,
                          style: StreamChatTheme.of(context)
                              .textTheme
                              .bodyBold
                              .copyWith(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .accentRed),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

Future<bool?> showInfoDialog(
  BuildContext context, {
  required String title,
  required String okText,
  Widget? icon,
  String? details,
  StreamChatThemeData? theme,
}) {
  return showModalBottomSheet(
    backgroundColor:
        theme?.colorTheme.white ?? StreamChatTheme.of(context).colorTheme.white,
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    )),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 26,
            ),
            if (icon != null) icon,
            SizedBox(
              height: 26,
            ),
            Text(
              title,
              style: theme?.textTheme.headlineBold ??
                  StreamChatTheme.of(context).textTheme.headlineBold,
            ),
            SizedBox(
              height: 7,
            ),
            if (details != null) Text(details),
            SizedBox(
              height: 36,
            ),
            Container(
              color: theme?.colorTheme.black.withOpacity(.08) ??
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(.08),
              height: 1,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  okText,
                  style: TextStyle(
                    color: theme?.colorTheme.black.withOpacity(0.5) ??
                        StreamChatTheme.of(context).colorTheme.accentBlue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Get random png with initials
String getRandomPicUrl(User user) =>
    'https://getstream.io/random_png/?id=${user.id}&name=${user.name}';

/// Get websiteName from [hostName]
String? getWebsiteName(String hostName) {
  switch (hostName) {
    case 'reddit':
      return 'Reddit';
    case 'youtube':
      return 'Youtube';
    case 'wikipedia':
      return 'Wikipedia';
    case 'twitter':
      return 'Twitter';
    case 'facebook':
      return 'Facebook';
    case 'amazon':
      return 'Amazon';
    case 'yelp':
      return 'Yelp';
    case 'imdb':
      return 'IMDB';
    case 'pinterest':
      return 'Pinterest';
    case 'tripadvisor':
      return 'TripAdvisor';
    case 'instagram':
      return 'Instagram';
    case 'walmart':
      return 'Walmart';
    case 'craigslist':
      return 'Craigslist';
    case 'ebay':
      return 'eBay';
    case 'linkedin':
      return 'LinkedIn';
    case 'google':
      return 'Google';
    case 'apple':
      return 'Apple';
    default:
      return null;
  }
}

/// A method returns a human readable string representing a file _size
String fileSize(dynamic size, [int round = 2]) {
  if (size == null) return 'Size N/A';

  /**
   * [size] can be passed as number or as string
   *
   * the optional parameter [round] specifies the number
   * of digits after comma/point (default is 2)
   */
  const divider = 1024;
  int _size;
  try {
    _size = int.parse(size.toString());
  } catch (e) {
    throw ArgumentError('Can not parse the size parameter: $e');
  }

  if (_size < divider) {
    return '$_size B';
  }

  if (_size < divider * divider && _size % divider == 0) {
    return '${(_size / divider).toStringAsFixed(0)} KB';
  }

  if (_size < divider * divider) {
    return '${(_size / divider).toStringAsFixed(round)} KB';
  }

  if (_size < divider * divider * divider && _size % divider == 0) {
    return '${(_size / (divider * divider)).toStringAsFixed(0)} MB';
  }

  if (_size < divider * divider * divider) {
    return '${(_size / divider / divider).toStringAsFixed(round)} MB';
  }

  if (_size < divider * divider * divider * divider && _size % divider == 0) {
    return '${(_size / (divider * divider * divider)).toStringAsFixed(0)} GB';
  }

  if (_size < divider * divider * divider * divider) {
    return '${(_size / divider / divider / divider).toStringAsFixed(round)} GB';
  }

  if (_size < divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    final num r = _size / divider / divider / divider / divider;
    return '${r.toStringAsFixed(0)} TB';
  }

  if (_size < divider * divider * divider * divider * divider) {
    final num r = _size / divider / divider / divider / divider;
    return '${r.toStringAsFixed(round)} TB';
  }

  if (_size < divider * divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    final num r = _size / divider / divider / divider / divider / divider;
    return '${r.toStringAsFixed(0)} PB';
  } else {
    final num r = _size / divider / divider / divider / divider / divider;
    return '${r.toStringAsFixed(round)} PB';
  }
}

///
StreamSvgIcon getFileTypeImage(String? type) {
  switch (type) {
    case '7z':
      return StreamSvgIcon.filetype7z();
    case 'csv':
      return StreamSvgIcon.filetypeCsv();
    case 'doc':
      return StreamSvgIcon.filetypeDoc();
    case 'docx':
      return StreamSvgIcon.filetypeDocx();
    case 'html':
      return StreamSvgIcon.filetypeHtml();
    case 'md':
      return StreamSvgIcon.filetypeMd();
    case 'odt':
      return StreamSvgIcon.filetypeOdt();
    case 'pdf':
      return StreamSvgIcon.filetypePdf();
    case 'ppt':
      return StreamSvgIcon.filetypePpt();
    case 'pptx':
      return StreamSvgIcon.filetypePptx();
    case 'rar':
      return StreamSvgIcon.filetypeRar();
    case 'rtf':
      return StreamSvgIcon.filetypeRtf();
    case 'tar':
      return StreamSvgIcon.filetypeTar();
    case 'txt':
      return StreamSvgIcon.filetypeTxt();
    case 'xls':
      return StreamSvgIcon.filetypeXls();
    case 'xlsx':
      return StreamSvgIcon.filetypeXlsx();
    case 'zip':
      return StreamSvgIcon.filetypeZip();
    default:
      return StreamSvgIcon.filetypeGeneric();
  }
}

Widget wrapAttachmentWidget(
  BuildContext context,
  Widget attachmentWidget,
  ShapeBorder attachmentShape,
  bool reverse,
  BorderRadius borderRadius,
) {
  return ClipRRect(
    borderRadius: borderRadius,
    child: Material(
      clipBehavior: Clip.antiAlias,
      shape: attachmentShape,
      type: MaterialType.transparency,
      child: Transform(
        transform: Matrix4.rotationY(reverse ? pi : 0),
        alignment: Alignment.center,
        child: attachmentWidget,
      ),
    ),
  );
}

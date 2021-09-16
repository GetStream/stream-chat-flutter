import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stream_chat_flutter/src/extension.dart';

/// Launch URL
Future<void> launchURL(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.translations.launchUrlError)),
    );
  }
}

/// Shows confirmation dialog
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String okText,
  Widget? icon,
  String? question,
  String? cancelText,
}) {
  final chatThemeData = StreamChatTheme.of(context);
  return showModalBottomSheet(
      useRootNavigator: false,
      backgroundColor: chatThemeData.colorTheme.barsBg,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      )),
      builder: (context) {
        final effect = chatThemeData.colorTheme.borderTop;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 26),
              if (icon != null) icon,
              const SizedBox(height: 26),
              Text(
                title,
                style: chatThemeData.textTheme.headlineBold,
              ),
              const SizedBox(height: 7),
              if (question != null)
                Text(
                  question,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 36),
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
                            style: chatThemeData.textTheme.bodyBold.copyWith(
                                color: chatThemeData.colorTheme.textHighEmphasis
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
                          style: chatThemeData.textTheme.bodyBold.copyWith(
                              color: chatThemeData.colorTheme.accentError),
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

/// Shows info dialog
Future<bool?> showInfoDialog(
  BuildContext context, {
  required String title,
  required String okText,
  Widget? icon,
  String? details,
  StreamChatThemeData? theme,
}) {
  final chatThemeData = StreamChatTheme.of(context);
  return showModalBottomSheet(
    useRootNavigator: false,
    backgroundColor:
        theme?.colorTheme.barsBg ?? chatThemeData.colorTheme.barsBg,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    )),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 26,
          ),
          if (icon != null) icon,
          const SizedBox(
            height: 26,
          ),
          Text(
            title,
            style: theme?.textTheme.headlineBold ??
                chatThemeData.textTheme.headlineBold,
          ),
          const SizedBox(
            height: 7,
          ),
          if (details != null) Text(details),
          const SizedBox(
            height: 36,
          ),
          Container(
            color: theme?.colorTheme.textHighEmphasis.withOpacity(.08) ??
                chatThemeData.colorTheme.textHighEmphasis.withOpacity(.08),
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
                  color: theme?.colorTheme.textHighEmphasis.withOpacity(0.5) ??
                      chatThemeData.colorTheme.accentPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
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

/// Wraps attachment widget with custom shape
Widget wrapAttachmentWidget(
  BuildContext context,
  Widget attachmentWidget,
  ShapeBorder attachmentShape,
  // ignore: avoid_positional_boolean_parameters
  bool reverse,
) =>
    Material(
      clipBehavior: Clip.hardEdge,
      shape: attachmentShape,
      type: MaterialType.transparency,
      child: attachmentWidget,
    );

/// Represents a 2-tuple, or pair.
class Tuple2<T1, T2> {
  /// Creates a new tuple value with the specified items.
  const Tuple2(this.item1, this.item2);

  /// Create a new tuple value with the specified list [items].
  factory Tuple2.fromList(List items) {
    if (items.length != 2) {
      throw ArgumentError('items must have length 2');
    }

    return Tuple2<T1, T2>(items[0] as T1, items[1] as T2);
  }

  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Returns a tuple with the first item set to the specified value.
  Tuple2<T1, T2> withItem1(T1 v) => Tuple2<T1, T2>(v, item2);

  /// Returns a tuple with the second item set to the specified value.
  Tuple2<T1, T2> withItem2(T2 v) => Tuple2<T1, T2>(item1, v);

  /// Creates a [List] containing the items of this [Tuple2].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) =>
      List.from([item1, item2], growable: growable);

  @override
  String toString() => '[$item1, $item2]';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple2 &&
          runtimeType == other.runtimeType &&
          item1 == other.item1 &&
          item2 == other.item2;

  @override
  int get hashCode => item1.hashCode ^ item2.hashCode;
}

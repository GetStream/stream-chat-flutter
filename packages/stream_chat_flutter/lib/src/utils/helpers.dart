import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:synchronized/synchronized.dart';
import 'package:url_launcher/url_launcher.dart';

final _permissionRequestLock = Lock();

/// Executes [computation] when [_permissionRequestLock] is available.
///
/// Only one asynchronous block can run while the [_permissionRequestLock]
/// is retained.
Future<T> runInPermissionRequestLock<T>(
  FutureOr<T> Function() computation, {
  Duration? timeout,
}) {
  return _permissionRequestLock.synchronized(
    computation,
    timeout: timeout,
  );
}

/// Launch URL
Future<void> launchURL(BuildContext context, String url) async {
  try {
    await launchUrl(
      Uri.parse(url).withScheme,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.translations.launchUrlError)),
    );
  }
}

/// Get centerTitle considering a default and platform specific behaviour
bool getEffectiveCenterTitle(
  ThemeData theme, {
  bool? centerTitle,
  List<Widget>? actions,
}) {
  if (centerTitle != null) return centerTitle;
  if (theme.appBarTheme.centerTitle != null) {
    return theme.appBarTheme.centerTitle!;
  }
  switch (theme.platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return false;
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return actions == null || actions.length < 2;
  }
}

/// Shows confirmation dialog
@Deprecated(
  '''
  showConfirmationDialog is deprecated.
  Use showConfirmationBottomSheet instead.''',
)
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String okText,
  Widget? icon,
  String? question,
  String? cancelText,
}) =>
    showConfirmationBottomSheet(
      context,
      title: title,
      okText: okText,
      icon: icon,
      question: question,
      cancelText: cancelText,
    );

/// Shows confirmation bottom sheet
Future<bool?> showConfirmationBottomSheet(
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
      ),
    ),
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
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        okText,
                        style: chatThemeData.textTheme.bodyBold.copyWith(
                          color: chatThemeData.colorTheme.accentError,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

/// Shows info dialog
@Deprecated(
  '''
  showInfoDialog is deprecated.
  Use showInfoBottomSheet instead.''',
)
Future<bool?> showInfoDialog(
  BuildContext context, {
  required String title,
  required String okText,
  Widget? icon,
  String? details,
  StreamChatThemeData? theme,
}) =>
    showInfoBottomSheet(
      context,
      title: title,
      okText: okText,
      icon: icon,
      details: details,
      theme: theme,
    );

/// Shows info bottom sheet
Future<bool?> showInfoBottomSheet(
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
      ),
    ),
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
            color: theme?.colorTheme.textHighEmphasis.withOpacity(0.08) ??
                chatThemeData.colorTheme.textHighEmphasis.withOpacity(0.08),
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
StreamSvgIcon getFileTypeImage(String? mimeType) {
  final subtype = mimeType?.split('/').last;
  switch (subtype) {
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
@Deprecated(
  '''
wrapAttachmentWidget is deprecated.
Use WrapAttachmentWidget instead
''',
)
Widget wrapAttachmentWidget(
  BuildContext context,
  Widget attachmentWidget,
  ShapeBorder attachmentShape,
  // ignore: avoid_positional_boolean_parameters
  bool reverse,
) =>
    WrapAttachmentWidget(
      attachmentWidget: attachmentWidget,
      attachmentShape: attachmentShape,
    );

/// Wraps attachment widget with custom shape
class WrapAttachmentWidget extends StatelessWidget {
  /// Builds a [WrapAttachmentWidget].
  const WrapAttachmentWidget({
    super.key,
    required this.attachmentWidget,
    required this.attachmentShape,
  });

  /// The widget to wrap
  final Widget attachmentWidget;

  /// The shape of the wrapper
  final ShapeBorder attachmentShape;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: attachmentShape,
      type: MaterialType.transparency,
      child: attachmentWidget,
    );
  }
}

/// Levenshtein algorithm implementation based on:
/// http://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
int levenshtein(String s, String t, {bool caseSensitive = true}) {
  if (!caseSensitive) {
    // ignore: parameter_assignments
    s = s.toLowerCase();
    // ignore: parameter_assignments
    t = t.toLowerCase();
  }
  if (s == t) return 0;
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;

  final v0 = List<int>.filled(t.length + 1, 0);
  final v1 = List<int>.filled(t.length + 1, 0);

  for (var i = 0; i < t.length + 1; i < i++) {
    v0[i] = i;
  }

  for (var i = 0; i < s.length; i++) {
    v1[0] = i + 1;

    for (var j = 0; j < t.length; j++) {
      final cost = (s[i] == t[j]) ? 0 : 1;
      v1[j + 1] = math.min(v1[j] + 1, math.min(v0[j + 1] + 1, v0[j] + cost));
    }

    for (var j = 0; j < t.length + 1; j++) {
      v0[j] = v1[j];
    }
  }

  return v1[t.length];
}

/// An easy way to handle attachment related operations on a message
extension AttachmentPackagesX on Message {
  /// This extension will return a List of type [StreamAttachmentPackage] from
  /// the existing attachments of the message
  List<StreamAttachmentPackage> getAttachmentPackageList() {
    final _attachmentPackages = List<StreamAttachmentPackage>.generate(
      attachments.length,
      (index) => StreamAttachmentPackage(
        attachment: attachments[index],
        message: this,
      ),
    );
    return _attachmentPackages;
  }
}

/// PortalLabel that refers to [StreamMessageListView]
const kPortalMessageListViewLabel = _PortalMessageListViewLabel();

class _PortalMessageListViewLabel extends PortalLabel<void> {
  const _PortalMessageListViewLabel() : super(null);

  @override
  String toString() => 'PortalLabel.MessageWidget';
}

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:url_launcher/url_launcher.dart';

import 'stream_svg_icon.dart';

import '../stream_chat_flutter.dart';

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

Future<bool> showConfirmationDialog(
  BuildContext context, {
  String title,
  Widget icon,
  String question,
  String okText,
  String cancelText,
}) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      )),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 26.0,
            ),
            if (icon != null) icon,
            SizedBox(
              height: 26.0,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            SizedBox(
              height: 7.0,
            ),
            Text(question),
            SizedBox(
              height: 36.0,
            ),
            Container(
              color: Color(0xffe6e6e6),
              height: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text(
                    cancelText,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    okText,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ],
        );
      });
}

/// Get random png with initials
String getRandomPicUrl(User user) =>
    'https://getstream.io/random_png/?id=${user.id}&name=${user.name}';

/// Get websiteName from [hostName]
String getWebsiteName(String hostName) {
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

///
String getSizeText(int bytes) {
  if (bytes == null) {
    return 'Size N/A';
  }

  if (bytes <= 1000) {
    return '${bytes} bytes';
  } else if (bytes <= 100000) {
    return '${(bytes / 1000).toStringAsFixed(2)} KB';
  } else {
    return '${(bytes / 1000000).toStringAsFixed(2)} MB';
  }
}

///
StreamSvgIcon getFileTypeImage(String type) {
  switch (type) {
    case '7z':
      return StreamSvgIcon.filetype_7z();
      break;
    case 'csv':
      return StreamSvgIcon.filetype_csv();
      break;
    case 'doc':
      return StreamSvgIcon.filetype_doc();
      break;
    case 'docx':
      return StreamSvgIcon.filetype_docx();
      break;
    case 'html':
      return StreamSvgIcon.filetype_html();
      break;
    case 'md':
      return StreamSvgIcon.filetype_md();
      break;
    case 'odt':
      return StreamSvgIcon.filetype_odt();
      break;
    case 'pdf':
      return StreamSvgIcon.filetype_pdf();
      break;
    case 'ppt':
      return StreamSvgIcon.filetype_ppt();
      break;
    case 'pptx':
      return StreamSvgIcon.filetype_pptx();
      break;
    case 'rar':
      return StreamSvgIcon.filetype_rar();
      break;
    case 'rtf':
      return StreamSvgIcon.filetype_rtf();
      break;
    case 'tar':
      return StreamSvgIcon.filetype_tar();
      break;
    case 'txt':
      return StreamSvgIcon.filetype_txt();
      break;
    case 'xls':
      return StreamSvgIcon.filetype_xls();
      break;
    case 'xlsx':
      return StreamSvgIcon.filetype_xlsx();
      break;
    case 'zip':
      return StreamSvgIcon.filetype_zip();
      break;
    default:
      return StreamSvgIcon.filetype_Generic();
      break;
  }
}

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
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

Future<bool> showConfirmationDialog(
  BuildContext context,
  String question,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(question),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.pop(
              context,
              true,
            ),
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(
              context,
              false,
            ),
          ),
        ],
      );
    },
  );
}

/// Get random png with initials
String getRandomPicUrl(User user) =>
    'https://getstream.io/random_png/?id=${user.id}&name=${user.name}';

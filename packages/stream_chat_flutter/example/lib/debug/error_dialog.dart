// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  Object e,
  String operation,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$operation Failed'),
        content: SingleChildScrollView(child: Text('$e')),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

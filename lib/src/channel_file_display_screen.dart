import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelFileDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Files',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        leading: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: StreamSvgIcon.left(
                color: Colors.black,
                size: 24.0,
              ),
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        backgroundColor: StreamChatTheme.of(context).primaryColor,
      ),
    );
  }
}

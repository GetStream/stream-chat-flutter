import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_flutter/src/back_button.dart';
import 'package:stream_chat_flutter/src/channel_info.dart';
import 'package:stream_chat_flutter/src/channel_name.dart';
import 'package:stream_chat_flutter/src/info_tile.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

import '../stream_chat_flutter.dart';
import './channel_name.dart';
import 'channel_image.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_header.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_header_paint.png)
///
/// It shows the current [Channel] information.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final Client client;
///   final Channel channel;
///
///   MyApp(this.client, this.channel);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: StreamChat(
///         client: client,
///         child: StreamChannel(
///           channel: channel,
///           child: Scaffold(
///             appBar: ChannelHeader(),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// Usually you would use this widget as an [AppBar] inside a [Scaffold].
/// However you can also use it as a normal widget.
///
/// Make sure to have a [StreamChannel] ancestor in order to provide the information about the channel.
/// Every part of the widget uses a [StreamBuilder] to render the channel information as soon as it updates.
///
/// By default the widget shows a backButton that calls [Navigator.pop].
/// You can disable this button using the [showBackButton] property of just override the behaviour
/// with [onBackPressed].
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme] and on its [ChannelTheme.channelHeaderTheme] property.
/// Modify it to change the widget appearance.
class ChannelHeader extends StatelessWidget implements PreferredSizeWidget {
  /// True if this header shows the leading back button
  final bool showBackButton;

  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback onBackPressed;

  /// Callback to call when the header is tapped.
  final VoidCallback onTitleTap;

  /// Callback to call when the image is tapped.
  final VoidCallback onImageTap;

  /// If true the typing indicator will be rendered if a user is typing
  final bool showTypingIndicator;

  final bool showConnectionStateTile;

  /// Creates a channel header
  ChannelHeader({
    Key key,
    this.showBackButton = true,
    this.onBackPressed,
    this.onTitleTap,
    this.showTypingIndicator = true,
    this.onImageTap,
    this.showConnectionStateTile = false,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final _client = StreamChat.of(context).client;

    return ValueListenableBuilder<ConnectionStatus>(
      valueListenable: _client.wsConnectionStatus,
      builder: (context, status, _) {
        String statusString = '';
        bool showStatus = true;

        switch (status) {
          case ConnectionStatus.connected:
            statusString = 'Connected';
            showStatus = false;
            break;
          case ConnectionStatus.connecting:
            statusString = 'Reconnecting...';
            break;
          case ConnectionStatus.disconnected:
            statusString = 'Disconnected';
            break;
        }

        return InfoTile(
          showMessage: showConnectionStateTile ? showStatus : false,
          message: statusString,
          child: AppBar(
            brightness: Theme.of(context).brightness,
            elevation: 1,
            leading: showBackButton
                ? StreamBackButton(
                    onPressed: onBackPressed,
                    showUnreads: true,
                  )
                : SizedBox(),
            backgroundColor: StreamChatTheme.of(context)
                .channelTheme
                .channelHeaderTheme
                .color,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Center(
                  child: ChannelImage(
                    onTap: onImageTap,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            title: InkWell(
              onTap: onTitleTap,
              child: Container(
                height: preferredSize.height,
                width: preferredSize.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ChannelName(
                      textStyle: StreamChatTheme.of(context)
                          .channelTheme
                          .channelHeaderTheme
                          .title,
                    ),
                    SizedBox(height: 2),
                    ChannelInfo(
                      showTypingIndicator: showTypingIndicator,
                      channel: channel,
                      textStyle: StreamChatTheme.of(context)
                          .channelPreviewTheme
                          .subtitle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  final Size preferredSize;
}

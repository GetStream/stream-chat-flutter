import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_image.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_image_paint.png)
///
/// It shows the current [Channel] image.
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
///       debugShowCheckedModeBanner: false,
///       home: StreamChat(
///         client: client,
///         child: StreamChannel(
///           channel: channel,
///           child: Center(
///             child: ChannelImage(
///               channel: channel,
///             ),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// The widget uses a [StreamBuilder] to render the channel information image as soon as it updates.
///
/// By default the widget radius size is 40x40 pixels.
/// Set the property [size] to set a custom dimension.
///
/// The widget renders the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class ChannelImage extends StatelessWidget {
  /// Instantiate a new ChannelImage
  const ChannelImage({
    Key key,
    this.channel,
    this.size = 40,
  }) : super(key: key);

  /// The channel to show the image of
  final Channel channel;

  /// The diameter of the image
  final double size;

  @override
  Widget build(BuildContext context) {
    final channel = this.channel ?? StreamChannel.of(context).channel;
    return StreamBuilder<Map<String, dynamic>>(
        stream: channel.extraDataStream,
        initialData: channel.extraData,
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: StreamChatTheme.of(context)
                .channelPreviewTheme
                .avatarTheme
                .borderRadius,
            child: Container(
              constraints: StreamChatTheme.of(context)
                  .channelPreviewTheme
                  .avatarTheme
                  .constraints,
              decoration: BoxDecoration(
                color: StreamChatTheme.of(context).accentColor,
              ),
              child: snapshot.data?.containsKey('image') ?? false
                  ? CachedNetworkImage(
                      imageUrl: snapshot.data['image'],
                      errorWidget: (_, __, ___) {
                        return Center(
                          child: Text(
                            snapshot.data?.containsKey('name') ?? false
                                ? snapshot.data['name'][0]
                                : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    )
                  : SizedBox(),
            ),
          );
        });
  }
}

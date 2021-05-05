import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/group_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_image.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_image_paint.png)
///
/// It shows the current [Channel] image.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
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
/// The widget uses a [StreamBuilder] to render the channel information
/// image as soon as it updates.
///
/// By default the widget radius size is 40x40 pixels.
/// Set the property [constraints] to set a custom dimension.
///
/// The widget renders the ui based on the first ancestor of type
/// [StreamChatTheme].
/// Modify it to change the widget appearance.
class ChannelImage extends StatelessWidget {
  /// Instantiate a new ChannelImage
  const ChannelImage({
    Key? key,
    this.channel,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  }) : super(key: key);

  /// [BorderRadius] to display the widget
  final BorderRadius? borderRadius;

  /// The channel to show the image of
  final Channel? channel;

  /// The diameter of the image
  final BoxConstraints? constraints;

  /// The function called when the image is tapped
  final VoidCallback? onTap;

  /// If image is selected
  final bool selected;

  /// Selection color for image
  final Color? selectionColor;

  /// Thickness of selection image
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final channel = this.channel ?? StreamChannel.of(context).channel;
    return StreamBuilder<Map<String, dynamic>>(
      stream: channel.extraDataStream,
      initialData: channel.extraData,
      builder: (context, snapshot) {
        String? image;
        if (snapshot.data!.containsKey('image') == true) {
          image = snapshot.data!['image'];
        } else if (channel.state?.members.length == 2) {
          final otherMember = channel.state?.members
              .firstWhere((member) => member.user?.id != streamChat.user?.id);
          return StreamBuilder<User>(
              stream: streamChat.client.state.usersStream.map(
                  (users) => users[otherMember?.userId] ?? otherMember!.user!),
              initialData: otherMember!.user,
              builder: (context, snapshot) => UserAvatar(
                    borderRadius: borderRadius ??
                        StreamChatTheme.of(context)
                            .channelPreviewTheme
                            .avatarTheme
                            ?.borderRadius,
                    user: snapshot.data ?? otherMember.user!,
                    constraints: constraints ??
                        StreamChatTheme.of(context)
                            .channelPreviewTheme
                            .avatarTheme
                            ?.constraints,
                    onTap: onTap != null ? (_) => onTap!() : null,
                    selected: selected,
                    selectionColor: selectionColor ??
                        StreamChatTheme.of(context).colorTheme.accentBlue,
                    selectionThickness: selectionThickness,
                  ));
        } else {
          final images = channel.state?.members
              .where((member) =>
                  member.user?.id != streamChat.user?.id &&
                  member.user?.extraData['image'] != null)
              .take(4)
              // ignore: cast_nullable_to_non_nullable
              .map((e) => e.user?.extraData['image'] as String)
              .toList();
          return GroupImage(
            images: images ?? [],
            borderRadius: borderRadius ??
                StreamChatTheme.of(context)
                    .channelPreviewTheme
                    .avatarTheme
                    ?.borderRadius,
            constraints: constraints ??
                StreamChatTheme.of(context)
                    .channelPreviewTheme
                    .avatarTheme
                    ?.constraints,
            onTap: onTap,
            selected: selected,
            selectionColor: selectionColor ??
                StreamChatTheme.of(context).colorTheme.accentBlue,
            selectionThickness: selectionThickness,
          );
        }

        Widget child = ClipRRect(
          borderRadius: borderRadius ??
              StreamChatTheme.of(context)
                  .channelPreviewTheme
                  .avatarTheme
                  ?.borderRadius,
          child: Container(
            constraints: constraints ??
                StreamChatTheme.of(context)
                    .channelPreviewTheme
                    .avatarTheme
                    ?.constraints,
            decoration: BoxDecoration(
              color: StreamChatTheme.of(context).colorTheme.accentBlue,
            ),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                if (image != null)
                  CachedNetworkImage(
                    imageUrl: image,
                    errorWidget: (_, __, ___) => Center(
                      child: Text(
                        snapshot.data?.containsKey('name') ?? false
                            ? snapshot.data!['name'][0]
                            : '',
                        style: TextStyle(
                          color: StreamChatTheme.of(context).colorTheme.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    fit: BoxFit.cover,
                  )
                else
                  StreamChatTheme.of(context).defaultChannelImage(
                    context,
                    channel,
                  ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                  ),
                ),
              ],
            ),
          ),
        );
        if (selected) {
          child = ClipRRect(
            key: const Key('selectedImage'),
            borderRadius: (borderRadius ??
                    StreamChatTheme.of(context)
                        .ownMessageTheme
                        .avatarTheme
                        ?.borderRadius ??
                    BorderRadius.zero) +
                BorderRadius.circular(selectionThickness),
            child: Container(
              constraints: constraints ??
                  StreamChatTheme.of(context)
                      .ownMessageTheme
                      .avatarTheme
                      ?.constraints,
              color: selectionColor ??
                  StreamChatTheme.of(context).colorTheme.accentBlue,
              child: Padding(
                padding: EdgeInsets.all(selectionThickness),
                child: child,
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}

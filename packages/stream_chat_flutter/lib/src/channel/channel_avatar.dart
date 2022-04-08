import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template channelAvatar}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_image.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_image_paint.png)
///
/// The image that represents the current [Channel].
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
/// Uses a [StreamBuilder] to render the channel information image as soon as
/// it updates.
///
/// By default, the widget radius size is 40x40 pixels. Set the [constraints]
/// property to set a custom dimension.
///
/// The UI is rendered based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget's appearance.
/// {@endtemplate}
class ChannelAvatar extends StatelessWidget {
  /// {@macro channelAvatar}
  const ChannelAvatar({
    Key? key,
    this.channel,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  }) : super(key: key);

  /// The [BorderRadius] for this [ChannelAvatar]
  final BorderRadius? borderRadius;

  /// The channel to show the image of
  final Channel? channel;

  /// The sizing constraints of the image
  final BoxConstraints? constraints;

  /// The action to perform when the image is tapped or clicked
  final VoidCallback? onTap;

  /// Whether the image is currently selected or not
  final bool selected;

  /// The color to use when the image is selected
  final Color? selectionColor;

  /// The value to use for the border thickness and padding of the
  /// selected image
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final channel = this.channel ?? StreamChannel.of(context).channel;

    assert(channel.state != null, 'Channel ${channel.id} is not initialized');

    final chatThemeData = StreamChatTheme.of(context);
    final colorTheme = chatThemeData.colorTheme;
    final previewTheme = chatThemeData.channelPreviewTheme.avatarTheme;

    return BetterStreamBuilder<String>(
      stream: channel.imageStream,
      initialData: channel.image,
      builder: (context, channelImage) {
        Widget child = ClipRRect(
          borderRadius: borderRadius ?? previewTheme?.borderRadius,
          child: Container(
            constraints: constraints ?? previewTheme?.constraints,
            decoration: BoxDecoration(color: colorTheme.accentPrimary),
            child: InkWell(
              onTap: onTap,
              child: CachedNetworkImage(
                imageUrl: channelImage,
                errorWidget: (_, __, ___) => Center(
                  child: Text(
                    channel.name?[0] ?? '',
                    style: TextStyle(
                      color: colorTheme.barsBg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

        if (selected) {
          child = ClipRRect(
            key: const Key('selectedImage'),
            borderRadius: BorderRadius.circular(selectionThickness) +
                (borderRadius ??
                    previewTheme?.borderRadius ??
                    BorderRadius.zero),
            child: Container(
              constraints: constraints ?? previewTheme?.constraints,
              color: selectionColor ?? colorTheme.accentPrimary,
              child: Padding(
                padding: EdgeInsets.all(selectionThickness),
                child: child,
              ),
            ),
          );
        }
        return child;
      },
      noDataBuilder: (context) {
        final currentUser = streamChat.currentUser!;
        final otherMembers = channel.state!.members
            .where((it) => it.userId != currentUser.id)
            .toList(growable: false);

        // our own space, no other members
        if (otherMembers.isEmpty) {
          return BetterStreamBuilder<User>(
            stream: streamChat.client.state.currentUserStream.map((it) => it!),
            initialData: currentUser,
            builder: (context, user) => UserAvatar(
              borderRadius: borderRadius ?? previewTheme?.borderRadius,
              user: user,
              constraints: constraints ?? previewTheme?.constraints,
              onTap: onTap != null ? (_) => onTap!() : null,
              selected: selected,
              selectionColor: selectionColor ?? colorTheme.accentPrimary,
              selectionThickness: selectionThickness,
            ),
          );
        }

        // 1-1 Conversation
        if (otherMembers.length == 1) {
          final member = otherMembers.first;
          return BetterStreamBuilder<Member>(
            stream: channel.state!.membersStream.map(
              (members) => members.firstWhere(
                (it) => it.userId == member.userId,
                orElse: () => member,
              ),
            ),
            initialData: member,
            builder: (context, member) => UserAvatar(
              borderRadius: borderRadius ?? previewTheme?.borderRadius,
              user: member.user!,
              constraints: constraints ?? previewTheme?.constraints,
              onTap: onTap != null ? (_) => onTap!() : null,
              selected: selected,
              selectionColor: selectionColor ?? colorTheme.accentPrimary,
              selectionThickness: selectionThickness,
            ),
          );
        }

        // Group conversation
        return GroupAvatar(
          members: otherMembers,
          borderRadius: borderRadius ?? previewTheme?.borderRadius,
          constraints: constraints ?? previewTheme?.constraints,
          onTap: onTap,
          selected: selected,
          selectionColor: selectionColor ?? colorTheme.accentPrimary,
          selectionThickness: selectionThickness,
        );
      },
    );
  }
}

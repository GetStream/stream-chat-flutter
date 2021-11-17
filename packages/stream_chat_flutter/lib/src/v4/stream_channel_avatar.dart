import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/group_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_image.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_image_paint.png)
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
class StreamChannelAvatar extends StatelessWidget {
  /// Instantiate a new ChannelImage
  StreamChannelAvatar({
    Key? key,
    required this.channel,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  })  : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        ),
        super(key: key);

  /// [BorderRadius] to display the widget
  final BorderRadius? borderRadius;

  /// The channel to show the image of
  final Channel channel;

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
    final client = channel.client.state;

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
        final currentUser = client.currentUser!;
        final otherMembers = channel.state!.members
            .where((it) => it.userId != currentUser.id)
            .toList(growable: false);

        // our own space, no other members
        if (otherMembers.isEmpty) {
          return BetterStreamBuilder<User>(
            stream: client.currentUserStream.map((it) => it!),
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
          channel: channel,
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

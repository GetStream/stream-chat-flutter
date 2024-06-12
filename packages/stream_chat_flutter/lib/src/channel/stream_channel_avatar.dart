import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
///             child: StreamChannelAvatar(
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
    super.key,
    required this.channel,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
    this.ownSpaceAvatarBuilder,
    this.oneToOneAvatarBuilder,
    this.groupAvatarBuilder,
  }) : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        );

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

  /// Builder to create avatar for own space channel.
  ///
  /// Defaults to [StreamUserAvatar].
  final StreamUserAvatarBuilder? ownSpaceAvatarBuilder;

  /// Builder to create avatar for one to one channel.
  ///
  /// Defaults to [StreamUserAvatar].
  final StreamUserAvatarBuilder? oneToOneAvatarBuilder;

  /// Builder to create avatar for group channel.
  ///
  /// Defaults to [StreamGroupAvatar].
  final StreamGroupAvatarBuilder? groupAvatarBuilder;

  @override
  Widget build(BuildContext context) {
    final client = channel.client.state;

    final chatThemeData = StreamChatTheme.of(context);
    final colorTheme = chatThemeData.colorTheme;
    final previewTheme = chatThemeData.channelPreviewTheme.avatarTheme;

    final fallbackWidget = Center(
      child: Text(
        channel.name?[0] ?? '',
        style: TextStyle(
          color: colorTheme.barsBg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return BetterStreamBuilder<String>(
      stream: channel.imageStream,
      initialData: channel.image,
      builder: (context, channelImage) {
        Widget child = ClipRRect(
          borderRadius:
              borderRadius ?? previewTheme?.borderRadius ?? BorderRadius.zero,
          child: Container(
            constraints: constraints ?? previewTheme?.constraints,
            decoration: BoxDecoration(color: colorTheme.accentPrimary),
            child: InkWell(
              onTap: onTap,
              child: channelImage.isEmpty
                  ? fallbackWidget
                  : CachedNetworkImage(
                      imageUrl: channelImage,
                      errorWidget: (_, __, ___) => fallbackWidget,
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
            builder: (context, user) {
              final ownSpaceBuilder = ownSpaceAvatarBuilder;
              if (ownSpaceBuilder != null) {
                return ownSpaceBuilder(context, user, selected);
              }

              return StreamUserAvatar(
                borderRadius: borderRadius ?? previewTheme?.borderRadius,
                user: user,
                constraints: constraints ?? previewTheme?.constraints,
                onTap: onTap != null ? (_) => onTap!() : null,
                selected: selected,
                selectionColor: selectionColor ?? colorTheme.accentPrimary,
                selectionThickness: selectionThickness,
              );
            },
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
            builder: (context, member) {
              final oneToOneBuilder = oneToOneAvatarBuilder;
              if (oneToOneBuilder != null) {
                return oneToOneBuilder(context, member.user!, selected);
              }

              return StreamUserAvatar(
                borderRadius: borderRadius ?? previewTheme?.borderRadius,
                user: member.user!,
                constraints: constraints ?? previewTheme?.constraints,
                onTap: onTap != null ? (_) => onTap!() : null,
                selected: selected,
                selectionColor: selectionColor ?? colorTheme.accentPrimary,
                selectionThickness: selectionThickness,
              );
            },
          );
        }

        final groupBuilder = groupAvatarBuilder;
        if (groupBuilder != null) {
          return groupBuilder(context, otherMembers, selected);
        }

        // Group conversation
        return StreamGroupAvatar(
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

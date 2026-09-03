// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A rounded-square avatar to replace the SDK's circular one.
///
/// From Step 6 of the
/// [Flutter Chat tutorial](https://getstream.io/chat/sdk/flutter/tutorial/).
/// Registered on the `avatar` component-builder slot in `tutorial_main_step6.dart`.
/// Because `avatar` is a single global slot, the change lands in the message
/// rows, the channel list, and the headers at once - including inside
/// [StreamChannelPage], which owns those widgets itself.
class RoundedAvatar extends StatelessWidget {
  const RoundedAvatar({super.key, required this.props});

  /// Everything the SDK would have used to draw the default avatar.
  final StreamAvatarProps props;

  @override
  Widget build(BuildContext context) {
    final imageUrl = props.imageUrl;
    final size = props.size?.value ?? StreamAvatarSize.lg.value;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: SizedBox.square(
        dimension: size,
        child: ColoredBox(
          color: props.backgroundColor ?? context.streamColorScheme.backgroundApp,
          child: imageUrl == null
              ? Center(child: props.placeholder(context))
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, _) => Center(child: props.placeholder(context)),
                ),
        ),
      ),
    );
  }
}

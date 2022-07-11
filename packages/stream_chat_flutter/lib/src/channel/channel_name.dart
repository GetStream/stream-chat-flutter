import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template channelName}
/// Displays the current [Channel] name using a [Text] widget.
///
/// The widget uses a [StreamBuilder] to render the channel information
/// image as soon as it updates.
/// {@endtemplate}
class ChannelName extends StatelessWidget {
  /// {@macro channelName}
  const ChannelName({
    super.key,
    this.textStyle,
    this.textOverflow = TextOverflow.ellipsis,
  });

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// How visual overflow should be handled.
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context);
    final channel = StreamChannel.of(context).channel;

    assert(channel.state != null, 'Channel ${channel.id} is not initialized');

    return BetterStreamBuilder<String>(
      stream: channel.nameStream,
      initialData: channel.name,
      builder: (context, channelName) => Text(
        channelName,
        style: textStyle,
        overflow: textOverflow,
      ),
      noDataBuilder: (context) => _NameGenerator(
        currentUser: client.currentUser!,
        members: channel.state!.members,
        textStyle: textStyle,
        textOverflow: textOverflow,
      ),
    );
  }
}

class _NameGenerator extends StatelessWidget {
  const _NameGenerator({
    required this.currentUser,
    required this.members,
    this.textStyle,
    this.textOverflow,
  });

  final User currentUser;
  final List<Member> members;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var channelName = context.translations.noTitleText;
        final otherMembers = members.where(
          (member) => member.userId != currentUser.id,
        );

        if (otherMembers.isNotEmpty) {
          if (otherMembers.length == 1) {
            final user = otherMembers.first.user;
            if (user != null) {
              channelName = user.name;
            }
          } else {
            final maxWidth = constraints.maxWidth;
            final maxChars = maxWidth / (textStyle?.fontSize ?? 1);
            var currentChars = 0;
            final currentMembers = <Member>[];
            otherMembers.forEach((element) {
              final newLength = currentChars + (element.user?.name.length ?? 0);
              if (newLength < maxChars) {
                currentChars = newLength;
                currentMembers.add(element);
              }
            });

            final exceedingMembers =
                otherMembers.length - currentMembers.length;
            channelName =
                '${currentMembers.map((e) => e.user?.name).join(', ')} '
                '${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
          }
        }

        return Text(
          channelName,
          style: textStyle,
          overflow: textOverflow,
        );
      },
    );
  }
}

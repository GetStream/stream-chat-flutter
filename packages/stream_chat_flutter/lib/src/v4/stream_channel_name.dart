import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// It shows the current [Channel] name using a [Text] widget.
///
/// The widget uses a [StreamBuilder] to render the channel information
/// image as soon as it updates.
class StreamChannelName extends StatelessWidget {
  /// Instantiate a new ChannelName
  StreamChannelName({
    super.key,
    required this.channel,
    this.textStyle,
    this.textOverflow = TextOverflow.ellipsis,
  }) : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        );

  /// The [Channel] to show the name for.
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// How visual overflow should be handled.
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) => BetterStreamBuilder<String>(
        stream: channel.nameStream,
        initialData: channel.name,
        builder: (context, channelName) => Text(
          channelName,
          style: textStyle,
          overflow: textOverflow,
        ),
        noDataBuilder: (context) => _generateName(
          channel.client.state.currentUser!,
          channel.state!.members,
        ),
      );

  Widget _generateName(
    User currentUser,
    List<Member> members,
  ) =>
      LayoutBuilder(
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
                final newLength =
                    currentChars + (element.user?.name.length ?? 0);
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

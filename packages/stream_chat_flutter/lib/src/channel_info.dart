import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter/src/extension.dart';

/// Widget which shows channel info
class ChannelInfo extends StatelessWidget {
  /// Constructor which creates a [ChannelInfo] widget
  const ChannelInfo({
    Key? key,
    required this.channel,
    this.textStyle,
    this.showTypingIndicator = true,
    this.parentId,
  }) : super(key: key);

  /// The channel about which the info is to be displayed
  final Channel channel;

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// If true the typing indicator will be rendered if a user is typing
  final bool showTypingIndicator;

  /// Id of the parent message in case of a thread
  final String? parentId;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    return BetterStreamBuilder<List<Member>>(
      stream: channel.state!.membersStream,
      initialData: channel.state!.members,
      builder: (context, data) => ConnectionStatusBuilder(
        statusBuilder: (context, status) {
          switch (status) {
            case ConnectionStatus.connected:
              return _buildConnectedTitleState(context, data);
            case ConnectionStatus.connecting:
              return _buildConnectingTitleState(context);
            case ConnectionStatus.disconnected:
              return _buildDisconnectedTitleState(context, client);
            default:
              return const Offstage();
          }
        },
      ),
    );
  }

  Widget _buildConnectedTitleState(
    BuildContext context,
    List<Member>? members,
  ) {
    Widget? alternativeWidget;

    final memberCount = channel.memberCount;
    if (memberCount != null && memberCount > 2) {
      var text = context.translations.membersCountText(memberCount);
      final watcherCount = channel.state?.watcherCount ?? 0;
      if (watcherCount > 0) {
        text += ' ${context.translations.watchersCountText(watcherCount)}';
      }
      alternativeWidget = Text(
        text,
        style: StreamChatTheme.of(context)
            .channelTheme
            .channelHeaderTheme
            .subtitle,
      );
    } else {
      final userId = StreamChat.of(context).currentUser?.id;
      final otherMember = members?.firstWhereOrNull(
        (element) => element.userId != userId,
      );

      if (otherMember != null) {
        if (otherMember.user?.online == true) {
          alternativeWidget = Text(
            context.translations.userOnlineText,
            style: textStyle,
          );
        } else {
          alternativeWidget = Text(
            '${context.translations.userLastOnlineText} '
            '${Jiffy(otherMember.user?.lastActive).fromNow()}',
            style: textStyle,
          );
        }
      }
    }

    if (!showTypingIndicator) {
      return alternativeWidget ?? const Offstage();
    }

    return TypingIndicator(
      parentId: parentId,
      alignment: Alignment.center,
      alternativeWidget: alternativeWidget,
      style: textStyle,
    );
  }

  Widget _buildConnectingTitleState(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
            width: 16,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            context.translations.searchingForNetworkText,
            style: textStyle,
          ),
        ],
      );

  Widget _buildDisconnectedTitleState(
    BuildContext context,
    StreamChatClient client,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.translations.offlineLabel,
            style: textStyle,
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
            onPressed: () => client
              ..closeConnection()
              ..openConnection(),
            child: Text(
              context.translations.tryAgainLabel,
              style: textStyle?.copyWith(
                color: StreamChatTheme.of(context).colorTheme.accentPrimary,
              ),
            ),
          ),
        ],
      );
}

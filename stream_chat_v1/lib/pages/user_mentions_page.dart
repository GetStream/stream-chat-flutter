import 'package:example/utils/localizations.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';

class UserMentionsPage extends StatefulWidget {
  @override
  State<UserMentionsPage> createState() => _UserMentionsPageState();
}

class _UserMentionsPageState extends State<UserMentionsPage> {
  late final controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
    messageFilter: Filter.custom(
      operator: r'$contains',
      key: 'mentioned_users.id',
      value: StreamChat.of(context).currentUser!.id,
    ),
    sort: [
      SortOption(
        'created_at',
        direction: SortOption.ASC,
      ),
    ],
    limit: 20,
  );
  @override
  Widget build(BuildContext context) {
    return StreamMessageSearchListView(
      controller: controller,
      emptyBuilder: (_) {
        return LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: StreamSvgIcon.mentions(
                          size: 96,
                          color:
                              StreamChatTheme.of(context).colorTheme.disabled,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).noMentionsExistYet,
                        style:
                            StreamChatTheme.of(context).textTheme.body.copyWith(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .textLowEmphasis,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      onMessageTap: (messageResponse) async {
        final client = StreamChat.of(context).client;
        final message = messageResponse.message;
        final channel = client.channel(
          messageResponse.channel!.type,
          id: messageResponse.channel!.id,
        );
        if (channel.state == null) {
          await channel.watch();
        }
        Navigator.pushNamed(
          context,
          Routes.CHANNEL_PAGE,
          arguments: ChannelPageArgs(
            channel: channel,
            initialMessage: message,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

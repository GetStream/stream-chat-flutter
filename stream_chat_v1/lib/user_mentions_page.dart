import 'package:example/localizations.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';

class UserMentionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).currentUser!;
    return MessageSearchBloc(
      child: MessageSearchListView(
        filters: Filter.in_('members', [user.id]),
        messageFilters: Filter.custom(
          operator: r'$contains',
          key: 'mentioned_users.id',
          value: user.id,
        ),
        sortOptions: [
          SortOption(
            'created_at',
            direction: SortOption.ASC,
          ),
        ],
        limit: 20,
        showResultCount: false,
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
                          style: StreamChatTheme.of(context)
                              .textTheme
                              .body
                              .copyWith(
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
        onItemTap: (messageResponse) async {
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
      ),
    );
  }
}

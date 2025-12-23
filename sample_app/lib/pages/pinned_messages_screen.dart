// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class PinnedMessagesScreen extends StatefulWidget {
  const PinnedMessagesScreen({super.key});

  @override
  State<PinnedMessagesScreen> createState() => _PinnedMessagesScreenState();
}

class _PinnedMessagesScreenState extends State<PinnedMessagesScreen> {
  late final controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'cid',
      [StreamChannel.of(context).channel.cid!],
    ),
    messageFilter: Filter.equal(
      'pinned',
      true,
    ),
    sort: [
      const SortOption.asc('created_at'),
    ],
    limit: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).pinnedMessages,
          style: TextStyle(
            color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
            fontSize: 16,
          ),
        ),
        leading: const StreamBackButton(),
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
      ),
      body: StreamMessageSearchListView(
        controller: controller,
        emptyBuilder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamSvgIcon(
                  icon: StreamSvgIcons.pin,
                  size: 136,
                  color: StreamChatTheme.of(context).colorTheme.disabled,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).noPinnedItems,
                  style: TextStyle(
                    fontSize: 17,
                    color:
                        StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${AppLocalizations.of(context).longPressMessage} ',
                      style: TextStyle(
                        fontSize: 14,
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textHighEmphasis
                            .withOpacity(0.5),
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context).pinToConversation,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textHighEmphasis
                            .withOpacity(0.5),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
        onMessageTap: (messageResponse) async {
          final client = StreamChat.of(context).client;
          final router = GoRouter.of(context);
          final message = messageResponse.message;
          final channel = client.channel(
            messageResponse.channel!.type,
            id: messageResponse.channel!.id,
          );
          if (channel.state == null) {
            await channel.watch();
          }
          router.pushNamed(
            Routes.CHANNEL_PAGE.name,
            pathParameters: Routes.CHANNEL_PAGE.params(channel),
            queryParameters: Routes.CHANNEL_PAGE.queryParams(message),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

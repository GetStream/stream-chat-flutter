// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class ChannelFileDisplayScreen extends StatefulWidget {
  const ChannelFileDisplayScreen({
    super.key,
    required this.messageTheme,
  });
  final StreamMessageThemeData messageTheme;

  @override
  State<ChannelFileDisplayScreen> createState() =>
      _ChannelFileDisplayScreenState();
}

class _ChannelFileDisplayScreenState extends State<ChannelFileDisplayScreen> {
  final Map<String?, VideoPlayerController?> controllerCache = {};

  late final controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'cid',
      [StreamChannel.of(context).channel.cid!],
    ),
    messageFilter: Filter.in_(
      'attachments.type',
      const ['file'],
    ),
    sort: [
      const SortOption(
        'created_at',
        direction: SortOption.ASC,
      ),
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
          AppLocalizations.of(context).files,
          style: TextStyle(
            color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
            fontSize: 16,
          ),
        ),
        leading: const StreamBackButton(),
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
      ),
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (
          BuildContext context,
          PagedValue<String, GetMessageResponse> value,
          Widget? child,
        ) {
          return value.when(
            (items, nextPageKey, error) {
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamSvgIcon(
                        icon: StreamSvgIcons.files,
                        size: 136,
                        color: StreamChatTheme.of(context).colorTheme.disabled,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context).noFiles,
                        style: TextStyle(
                          fontSize: 14,
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .textHighEmphasis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context).filesAppearHere,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .textHighEmphasis
                              .withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final media = <Attachment, Message>{};

              for (final item in items) {
                item.message.attachments
                    .where((e) => e.type == 'file')
                    .forEach((e) {
                  media[e] = item.message;
                });
              }

              return LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) {
                    controller.loadMore(nextPageKey);
                  }
                },
                child: ListView.builder(
                  itemBuilder: (context, position) {
                    return Padding(
                      padding: const EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: StreamFileAttachment(
                          message: media.values.toList()[position],
                          file: media.keys.toList()[position],
                        ),
                      ),
                    );
                  },
                  itemCount: media.length,
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (_) => const Offstage(),
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

  @override
  void initState() {
    controller.doInitialLoad();
    super.initState();
  }
}

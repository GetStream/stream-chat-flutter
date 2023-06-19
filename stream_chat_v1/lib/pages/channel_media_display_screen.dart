import 'package:example/utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

import '../routes/routes.dart';

class ChannelMediaDisplayScreen extends StatefulWidget {
  final StreamMessageThemeData messageTheme;

  const ChannelMediaDisplayScreen({
    Key? key,
    required this.messageTheme,
  }) : super(key: key);

  @override
  State<ChannelMediaDisplayScreen> createState() =>
      _ChannelMediaDisplayScreenState();
}

class _ChannelMediaDisplayScreenState extends State<ChannelMediaDisplayScreen> {
  final Map<String?, VideoPlayerController?> controllerCache = {};

  late final controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'cid',
      [StreamChannel.of(context).channel.cid!],
    ),
    messageFilter: Filter.in_(
      'attachments.type',
      const ['image', 'video'],
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
          AppLocalizations.of(context).photosAndVideos,
          style: TextStyle(
            color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
            fontSize: 16.0,
          ),
        ),
        leading: const StreamBackButton(),
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
      ),
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context,
            PagedValue<String, GetMessageResponse> value, Widget? child) {
          return value.when(
            (items, nextPageKey, error) {
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamSvgIcon.pictures(
                        size: 136.0,
                        color: StreamChatTheme.of(context).colorTheme.disabled,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        AppLocalizations.of(context).noMedia,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .textHighEmphasis,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        AppLocalizations.of(context)
                            .photosOrVideosWillAppearHere,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
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
              final media = <_AssetPackage>[];

              for (final item in value.asSuccess.items) {
                item.message.attachments
                    .where((e) =>
                        (e.type == 'image' || e.type == 'video') &&
                        e.ogScrapeUrl == null)
                    .forEach((e) {
                  VideoPlayerController? controller;
                  if (e.type == 'video') {
                    final cachedController = controllerCache[e.assetUrl];

                    if (cachedController == null) {
                      controller = VideoPlayerController.network(e.assetUrl!);
                      controller.initialize();
                      controllerCache[e.assetUrl] = controller;
                    } else {
                      controller = cachedController;
                    }
                  }
                  media.add(_AssetPackage(e, item.message, controller));
                });
              }

              return LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) {
                    controller.loadMore(nextPageKey);
                  }
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, position) {
                    var channel = StreamChannel.of(context).channel;
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StreamChannel(
                                channel: channel,
                                child: StreamFullScreenMedia(
                                  mediaAttachmentPackages: media
                                      .map(
                                        (e) => StreamAttachmentPackage(
                                          attachment: e.attachment,
                                          message: e.message,
                                        ),
                                      )
                                      .toList(),
                                  startIndex: position,
                                  userName: media[position].message.user!.name,
                                  onShowMessage: (m, c) async {
                                    final router = GoRouter.of(context);
                                    if (channel.state == null) {
                                      await channel.watch();
                                    }
                                    router.pushNamed(
                                      Routes.CHANNEL_PAGE.name,
                                      pathParameters:
                                          Routes.CHANNEL_PAGE.params(channel),
                                      queryParameters:
                                          Routes.CHANNEL_PAGE.queryParams(m),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        child: media[position].attachment.type == 'image'
                            ? IgnorePointer(
                                child: StreamImageAttachment(
                                  attachment: media[position].attachment,
                                  message: media[position].message,
                                  showTitle: false,
                                  messageTheme: widget.messageTheme,
                                ),
                              )
                            : VideoPlayer(media[position].videoPlayer!),
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

class _AssetPackage {
  Attachment attachment;
  Message message;
  VideoPlayerController? videoPlayer;

  _AssetPackage(this.attachment, this.message, this.videoPlayer);
}

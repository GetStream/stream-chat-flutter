import 'package:example/localizations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class ChannelMediaDisplayScreen extends StatefulWidget {
  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created_at or member_count.
  /// Direction can be ascending or descending.
  final List<SortOption>? sortOptions;

  /// Pagination parameters
  /// limit: the number of users to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams paginationParams;

  /// The builder used when the file list is empty.
  final WidgetBuilder? emptyBuilder;

  final ShowMessageCallback? onShowMessage;

  final StreamMessageThemeData messageTheme;

  const ChannelMediaDisplayScreen({
    required this.messageTheme,
    this.sortOptions,
    this.paginationParams = const PaginationParams(limit: 20),
    this.emptyBuilder,
    this.onShowMessage,
  });

  @override
  _ChannelMediaDisplayScreenState createState() =>
      _ChannelMediaDisplayScreenState();
}

class _ChannelMediaDisplayScreenState extends State<ChannelMediaDisplayScreen> {
  Map<String?, VideoPlayerController?> controllerCache = {};

  @override
  void initState() {
    super.initState();
    final messageSearchBloc = MessageSearchBloc.of(context);
    messageSearchBloc.search(
      filter: Filter.in_(
        'cid',
        [StreamChannel.of(context).channel.cid!],
      ),
      messageFilter: Filter.in_(
        'attachments.type',
        ['image', 'video'],
      ),
      sort: widget.sortOptions,
      pagination: widget.paginationParams,
    );
  }

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
        leading: StreamBackButton(),
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
      ),
      body: _buildMediaGrid(),
    );
  }

  Widget _buildMediaGrid() {
    final messageSearchBloc = MessageSearchBloc.of(context);

    return StreamBuilder<List<GetMessageResponse>>(
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) {
          if (widget.emptyBuilder != null) {
            return widget.emptyBuilder!(context);
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamSvgIcon.pictures(
                  size: 136.0,
                  color: StreamChatTheme.of(context).colorTheme.disabled,
                ),
                SizedBox(height: 16.0),
                Text(
                  AppLocalizations.of(context).noMedia,
                  style: TextStyle(
                    fontSize: 14.0,
                    color:
                        StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  AppLocalizations.of(context).photosOrVideosWillAppearHere,
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

        for (var item in snapshot.data!) {
          item.message.attachments
              .where((e) =>
                  (e.type == 'image' || e.type == 'video') &&
                  e.ogScrapeUrl == null)
              .forEach((e) {
            VideoPlayerController? controller;
            if (e.type == 'video') {
              var cachedController = controllerCache[e.assetUrl];

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
          onEndOfPage: () => messageSearchBloc.search(
            filter: Filter.in_(
              'cid',
              [StreamChannel.of(context).channel.cid!],
            ),
            messageFilter: Filter.in_(
              'attachments.type',
              ['image', 'video'],
            ),
            sort: widget.sortOptions,
            pagination: widget.paginationParams.copyWith(
              offset: messageSearchBloc.messageResponses?.length ?? 0,
            ),
          ),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
                            onShowMessage: widget.onShowMessage,
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
                            size: Size(
                              MediaQuery.of(context).size.width * 0.8,
                              MediaQuery.of(context).size.height * 0.3,
                            ),
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
      stream: messageSearchBloc.messagesStream,
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (var c in controllerCache.values) {
      c!.dispose();
    }
  }
}

class _AssetPackage {
  Attachment attachment;
  Message message;
  VideoPlayerController? videoPlayer;

  _AssetPackage(this.attachment, this.message, this.videoPlayer);
}

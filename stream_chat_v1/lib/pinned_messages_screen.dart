import 'package:example/localizations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class PinnedMessagesScreen extends StatefulWidget {
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

  const PinnedMessagesScreen({
    required this.messageTheme,
    this.sortOptions,
    this.paginationParams = const PaginationParams(limit: 20),
    this.emptyBuilder,
    this.onShowMessage,
  });

  @override
  _PinnedMessagesScreenState createState() => _PinnedMessagesScreenState();
}

class _PinnedMessagesScreenState extends State<PinnedMessagesScreen> {
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
      messageFilter: Filter.equal(
        'pinned',
        true,
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
          AppLocalizations.of(context).pinnedMessages,
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
                StreamSvgIcon.pin(
                  size: 136.0,
                  color: StreamChatTheme.of(context).colorTheme.disabled,
                ),
                SizedBox(height: 16.0),
                Text(
                  AppLocalizations.of(context).noPinnedItems,
                  style: TextStyle(
                    fontSize: 17.0,
                    color:
                        StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${AppLocalizations.of(context).longPressMessage} ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textHighEmphasis
                            .withOpacity(0.5),
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context).pinToConversation,
                      style: TextStyle(
                        fontSize: 14.0,
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
        }

        var data = snapshot.data ?? [];

        return LazyLoadScrollView(
          onEndOfPage: () => messageSearchBloc.search(
            filter: Filter.in_(
              'cid',
              [StreamChannel.of(context).channel.cid!],
            ),
            messageFilter: Filter.equal(
              'pinned',
              true,
            ),
            sort: widget.sortOptions,
            pagination: widget.paginationParams.copyWith(
              offset: messageSearchBloc.messageResponses?.length ?? 0,
            ),
          ),
          child: ListView.builder(
            itemBuilder: (context, position) {
              var user = data[position].message.user!;
              var attachments = data[position].message.attachments;
              var text = data[position].message.text ?? '';

              return ListTile(
                leading: StreamUserAvatar(
                  user: user,
                  constraints: BoxConstraints.tightFor(
                    width: 40.0,
                    height: 40.0,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                title: Text(
                  user.name,
                  style: TextStyle(
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .textHighEmphasis,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  text != ''
                      ? text
                      : (attachments.isNotEmpty
                          ? '${attachments.length} ${attachments.length > 1 ? AppLocalizations.of(context).attachments : AppLocalizations.of(context).attachment}'
                          : ''),
                ),
                onTap: () {
                  widget.onShowMessage?.call(data[position].message,
                      StreamChannel.of(context).channel);
                },
              );
            },
            itemCount: snapshot.data!.length,
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

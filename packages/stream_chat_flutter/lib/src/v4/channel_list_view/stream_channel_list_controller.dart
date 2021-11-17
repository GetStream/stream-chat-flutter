import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter/src/paged_value_notifier.dart';

class StreamChannelListController extends PagedValueNotifier<int, Channel> {
  /// Creates a [StreamChannelListController].
  StreamChannelListController({
    required this.client,
    this.filter,
    this.sort,
    this.limit = 2,
    this.messageLimit,
    this.memberLimit,
  }) : super(const PagedValue.loading());

  /// Creates a [StreamChannelListController] from the passed [value].
  StreamChannelListController.fromValue(
    PagedValue<int, Channel> value, {
    required this.client,
    this.filter,
    this.sort,
    this.limit = 2,
    this.messageLimit,
    this.memberLimit,
  }) : super(value);

  /// The client to use for the channel list.
  final StreamChatClient client;

  /// The filter to apply to the channel list.
  final Filter? filter;

  /// The sort to apply to the channel list.
  final List<SortOption<ChannelModel>>? sort;

  /// The limit to apply to the channel list.
  final int limit;

  /// The limit to apply to the message list.
  final int? messageLimit;

  /// The limit to apply to the member list.
  final int? memberLimit;

  @override
  Future<void> doInitialLoad() async {
    final limit = this.limit * defaultInitialPagedLimitMultiplier;
    try {
      await for (final channels in client.queryChannels(
        filter: filter,
        sort: sort,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        paginationParams: PaginationParams(limit: limit),
      )) {
        final nextKey = channels.length < limit ? null : channels.length;
        value = PagedValue(
          items: channels,
          nextPageKey: nextKey,
        );
      }
    } catch (error) {
      value = PagedValue.error(StreamChatError('error'));
    }
  }

  @override
  Future<void> loadMore(int nextPageKey) async {
    assert(value is Success<int, Channel>, '');
    final previousValue = value as Success<int, Channel>;

    try {
      await for (final channels in client.queryChannels(
        filter: filter,
        sort: sort,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        paginationParams: PaginationParams(limit: limit, offset: nextPageKey),
      )) {
        final previousItems = previousValue.items;
        final newItems = previousItems + channels;
        final nextKey = channels.length < limit ? null : newItems.length;
        value = PagedValue(
          items: newItems,
          nextPageKey: nextKey,
        );
      }
    } catch (error) {
      value = previousValue.copyWith(error: StreamChatError('error'));
    }
  }
}

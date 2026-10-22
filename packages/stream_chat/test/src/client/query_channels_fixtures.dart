import 'package:collection/collection.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

/// A generated channel query answer carrying the channel of each state in
/// [channelStates], with [predefinedFilter] as the filter the query resolved
/// to.
///
/// Throws if a state carries more than its channel, which this answer would
/// drop.
api.QueryChannelsResponse generatedQueryChannelsResponse(
  List<ChannelState> channelStates, {
  PredefinedFilter? predefinedFilter,
}) => api.QueryChannelsResponse(
  duration: '0.01ms',
  channels: [for (final channelState in channelStates) _generatedChannelState(channelState)],
  predefinedFilter: switch (predefinedFilter) {
    final filter? => api.ParsedPredefinedFilterResponse(
      name: filter.name,
      filter: filter.filter.toJson(),
      sort: filter.sort
          ?.map((sort) => api.SortParamRequest(field: sort.field.remote, direction: sort.direction.value))
          .toList(),
    ),
    null => null,
  },
);

api.ChannelStateResponseFields _generatedChannelState(ChannelState channelState) {
  if ([
    channelState.messages,
    channelState.members,
    channelState.pinnedMessages,
    channelState.read,
    channelState.watchers,
    channelState.membership,
  ].any((it) => it != null)) {
    throw ArgumentError.value(channelState, 'channelState', 'carries more than its channel');
  }

  final channel = channelState.channel!;
  return api.ChannelStateResponseFields(
    channel: api.ChannelResponse(
      cid: channel.cid,
      id: channel.id,
      type: channel.type,
      createdAt: channel.createdAt,
      updatedAt: channel.updatedAt,
      lastMessageAt: channel.lastMessageAt,
      custom: channel.custom,
      memberCount: channel.memberCount,
      disabled: false,
      frozen: channel.frozen,
    ),
    members: const [],
    messages: const [],
    pinnedMessages: const [],
    threads: const [],
  );
}

/// Matches a generated channel query request whose filter serializes like
/// [filter] and which carries [limit], [predefinedFilter], [filterValues],
/// [sortValues] and [messageLimit], each only when given.
Matcher isChannelQuery({
  Filter<Object>? filter,
  int? limit,
  String? predefinedFilter,
  Map<String, Object?>? filterValues,
  Map<String, Object?>? sortValues,
  Object? messageLimit = _anyValue,
}) => predicate<api.QueryChannelsRequest>(
  (request) =>
      (filter == null || const DeepCollectionEquality().equals(request.filterConditions, filter.toJson())) &&
      (limit == null || request.limit == limit) &&
      (predefinedFilter == null || request.predefinedFilter == predefinedFilter) &&
      (filterValues == null || const DeepCollectionEquality().equals(request.filterValues, filterValues)) &&
      (sortValues == null || const DeepCollectionEquality().equals(request.sortValues, sortValues)) &&
      (identical(messageLimit, _anyValue) || request.messageLimit == messageLimit),
  'a channel query request',
);

const _anyValue = Object();

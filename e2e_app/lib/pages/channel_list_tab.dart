import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../navigation.dart';
import '../widgets/search_text_field.dart';
import 'channel_actions_sheet.dart';

/// What the search field searches.
enum SearchScope { messages, channels }

/// The channel list, with a search field that searches either messages or
/// channels by name.
class ChannelListTab extends StatefulWidget {
  const ChannelListTab({super.key});

  @override
  State<ChannelListTab> createState() => _ChannelListTabState();
}

class _ChannelListTabState extends State<ChannelListTab> {
  late final _client = StreamChat.of(context).client;
  late final _userId = StreamChat.of(context).currentUser!.id;

  late final _channelListController = StreamChannelListController(
    client: _client,
    filter: Filter.in_('members', [_userId]),
    limit: 30,
  );

  late final _messageSearchController = StreamMessageSearchListController(
    client: _client,
    filter: Filter.in_('members', [_userId]),
    limit: 5,
    searchQuery: '',
  );

  final _searchController = TextEditingController();
  var _query = '';
  var _scope = SearchScope.messages;
  StreamChannelListController? _channelSearchController;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    final query = _searchController.text;
    if (query == _query) return;
    _search(query);
  }

  void _onScopeChanged(SearchScope scope) {
    setState(() => _scope = scope);
    _search(_query);
  }

  void _search(String query) {
    setState(() => _query = query);
    if (query.isEmpty) return _messageSearchController.clearResults();

    switch (_scope) {
      case SearchScope.messages:
        _messageSearchController.search(query);
      case SearchScope.channels:
        _channelSearchController?.dispose();
        _channelSearchController = StreamChannelListController(
          client: _client,
          filter: Filter.and([
            Filter.in_('members', [_userId]),
            Filter.autoComplete('name', query),
          ]),
          limit: 30,
        );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _channelListController.dispose();
    _messageSearchController.dispose();
    _channelSearchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _query.isNotEmpty;

    return Column(
      children: [
        SearchTextField(controller: _searchController),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            children: [
              for (final scope in SearchScope.values)
                ChoiceChip(
                  label: Text(switch (scope) {
                    SearchScope.messages => 'Messages',
                    SearchScope.channels => 'Channels',
                  }),
                  selected: _scope == scope,
                  onSelected: (_) => _onScopeChanged(scope),
                ),
            ],
          ),
        ),
        Expanded(
          child: switch ((isSearching, _scope)) {
            (false, _) => _ChannelList(controller: _channelListController),
            (true, SearchScope.messages) => StreamMessageSearchListView(
              controller: _messageSearchController,
              onMessageTap: (response) {
                final channel = response.channel!;
                openMessage(context, _client.channel(channel.type, id: channel.id), response.message.id).ignore();
              },
            ),
            (true, SearchScope.channels) => StreamChannelListView(
              key: ValueKey(_query),
              controller: _channelSearchController!,
              onChannelTap: (channel) => openChannel(context, channel),
            ),
          },
        ),
      ],
    );
  }
}

class _ChannelList extends StatelessWidget {
  const _ChannelList({required this.controller});

  final StreamChannelListController controller;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final colorScheme = context.streamColorScheme;

    return SlidableAutoCloseBehavior(
      child: StreamChannelListView(
        controller: controller,
        itemBuilder: (context, channels, index, defaultWidget) {
          final channel = channels[index];
          return Slidable(
            groupTag: 'channel-actions',
            endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: const BehindMotion(),
              children: [
                CustomSlidableAction(
                  backgroundColor: colorScheme.backgroundSurface,
                  onPressed: (_) => showChannelActionsSheet(context, channel),
                  child: Icon(icons.moreHorizontal, size: 20),
                ),
                BetterStreamBuilder<bool>(
                  stream: channel.isMutedStream,
                  initialData: channel.isMuted,
                  builder: (context, isMuted) => CustomSlidableAction(
                    backgroundColor: colorScheme.accentPrimary,
                    onPressed: (_) => (isMuted ? channel.unmute() : channel.mute()).ignore(),
                    child: Icon(isMuted ? icons.audio : icons.mute, size: 20),
                  ),
                ),
              ],
            ),
            child: defaultWidget,
          );
        },
        onChannelTap: (channel) => openChannel(context, channel),
        onChannelLongPress: (channel) => showChannelActionsSheet(context, channel),
      ),
    );
  }
}

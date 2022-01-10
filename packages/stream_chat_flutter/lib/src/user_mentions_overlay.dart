import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/custom_text_controller.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/user_mention_tile.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Builder function for building a mention tile.
///
/// Use [UserMentionTile] for the default implementation.
typedef MentionTileBuilder = Widget Function(
  BuildContext context,
  User user,
);

/// Overlay for displaying users that can be mentioned.
class UserMentionsOverlay extends StatefulWidget {
  /// Constructor for creating a [UserMentionsOverlay].
  UserMentionsOverlay({
    Key? key,
    required this.controller,
    required this.query,
    required this.channel,
    required this.size,
    this.client,
    this.limit = 10,
    this.mentionAllAppUsers = false,
    this.mentionsTileBuilder,
    this.onMentionUserTap,
  })  : assert(
          channel.state != null,
          'Channel ${channel.cid} is not yet initialized',
        ),
        assert(
          !mentionAllAppUsers || (mentionAllAppUsers && client != null),
          'StreamChatClient is required in order to use mentionAllAppUsers',
        ),
        super(key: key);

  /// Query for searching users.
  final CustomTextController controller;

  /// Query for searching users.
  final String query;

  /// Limit applied on user search results.
  final int limit;

  /// The size of the overlay.
  final Size size;

  /// The channel to search for users.
  final Channel channel;

  /// The client to search for users in case [mentionAllAppUsers] is True.
  final StreamChatClient? client;

  /// When enabled mentions search users across the entire app.
  ///
  /// Defaults to false.
  final bool mentionAllAppUsers;

  /// Customize the tile for the mentions overlay.
  final MentionTileBuilder? mentionsTileBuilder;

  /// Callback called when a user is selected.
  final void Function(User user)? onMentionUserTap;

  @override
  _UserMentionsOverlayState createState() => _UserMentionsOverlayState();
}

class _UserMentionsOverlayState extends State<UserMentionsOverlay> {
  late Future<List<User>> userMentionsFuture;

  @override
  void initState() {
    super.initState();
    userMentionsFuture = queryMentions(widget.query);
  }

  @override
  void didUpdateWidget(covariant UserMentionsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.channel != oldWidget.channel ||
        widget.query != oldWidget.query ||
        widget.mentionAllAppUsers != oldWidget.mentionAllAppUsers ||
        widget.limit != oldWidget.limit) {
      userMentionsFuture = queryMentions(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.6),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints.loose(widget.size),
              decoration: BoxDecoration(color: theme.colorTheme.barsBg),
              child: FutureBuilder<List<User>>(
                future: userMentionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Offstage();
                  if (!snapshot.hasData) return const Offstage();
                  final now = DateTime.now();
                  widget.controller.addUsers(snapshot.data!.toSet());
                  final users = snapshot.data!.take(4).toList()
                    ..sort((a, b) =>
                        (b.lastActive ?? now).compareTo(a.lastActive ?? now));

                  return ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Material(
                        color: theme.colorTheme.barsBg,
                        child: InkWell(
                          onTap: () => widget.onMentionUserTap?.call(user),
                          child:
                              widget.mentionsTileBuilder?.call(context, user) ??
                                  UserMentionTile(user),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<User> get membersAndWatchers {
    final state = widget.channel.state!;
    return {
      ...state.watchers,
      ...state.members.map((it) => it.user),
    }.whereType<User>().toList(growable: false);
  }

  Future<List<User>> queryMentions(String query) async {
    if (widget.mentionAllAppUsers) {
      return _queryUsers(query);
    }

    var channelState = widget.channel.state;

    channelState = channelState!;
    final members = channelState.members;

    // By default, we return maximum 100 members via queryChannels api call.
    // Thus it is safe to assume, that if number of members in channel.state
    // is < 100, then all the members are already available on client side
    // and we don't need to make any api call to queryMembers endpoint.
    if (members.length < 100) {
      final matchingUsers = membersAndWatchers.search(query);
      return matchingUsers.toList(growable: false);
    }

    final result = await _queryMembers(query);
    return result
        .map((it) => it.user)
        .whereType<User>()
        .toList(growable: false);
  }

  Future<List<Member>> _queryMembers(String query) async {
    final response = await widget.channel.queryMembers(
      pagination: PaginationParams(limit: widget.limit),
      filter: query.isEmpty
          ? const Filter.empty()
          : Filter.autoComplete('name', query),
    );
    return response.members;
  }

  Future<List<User>> _queryUsers(String query) async {
    assert(
      widget.client != null,
      'StreamChatClient is required in order to query all app users',
    );
    final response = await widget.client!.queryUsers(
      pagination: PaginationParams(limit: widget.limit),
      filter: query.isEmpty
          ? Filter.notEqual('id', 'system')
          : Filter.and([
              Filter.autoComplete('name', query),
              Filter.notEqual('id', 'system'),
            ]),
      sort: [const SortOption('last_active', direction: SortOption.DESC)],
    );
    return response.users;
  }
}

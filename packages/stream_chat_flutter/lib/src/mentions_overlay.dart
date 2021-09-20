import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Overlay for displaying users that can be mentioned
class MentionsOverlay extends StatelessWidget {
  /// Constructor for creating a [MentionsOverlay]
  const MentionsOverlay({
    required this.query,
    required this.onMentionResult,
    required this.size,
    required this.channel,
    this.mentionsTileBuilder,
    Key? key,
  }) : super(key: key);

  /// The size of the overlay
  final Size size;

  /// Query for searching users
  final String query;

  /// The channel to search for users
  final Channel channel;

  /// Callback called when a user is selected
  final ValueChanged<User?> onMentionResult;

  /// Customize the tile for the mentions overlay
  final MentionTileBuilder? mentionsTileBuilder;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);

    Future<List<Member>>? queryMembers;

    if (query.isNotEmpty) {
      queryMembers = channel
          .queryMembers(filter: Filter.autoComplete('name', query))
          .then((res) => res.members);
    }

    final members = channel.state?.members
            .where((m) => m.user?.name.toLowerCase().contains(query) == true)
            .toList() ??
        [];

    if (members.isEmpty) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      color: _streamChatTheme.colorTheme.barsBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: BoxConstraints.loose(size),
        decoration: BoxDecoration(
          color: _streamChatTheme.colorTheme.barsBg,
        ),
        child: FutureBuilder<List<Member>>(
          future: queryMembers ?? Future.value(members),
          initialData: members,
          builder: (context, snapshot) => ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 8,
              ),
              ...snapshot.data!
                  .where((it) => it.user != null)
                  .map(
                    (m) => Material(
                      color: _streamChatTheme.colorTheme.barsBg,
                      child: InkWell(
                        onTap: () {
                          onMentionResult(m.user);
                        },
                        child: mentionsTileBuilder != null
                            ? mentionsTileBuilder!(context, m)
                            : MentionTile(m),
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

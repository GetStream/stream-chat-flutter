import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Overlay for displaying users that can be mentioned
class MentionsOverlay extends StatelessWidget {
  /// Constructor for creating a [MentionsOverlay]
  const MentionsOverlay(
    this.context, {
    required this.query,
    required this.onMentionResult,
    this.mentionsTileBuilder,
    Key? key,
  }) : super(key: key);

  /// Context of the upper tree
  final BuildContext context;

  /// Query for searching users
  final String query;

  /// Callback called when a user is selected
  final ValueChanged<User?> onMentionResult;

  /// Customize the tile for the mentions overlay
  final MentionTileBuilder? mentionsTileBuilder;

  @override
  Widget build(BuildContext otherContext) {
    final _streamChatTheme = StreamChatTheme.of(context);

    Future<List<Member>>? queryMembers;

    final channelState = StreamChannel.of(context);
    if (query.isNotEmpty) {
      queryMembers = channelState.channel
          .queryMembers(filter: Filter.autoComplete('name', query))
          .then((res) => res.members);
    }

    final members = channelState.channel.state?.members
            .where((m) => m.user?.name.toLowerCase().contains(query) == true)
            .toList() ??
        [];

    if (members.isEmpty) {
      return const SizedBox();
    }

    // ignore: cast_nullable_to_non_nullable
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final child = Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      color: _streamChatTheme.colorTheme.barsBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: BoxConstraints.loose(Size(size.width - 16, 200)),
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
      builder: (context, val, child) => Transform.scale(
        scale: val,
        child: child,
      ),
      child: child,
    );
  }
}

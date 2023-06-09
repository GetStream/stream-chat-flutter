import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class DebugMembers extends StatelessWidget {
  const DebugMembers({
    super.key,
    required this.members,
  });

  final List<Member> members;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.orange,
          padding: const EdgeInsets.all(8),
          child: const Text('Members'),
        ),
        Container(
          color: Colors.orange,
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            itemBuilder: (BuildContext context, int index) {
              final member = members[index];
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(member.user?.name ?? '?'),
                        Text('ID: ${member.user?.id ?? '?'}'),
                        Text('Ban: ${member.banned ? 'T' : 'F'}'),
                        Text('ShBan: ${member.shadowBanned ? 'T' : 'F'}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

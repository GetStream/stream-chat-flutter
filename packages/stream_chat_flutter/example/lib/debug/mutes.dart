import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class DebugMutes extends StatelessWidget {
  const DebugMutes({super.key, required this.mutes});

  final List<Mute> mutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.lightBlueAccent,
          padding: const EdgeInsets.all(8),
          child: const Text('Mutes'),
        ),
        Container(
          color: Colors.lightBlueAccent,
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mutes.length,
            itemBuilder: (BuildContext context, int index) {
              final mute = mutes[index];
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
                        Text('By: ${mute.user.name} (${mute.user.id})'),
                        Text(
                          'Who: ${mute.target.name} (${mute.target.id})',
                        ),
                        Text('Exp: ${mute.expires}'),
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

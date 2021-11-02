import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CountdownButton extends StatelessWidget {
  const CountdownButton({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: StreamChatTheme.of(context).colorTheme.disabled,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: Text('$count'),
            ),
          ),
        ),
      );
}

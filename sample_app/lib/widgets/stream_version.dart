import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:yaml/yaml.dart';

class StreamVersion extends StatelessWidget {
  const StreamVersion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.bottomCenter,
      child: FutureBuilder<String>(
        future: rootBundle.loadString('pubspec.lock'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          final pubspec = snapshot.data!;
          final yaml = loadYaml(pubspec);
          final streamChatDep =
              yaml['packages']['stream_chat_flutter']['version'];

          return Text(
            '${AppLocalizations.of(context).streamSDK} v $streamChatDep',
            style: TextStyle(
              fontSize: 14,
              color: StreamChatTheme.of(context).colorTheme.disabled,
            ),
          );
        },
      ),
    );
  }
}

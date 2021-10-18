import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Overlay for displaying commands that can be used
class CommandsOverlay extends StatelessWidget {
  /// Constructor for creating a [CommandsOverlay]
  const CommandsOverlay({
    required this.text,
    required this.onCommandResult,
    required this.size,
    required this.channel,
    Key? key,
  }) : super(key: key);

  /// The size of the overlay
  final Size size;

  /// Query for searching commands
  final String text;

  /// The channel to search for users
  final Channel channel;

  /// Callback called when a command is selected
  final ValueChanged<Command> onCommandResult;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    final commands = channel.config?.commands
            .where((c) => c.name.contains(text.replaceFirst('/', '')))
            .toList() ??
        [];

    if (commands.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: _streamChatTheme.colorTheme.barsBg,
        clipBehavior: Clip.hardEdge,
        child: Container(
          constraints: BoxConstraints.loose(size),
          decoration: BoxDecoration(
            color: _streamChatTheme.colorTheme.barsBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              if (commands.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: StreamSvgIcon.lightning(
                          color: _streamChatTheme.colorTheme.accentPrimary,
                        ),
                      ),
                      Text(
                        context.translations.instantCommandsLabel,
                        style: TextStyle(
                          color: _streamChatTheme.colorTheme.textHighEmphasis
                              .withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              ...commands
                  .map(
                    (c) => InkWell(
                      onTap: () {
                        onCommandResult(c);
                      },
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            _buildCommandIcon(_streamChatTheme, c.name),
                            const SizedBox(
                              width: 8,
                            ),
                            Text.rich(
                              TextSpan(
                                text: c.name.capitalize(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '   /${c.name} ${c.args}',
                                    style: _streamChatTheme.textTheme.body
                                        .copyWith(
                                      // ignore: lines_longer_than_80_chars
                                      color: _streamChatTheme
                                          // ignore: lines_longer_than_80_chars
                                          .colorTheme
                                          .textLowEmphasis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommandIcon(
    StreamChatThemeData _streamChatTheme,
    String iconType,
  ) {
    switch (iconType) {
      case 'giphy':
        return CircleAvatar(
          radius: 12,
          child: StreamSvgIcon.giphyIcon(
            size: 24,
          ),
        );
      case 'ban':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.iconUserDelete(
            size: 16,
            color: Colors.white,
          ),
        );
      case 'flag':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.flag(
            size: 14,
            color: Colors.white,
          ),
        );
      case 'imgur':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: ClipOval(
            child: StreamSvgIcon.imgur(
              size: 24,
            ),
          ),
        );
      case 'mute':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.mute(
            size: 16,
            color: Colors.white,
          ),
        );
      case 'unban':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.userAdd(
            size: 16,
            color: Colors.white,
          ),
        );
      case 'unmute':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.volumeUp(
            size: 16,
            color: Colors.white,
          ),
        );
      default:
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.lightning(
            size: 16,
            color: Colors.white,
          ),
        );
    }
  }
}

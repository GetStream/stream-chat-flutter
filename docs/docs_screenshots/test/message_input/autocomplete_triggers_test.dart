import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

/// Overlay for displaying emoji that can be used.
/// This is a verbatim copy of the sample in the docs to ensure it compiles.
class StreamEmojiAutocompleteOptions extends StatelessWidget {
  /// Constructor for creating a [StreamEmojiAutocompleteOptions]
  const StreamEmojiAutocompleteOptions({
    super.key,
    required this.query,
    this.onEmojiSelected,
    this.style = AutocompleteOptionsStyle.fixed,
  });

  /// Query for searching emoji.
  final String query;

  /// Callback called when an emoji is selected.
  final ValueSetter<Emoji>? onEmojiSelected;

  /// The visual style of the autocomplete options overlay.
  ///
  /// Defaults to [AutocompleteOptionsStyle.fixed].
  final AutocompleteOptionsStyle style;

  @override
  Widget build(BuildContext context) {
    final emojis = Emoji.all().where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedShortName = it.shortName.toUpperCase();

      return normalizedShortName.contains(normalizedQuery);
    });

    if (emojis.isEmpty) return const SizedBox.shrink();

    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final (:elevation, :margin, :shape) = style.resolve(colorScheme.borderDefault);

    return StreamAutocompleteOptions<Emoji>(
      options: emojis,
      elevation: elevation,
      margin: margin,
      shape: shape,
      maxHeight: 208,
      optionBuilder: (context, emoji) {
        return ListTile(
          dense: true,
          horizontalTitleGap: context.streamSpacing.sm,
          leading: StreamEmoji(emoji: StreamUnicodeEmoji(emoji.char), size: StreamEmojiSize.md),
          title: SubstringHighlight(
            text: emoji.shortName,
            term: query,
            textStyleHighlight: textTheme.bodyDefault.copyWith(
              color: colorScheme.accentPrimary,
              fontWeight: FontWeight.bold,
            ),
            textStyle: textTheme.bodyDefault.copyWith(
              color: colorScheme.textPrimary,
            ),
          ),
          onTap: onEmojiSelected == null ? null : () => onEmojiSelected!(emoji),
        );
      },
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  docsGoldenTest(
    'mention autocomplete trigger',
    fileName: 'autocomplete_trigger_mention',
    constraints: const BoxConstraints.tightFor(width: 375, height: 290),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      final members = [
        noahSmith,
        liamJohnson,
        miaThompson,
        ethanWilson,
      ].map((user) => Member(userId: user.id, user: user)).toList();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        members: members,
      );

      when(() => channelState.watchers).thenReturn([]);

      final messageComposerController = StreamMessageComposerController()..message = Message(text: 'Hello @');

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamMentionAutocompleteOptions(
                  query: '',
                  channel: channel,
                ),
                StreamMessageComposer(messageComposerController: messageComposerController),
              ],
            ),
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'commands autocomplete trigger',
    fileName: 'autocomplete_trigger_commands',
    constraints: const BoxConstraints.tightFor(width: 375, height: 340),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
      );

      when(() => channel.config).thenReturn(
        ChannelConfig(
          commands: [
            Command(
              name: 'giphy',
              description: 'Post a random gif to the channel',
              args: '[text]',
            ),
            Command(
              name: 'ban',
              description: 'Ban a user',
              args: '@username [text]',
            ),
            Command(
              name: 'flag',
              description: 'Flag a message',
              args: '[messageId]',
            ),
            Command(
              name: 'mute',
              description: 'Mute a user',
              args: '@username',
            ),
          ],
        ),
      );

      final messageComposerController = StreamMessageComposerController()..message = Message(text: '/');

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamCommandAutocompleteOptions(
                  query: '',
                  channel: channel,
                ),
                StreamMessageComposer(messageComposerController: messageComposerController),
              ],
            ),
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'emoji autocomplete trigger',
    fileName: 'autocomplete_trigger_emoji',
    constraints: const BoxConstraints.tightFor(width: 375, height: 380),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
      );

      final messageComposerController = StreamMessageComposerController()
        ..message = Message(text: 'Hello :smile');

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamEmojiAutocompleteOptions(
                  query: 'smile',
                  onEmojiSelected: (_) {},
                ),
                StreamMessageComposer(
                  messageComposerController: messageComposerController,
                  customAutocompleteTriggers: [
                    StreamAutocompleteTrigger(
                      trigger: ':',
                      minimumRequiredCharacters: 2,
                      optionsViewBuilder: (context, autocompleteQuery, _) {
                        return StreamEmojiAutocompleteOptions(
                          query: autocompleteQuery.query,
                          onEmojiSelected: (emoji) {
                            StreamAutocomplete.of(context).acceptAutocompleteOption(
                              emoji.char,
                              keepTrigger: false,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

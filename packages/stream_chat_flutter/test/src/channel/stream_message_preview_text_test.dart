import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late OwnUser currentUser;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    currentUser = OwnUser(id: 'test-user-id', name: 'Test User');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);
  });

  // Helper to pump the message preview widget
  Future<void> pumpMessagePreview(
    WidgetTester tester,
    Message message, {
    String? language,
    TextStyle? textStyle,
    ChannelModel? channel,
    StreamChatConfigurationData? configData,
  }) async {
    final client = MockClient();
    final clientState = MockClientState();
    final currentUser = OwnUser(id: 'test-user-id', name: 'Test User');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StreamChat(
            client: client,
            streamChatConfigData: configData,
            streamChatThemeData: StreamChatThemeData.light(),
            child: Center(
              child: StreamMessagePreviewText(
                message: message,
                language: language,
                textStyle: textStyle,
                channel: channel,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('StreamMessagePreviewText', () {
    testWidgets('renders regular text message', (tester) async {
      final message = Message(
        text: 'Hello, world!',
        user: User(id: 'other-user-id', name: 'Other User'),
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('Hello, world!'), findsOneWidget);
    });

    testWidgets('renders deleted message', (tester) async {
      final message = Message(
        text: 'Original message',
        type: MessageType.deleted,
        user: User(id: 'other-user-id', name: 'Other User'),
        deletedAt: DateTime.now(),
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('Message deleted'), findsOneWidget);
    });

    testWidgets('renders system message', (tester) async {
      final message = Message(
        text: 'User joined the channel',
        type: MessageType.system,
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('User joined the channel'), findsOneWidget);
    });

    testWidgets('renders empty system message', (tester) async {
      final message = Message(type: MessageType.system);

      await pumpMessagePreview(tester, message);

      expect(find.text('System Message'), findsOneWidget);
    });

    testWidgets('renders empty message with no attachments', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
      );

      await pumpMessagePreview(tester, message);

      expect(find.text(''), findsOneWidget);
    });

    testWidgets('renders message with mentioned users in bold', (tester) async {
      final mentionedUser = User(id: 'mentioned-id', name: 'Mentioned User');
      final message = Message(
        text: 'Hello @Mentioned User, how are you?',
        user: User(id: 'other-user-id', name: 'Other User'),
        mentionedUsers: [mentionedUser],
      );

      await pumpMessagePreview(tester, message, textStyle: const TextStyle());

      expect(find.text('Hello @Mentioned User, how are you?'), findsOneWidget);

      // Find the rich text and verify that it contains a valid TextSpan
      final textWidget = tester.widget<Text>(find.byType(Text).last);
      expect(textWidget.textSpan, isNotNull);
    });

    group('Attachments', () {
      testWidgets('renders image attachment', (tester) async {
        final message = Message(
          text: '',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.image,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📷 Image'), findsOneWidget);
      });

      testWidgets('renders image attachment with text', (tester) async {
        final message = Message(
          text: 'Check this out',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.image,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📷 Check this out'), findsOneWidget);
      });

      testWidgets('renders video attachment', (tester) async {
        final message = Message(
          text: '',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.video,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📹 Video'), findsOneWidget);
      });

      testWidgets('renders video attachment with text', (tester) async {
        final message = Message(
          text: 'Check this out',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.video,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📹 Check this out'), findsOneWidget);
      });

      testWidgets('renders file attachment', (tester) async {
        final message = Message(
          text: '',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.file,
              title: 'document.pdf',
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📄 document.pdf'), findsOneWidget);
      });

      testWidgets('renders audio attachment', (tester) async {
        final message = Message(
          text: '',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.audio,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('🎧 Audio'), findsOneWidget);
      });

      testWidgets('renders audio attachment with text', (tester) async {
        final message = Message(
          text: 'Check this out',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.audio,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('🎧 Check this out'), findsOneWidget);
      });

      testWidgets('renders giphy attachment with text', (tester) async {
        final message = Message(
          text: 'Check this out',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.giphy,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('/giphy Check this out'), findsOneWidget);
      });

      testWidgets('renders voice recording attachment', (tester) async {
        final message = Message(
          text: '',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: AttachmentType.voiceRecording,
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('🎤 Voice Recording'), findsOneWidget);
      });

      testWidgets('renders unknown attachment type with text', (tester) async {
        final message = Message(
          text: 'Some text',
          user: User(id: 'other-user-id', name: 'Other User'),
          attachments: [
            Attachment(
              type: 'unknown',
            ),
          ],
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('Some text'), findsOneWidget);
      });
    });

    group('Poll Tests', () {
      testWidgets('renders poll with latest voter (current user)',
          (tester) async {
        final voterPoll = Poll(
          name: 'Favorite Color?',
          options: const [
            PollOption(id: 'option-1', text: 'Red'),
            PollOption(id: 'option-2', text: 'Blue'),
          ],
          latestVotesByOption: {
            'option-1': [
              PollVote(
                user: currentUser,
                optionId: 'option-1',
              ),
            ],
          },
        );

        final message = Message(
          user: User(id: 'other-user-id', name: 'Poll Creator'),
          poll: voterPoll,
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📊 You voted: "Favorite Color?"'), findsOneWidget);
      });

      testWidgets('renders poll with latest voter (another user)',
          (tester) async {
        final voter = User(id: 'voter-id', name: 'Voter');
        final voterPoll = Poll(
          name: 'Favorite Color?',
          options: const [
            PollOption(id: 'option-1', text: 'Red'),
            PollOption(id: 'option-2', text: 'Blue'),
          ],
          latestVotesByOption: {
            'option-1': [
              PollVote(
                user: voter,
                optionId: 'option-1',
              ),
            ],
          },
        );

        final message = Message(
          user: User(id: 'other-user-id', name: 'Poll Creator'),
          poll: voterPoll,
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📊 Voter voted: "Favorite Color?"'), findsOneWidget);
      });

      testWidgets('renders poll with creator (current user)', (tester) async {
        final message = Message(
          user: User(id: 'other-user-id', name: 'Message Sender'),
          poll: Poll(
            name: 'Favorite Color?',
            options: const [
              PollOption(id: 'option-1', text: 'Red'),
              PollOption(id: 'option-2', text: 'Blue'),
            ],
            createdBy: currentUser,
          ),
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📊 You created: "Favorite Color?"'), findsOneWidget);
      });

      testWidgets('renders poll with creator (another user)', (tester) async {
        final creator = User(id: 'creator-id', name: 'Alex');
        final message = Message(
          user: User(id: 'other-user-id', name: 'Message Sender'),
          poll: Poll(
            name: 'Favorite Color?',
            options: const [
              PollOption(id: 'option-1', text: 'Red'),
              PollOption(id: 'option-2', text: 'Blue'),
            ],
            createdBy: creator,
          ),
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📊 Alex created: "Favorite Color?"'), findsOneWidget);
      });

      testWidgets('renders poll with only name', (tester) async {
        final message = Message(
          user: User(id: 'other-user-id', name: 'Message Sender'),
          poll: Poll(
            name: 'Favorite Color?',
            options: const [
              PollOption(id: 'option-1', text: 'Red'),
              PollOption(id: 'option-2', text: 'Blue'),
            ],
          ),
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📊 Favorite Color?'), findsOneWidget);
      });

      testWidgets('renders poll with empty name', (tester) async {
        final message = Message(
          user: User(id: 'other-user-id', name: 'Message Sender'),
          poll: Poll(
            name: '   ',
            options: const [
              PollOption(id: 'option-1', text: 'Red'),
              PollOption(id: 'option-2', text: 'Blue'),
            ],
          ),
        );

        await pumpMessagePreview(tester, message);

        expect(find.text('📊'), findsOneWidget);
      });
    });

    testWidgets('renders location attachment', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        sharedLocation: Location(
          latitude: 37.7749,
          longitude: -122.4194,
        ),
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('📍 Location'), findsOneWidget);
    });

    testWidgets('renders live location attachment', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        sharedLocation: Location(
          latitude: 37.7749,
          longitude: -122.4194,
          endAt: DateTime.now().add(const Duration(minutes: 15)),
        ),
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('📍 Live Location'), findsOneWidget);
    });

    testWidgets('supports different language for translation', (tester) async {
      final message = Message(
        text: 'Hello, world!',
        user: User(id: 'other-user-id', name: 'Other User'),
        i18n: const {
          'fr_text': 'Bonjour, monde!',
        },
      );

      await pumpMessagePreview(tester, message, language: 'fr');

      expect(find.text('Bonjour, monde!'), findsOneWidget);
    });

    group('Channel-specific behaviors', () {
      testWidgets(
        'prepends "You:" for current user\'s messages in group channels',
        (tester) async {
          final channel = ChannelModel(
            id: 'test-channel',
            type: 'messaging',
            memberCount: 3,
          );

          final message = Message(
            text: 'Hello everyone',
            user: User(id: 'test-user-id', name: 'Test User'), // Current user
          );

          await pumpMessagePreview(tester, message, channel: channel);

          expect(find.text('You: Hello everyone'), findsOneWidget);
        },
      );

      testWidgets(
        'prepends author name for other messages in group channels',
        (tester) async {
          final channel = ChannelModel(
            id: 'test-channel',
            type: 'messaging',
            memberCount: 3,
          );

          final message = Message(
            text: 'Hello everyone',
            user: User(id: 'other-user-id', name: 'Jane Doe'),
          );

          await pumpMessagePreview(tester, message, channel: channel);

          expect(find.text('Jane Doe: Hello everyone'), findsOneWidget);
        },
      );

      testWidgets(
        'does not prepend author name in 1:1 channels',
        (tester) async {
          final channel = ChannelModel(
            id: 'test-channel',
            type: 'messaging',
            memberCount: 2,
          );

          final message = Message(
            text: 'Hello there',
            user: User(id: 'other-user-id', name: 'Jane Doe'),
          );

          await pumpMessagePreview(tester, message, channel: channel);

          expect(find.text('Hello there'), findsOneWidget);
        },
      );

      testWidgets(
        'falls back to user language for translation when available',
        (tester) async {
          final client = MockClient();
          final clientState = MockClientState();
          final currentUser = OwnUser(
            id: 'test-user-id',
            name: 'Test User',
            language: 'es', // Spanish language
          );

          when(() => client.state).thenReturn(clientState);
          when(() => clientState.currentUser).thenReturn(currentUser);

          final message = Message(
            text: 'Hello, world!',
            user: User(id: 'other-user-id', name: 'Other User'),
            i18n: const {
              'es_text': 'Hola, mundo!',
            },
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: StreamChat(
                  client: client,
                  streamChatThemeData: StreamChatThemeData.light(),
                  child: Center(
                    child: StreamMessagePreviewText(
                      message: message,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();

          expect(find.text('Hola, mundo!'), findsOneWidget);
        },
      );
    });
  });

  group('Custom MessagePreviewFormatter', () {
    const customFormatter = _CustomMessagePreviewFormatter();

    testWidgets('can override formatCurrentUserMessage', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 3,
      );

      final message = Message(
        text: 'Hello everyone',
        user: User(id: 'test-user-id', name: 'Test User'), // Current user
      );

      await pumpMessagePreview(
        tester,
        message,
        channel: channel,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      // Custom formatter removes "You:" prefix
      expect(find.text('Hello everyone'), findsOneWidget);
      expect(find.text('You: Hello everyone'), findsNothing);
    });

    testWidgets('can override formatGroupMessage', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 3,
      );

      final message = Message(
        text: 'Hello',
        user: User(id: 'other-user-id', name: 'John Doe'),
      );

      await pumpMessagePreview(
        tester,
        message,
        channel: channel,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      // Custom formatter uses "says:" instead of ":"
      expect(find.text('John Doe says: Hello'), findsOneWidget);
    });

    testWidgets('can override formatPollMessage', (tester) async {
      final message = Message(
        user: User(id: 'other-user-id', name: 'Message Sender'),
        poll: Poll(
          name: 'Favorite Color?',
          options: const [
            PollOption(id: 'option-1', text: 'Red'),
            PollOption(id: 'option-2', text: 'Blue'),
          ],
        ),
      );

      await pumpMessagePreview(
        tester,
        message,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      // Custom formatter uses different format
      expect(find.text('📊 Poll: Favorite Color?'), findsOneWidget);
    });

    testWidgets('can override formatLocationMessage', (tester) async {
      final message = Message(
        user: User(id: 'other-user-id', name: 'Message Sender'),
        sharedLocation: Location(
          latitude: 37.7749,
          longitude: -122.4194,
        ),
      );

      await pumpMessagePreview(
        tester,
        message,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      // Custom formatter uses different format
      expect(find.text('🗺️ -> Location Shared'), findsOneWidget);
    });

    testWidgets('can override formatMessageAttachments', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'user-id'),
        attachments: [
          Attachment(
            type: 'product',
            extraData: const {'title': 'iPhone'},
          ),
        ],
      );

      await pumpMessagePreview(
        tester,
        message,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      // Custom formatter handles custom attachment type
      expect(find.text('🛍️ iPhone'), findsOneWidget);
    });

    testWidgets('can override formatDirectMessage', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 2,
      );

      final message = Message(
        text: 'Hey there',
        user: User(id: 'other-user-id', name: 'Jane Doe'),
      );

      await pumpMessagePreview(
        tester,
        message,
        channel: channel,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      // Custom formatter adds emoji prefix
      expect(find.text('💬 Hey there'), findsOneWidget);
    });
  });
}

// Custom formatter for testing overrides
class _CustomMessagePreviewFormatter extends StreamMessagePreviewFormatter {
  const _CustomMessagePreviewFormatter();

  @override
  String formatCurrentUserMessage(BuildContext context, String messageText) {
    // Remove "You:" prefix
    return messageText;
  }

  @override
  String formatGroupMessage(
    BuildContext context,
    User? messageAuthor,
    String messageText,
  ) {
    final authorName = messageAuthor?.name;
    if (authorName == null || authorName.isEmpty) return messageText;

    // Use "says:" instead of ":"
    return '$authorName says: $messageText';
  }

  @override
  String formatPollMessage(
    BuildContext context,
    Poll poll,
    User? currentUser,
  ) {
    // Simple format with "Poll:" prefix
    return poll.name.isEmpty ? '📊 Poll' : '📊 Poll: ${poll.name}';
  }

  @override
  String formatLocationMessage(BuildContext context, Location location) {
    // Simple format with custom emoji
    return '🗺️ -> Location Shared';
  }

  @override
  String formatDirectMessage(BuildContext context, String messageText) {
    // Add emoji prefix
    return '💬 $messageText';
  }

  @override
  String? formatMessageAttachments(
    BuildContext context,
    String? messageText,
    Iterable<Attachment> attachments,
  ) {
    final attachment = attachments.firstOrNull;

    // Handle custom product attachment type
    if (attachment?.type == 'product') {
      final title = attachment?.extraData['title'] as String?;
      return '🛍️ ${title ?? "Product"}';
    }

    // Fallback to default implementation
    return super.formatMessageAttachments(context, messageText, attachments);
  }
}

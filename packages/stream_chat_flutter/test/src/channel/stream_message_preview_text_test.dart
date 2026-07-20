import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  Future<void> pumpMessagePreview(
    WidgetTester tester,
    Message message, {
    String? language,
    TextStyle? textStyle,
    ChannelModel? channel,
    StreamChatConfigurationData? configData,
    bool showCaption = true,
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
            configData: configData,
            themeData: StreamChatThemeData(),
            child: Center(
              child: StreamMessagePreviewText(
                message: message,
                language: language,
                textStyle: textStyle,
                channel: channel,
                showCaption: showCaption,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('Message types', () {
    testWidgets('renders regular text message', (tester) async {
      final message = Message(
        text: 'Hello, world!',
        user: User(id: 'other-user-id', name: 'Other User'),
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('Hello, world!'), findsOneWidget);
      expect(_findIcons(tester), isEmpty);
    });

    testWidgets('renders deleted message with ban icon', (tester) async {
      final message = Message(
        text: 'Original message',
        type: MessageType.deleted,
        user: User(id: 'other-user-id', name: 'Other User'),
        deletedAt: DateTime.now(),
      );

      await pumpMessagePreview(tester, message);

      final icons = _findIcons(tester);
      expect(icons, hasLength(1));
      expect(icons.first.size, 16);

      expect(_extractText(tester), 'Message deleted');

      final span = _getPreviewSpan(tester);
      final styledSpans = _findTextSpans(span);
      final deletedSpan = styledSpans.firstWhere((s) => s.text == 'Message deleted');
      expect(deletedSpan.style?.color, isNotNull);
    });

    testWidgets('renders system message with text', (tester) async {
      final message = Message(
        text: 'User joined the channel',
        type: MessageType.system,
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('User joined the channel'), findsOneWidget);
      expect(_findIcons(tester), isEmpty);
    });

    testWidgets('renders system message without text as fallback label', (tester) async {
      final message = Message(type: MessageType.system);

      await pumpMessagePreview(tester, message);

      expect(find.text('System Message'), findsOneWidget);
    });

    testWidgets('renders empty message with no text or attachments', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
      );

      await pumpMessagePreview(tester, message);

      expect(find.byType(StreamMessagePreviewText), findsOneWidget);
      expect(_findIcons(tester), isEmpty);
    });

    testWidgets('renders null text message as empty', (tester) async {
      final message = Message(
        user: User(id: 'other-user-id', name: 'Other User'),
      );

      await pumpMessagePreview(tester, message);

      expect(find.byType(StreamMessagePreviewText), findsOneWidget);
    });

    testWidgets('trims whitespace-only text as empty', (tester) async {
      final message = Message(
        text: '   ',
        user: User(id: 'other-user-id', name: 'Other User'),
      );

      await pumpMessagePreview(tester, message);

      expect(find.byType(StreamMessagePreviewText), findsOneWidget);
      expect(_findIcons(tester), isEmpty);
    });
  });

  group('Mentions', () {
    testWidgets('renders mentioned users as plain text', (tester) async {
      final mentionedUser = User(id: 'mentioned-id', name: 'Mentioned User');
      final message = Message(
        text: 'Hello @Mentioned User, how are you?',
        user: User(id: 'other-user-id', name: 'Other User'),
        mentionedUsers: [mentionedUser],
      );

      await pumpMessagePreview(tester, message, textStyle: const TextStyle());

      expect(find.text('Hello @Mentioned User, how are you?'), findsOneWidget);

      final span = _getPreviewSpan(tester);
      final textSpans = _findTextSpans(span);
      expect(
        textSpans.any((s) => s.style?.fontWeight == FontWeight.bold),
        isFalse,
      );
    });

    testWidgets('renders multiple mentions as plain text', (tester) async {
      final user1 = User(id: 'user-1', name: 'Alice');
      final user2 = User(id: 'user-2', name: 'Bob');
      final message = Message(
        text: 'Hey @Alice and @Bob!',
        user: User(id: 'other-user-id', name: 'Other User'),
        mentionedUsers: [user1, user2],
      );

      await pumpMessagePreview(tester, message, textStyle: const TextStyle());

      expect(find.text('Hey @Alice and @Bob!'), findsOneWidget);

      final span = _getPreviewSpan(tester);
      final textSpans = _findTextSpans(span);
      expect(
        textSpans.any((s) => s.style?.fontWeight == FontWeight.bold),
        isFalse,
      );
    });

    testWidgets('renders message without matching mention as plain text', (tester) async {
      final mentionedUser = User(id: 'mentioned-id', name: 'NoMatch');
      final message = Message(
        text: 'Hello @SomeoneElse',
        user: User(id: 'other-user-id', name: 'Other User'),
        mentionedUsers: [mentionedUser],
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('Hello @SomeoneElse'), findsOneWidget);
    });
  });

  group('Single attachments', () {
    testWidgets('image attachment shows camera icon and "Photo" label', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.image)],
      );

      await pumpMessagePreview(tester, message);

      final icons = _findIcons(tester);
      expect(icons, hasLength(1));
      expect(icons.first.size, 16);
      expect(_extractText(tester), 'Photo');
    });

    testWidgets('image attachment with caption shows icon and caption', (tester) async {
      final message = Message(
        text: 'Check this out',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.image)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Check this out');
    });

    testWidgets('video attachment shows video icon and "Video" label', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.video)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Video');
    });

    testWidgets('video attachment with caption shows icon and caption', (tester) async {
      final message = Message(
        text: 'Watch this',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.video)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Watch this');
    });

    testWidgets('file attachment shows file icon and "File" fallback label', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.file)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'File');
    });

    testWidgets('file attachment with file name shows the file name', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(
            type: AttachmentType.file,
            file: AttachmentFile(size: 100, bytes: Uint8List(100), name: 'report.pdf'),
          ),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'report.pdf');
    });

    testWidgets('audio attachment shows microphone icon and "Audio" label', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.audio)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Audio');
    });

    testWidgets('audio attachment with caption shows icon and caption', (tester) async {
      final message = Message(
        text: 'New podcast episode',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.audio)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'New podcast episode');
    });

    testWidgets('voice recording shows microphone icon with duration', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.voiceRecording)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), contains('Voice recording'));
      expect(_extractText(tester), contains('00:00'));
    });

    testWidgets('voice recording with duration shows formatted time', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(
            type: AttachmentType.voiceRecording,
            extraData: const {'duration': 125},
          ),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), contains('Voice recording'));
      expect(_extractText(tester), contains('02:05'));
    });

    testWidgets('giphy attachment with caption shows file icon and caption', (tester) async {
      final message = Message(
        text: 'funny cat',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.giphy)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'funny cat');
    });

    testWidgets('giphy attachment without caption shows file icon and Giphy label', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.giphy)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Giphy');
    });

    testWidgets('link preview with caption shows link icon and caption', (tester) async {
      final message = Message(
        text: 'check out this article',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(
            type: AttachmentType.urlPreview,
            title: 'Example article',
            titleLink: 'https://example.com',
          ),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'check out this article');
    });

    testWidgets('link preview without caption falls back to attachment title', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(
            type: AttachmentType.urlPreview,
            title: 'Example article',
            titleLink: 'https://example.com',
          ),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Example article');
    });

    testWidgets('link preview without caption or title falls back to "Link"', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: AttachmentType.urlPreview)],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Link');
    });

    testWidgets('unknown attachment type shows file icon with text', (tester) async {
      final message = Message(
        text: 'Some text',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: 'custom_type')],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Some text');
    });

    testWidgets('unknown attachment type without text shows file icon only', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [Attachment(type: 'custom_type')],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), isEmpty);
    });
  });

  group('Multiple same-type attachments', () {
    testWidgets('multiple images show camera icon and photo count', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.image),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), '3 photos');
    });

    testWidgets('multiple videos show video icon and video count', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(type: AttachmentType.video),
          Attachment(type: AttachmentType.video),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), '2 videos');
    });

    testWidgets('multiple files show file icon and file count', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(type: AttachmentType.file),
          Attachment(type: AttachmentType.file),
          Attachment(type: AttachmentType.file),
          Attachment(type: AttachmentType.file),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), '4 files');
    });

    testWidgets('multiple images with caption show icon and caption text', (tester) async {
      final message = Message(
        text: 'Vacation photos',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.image),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Vacation photos');
    });
  });

  group('Mixed-type attachments', () {
    testWidgets('mixed types show generic file icon and total count', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.video),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), '2 files');
    });

    testWidgets('three mixed types show count of all', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.video),
          Attachment(type: AttachmentType.file),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), '3 files');
    });

    testWidgets('mixed types with caption show generic icon and caption', (tester) async {
      final message = Message(
        text: 'Mixed media',
        user: User(id: 'other-user-id', name: 'Other User'),
        attachments: [
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.file),
        ],
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Mixed media');
    });
  });

  group('Polls', () {
    testWidgets('poll shows chart icon and poll name', (tester) async {
      final message = Message(
        user: User(id: 'other-user-id', name: 'Poll Creator'),
        poll: Poll(
          name: 'Favorite Color?',
          options: const [
            PollOption(id: 'option-1', text: 'Red'),
            PollOption(id: 'option-2', text: 'Blue'),
          ],
        ),
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Favorite Color?');
    });

    testWidgets('poll with empty name shows chart icon only', (tester) async {
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

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), isEmpty);
    });

    testWidgets('poll in group channel includes sender prefix', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 3,
      );

      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        poll: Poll(
          name: 'Lunch spot?',
          options: const [
            PollOption(id: 'option-1', text: 'Pizza'),
            PollOption(id: 'option-2', text: 'Sushi'),
          ],
        ),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(_findIcons(tester), hasLength(1));

      final text = _extractText(tester);
      expect(text, contains('You: '));
      expect(text, contains('Lunch spot?'));
    });
  });

  group('Locations', () {
    testWidgets('static location shows map pin icon and location label', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Other User'),
        sharedLocation: Location(
          latitude: 37.7749,
          longitude: -122.4194,
        ),
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), contains('Location'));
      expect(_extractText(tester), isNot(contains('Live')));
    });

    testWidgets('live location shows map pin icon and live location label', (tester) async {
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

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), contains('Live Location'));
    });

    testWidgets('location with caption shows map pin icon and caption text', (tester) async {
      final message = Message(
        text: 'Meet me here',
        user: User(id: 'other-user-id', name: 'Other User'),
        sharedLocation: Location(
          latitude: 37.7749,
          longitude: -122.4194,
        ),
      );

      await pumpMessagePreview(tester, message);

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Meet me here');
    });
  });

  group('Channel context', () {
    testWidgets('group channel prepends bold "You:" for current user', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 3,
      );

      final message = Message(
        text: 'Hello everyone',
        user: User(id: 'test-user-id', name: 'Test User'),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.text('You: Hello everyone'), findsOneWidget);

      final span = _getPreviewSpan(tester);
      final youSpan = _findTextSpans(span).firstWhere((s) => s.text == 'You: ');
      expect(youSpan.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('group channel prepends bold first name for other users', (tester) async {
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

      expect(find.text('Jane: Hello everyone'), findsOneWidget);

      final span = _getPreviewSpan(tester);
      final nameSpan = _findTextSpans(span).firstWhere((s) => s.text == 'Jane: ');
      expect(nameSpan.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('group channel skips prefix when message has no user', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 3,
      );

      final message = Message(text: 'Hello');

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('1:1 channel does not prepend author name', (tester) async {
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
    });

    testWidgets('no channel does not prepend author name', (tester) async {
      final message = Message(
        text: 'Hello there',
        user: User(id: 'other-user-id', name: 'Jane Doe'),
      );

      await pumpMessagePreview(tester, message);

      expect(find.text('Hello there'), findsOneWidget);
    });

    testWidgets('group channel with attachment includes sender prefix', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 3,
      );

      final message = Message(
        text: '',
        user: User(id: 'other-user-id', name: 'Jane Doe'),
        attachments: [Attachment(type: AttachmentType.image)],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      final text = _extractText(tester);
      expect(text, contains('Jane: '));
      expect(text, contains('Photo'));
    });
  });

  group('Translations', () {
    testWidgets('uses explicit language parameter for translation', (tester) async {
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

    testWidgets('falls back to user language when no explicit language', (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final currentUser = OwnUser(
        id: 'test-user-id',
        name: 'Test User',
        language: 'es',
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
              themeData: StreamChatThemeData(),
              child: Center(
                child: StreamMessagePreviewText(message: message),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Hola, mundo!'), findsOneWidget);
    });

    testWidgets('falls back to original text when translation missing', (tester) async {
      final message = Message(
        text: 'Hello, world!',
        user: User(id: 'other-user-id', name: 'Other User'),
        i18n: const {
          'fr_text': 'Bonjour, monde!',
        },
      );

      await pumpMessagePreview(tester, message, language: 'de');

      expect(find.text('Hello, world!'), findsOneWidget);
    });
  });

  group('Custom MessagePreviewFormatter', () {
    const customFormatter = _CustomMessagePreviewFormatter();

    testWidgets('can remove current user prefix via formatCurrentUserMessage', (tester) async {
      final channel = ChannelModel(
        id: 'test-channel',
        type: 'messaging',
        memberCount: 3,
      );

      final message = Message(
        text: 'Hello everyone',
        user: User(id: 'test-user-id', name: 'Test User'),
      );

      await pumpMessagePreview(
        tester,
        message,
        channel: channel,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      expect(find.text('Hello everyone'), findsOneWidget);
      expect(find.text('You: Hello everyone'), findsNothing);
    });

    testWidgets('can customize group message prefix via formatGroupMessage', (tester) async {
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

      expect(find.text('John Doe says: Hello'), findsOneWidget);
    });

    testWidgets('can customize poll formatting via formatPollMessage', (tester) async {
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

      expect(find.text('📊 Poll: Favorite Color?'), findsOneWidget);
      expect(_findIcons(tester), isEmpty);
    });

    testWidgets('can customize location formatting via formatLocationMessage', (tester) async {
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

      expect(find.text('🗺️ -> Location Shared'), findsOneWidget);
      expect(_findIcons(tester), isEmpty);
    });

    testWidgets('can handle custom attachment types via formatMessageAttachments', (tester) async {
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

      expect(find.text('🛍️ iPhone'), findsOneWidget);
    });

    testWidgets('custom formatter falls through to default for known types', (tester) async {
      final message = Message(
        text: '',
        user: User(id: 'user-id'),
        attachments: [Attachment(type: AttachmentType.image)],
      );

      await pumpMessagePreview(
        tester,
        message,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      expect(_findIcons(tester), hasLength(1));
      expect(_extractText(tester), 'Photo');
    });

    testWidgets('can customize direct message via formatMessage override', (tester) async {
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

      expect(find.text('💬 Hey there'), findsOneWidget);
    });
  });

  group('Accessibility label (formatMessageSemanticsLabel)', () {
    testWidgets('group channel — full sender name prefix for other users', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'Hello there',
        user: User(id: 'other', name: 'Jane Doe'),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('Jane Doe\nHello there'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('group channel — drops the prefix entirely when sender is unknown', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      // No `user` on the message — the formatter can't derive a sender
      // name. Rather than emit a bare "Message" prefix that carries no
      // information, drop the prefix and read the body alone.
      final message = Message(text: 'Hello there');

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('Hello there'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('group channel — "You, body" for own messages', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'Hello everyone',
        user: User(id: 'test-user-id', name: 'Test User'),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nHello everyone'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('1-on-1 channel — no speaker prefix (sender is implicit) for other user', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Hi',
        user: User(id: 'other', name: 'Jane'),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('Hi'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('1-on-1 channel — "You, body" for own messages', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'See you tomorrow',
        user: User(id: 'test-user-id', name: 'Test User'),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nSee you tomorrow'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('attachment message — icon placeholder is stripped from the label', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'other', name: 'Jane Doe'),
        attachments: [
          Attachment(type: 'image'),
          Attachment(type: 'image'),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // Without `includePlaceholders: false`, the inline camera icon
      // (WidgetSpan) would leak an object-replacement character into the
      // label — screen readers would announce it as "object" or silence.
      expect(find.bySemanticsLabel('Jane Doe\n2 photos'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('poll message — "Poll" type prefix restores context lost by the icon', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        poll: Poll(
          id: 'p1',
          name: "What's for lunch?",
          options: const [],
        ),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel("You\nPoll\nWhat's for lunch?"), findsOneWidget);
      handle.dispose();
    });

    testWidgets('poll message from other user — "Poll" prefix included', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'other', name: 'Jane Doe'),
        poll: Poll(id: 'p2', name: 'ee', options: const []),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // "Jane Doe, Poll, ee" — SR user now knows "ee" is a poll title from
      // Jane, not a plain-text message that says "ee".
      expect(find.bySemanticsLabel('Jane Doe\nPoll\nee'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('single image attachment — icon placeholder stripped', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: 'image')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nPhoto'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('single video attachment — icon placeholder stripped', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: 'video')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nVideo'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('file attachment with title — "File" type prefix restores context', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: 'file', title: 'report.pdf')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nFile\nreport.pdf'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('image with caption text — "Photo" type prefix + caption', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'Check this out',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: 'image')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nPhoto\nCheck this out'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('multiple images with caption — pluralized type prefix + caption', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'Beach day',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [
          Attachment(type: 'image'),
          Attachment(type: 'image'),
          Attachment(type: 'image'),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\n3 photos\nBeach day'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('video with caption — "Video" type prefix + caption', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'From the concert',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: 'video')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nVideo\nFrom the concert'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('mixed-type attachments with caption — "N files" prefix + caption', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'Mixed bag',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [
          Attachment(type: 'image'),
          Attachment(type: 'video'),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\n2 files\nMixed bag'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('mixed-type attachments without caption — no prefix (fallback has type)', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [
          Attachment(type: 'image'),
          Attachment(type: 'video'),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // Fallback body is "2 files" — already includes the type word; no
      // prefix needed. Avoids the "2 files, 2 files" redundancy.
      expect(find.bySemanticsLabel('You\n2 files'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('voice recording — duration spelled out for screen readers', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [
          Attachment(
            type: 'voiceRecording',
            extraData: const {'duration': 83.0},
          ),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // "1 minute 23 seconds" — spelled out, not "1:23" which reads
      // inconsistently across screen readers.
      expect(
        find.bySemanticsLabel('You\nVoice recording\n1 minute, 23 seconds'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('shared location without caption — "Location" fallback only', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        sharedLocation: Location(latitude: 0, longitude: 0),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nLocation'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('shared location with caption — "Location, {caption}"', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'Meeting spot',
        user: User(id: 'test-user-id', name: 'Test User'),
        sharedLocation: Location(latitude: 0, longitude: 0),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nLocation\nMeeting spot'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('deleted message — no speaker prefix; deletion IS the content', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        text: 'gone',
        type: 'deleted',
        user: User(id: 'other', name: 'Jane Doe'),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // "Jane, Message deleted" would sound like Jane said the literal
      // phrase "Message deleted". Return the deletion notice verbatim.
      expect(find.bySemanticsLabel('Message deleted'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('system message — "System, <body>" prefix disambiguates the event from an authored message', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Alice was added to the channel',
        type: 'system',
        user: User(id: 'alice', name: 'Alice'),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // Without the "System" prefix a DM row titled "Alice" would read
      // "Alice, ..., Alice was added to the channel" — sounding like
      // Alice authored that sentence herself.
      expect(
        find.bySemanticsLabel('System\nAlice was added to the channel'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('showCaption: false — attachment a11y drops the caption, mirroring the visual', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Beach day',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.image),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel, showCaption: false);

      // Visual falls back to "2 photos" (no caption); a11y must match so
      // dense contexts like quoted-reply previews stay consistent.
      expect(find.bySemanticsLabel('You\n2 photos'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('showCaption: false — location a11y drops the caption', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Meet me here',
        user: User(id: 'other', name: 'Alice'),
        sharedLocation: Location(latitude: 0, longitude: 0),
      );

      await pumpMessagePreview(tester, message, channel: channel, showCaption: false);

      expect(find.bySemanticsLabel('Location'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('audio attachment — "Audio" type label, no caption', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.audio)],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nAudio'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('audio attachment with caption — "Audio, {caption}"', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Track name',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.audio)],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nAudio\nTrack name'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('url preview — "Link, {og title}" when caption absent', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.urlPreview, title: 'Article title')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nLink\nArticle title'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('url preview with caption — caption wins over og title', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Check this out',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.urlPreview, title: 'Article title')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nLink\nCheck this out'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('url preview without title or caption — bare "Link"', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.urlPreview)],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nLink'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('giphy attachment — "Giphy" fallback when caption absent', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.giphy)],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nGiphy'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('giphy attachment with caption — "Giphy, {caption}"', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Reaction meme',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.giphy)],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nGiphy\nReaction meme'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('voice recording with caption — caption wins over duration', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Listen to this',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [
          Attachment(
            type: AttachmentType.voiceRecording,
            extraData: const {'duration': 83.0},
          ),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // Caption preempts the spelled-out duration extra.
      expect(find.bySemanticsLabel('You\nVoice recording\nListen to this'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('file without title or caption — bare "File"', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.file)],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nFile'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('file with caption — caption wins over title', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Docs for review',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.file, title: 'report.pdf')],
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nFile\nDocs for review'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('live location — distinct "Live location" fallback', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        sharedLocation: Location(latitude: 0, longitude: 0, endAt: DateTime.now().add(const Duration(minutes: 5))),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      // Localized label is title-cased in en — `Live Location` (matches
       // the existing visible-side `locationLabel(isLive: true)` output).
      expect(find.bySemanticsLabel('You\nLive Location'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('poll with empty name — bare "Poll" prefix, no body', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 3);
      final message = Message(
        user: User(id: 'test-user-id', name: 'Test User'),
        poll: Poll(id: 'p1', name: '', options: const []),
      );

      await pumpMessagePreview(tester, message, channel: channel);

      expect(find.bySemanticsLabel('You\nPoll'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('system message without text — falls back to localized label', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(type: 'system', user: User(id: 'alice', name: 'Alice'));

      await pumpMessagePreview(tester, message, channel: channel);

      // No event body → fall back to the localized "System Message" label
      // without the "System, " prefix (there's nothing to disambiguate).
      expect(find.bySemanticsLabel('System Message'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('showCaption: false on voice recording — falls back to duration', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Listen to this',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [
          Attachment(
            type: AttachmentType.voiceRecording,
            extraData: const {'duration': 83.0},
          ),
        ],
      );

      await pumpMessagePreview(tester, message, channel: channel, showCaption: false);

      // With caption suppressed, the intrinsic duration fills the "extra" slot.
      expect(
        find.bySemanticsLabel('You\nVoice recording\n1 minute, 23 seconds'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('showCaption: false on file — falls back to filename', (tester) async {
      final handle = tester.ensureSemantics();
      final channel = ChannelModel(id: 'c', type: 'messaging', memberCount: 2);
      final message = Message(
        text: 'Please review',
        user: User(id: 'test-user-id', name: 'Test User'),
        attachments: [Attachment(type: AttachmentType.file, title: 'report.pdf')],
      );

      await pumpMessagePreview(tester, message, channel: channel, showCaption: false);

      // With caption suppressed, the intrinsic filename fills the "extra" slot.
      expect(find.bySemanticsLabel('You\nFile\nreport.pdf'), findsOneWidget);
      handle.dispose();
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Extracts concatenated text from all [TextSpan]s in the preview, skipping
/// icon placeholders ([WidgetSpan]s).
String _extractText(WidgetTester tester) {
  final span = _getPreviewSpan(tester);
  return _spanText(span).trim();
}

String _spanText(InlineSpan span) {
  if (span is! TextSpan) return '';
  final buffer = StringBuffer(span.text ?? '');
  for (final child in span.children ?? <InlineSpan>[]) {
    buffer.write(_spanText(child));
  }
  return buffer.toString();
}

/// Returns the root [TextSpan] rendered by the [StreamMessagePreviewText].
TextSpan _getPreviewSpan(WidgetTester tester) {
  final text = tester.widget<Text>(
    find.descendant(
      of: find.byType(StreamMessagePreviewText),
      matching: find.byType(Text),
    ),
  );
  return text.textSpan! as TextSpan;
}

/// Recursively collects all leaf [TextSpan]s that have non-null [text].
///
/// The returned spans carry their *effective* style — merged top-down with
/// every ancestor [TextSpan.style] — since the formatter applies style at
/// the root and lets children inherit it via Flutter's normal span-style
/// inheritance.
List<TextSpan> _findTextSpans(InlineSpan span, [TextStyle? inheritedStyle]) {
  final result = <TextSpan>[];
  if (span is! TextSpan) return result;

  final effectiveStyle = inheritedStyle?.merge(span.style) ?? span.style;
  if (span.text != null) {
    result.add(TextSpan(text: span.text, style: effectiveStyle));
  }
  for (final child in span.children ?? <InlineSpan>[]) {
    result.addAll(_findTextSpans(child, effectiveStyle));
  }
  return result;
}

/// Finds all icon [WidgetSpan]s rendered inside the [StreamMessagePreviewText].
///
/// Icons are emitted as [WidgetSpan]s wrapping an [Icon] so they can be
/// vertically centered against the surrounding text via
/// [PlaceholderAlignment.middle].
List<_PreviewIcon> _findIcons(WidgetTester tester) {
  final span = _getPreviewSpan(tester);
  final result = <_PreviewIcon>[];
  void visit(InlineSpan span) {
    if (span is WidgetSpan) {
      final child = span.child;
      if (child is Icon) {
        result.add(_PreviewIcon(icon: child.icon, size: child.size));
      }
      return;
    }
    if (span is TextSpan) {
      for (final child in span.children ?? <InlineSpan>[]) {
        visit(child);
      }
    }
  }

  visit(span);
  return result;
}

/// Minimal stand-in for the old `Icon` widget in tests.
class _PreviewIcon {
  const _PreviewIcon({this.icon, this.size});

  /// The [IconData] rendered.
  final IconData? icon;

  /// Nominal icon render size.
  final double? size;
}

// ---------------------------------------------------------------------------
// Custom formatter for override tests
// ---------------------------------------------------------------------------

class _CustomMessagePreviewFormatter extends StreamMessagePreviewFormatter {
  const _CustomMessagePreviewFormatter();

  @override
  TextSpan formatMessage(
    BuildContext context,
    Message message, {
    bool showCaption = true,
    ChannelModel? channel,
    User? currentUser,
  }) {
    if (channel != null && channel.memberCount <= 2) {
      final text = message.text ?? '';
      return TextSpan(text: '💬 $text');
    }
    return super.formatMessage(
      context,
      message,
      showCaption: showCaption,
      channel: channel,
      currentUser: currentUser,
    );
  }

  @override
  TextSpan formatCurrentUserMessage(BuildContext context, TextSpan messageBody) {
    return messageBody;
  }

  @override
  TextSpan formatGroupMessage(
    BuildContext context,
    User? messageAuthor,
    TextSpan messageBody,
  ) {
    final authorName = messageAuthor?.name;
    if (authorName == null || authorName.isEmpty) return messageBody;

    return TextSpan(
      children: [
        TextSpan(text: '$authorName says: '),
        messageBody,
      ],
    );
  }

  @override
  TextSpan formatPollMessage(BuildContext context, Poll poll, User? currentUser) {
    return TextSpan(
      text: poll.name.trim().isEmpty ? '📊 Poll' : '📊 Poll: ${poll.name}',
    );
  }

  @override
  TextSpan formatLocationMessage(
    BuildContext context,
    Message message,
    Location location, {
    bool showCaption = true,
  }) {
    return const TextSpan(text: '🗺️ -> Location Shared');
  }

  @override
  TextSpan? formatMessageAttachments(
    BuildContext context,
    String? messageText,
    Iterable<Attachment> attachments, {
    bool showCaption = true,
  }) {
    final attachment = attachments.firstOrNull;

    if (attachment?.type == 'product') {
      final title = attachment?.extraData['title'] as String?;
      return TextSpan(text: '🛍️ ${title ?? "Product"}');
    }

    return super.formatMessageAttachments(
      context,
      messageText,
      attachments,
      showCaption: showCaption,
    );
  }
}

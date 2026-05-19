import 'dart:typed_data';

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
            streamChatThemeData: StreamChatThemeData(),
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
      expect(_extractText(tester), contains('Voice Recording'));
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
      expect(_extractText(tester), contains('Voice Recording'));
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
              streamChatThemeData: StreamChatThemeData(),
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

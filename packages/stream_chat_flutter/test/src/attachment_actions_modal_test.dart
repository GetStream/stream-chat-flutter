import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

class MockAttachmentDownloader extends Mock {
  ProgressCallback? progressCallback;
  DownloadedPathCallback? downloadedPathCallback;
  Completer<String> completer = Completer();

  Future<String> call(
    Attachment attachment, {
    ProgressCallback? progressCallback,
    DownloadedPathCallback? downloadedPathCallback,
  }) {
    this.progressCallback = progressCallback;
    this.downloadedPathCallback = downloadedPathCallback;
    return completer.future;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(
        MaterialPageRoute(builder: (context) => const SizedBox()));
    registerFallbackValue(Message());
  });

  testWidgets(
    'it should show all the actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      final attachment = Attachment(
        type: 'image',
        title: 'text.jpg',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: AttachmentActionsModal(
              message: message,
              attachment: attachment,
            ),
          ),
        ),
      );
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Show in Chat'), findsOneWidget);
      expect(find.text('Save Image'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    },
  );

  testWidgets(
    "it should hide delete if it's not my message",
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id2'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      final attachment = Attachment(
        type: 'image',
        title: 'text.jpg',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: AttachmentActionsModal(
              message: message,
              attachment: attachment,
            ),
          ),
        ),
      );
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Show in Chat'), findsOneWidget);
      expect(find.text('Save Image'), findsOneWidget);
      expect(find.text('Delete'), findsNothing);
    },
  );

  testWidgets(
    'it should show save video for videos',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      final attachment = Attachment(
        type: 'video',
        title: 'video.mp4',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: AttachmentActionsModal(
                message: message,
                attachment: attachment,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Save Video'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on reply should pop',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      final mockObserver = MockNavigatorObserver();

      final attachment = Attachment(
        type: 'image',
        title: 'image.jpg',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          navigatorObservers: [mockObserver],
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: AttachmentActionsModal(
                message: message,
                attachment: attachment,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Reply'));
      verify(() => mockObserver.didPop(any(), any()));
    },
  );

  testWidgets(
    'tapping on show in chat should call onShowMessage',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      final onShowMessage = MockVoidCallback();

      final attachment = Attachment(
        type: 'image',
        title: 'image.jpg',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: AttachmentActionsModal(
                onShowMessage: onShowMessage,
                message: message,
                attachment: attachment,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Show in Chat'));
      verify(onShowMessage.call).called(1);
    },
  );

  testWidgets(
    'tapping on delete in chat should remove the attachment',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final mockChannel = MockChannel();

      when(() => mockChannel.updateMessage(any()))
          .thenAnswer((_) async => UpdateMessageResponse());
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final targetAttachment = Attachment(
        type: 'image',
        title: 'image.jpg',
      );
      final remainingAttachment = Attachment(
        type: 'image',
        title: 'image.jpg',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          targetAttachment,
          remainingAttachment,
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            child: child,
          ),
          home: StreamChannel(
            showLoading: false,
            channel: mockChannel,
            child: AttachmentActionsModal(
              message: message,
              attachment: targetAttachment,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Delete'));
      verify(() => mockChannel.updateMessage(message.copyWith(
            attachments: [
              message.attachments[1],
            ],
          ))).called(1);
    },
  );

  testWidgets(
    'tapping on delete in chat should remove the attachment if there is text',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final mockChannel = MockChannel();

      when(() => mockChannel.updateMessage(any()))
          .thenAnswer((_) async => UpdateMessageResponse());
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final attachment = Attachment(
        type: 'image',
        title: 'image.jpg',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            child: child,
          ),
          home: StreamChannel(
            showLoading: false,
            channel: mockChannel,
            child: AttachmentActionsModal(
              message: message,
              attachment: attachment,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Delete'));
      verify(() => mockChannel.updateMessage(message.copyWith(
            attachments: [],
          ))).called(1);
    },
  );

  testWidgets(
    // ignore: lines_longer_than_80_chars
    "tapping on delete in chat should remove the message if that's the only attachment and there is no text",
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final mockChannel = MockChannel();

      when(() => mockChannel.deleteMessage(any()))
          .thenAnswer((_) async => EmptyResponse());
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final attachment = Attachment(
        type: 'image',
        title: 'image.jpg',
      );
      final message = Message(
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            child: child,
          ),
          home: StreamChannel(
            showLoading: false,
            channel: mockChannel,
            child: AttachmentActionsModal(
              message: message,
              attachment: attachment,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Delete'));
      verify(() => mockChannel.deleteMessage(message)).called(1);
    },
  );

  testWidgets(
    'tapping on save in chat should call image downloader',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final imageDownloader = MockAttachmentDownloader();

      final attachment = Attachment(
        type: 'image',
        title: 'image.jpg',
      );
      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          attachment,
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            child: child,
          ),
          home: SizedBox(
            child: AttachmentActionsModal(
              imageDownloader: imageDownloader,
              message: message,
              attachment: attachment,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Save Image'));

      imageDownloader.progressCallback!(0, 100000);
      await tester.pump();
      expect(find.text('0.00 MB'), findsOneWidget);

      imageDownloader.progressCallback!(50000, 100000);
      await tester.pump();
      expect(find.text('0.05 MB'), findsOneWidget);

      imageDownloader.progressCallback!(100000, 100000);
      imageDownloader.downloadedPathCallback!('path');
      imageDownloader.completer.complete('path');
      await tester.pump();
      expect(find.byKey(const Key('completedIcon')), findsOneWidget);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
    },
  );

  testWidgets(
    'tapping on save in chat should call file downloader',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final fileDownloader = MockAttachmentDownloader();

      final attachment = Attachment(
        type: 'video',
        title: 'video.mp4',
      );
      final message = Message(
          text: 'test',
          user: User(
            id: 'user-id',
          ),
          attachments: [
            attachment,
          ]);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            child: child,
          ),
          home: SizedBox(
            child: AttachmentActionsModal(
              fileDownloader: fileDownloader,
              message: message,
              attachment: attachment,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Save Video'));

      fileDownloader.progressCallback!(0, 100000);
      await tester.pump();
      expect(find.text('0.00 MB'), findsOneWidget);

      fileDownloader.progressCallback!(50000, 100000);
      await tester.pump();
      expect(find.text('0.05 MB'), findsOneWidget);

      fileDownloader.progressCallback!(100000, 100000);
      fileDownloader.downloadedPathCallback!('path');
      fileDownloader.completer.complete('path');
      await tester.pump();
      expect(find.byKey(const Key('completedIcon')), findsOneWidget);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
    },
  );
}

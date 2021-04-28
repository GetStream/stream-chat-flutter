import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/attachment_actions_modal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

class MockAttachmentDownloader extends Mock {
  ProgressCallback? progressCallback;
  Completer<String> completer = Completer();

  Future<String> call(
    Attachment attachment, {
    ProgressCallback? progressCallback,
  }) {
    this.progressCallback = progressCallback;
    return completer.future;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (context) => SizedBox()));
    registerFallbackValue(Message());
  });

  testWidgets(
    'it should show all the actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: AttachmentActionsModal(
              message: Message(
                text: 'test',
                user: User(
                  id: 'user-id',
                ),
                attachments: [
                  Attachment(
                    type: 'image',
                    title: 'text.jpg',
                  ),
                ],
              ),
              currentIndex: 0,
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
    'it should hide delete if it\'s not my message',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id2'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: AttachmentActionsModal(
              message: Message(
                text: 'test',
                user: User(
                  id: 'user-id',
                ),
                attachments: [
                  Attachment(
                    type: 'image',
                    title: 'text.jpg',
                  ),
                ],
              ),
              currentIndex: 0,
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: Container(
              child: AttachmentActionsModal(
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                  attachments: [
                    Attachment(
                      type: 'video',
                      title: 'video.mp4',
                    ),
                  ],
                ),
                currentIndex: 0,
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      final mockObserver = MockNavigatorObserver();

      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          Attachment(
            type: 'image',
            title: 'image.jpg',
          ),
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          navigatorObservers: [mockObserver],
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: Container(
              child: AttachmentActionsModal(
                message: message,
                currentIndex: 0,
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      final onShowMessage = MockVoidCallback();

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: Container(
              child: AttachmentActionsModal(
                onShowMessage: onShowMessage,
                message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                    attachments: [
                      Attachment(
                        type: 'image',
                        title: 'image.jpg',
                      ),
                    ]),
                currentIndex: 0,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Show in Chat'));
      verify(() => onShowMessage.call()).called(1);
    },
  );

  testWidgets(
    'tapping on delete in chat should remove the attachment',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final mockChannel = MockChannel();

      when(() => mockChannel.updateMessage(any())).thenAnswer((_) async {
        return UpdateMessageResponse();
      });
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          Attachment(
            type: 'image',
            title: 'image.jpg',
          ),
          Attachment(
            type: 'image',
            title: 'image.jpg',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamChat(
              client: client,
              child: child!,
            );
          },
          home: StreamChannel(
            showLoading: false,
            channel: mockChannel,
            child: AttachmentActionsModal(
              message: message,
              currentIndex: 0,
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

      when(() => mockChannel.updateMessage(any())).thenAnswer((_) async {
        return UpdateMessageResponse();
      });
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final message = Message(
        text: 'test',
        user: User(
          id: 'user-id',
        ),
        attachments: [
          Attachment(
            type: 'image',
            title: 'image.jpg',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamChat(
              client: client,
              child: child!,
            );
          },
          home: StreamChannel(
            showLoading: false,
            channel: mockChannel,
            child: AttachmentActionsModal(
              message: message,
              currentIndex: 0,
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
    'tapping on delete in chat should remove the message if that\'s the only attachment and there is no text',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final mockChannel = MockChannel();

      when(() => mockChannel.deleteMessage(any())).thenAnswer((_) async {
        return EmptyResponse();
      });
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final message = Message(
        user: User(
          id: 'user-id',
        ),
        attachments: [
          Attachment(
            type: 'image',
            title: 'image.jpg',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamChat(
              client: client,
              child: child!,
            );
          },
          home: StreamChannel(
            showLoading: false,
            channel: mockChannel,
            child: AttachmentActionsModal(
              message: message,
              currentIndex: 0,
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final imageDownloader = MockAttachmentDownloader();

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamChat(
              client: client,
              child: child!,
            );
          },
          home: Container(
            child: AttachmentActionsModal(
              imageDownloader: imageDownloader,
              message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                  attachments: [
                    Attachment(
                      type: 'image',
                      title: 'image.jpg',
                    ),
                  ]),
              currentIndex: 0,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Save Image'));

      imageDownloader.progressCallback!(0, 100);
      await tester.pump();
      expect(find.text('0%'), findsOneWidget);

      imageDownloader.progressCallback!(50, 100);
      await tester.pump();
      expect(find.text('50%'), findsOneWidget);

      imageDownloader.progressCallback!(100, 100);
      imageDownloader.completer.complete('path');
      await tester.pump();
      expect(find.byKey(Key('completedIcon')), findsOneWidget);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
    },
  );

  testWidgets(
    'tapping on save in chat should call file downloader',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final fileDownloader = MockAttachmentDownloader();

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamChat(
              client: client,
              child: child!,
            );
          },
          home: Container(
            child: AttachmentActionsModal(
              fileDownloader: fileDownloader,
              message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                  attachments: [
                    Attachment(
                      type: 'video',
                      title: 'video.mp4',
                    ),
                  ]),
              currentIndex: 0,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Save Video'));

      fileDownloader.progressCallback!(0, 100);
      await tester.pump();
      expect(find.text('0%'), findsOneWidget);

      fileDownloader.progressCallback!(50, 100);
      await tester.pump();
      expect(find.text('50%'), findsOneWidget);

      fileDownloader.progressCallback!(100, 100);
      fileDownloader.completer.complete('path');
      await tester.pump();
      expect(find.byKey(Key('completedIcon')), findsOneWidget);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
    },
  );
}

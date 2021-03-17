import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/src/attachment_actions_modal.dart';
import 'package:stream_chat_flutter/src/message_actions_modal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show the all actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.getDefaultTheme(themeData);
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
                        type: 'file',
                        title: 'example.pdf',
                        extraData: {
                          'mime_type': 'pdf',
                        },
                      ),
                    ]),
                currentIndex: 0,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.pump(Duration(milliseconds: 1000));
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Show in Chat'), findsOneWidget);
    },
  );

  // testWidgets(
  //   'it should go to reply',
  //       (WidgetTester tester) async {
  //     final client = MockClient();
  //     final clientState = MockClientState();
  //
  //     when(client.state).thenReturn(clientState);
  //     when(clientState.user).thenReturn(OwnUser(id: 'user-id'));
  //
  //     final themeData = ThemeData();
  //     final streamTheme = StreamChatThemeData.getDefaultTheme(themeData);
  //
  //     final mockObserver = MockNavigatorObserver();
  //
  //     await tester.pumpWidget(
  //       MaterialApp(
  //         theme: themeData,
  //         home: StreamChat(
  //           streamChatThemeData: streamTheme,
  //           client: client,
  //           child: Container(
  //             child: AttachmentActionsModal(
  //               message: Message(
  //                   text: 'test',
  //                   user: User(
  //                     id: 'user-id',
  //                   ),
  //                   attachments: [
  //                     Attachment(
  //                       type: 'file',
  //                       title: 'example.pdf',
  //                       extraData: {
  //                         'mime_type': 'pdf',
  //                       },
  //                     ),
  //                   ]
  //               ),
  //               currentIndex: 0,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //     await tester.pump();
  //
  //     await tester.pump(Duration(milliseconds: 1000));
  //     await tester.tap(find.byKey(Key('replyButton')));
  //     await tester.pump(Duration(milliseconds: 3000));
  //     verify(mockObserver.didPop(any, any));
  //   },
  // );
}

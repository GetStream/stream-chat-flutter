import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

void main() {
  test('MessageListViewThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamMessageListViewThemeData(),
        const StreamMessageListViewThemeData().copyWith());
    expect(const StreamMessageListViewThemeData().hashCode,
        const StreamMessageListViewThemeData().copyWith().hashCode);
  });

  test(
      '''Light MessageListViewThemeData lerps completely to dark MessageListViewThemeData''',
      () {
    expect(
        const StreamMessageListViewThemeData().lerp(
            _messageListViewThemeDataControl,
            _messageListViewThemeDataControlDark,
            1),
        _messageListViewThemeDataControlDark);
  });

  test(
      '''Light MessageListViewThemeData lerps halfway to dark MessageListViewThemeData''',
      () {
    expect(
        const StreamMessageListViewThemeData().lerp(
            _messageListViewThemeDataControl,
            _messageListViewThemeDataControlDark,
            0.5),
        _messageListViewThemeDataControlHalfLerp);
  });

  test(
      '''Dark MessageListViewThemeData lerps completely to light MessageListViewThemeData''',
      () {
    expect(
        const StreamMessageListViewThemeData().lerp(
            _messageListViewThemeDataControlDark,
            _messageListViewThemeDataControl,
            1),
        _messageListViewThemeDataControl);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
        _messageListViewThemeDataControl
            .merge(_messageListViewThemeDataControlDark),
        _messageListViewThemeDataControlDark);
  });

  testWidgets(
      'Passing no MessageListViewThemeData returns default light theme values',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockStreamChatClient(),
          child: child,
        ),
        home: Builder(
          builder: (BuildContext context) {
            _context = context;
            return Scaffold(
              body: StreamChannel(
                channel: MockChannel(),
                child: const StreamMessageListView(),
              ),
            );
          },
        ),
      ),
    );

    final messageListViewTheme = StreamMessageListViewTheme.of(_context);
    expect(messageListViewTheme.backgroundColor,
        _messageListViewThemeDataControl.backgroundColor);
  });

  testWidgets(
      'Passing no MessageListViewThemeData returns default dark theme values',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockStreamChatClient(),
          streamChatThemeData: StreamChatThemeData.dark(),
          child: child,
        ),
        home: Builder(
          builder: (BuildContext context) {
            _context = context;
            return Scaffold(
              body: StreamChannel(
                channel: MockChannel(),
                child: const StreamMessageListView(),
              ),
            );
          },
        ),
      ),
    );

    final messageListViewTheme = StreamMessageListViewTheme.of(_context);
    expect(messageListViewTheme.backgroundColor,
        _messageListViewThemeDataControlDark.backgroundColor);
  });

  testWidgets(
      'Pass backgroundImage to MessageListViewThemeData return backgroundImage',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockStreamChatClient(),
          streamChatThemeData: StreamChatThemeData.light()
              .copyWith(messageListViewTheme: _messageListViewThemeDataImage),
          child: child,
        ),
        home: Builder(
          builder: (BuildContext context) {
            _context = context;
            return Scaffold(
              body: StreamChannel(
                channel: MockChannel(),
                child: const StreamMessageListView(),
              ),
            );
          },
        ),
      ),
    );

    final messageListViewTheme = StreamMessageListViewTheme.of(_context);
    expect(messageListViewTheme.backgroundImage,
        _messageListViewThemeDataImage.backgroundImage);
  });
}

final _messageListViewThemeDataControl = StreamMessageListViewThemeData(
  backgroundColor: StreamColorTheme.light().barsBg,
);

const _messageListViewThemeDataControlHalfLerp = StreamMessageListViewThemeData(
  backgroundColor: Color(0xff87898b),
);

final _messageListViewThemeDataControlDark = StreamMessageListViewThemeData(
  backgroundColor: StreamColorTheme.dark().barsBg,
);

const _messageListViewThemeDataImage = StreamMessageListViewThemeData(
  backgroundImage: DecorationImage(
    image: AssetImage('example/assets/background_doodle.png'),
    fit: BoxFit.cover,
  ),
);

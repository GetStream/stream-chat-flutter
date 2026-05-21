import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

void main() {
  test('MessageListViewThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamMessageListViewThemeData(), const StreamMessageListViewThemeData().copyWith());
    expect(const StreamMessageListViewThemeData().hashCode, const StreamMessageListViewThemeData().copyWith().hashCode);
  });

  test('Light MessageListViewThemeData lerps completely to dark MessageListViewThemeData', () {
    expect(
      StreamMessageListViewThemeData.lerp(
        _messageListViewThemeDataControl,
        _messageListViewThemeDataControlDark,
        1,
      ),
      _messageListViewThemeDataControlDark,
    );
  });

  test('Light MessageListViewThemeData lerps halfway to dark MessageListViewThemeData', () {
    expect(
      StreamMessageListViewThemeData.lerp(
        _messageListViewThemeDataControl,
        _messageListViewThemeDataControlDark,
        0.5,
      ),
      _messageListViewThemeDataControlHalfLerp,
    );
  });

  test('Dark MessageListViewThemeData lerps completely to light MessageListViewThemeData', () {
    expect(
      StreamMessageListViewThemeData.lerp(
        _messageListViewThemeDataControlDark,
        _messageListViewThemeDataControl,
        1,
      ),
      _messageListViewThemeDataControl,
    );
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
      _messageListViewThemeDataControl.merge(_messageListViewThemeDataControlDark),
      _messageListViewThemeDataControlDark,
    );
  });

  testWidgets('Passing no MessageListViewThemeData returns default light theme values', (WidgetTester tester) async {
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final messageListViewTheme = StreamMessageListViewTheme.of(_context);
    expect(messageListViewTheme.backgroundColor, isNull);
  });

  testWidgets('StreamMessageListViewTheme.of merges local theme over global theme', (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockStreamChatClient(),
          // Global theme sets backgroundColor only.
          streamChatThemeData: StreamChatThemeData().copyWith(
            messageListViewTheme: const StreamMessageListViewThemeData(
              backgroundColor: _bgColorLight,
            ),
          ),
          child: child,
        ),
        home: StreamMessageListViewTheme(
          // Local theme overrides messageHighlightColor only.
          data: const StreamMessageListViewThemeData(
            messageHighlightColor: _highlightColorDark,
          ),
          child: Builder(
            builder: (BuildContext context) {
              _context = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    final messageListViewTheme = StreamMessageListViewTheme.of(_context);
    // backgroundColor comes from the global theme.
    expect(messageListViewTheme.backgroundColor, _bgColorLight);
    // messageHighlightColor comes from the local theme.
    expect(messageListViewTheme.messageHighlightColor, _highlightColorDark);
  });

  testWidgets('Pass backgroundImage to MessageListViewThemeData return backgroundImage', (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockStreamChatClient(),
          streamChatThemeData: StreamChatThemeData().copyWith(
            messageListViewTheme: _messageListViewThemeDataImage,
          ),
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
    expect(messageListViewTheme.backgroundImage, _messageListViewThemeDataImage.backgroundImage);
  });
}

const _bgColorLight = Color(0xFFFFFFFF);
const _bgColorDark = Color(0xFF121212);
const _highlightColorLight = Color(0x40BBDEFB);
const _highlightColorDark = Color(0x401A237E);

const _messageListViewThemeDataControl = StreamMessageListViewThemeData(
  backgroundColor: _bgColorLight,
  messageHighlightColor: _highlightColorLight,
);

final _messageListViewThemeDataControlHalfLerp = StreamMessageListViewThemeData(
  backgroundColor: Color.lerp(_bgColorLight, _bgColorDark, 0.5),
  messageHighlightColor: Color.lerp(_highlightColorLight, _highlightColorDark, 0.5),
);

const _messageListViewThemeDataControlDark = StreamMessageListViewThemeData(
  backgroundColor: _bgColorDark,
  messageHighlightColor: _highlightColorDark,
);

const _messageListViewThemeDataImage = StreamMessageListViewThemeData(
  backgroundImage: DecorationImage(
    image: AssetImage('example/assets/background_doodle.png'),
    fit: BoxFit.cover,
  ),
);

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  test('MessageSearchListViewThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamMessageSearchListViewThemeData(),
        const StreamMessageSearchListViewThemeData().copyWith());
    expect(const StreamMessageSearchListViewThemeData().hashCode,
        const StreamMessageSearchListViewThemeData().copyWith().hashCode);
  });

  test(
      '''Light MessageSearchListViewThemeData lerps completely to dark MessageSearchListViewThemeData''',
      () {
    expect(
        const StreamMessageSearchListViewThemeData().lerp(
            _messageSearchListViewThemeDataControl,
            _messageSearchListViewThemeDataControlDark,
            1),
        _messageSearchListViewThemeDataControlDark);
  });

  test(
      '''Light MessageSearchListViewThemeData lerps halfway to dark MessageSearchListViewThemeData''',
      () {
    expect(
        const StreamMessageSearchListViewThemeData().lerp(
            _messageSearchListViewThemeDataControl,
            _messageSearchListViewThemeDataControlDark,
            0.5),
        _messageSearchListViewThemeDataControlHalfLerp);
  });

  test(
      '''Dark MessageSearchListViewThemeData lerps completely to light MessageSearchListViewThemeData''',
      () {
    expect(
        const StreamMessageSearchListViewThemeData().lerp(
            _messageSearchListViewThemeDataControlDark,
            _messageSearchListViewThemeDataControl,
            1),
        _messageSearchListViewThemeDataControl);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
        _messageSearchListViewThemeDataControl
            .merge(_messageSearchListViewThemeDataControlDark),
        _messageSearchListViewThemeDataControlDark);
  });

  testWidgets(
      '''Passing no MessageSearchListViewThemeData returns default light theme values''',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockClient(),
          child: child,
        ),
        home: Builder(
          builder: (BuildContext context) {
            _context = context;
            return Scaffold(
              body: MessageSearchBloc(
                child: MessageSearchListView(
                  filters: Filter.in_('members', const ['test_id']),
                  messageQuery: 'test query',
                ),
              ),
            );
          },
        ),
      ),
    );

    final messageSearchListViewTheme =
        StreamMessageSearchListViewTheme.of(_context);
    expect(messageSearchListViewTheme.backgroundColor,
        _messageSearchListViewThemeDataControl.backgroundColor);
  });

  testWidgets(
      '''Passing no MessageSearchListViewThemeData returns default dark theme values''',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockClient(),
          streamChatThemeData: StreamChatThemeData.dark(),
          child: child,
        ),
        home: Builder(
          builder: (BuildContext context) {
            _context = context;
            return Scaffold(
              body: MessageSearchBloc(
                child: MessageSearchListView(
                  filters: Filter.in_('members', const ['test_id']),
                  messageQuery: 'test query',
                ),
              ),
            );
          },
        ),
      ),
    );

    final messageSearchListViewTheme =
        StreamMessageSearchListViewTheme.of(_context);
    expect(messageSearchListViewTheme.backgroundColor,
        _messageSearchListViewThemeDataControlDark.backgroundColor);
  });
}

final _messageSearchListViewThemeDataControl =
    StreamMessageSearchListViewThemeData(
  backgroundColor: StreamColorTheme.light().appBg,
);

const _messageSearchListViewThemeDataControlHalfLerp =
    StreamMessageSearchListViewThemeData(
  backgroundColor: Color(0xff818384),
);

final _messageSearchListViewThemeDataControlDark =
    StreamMessageSearchListViewThemeData(
  backgroundColor: StreamColorTheme.dark().appBg,
);

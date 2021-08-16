import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  test('ChannelListViewThemeData copyWith, ==, hashCode basics', () {
    expect(const ChannelListViewThemeData(),
        const ChannelListViewThemeData().copyWith());
  });

  test(
      '''Light ChannelListViewThemeData lerps completely to dark ChannelListViewThemeData''',
      () {
    expect(
        const ChannelListViewThemeData().lerp(_channelListViewThemeDataControl,
            _channelListViewThemeDataControlDark, 1),
        _channelListViewThemeDataControlDark);
  });

  test(
      '''Light ChannelListViewThemeData lerps halfway to dark ChannelListViewThemeData''',
      () {
    expect(
        const ChannelListViewThemeData().lerp(_channelListViewThemeDataControl,
            _channelListViewThemeDataControlDark, 0.5),
        _channelListViewThemeDataControlHalfLerp);
  });

  test(
      '''Dark ChannelListViewThemeData lerps completely to light ChannelListViewThemeData''',
      () {
    expect(
        const ChannelListViewThemeData().lerp(
            _channelListViewThemeDataControlDark,
            _channelListViewThemeDataControl,
            1),
        _channelListViewThemeDataControl);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
        _channelListViewThemeDataControl
            .merge(_channelListViewThemeDataControlDark),
        _channelListViewThemeDataControlDark);
  });

  testWidgets(
      'Passing no ChannelListViewThemeData returns default light theme values',
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
              body: StreamChannel(
                channel: MockChannel(),
                child: const ChannelListView(),
              ),
            );
          },
        ),
      ),
    );

    final channelListViewTheme = ChannelListViewTheme.of(_context);
    expect(channelListViewTheme.backgroundColor,
        _channelListViewThemeDataControl.backgroundColor);
  });

  testWidgets(
      'Passing no ChannelListViewThemeData returns default dark theme values',
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
              body: StreamChannel(
                channel: MockChannel(),
                child: const MessageListView(),
              ),
            );
          },
        ),
      ),
    );

    final channelListViewTheme = ChannelListViewTheme.of(_context);
    expect(channelListViewTheme.backgroundColor,
        _channelListViewThemeDataControlDark.backgroundColor);
  });
}

final _channelListViewThemeDataControl = ChannelListViewThemeData(
  backgroundColor: ColorTheme.light().appBg,
);

const _channelListViewThemeDataControlHalfLerp = ChannelListViewThemeData(
  backgroundColor: Color(0xff818384),
);

final _channelListViewThemeDataControlDark = ChannelListViewThemeData(
  backgroundColor: ColorTheme.dark().appBg,
);

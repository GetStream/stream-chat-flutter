// ignore: lines_longer_than_80_chars
// ignore_for_file: deprecated_member_use_from_same_package, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  test('UserListViewThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamUserListViewThemeData(),
        const StreamUserListViewThemeData().copyWith());
  });

  test(
      '''Light UserListViewThemeData lerps completely to dark UserListViewThemeData''',
      () {
    expect(
        const StreamUserListViewThemeData().lerp(_userListViewThemeDataControl,
            _userListViewThemeDataControlDark, 1),
        _userListViewThemeDataControlDark);
  });

  test(
      '''Light UserListViewThemeData lerps halfway to dark UserListViewThemeData''',
      () {
    expect(
        const StreamUserListViewThemeData().lerp(_userListViewThemeDataControl,
            _userListViewThemeDataControlDark, 0.5),
        _userListViewThemeDataControlHalfLerp);
  });

  test(
      '''Dark UserListViewThemeData lerps completely to light UserListViewThemeData''',
      () {
    expect(
        const StreamUserListViewThemeData().lerp(
            _userListViewThemeDataControlDark,
            _userListViewThemeDataControl,
            1),
        _userListViewThemeDataControl);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
        _userListViewThemeDataControl.merge(_userListViewThemeDataControlDark),
        _userListViewThemeDataControlDark);
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
              body: UsersBloc(
                child: UserListView(),
              ),
            );
          },
        ),
      ),
    );

    final userListViewTheme = StreamUserListViewTheme.of(_context);
    expect(userListViewTheme.backgroundColor,
        _userListViewThemeDataControl.backgroundColor);
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
              body: UsersBloc(
                child: UserListView(),
              ),
            );
          },
        ),
      ),
    );

    final userListViewTheme = StreamUserListViewTheme.of(_context);
    expect(userListViewTheme.backgroundColor,
        _userListViewThemeDataControlDark.backgroundColor);
  });
}

final _userListViewThemeDataControl = StreamUserListViewThemeData(
  backgroundColor: StreamColorTheme.light().appBg,
);

const _userListViewThemeDataControlHalfLerp = StreamUserListViewThemeData(
  backgroundColor: Color(0xff818384),
);

final _userListViewThemeDataControlDark = StreamUserListViewThemeData(
  backgroundColor: StreamColorTheme.dark().appBg,
);

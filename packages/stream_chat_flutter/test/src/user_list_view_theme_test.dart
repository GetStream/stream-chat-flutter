import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  test('UserListViewThemeData copyWith, ==, hashCode basics', () {
    expect(const UserListViewThemeData(),
        const UserListViewThemeData().copyWith());
  });

  test(
      '''Light UserListViewThemeData lerps completely to dark UserListViewThemeData''',
      () {
    expect(
        const UserListViewThemeData().lerp(_userListViewThemeDataControl,
            _userListViewThemeDataControlDark, 1),
        _userListViewThemeDataControlDark);
  });

  test(
      '''Light UserListViewThemeData lerps halfway to dark UserListViewThemeData''',
      () {
    expect(
        const UserListViewThemeData().lerp(_userListViewThemeDataControl,
            _userListViewThemeDataControlDark, 0.5),
        _userListViewThemeDataControlHalfLerp);
  });

  test(
      '''Dark UserListViewThemeData lerps completely to light UserListViewThemeData''',
      () {
    expect(
        const UserListViewThemeData().lerp(_userListViewThemeDataControlDark,
            _userListViewThemeDataControl, 1),
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
            return const Scaffold(
              body: UsersBloc(
                child: UserListView(),
              ),
            );
          },
        ),
      ),
    );

    final userListViewTheme = UserListViewTheme.of(_context);
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
            return const Scaffold(
              body: UsersBloc(
                child: UserListView(),
              ),
            );
          },
        ),
      ),
    );

    final userListViewTheme = UserListViewTheme.of(_context);
    expect(userListViewTheme.backgroundColor,
        _userListViewThemeDataControlDark.backgroundColor);
  });
}

final _userListViewThemeDataControl = UserListViewThemeData(
  backgroundColor: ColorTheme.light().appBg,
);

const _userListViewThemeDataControlHalfLerp = UserListViewThemeData(
  backgroundColor: Color(0xff818384),
);

final _userListViewThemeDataControlDark = UserListViewThemeData(
  backgroundColor: ColorTheme.dark().appBg,
);

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> _pumpItem(
  WidgetTester tester, {
  required Widget child,
  StreamComponentBuilders? componentBuilders,
}) async {
  Widget tree = MaterialApp(
    home: StreamChatConfiguration(
      data: StreamChatConfigurationData(),
      child: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Scaffold(body: child),
      ),
    ),
  );

  if (componentBuilders != null) {
    tree = StreamComponentFactory(builders: componentBuilders, child: tree);
  }

  await tester.pumpWidget(tree);
  await tester.pumpAndSettle();
}

void main() {
  group('DefaultStreamMentionItem', () {
    testWidgets('renders @channel title and notifyChannelText subtitle', (tester) async {
      await _pumpItem(
        tester,
        child: const StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: StreamChannelMention()),
        ),
      );

      expect(find.text('@channel'), findsOneWidget);
      expect(find.text('Notify everyone in this channel'), findsOneWidget);
    });

    testWidgets('renders @here title and notifyHereText subtitle', (tester) async {
      await _pumpItem(
        tester,
        child: const StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: StreamHereMention()),
        ),
      );

      expect(find.text('@here'), findsOneWidget);
      expect(find.text('Notify every online member in this channel'), findsOneWidget);
    });

    testWidgets('renders @<role> title and notifyRoleText subtitle for a role mention', (tester) async {
      await _pumpItem(
        tester,
        child: const StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: StreamRoleMention(role: 'admin')),
        ),
      );

      expect(find.text('@admin'), findsOneWidget);
      expect(find.text('Notify all admin members'), findsOneWidget);
    });

    testWidgets('renders @<group> title and description subtitle for a group with description', (tester) async {
      final group = UserGroup(
        id: 'hr-id',
        name: 'hr',
        description: 'Human Resources team',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );

      await _pumpItem(
        tester,
        child: StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: StreamGroupMention(userGroup: group)),
        ),
      );

      expect(find.text('@hr'), findsOneWidget);
      expect(find.text('Human Resources team'), findsOneWidget);
    });

    testWidgets('hides the subtitle when a group has no description', (tester) async {
      final group = UserGroup(
        id: 'hr-id',
        name: 'hr',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );

      await _pumpItem(
        tester,
        child: StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: StreamGroupMention(userGroup: group)),
        ),
      );

      expect(find.text('@hr'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('hides the subtitle when a group has an empty description', (tester) async {
      final group = UserGroup(
        id: 'hr-id',
        name: 'hr',
        description: '',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );

      await _pumpItem(
        tester,
        child: StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: StreamGroupMention(userGroup: group)),
        ),
      );

      expect(find.text('@hr'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders user.name with an avatar and no subtitle for a user mention', (tester) async {
      final user = User(id: 'alice-id', name: 'Alice');

      await _pumpItem(
        tester,
        child: StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: StreamUserMention(user: user)),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
      expect(find.byType(StreamUserAvatar), findsOneWidget);
    });

    testWidgets('falls back to @<display> for unknown StreamMention subclasses', (tester) async {
      await _pumpItem(
        tester,
        child: const StreamMentionItem.fromProps(
          props: StreamMentionItemProps(mention: _CustomMention()),
        ),
      );

      expect(find.text('@custom-display'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });

  group('StreamMentionItem', () {
    testWidgets('falls back to DefaultStreamMentionItem when no global builder is registered', (tester) async {
      await _pumpItem(
        tester,
        child: StreamMentionItem(mention: const StreamChannelMention()),
      );

      expect(find.byType(DefaultStreamMentionItem), findsOneWidget);
      expect(find.text('@channel'), findsOneWidget);
    });

    testWidgets('honors a global mentionItem component builder when registered', (tester) async {
      await _pumpItem(
        tester,
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            mentionItem: (_, props) => Text('custom-${props.mention.display}'),
          ),
        ),
        child: StreamMentionItem(mention: const StreamChannelMention()),
      );

      expect(find.text('custom-channel'), findsOneWidget);
      expect(find.byType(DefaultStreamMentionItem), findsNothing);
    });

    testWidgets('invokes onTap when the item is tapped', (tester) async {
      var tapCount = 0;
      await _pumpItem(
        tester,
        child: StreamMentionItem(
          mention: const StreamChannelMention(),
          onTap: () => tapCount++,
        ),
      );

      await tester.tap(find.text('@channel'));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    });

    testWidgets('forwards onTap from StreamMentionItemProps through .fromProps', (tester) async {
      var tapCount = 0;
      await _pumpItem(
        tester,
        child: StreamMentionItem.fromProps(
          props: StreamMentionItemProps(
            mention: const StreamHereMention(),
            onTap: () => tapCount++,
          ),
        ),
      );

      await tester.tap(find.text('@here'));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    });
  });

  group('StreamMentionItemProps', () {
    test('stores mention and onTap', () {
      const mention = StreamChannelMention();
      void onTap() {}
      const props = StreamMentionItemProps(mention: mention);
      final propsWithTap = StreamMentionItemProps(mention: mention, onTap: onTap);

      expect(props.mention, same(mention));
      expect(props.onTap, isNull);
      expect(propsWithTap.onTap, same(onTap));
    });
  });
}

class _CustomMention extends StreamMention {
  const _CustomMention();

  @override
  StreamMentionType get type => StreamMentionType.user;

  @override
  String get display => 'custom-display';
}

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Diagnostic test comparing the semantic tree produced by Flutter's vanilla
// Material TabBar vs. our custom tab strip (using StreamButton.icon).
// Goal: keep StreamButton.icon but match Flutter's wrapping pattern as
// closely as possible, then inspect the merged SemanticsData per tab to
// confirm announcement-order parity.

String _fmt(SemanticsData d) {
  final lines = <String>[];
  void add(String key, Object? value) {
    if (value == null) return;
    if (value is String && value.isEmpty) return;
    if (value is List && value.isEmpty) return;
    lines.add('  $key: $value');
  }

  final actions = SemanticsAction.values.where((a) => (d.actions & a.index) != 0).map((a) => a.name).toList();
  final flags = d.flagsCollection.toStrings();

  add('actions', actions);
  add('flags', flags);
  add('label', d.label);
  add('tooltip', d.tooltip);
  add('hint', d.hint);
  add('role', d.role == SemanticsRole.none ? null : d.role.name);
  return '{\n${lines.join(',\n')}\n}';
}

Widget _wrap(Widget widget) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.streamColorScheme.backgroundApp,
          body: Center(child: widget),
        ),
      ),
    ),
  );
}

const _tabTitles = ['Photo gallery', 'Take a photo', 'Choose file'];

void _dumpTabs(WidgetTester tester, String header) {
  debugPrint('============ $header ============');
  for (final (i, title) in _tabTitles.indexed) {
    final tabNode = tester.getSemantics(find.byTooltip(title));
    debugPrint('--- Tab $i ($title) ---');
    debugPrint(_fmt(tabNode.getSemanticsData()));
  }
}

void main() {
  group('Tab semantics diff: Flutter TabBar vs StreamButton.icon-based strip', () {
    testWidgets('Flutter TabBar with Tab(icon: Semantics(label:))', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(
          DefaultTabController(
            length: _tabTitles.length,
            initialIndex: 1,
            child: TabBar(
              isScrollable: true,
              tabs: [
                for (final title in _tabTitles)
                  Tab(
                    icon: Tooltip(
                      message: title,
                      child: Semantics(
                        label: title,
                        child: const Icon(Icons.photo),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      _dumpTabs(tester, 'FLUTTER TABBAR');

      handle.dispose();
    });

    testWidgets(
      'our tab strip — MergeSemantics + Semantics(role: tab) + Stack + sibling Semantics(selected, label)',
      (tester) async {
        final handle = tester.ensureSemantics();
        var selectedIndex = 1;

        await tester.pumpWidget(
          _wrap(
            StatefulBuilder(
              builder: (context, setState) {
                final localizations = MaterialLocalizations.of(context);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Semantics(
                    container: true,
                    explicitChildNodes: true,
                    role: SemanticsRole.tabBar,
                    child: Row(
                      children: [
                        for (final (i, title) in _tabTitles.indexed)
                          // Flutter's TabBar exact wrap pattern:
                          // MergeSemantics > Semantics(role: tab) > Stack > [content, Semantics(selected, label)]
                          MergeSemantics(
                            child: Semantics(
                              label: title,
                              role: SemanticsRole.tab,
                              child: Stack(
                                children: [
                                  // External Tooltip with excludeFromSemantics:true
                                  // for the visible popover only; SR label comes from
                                  // the outer Semantics(label:) wrap. StreamButton
                                  // intentionally has NO tooltip here to avoid the
                                  // duplicate read ("name, ..., name, double tap...").
                                  Tooltip(
                                    message: title,
                                    excludeFromSemantics: true,
                                    child: StreamButton.icon(
                                      style: StreamButtonStyle.secondary,
                                      type: StreamButtonType.ghost,
                                      size: StreamButtonSize.large,
                                      onPressed: () => setState(() => selectedIndex = i),
                                      isSelected: i == selectedIndex,
                                      icon: const Icon(Icons.photo),
                                    ),
                                  ),
                                  Semantics(
                                    selected: i == selectedIndex,
                                    label: localizations.tabLabel(
                                      tabIndex: i + 1,
                                      tabCount: _tabTitles.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );

        _dumpTabs(tester, 'OUR TAB STRIP');

        handle.dispose();
      },
    );
  });
}

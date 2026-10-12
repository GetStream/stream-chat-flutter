import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/misc/memoized_builder.dart';

void main() {
  testWidgets('MemoizedBuilder reuses its child while the dependencies are equal', (tester) async {
    var builds = 0;
    Widget memo() => MemoizedBuilder(
      dependencies: (1, 'a'),
      builder: (context) {
        builds += 1;
        return const SizedBox();
      },
    );

    await tester.pumpWidget(memo());
    await tester.pumpWidget(memo());

    expect(builds, 1);
  });

  testWidgets('MemoizedBuilder rebuilds its child when the dependencies change', (tester) async {
    var builds = 0;
    Widget memo(int value) => MemoizedBuilder(
      dependencies: value,
      builder: (context) {
        builds += 1;
        return Text('$value', textDirection: TextDirection.ltr);
      },
    );

    await tester.pumpWidget(memo(1));
    await tester.pumpWidget(memo(2));

    expect(builds, 2);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('MemoizedBuilder rebuilds its child when an inherited value it reads changes', (tester) async {
    Widget memo(Brightness brightness) => Theme(
      data: ThemeData(brightness: brightness),
      child: MemoizedBuilder(
        dependencies: null,
        builder: (context) => Text(Theme.of(context).brightness.name, textDirection: TextDirection.ltr),
      ),
    );

    await tester.pumpWidget(memo(Brightness.light));
    await tester.pumpWidget(memo(Brightness.dark));

    expect(find.text('dark'), findsOneWidget);
  });
}

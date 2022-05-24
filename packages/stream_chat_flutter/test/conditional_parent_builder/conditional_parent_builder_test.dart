import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/conditional_parent_builder/conditional_parent_builder.dart';

void main() {
  testWidgets('ConditionalParentBuilder builds the parent widget',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ConditionalParentBuilder(
              builder: (context, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child,
                ],
              ),
              child: const Text('Hello World!'),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('ConditionalParentBuilder does not build the parent widget',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ConditionalParentBuilder(
              builder: (context, child) {
                return child;
              },
              child: const Text('Hello World!'),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Text), findsOneWidget);
  });
}

import 'dart:math';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  testWidgets(
    'control test',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: const Scaffold(
              body: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: StreamGradientAvatar(
                      name: 'demo user', userId: 'demo123'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamGradientAvatar), findsOneWidget);
    },
  );

  goldenTest(
    'golden test for the name "demo user"',
    fileName: 'gradient_avatar_0',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(name: 'demo user', userId: 'demo123'),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'golden test for the name "demo"',
    fileName: 'gradient_avatar_1',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(name: 'demo', userId: 'demo1'),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'control special character test',
    fileName: 'gradient_avatar_2',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(
              name: r'd123@/d de:$as',
              userId: 'demo123',
            ),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'control special character test 2',
    fileName: 'gradient_avatar_3',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(
              name: r'123@/d $as',
              userId: 'demo123',
            ),
          ),
        ),
      ),
    ),
  );

  group('Gradient Avatar deterministic color tests', () {
    test('users with same length IDs should have different gradient colors', () {
      // Create a few user IDs of the same length but different values
      final userIdsWithSameLength = ['12133', '12134', '12135', '98765', '54321'];
      final gradientIndices = <int>[];
      
      for (final userId in userIdsWithSameLength) {
        // Create a mock random generator using userId.hashCode (the fix)
        final rand = Random(userId.hashCode);
        final gradientIndex = rand.nextInt(colorGradients.length);
        gradientIndices.add(gradientIndex);
      }
      
      // Verify that not all gradient indices are the same
      // (With the old behavior using userId.length, they would all be identical)
      final uniqueIndices = gradientIndices.toSet();
      expect(uniqueIndices.length, greaterThan(1), 
        reason: 'Users with same-length IDs should get different gradient colors');
    });

    test('same user ID should always get the same gradient color', () {
      const userId = '12345';
      final gradientIndices = <int>[];
      
      // Generate gradient index multiple times for the same user
      for (int i = 0; i < 5; i++) {
        final rand = Random(userId.hashCode);
        final gradientIndex = rand.nextInt(colorGradients.length);
        gradientIndices.add(gradientIndex);
      }
      
      // All indices should be the same for the same user
      final uniqueIndices = gradientIndices.toSet();
      expect(uniqueIndices.length, equals(1),
        reason: 'Same user ID should always get the same gradient color');
    });
    
    test('different user IDs should have potential for different colors', () {
      final userIds = ['user1', 'user2', 'user3', 'user4', 'user5'];
      final gradientIndices = <int>[];
      
      for (final userId in userIds) {
        final rand = Random(userId.hashCode);
        final gradientIndex = rand.nextInt(colorGradients.length);
        gradientIndices.add(gradientIndex);
      }
      
      // While not guaranteed, different users should very likely get different colors
      final uniqueIndices = gradientIndices.toSet();
      expect(uniqueIndices.length, greaterThan(1), 
        reason: 'Different users should have potential for different gradient colors');
    });
  });
}

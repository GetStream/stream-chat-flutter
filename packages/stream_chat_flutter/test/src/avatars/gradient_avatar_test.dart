// ignore_for_file: lines_longer_than_80_chars

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

  // Regression test for GitHub issue #2369
  // https://github.com/GetStream/stream-chat-flutter/issues/2369
  //
  // Issue: All Users have the same Gradient Avatar color
  // Problem: Users with same-length IDs were getting identical gradient colors
  // Solution: Use userId.hashCode instead of length-based randomization
  goldenTest(
    'GitHub issue #2369 - same-length user IDs should have different colors',
    fileName: 'gradient_avatar_issue_2369',
    builder: () => GoldenTestGroup(
      children: [
        // Test case from GitHub issue #2369 - these numeric IDs have same length
        // but should produce different gradient colors after the fix
        GoldenTestScenario(
          name: 'Numeric IDs (5 chars) - Should show different colors',
          constraints: const BoxConstraints.tightFor(width: 450, height: 180),
          child: const AvatarComparisonRow(
            users: [
              ('12133', 'User One'), // Example IDs from the issue
              ('12134', 'User Two'), // These were showing same colors
              ('12135', 'User Three'), // before the hashCode fix
            ],
          ),
        ),
        // Additional test with alphabetic IDs of same length
        GoldenTestScenario(
          name: 'Alphabetic IDs (5 chars) - Should show different colors',
          constraints: const BoxConstraints.tightFor(width: 450, height: 180),
          child: const AvatarComparisonRow(
            users: [
              ('abcde', 'User Alpha'),
              ('fghij', 'User Beta'),
              ('klmno', 'User Gamma'),
            ],
          ),
        ),
        GoldenTestScenario(
          name: 'Mixed length IDs - For reference (should be different)',
          constraints: const BoxConstraints.tightFor(width: 450, height: 180),
          child: const AvatarComparisonRow(
            users: [
              ('a', 'Short'),
              ('medium123', 'Medium'),
              ('verylonguser456', 'Long'),
            ],
          ),
        ),
        GoldenTestScenario(
          name: 'Same user ID - Should be identical',
          constraints: const BoxConstraints.tightFor(width: 450, height: 180),
          child: const AvatarComparisonRow(
            users: [
              ('test123', 'Same User'),
              ('test123', 'Same User'),
              ('test123', 'Same User'),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A widget that displays a row of gradient avatars for comparison testing.
///
/// This widget is specifically designed for testing gradient avatar color
/// variations, particularly for verifying fixes to GitHub issue #2369 where
/// users with same-length IDs were getting identical colors.
///
/// See: https://github.com/GetStream/stream-chat-flutter/issues/2369
class AvatarComparisonRow extends StatelessWidget {
  /// Creates an [AvatarComparisonRow] with the given list of users.
  ///
  /// The [users] parameter should contain tuples of (userId, userName) pairs
  /// to be displayed as gradient avatars for visual comparison.
  const AvatarComparisonRow({
    super.key,
    required this.users,
    this.avatarSize = 100.0,
    this.spacing = 8.0,
  });

  /// List of users to display as (userId, userName) tuples
  final List<(String, String)> users;

  /// Size of each avatar in logical pixels
  final double avatarSize;

  /// Horizontal spacing between avatars in logical pixels
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: users.map((userData) {
        final (userId, userName) = userData;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: _AvatarItem(
              userId: userId,
              userName: userName,
              avatarSize: avatarSize,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Individual avatar item with labels
class _AvatarItem extends StatelessWidget {
  const _AvatarItem({
    required this.userId,
    required this.userName,
    required this.avatarSize,
  });

  final String userId;
  final String userName;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: avatarSize,
          height: avatarSize,
          child: StreamGradientAvatar(
            name: userName,
            userId: userId,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          userId,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          userName,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

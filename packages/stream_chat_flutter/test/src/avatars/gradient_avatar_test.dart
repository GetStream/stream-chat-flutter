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
    constraints: const BoxConstraints.tightFor(width: 600, height: 1200),
    builder: () => _wrapWithMaterialApp(
      const AvatarComparisonTestWidget(),
    ),
  );
}

/// Custom test widget for GitHub issue #2369 avatar comparison
///
/// This widget creates a custom themed layout without using GoldenTestGroup
/// to avoid theme conflicts with other tests in the package.
class AvatarComparisonTestWidget extends StatelessWidget {
  const AvatarComparisonTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GitHub Issue #2369 - Gradient Avatar Color Fix',
          style: theme.textTheme.title,
        ),
        const SizedBox(height: 8),
        Text(
          'Users with same-length IDs should have different colors',
          style: theme.textTheme.headline.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
        ),
        const SizedBox(height: 16),

        // Test scenarios
        _buildTestSection(
          context,
          title: 'Numeric IDs (5 chars) - Should show different colors',
          description: 'Example IDs from the GitHub issue',
          child: const AvatarComparisonRow(
            users: [
              ('12133', 'User One'), // Example IDs from the issue
              ('12134', 'User Two'), // These were showing same colors
              ('12135', 'User Three'), // before the hashCode fix
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildTestSection(
          context,
          title: 'Alphabetic IDs (5 chars) - Should show different colors',
          description: 'Additional test with same-length alphabetic IDs',
          child: const AvatarComparisonRow(
            users: [
              ('abcde', 'User Alpha'),
              ('fghij', 'User Beta'),
              ('klmno', 'User Gamma'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildTestSection(
          context,
          title: 'Mixed length IDs - For reference',
          description: 'Different length IDs should always be different',
          child: const AvatarComparisonRow(
            users: [
              ('a', 'Short'),
              ('medium123', 'Medium'),
              ('verylonguser456', 'Long'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildTestSection(
          context,
          title: 'Same user ID - Should be identical',
          description: 'Consistency test - same ID should produce same colors',
          child: const AvatarComparisonRow(
            users: [
              ('test123', 'Same User'),
              ('test123', 'Same User'),
              ('test123', 'Same User'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    final theme = StreamChatTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headline.copyWith(
            color: theme.colorTheme.textHighEmphasis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.body.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorTheme.barsBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorTheme.borders),
          ),
          child: child,
        ),
      ],
    );
  }
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
    final theme = StreamChatTheme.of(context);

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
          style: theme.textTheme.footnoteBold.copyWith(
            color: theme.colorTheme.textHighEmphasis,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          userName,
          style: theme.textTheme.footnote.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(brightness: brightness),
      child: Builder(builder: (context) {
        final theme = StreamChatTheme.of(context);
        return Scaffold(
          backgroundColor: theme.colorTheme.appBg,
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Center(child: widget),
          ),
        );
      }),
    ),
  );
}

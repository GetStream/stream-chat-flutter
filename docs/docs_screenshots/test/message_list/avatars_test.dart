import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_network_image.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // -----------------------------------------------------------------------
  // avatarGroup — custom group grid layout via StreamComponentFactory
  // Shows a horizontal row instead of the default 2×2 grid.
  // -----------------------------------------------------------------------

  docsGoldenTest(
    'avatar group custom layout',
    fileName: 'avatar_group_custom',
    constraints: const BoxConstraints.tightFor(width: 120, height: 60),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      final users = [noahSmith, sophiaLee, liamJohnson, elenaBarros];

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamComponentFactory(
          builders: StreamComponentBuilders(
            // Re-register the golden network image stub so this inner factory
            // doesn't shadow the outer GoldenComponentFactory's networkImage slot.
            networkImage: goldenNetworkImageBuilder,
            avatarGroup: (context, props) {
              // Custom layout: horizontal row instead of the default 2×2 grid.
              final themeSize = switch (props.size ?? StreamAvatarGroupSize.lg) {
                StreamAvatarGroupSize.lg => StreamAvatarSize.sm,
                StreamAvatarGroupSize.xl => StreamAvatarSize.md,
                StreamAvatarGroupSize.xxl => StreamAvatarSize.xl,
              };
              return StreamAvatarTheme(
                data: StreamAvatarThemeData(size: themeSize),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: props.children
                      .take(3)
                      .map(
                        (avatar) => Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: avatar,
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: StreamUserAvatarGroup(
                users: users,
                size: StreamAvatarGroupSize.lg,
              ),
            ),
          ),
        ),
      );
    },
  );

  // -----------------------------------------------------------------------
  // avatarStack — custom layout via StreamComponentFactory
  // Shows 1 medium avatar on top, remaining avatars in a row below.
  // -----------------------------------------------------------------------

  docsGoldenTest(
    'avatar stack custom layout',
    fileName: 'avatar_stack_custom',
    constraints: const BoxConstraints.tightFor(width: 120, height: 60),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      final users = [noahSmith, sophiaLee, liamJohnson, elenaBarros];

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamComponentFactory(
          builders: StreamComponentBuilders(
            // Re-register the golden network image stub so this inner factory
            // doesn't shadow the outer GoldenComponentFactory's networkImage slot.
            networkImage: goldenNetworkImageBuilder,
            avatarStack: (context, props) {
              // Custom layout: 1 medium avatar on top (overlapping the row
              // below by 10%), rest in a small overlapping row (40% overlap).
              final visible = props.children.take(props.max).toList();
              if (visible.isEmpty) return const SizedBox.shrink();

              final topDiameter = StreamAvatarSize.md.value;
              final bottomDiameter = StreamAvatarSize.sm.value;
              final step = bottomDiameter * 0.6;
              final rest = visible.skip(1).toList();
              final bottomRowWidth = rest.isEmpty ? 0.0 : bottomDiameter + (rest.length - 1) * step;
              final totalWidth = bottomRowWidth.clamp(topDiameter, double.infinity);
              final topLeft = (totalWidth - topDiameter) / 2;
              final bottomLeft = (totalWidth - bottomRowWidth) / 2;
              final topOverlap = topDiameter * 0.1;
              final totalHeight = topDiameter + bottomDiameter - topOverlap;

              return SizedBox(
                width: totalWidth,
                height: totalHeight,
                child: Stack(
                  children: [
                    // Top avatar
                    Positioned(
                      top: 0,
                      left: topLeft,
                      child: StreamAvatarTheme(
                        data: const StreamAvatarThemeData(size: StreamAvatarSize.md),
                        child: visible.first,
                      ),
                    ),
                    // Bottom row
                    Positioned(
                      top: topDiameter - topOverlap,
                      left: bottomLeft,
                      child: StreamAvatarTheme(
                        data: const StreamAvatarThemeData(size: StreamAvatarSize.sm),
                        child: SizedBox(
                          width: bottomRowWidth,
                          height: bottomDiameter,
                          child: Stack(
                            children: [
                              for (var i = 0; i < rest.length; i++) Positioned(left: i * step, child: rest[i]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: StreamUserAvatarStack(
                users: users,
                size: StreamAvatarStackSize.sm,
                max: 4,
              ),
            ),
          ),
        ),
      );
    },
  );
}

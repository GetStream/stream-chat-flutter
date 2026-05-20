import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:sample_app/widgets/stream_version.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = defaultUsers;

    return Scaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 34,
                bottom: 20,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  height: 40,
                  colorFilter: ColorFilter.mode(
                    context.streamColorScheme.accentPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Text(
                'Welcome to Stream Chat',
                style: context.streamTextTheme.headingLg,
              ),
            ),
            Text(
              'Select a user to try the Flutter SDK:',
              style: context.streamTextTheme.bodyDefault,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ListView.separated(
                  separatorBuilder: (context, i) {
                    return Container(
                      height: 1,
                      color: context.streamColorScheme.borderDefault,
                    );
                  },
                  itemCount: users.length + 1,
                  itemBuilder: (context, i) {
                    return [
                      ...users.entries.map((entry) {
                        final token = entry.key;
                        final user = entry.value;
                        return ListTile(
                          visualDensity: VisualDensity.compact,
                          onTap: () async {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              barrierColor: context.streamColorScheme.backgroundOverlayLight,
                              builder: (context) => Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: context.streamColorScheme.backgroundElevation1,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            );

                            final router = GoRouter.of(context);

                            try {
                              await authController.connect(
                                apiKey: kDefaultStreamApiKey,
                                user: user,
                                token: token,
                              );
                            } finally {
                              // Pop the progress dialog regardless of outcome.
                              router.pop();
                            }

                            // The router's redirect will forward an
                            // Authenticated user to the channel list, but
                            // nudge it along explicitly for snappiness.
                            router.replaceNamed(Routes.CHANNEL_LIST_PAGE.name);
                          },
                          leading: StreamUserAvatar(
                            size: .lg,
                            user: user,
                          ),
                          title: Text(
                            user.name,
                            style: context.streamTextTheme.bodyEmphasis,
                          ),
                          subtitle: Text(
                            'Stream test account',
                            style: context.streamTextTheme.captionDefault.copyWith(
                              color: context.streamColorScheme.textSecondary,
                            ),
                          ),
                          trailing: Icon(
                            context.streamIcons.arrowRight,
                            color: context.streamColorScheme.accentPrimary,
                          ),
                        );
                      }),
                      ListTile(
                        onTap: () => GoRouter.of(context).pushNamed(Routes.ADVANCED_OPTIONS.name),
                        leading: CircleAvatar(
                          backgroundColor: context.streamColorScheme.borderDefault,
                          child: Icon(
                            Icons.settings,
                            color: context.streamColorScheme.textPrimary,
                          ),
                        ),
                        title: Text(
                          'Advanced Options',
                          style: context.streamTextTheme.bodyEmphasis,
                        ),
                        subtitle: Text(
                          'Custom settings',
                          style: context.streamTextTheme.captionDefault.copyWith(
                            color: context.streamColorScheme.textSecondary,
                          ),
                        ),
                        trailing: SvgPicture.asset(
                          'assets/icon_arrow_right.svg',
                          height: 24,
                          width: 24,
                          clipBehavior: Clip.none,
                        ),
                      ),
                    ][i];
                  },
                ),
              ),
            ),
            const StreamVersion(),
          ],
        ),
      ),
    );
  }
}

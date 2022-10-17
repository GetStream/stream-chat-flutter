import 'package:example/state/init_data.dart';
import 'package:example/utils/app_config.dart';
import 'package:example/utils/localizations.dart';
import 'package:example/widgets/stream_version.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../routes/routes.dart';

const kStreamApiKey = 'STREAM_API_KEY';
const kStreamUserId = 'STREAM_USER_ID';
const kStreamToken = 'STREAM_TOKEN';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = defaultUsers;

    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  color: StreamChatTheme.of(context).colorTheme.accentPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13.0),
              child: Text(
                AppLocalizations.of(context).welcomeToStreamChat,
                style: StreamChatTheme.of(context).textTheme.title,
              ),
            ),
            Text(
              '${AppLocalizations.of(context).selectUserToTryFlutterSDK}:',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ListView.separated(
                  separatorBuilder: (context, i) {
                    return Container(
                      height: 1,
                      color: StreamChatTheme.of(context).colorTheme.borders,
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
                              barrierColor: StreamChatTheme.of(context)
                                  .colorTheme
                                  .overlay,
                              builder: (context) => Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: StreamChatTheme.of(context)
                                        .colorTheme
                                        .barsBg,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            );

                            final client =
                                context.read<InitNotifier>().initData!.client;

                            final router = GoRouter.of(context);

                            await client.connectUser(
                              user,
                              token,
                            );

                            if (!kIsWeb) {
                              const secureStorage = FlutterSecureStorage();
                              secureStorage.write(
                                key: kStreamApiKey,
                                value: kDefaultStreamApiKey,
                              );
                              secureStorage.write(
                                key: kStreamUserId,
                                value: user.id,
                              );
                              secureStorage.write(
                                key: kStreamToken,
                                value: token,
                              );
                            }
                            router.replaceNamed(Routes.CHANNEL_LIST_PAGE.name);
                          },
                          leading: StreamUserAvatar(
                            user: user,
                            constraints: BoxConstraints.tight(
                              const Size.fromRadius(20),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style:
                                StreamChatTheme.of(context).textTheme.bodyBold,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context).streamTestAccount,
                            style: StreamChatTheme.of(context)
                                .textTheme
                                .footnote
                                .copyWith(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .textLowEmphasis,
                                ),
                          ),
                          trailing: StreamSvgIcon.arrowRight(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentPrimary,
                          ),
                        );
                      }),
                      ListTile(
                        onTap: () => GoRouter.of(context)
                            .pushNamed(Routes.ADVANCED_OPTIONS.name),
                        leading: CircleAvatar(
                          backgroundColor:
                              StreamChatTheme.of(context).colorTheme.borders,
                          child: StreamSvgIcon.settings(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .textHighEmphasis,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context).advancedOptions,
                          style: StreamChatTheme.of(context).textTheme.bodyBold,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context).customSettings,
                          style: StreamChatTheme.of(context)
                              .textTheme
                              .footnote
                              .copyWith(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .textLowEmphasis,
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

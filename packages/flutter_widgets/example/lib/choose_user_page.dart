import 'package:example/stream_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'routes/routes.dart';

const kStreamApiKey = 'STREAM_API_KEY';
const kStreamUserId = 'STREAM_USER_ID';
const kStreamToken = 'STREAM_TOKEN';
const kDefaultStreamApiKey = 'kv7mcsxr24p8';

class ChooseUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = <String, User>{
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FsdmF0b3JlIn0.pgiJz7sIc7iP29BHKFwe3nLm5-OaR_1l2P-SlgiC9a8':
          User(
        id: 'salvatore',
        extraData: {
          'name': 'Salvatore Giordano',
          'image':
              'https://ca.slack-edge.com/T02RM6X6B-USKK9FFRT-30c415e207a9-512',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FoaWwifQ.WnIUoB5gR2kcAsFhiDvkiD6zdHXZ-VSU2aQWWkhsvfo':
          User(
        id: 'sahil',
        extraData: {
          'name': 'Sahil Kumar',
          'image':
              'https://ca.slack-edge.com/T02RM6X6B-U01EYU51M89-bbc152b40321-512',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYmVuIn0.nAz2sNFGQwY7rl2Og2z3TGHUsdpnN53tOsUglJFvLmg':
          User(
        id: 'ben',
        extraData: {
          'name': 'Ben Golden',
          'image':
              'https://ca.slack-edge.com/T02RM6X6B-U01AXAF23MG-f57403a3cb0d-512',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGhpZXJyeSJ9.lEq6TrZtHzjoNtf7HHRufUPyGo_pa8vg4_XhEBp4ckY':
          User(
        id: 'thierry',
        extraData: {
          'name': 'Thierry Schellenbach',
          'image':
              'https://ca.slack-edge.com/T02RM6X6B-U02RM6X6D-g28a1278a98e-512',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.GLSI0ESshERMo2WjUpysD709NEtn1zmGimUN2an7g9o':
          User(
        id: 'tommaso',
        extraData: {
          'name': 'Tommaso Barbugli',
          'image':
              'https://ca.slack-edge.com/T02RM6X6B-U02U7SJP4-0f65a5997877-512',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZGV2ZW4ifQ.z3zI4PqJnNhc-1o-VKcmb6BnnQ0oxFNCRHwEulHqcWc':
          User(
        id: 'deven',
        extraData: {
          'name': 'Deven Joshi',
          'image':
              'https://ca.slack-edge.com/T02RM6X6B-U01AM7ELPTL-8a60da32704c-512',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibmVldmFzaCJ9.3EdHegTxibrz3A9cTiKmpEyawwcCVB8FXnoFzr4eKvw':
          User(
        id: 'neevash',
        extraData: {
          'name': 'Neevash Ramdial',
          'image':
              'https://ca.slack-edge.com/T02RM6X6B-U01DZ046DS8-b00d321d2880-512',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MSJ9.fnelU7HcP7QoEEsCGteNlF1fppofzNlrnpDQuIgeKCU':
          User(
        id: 'qatest1',
        extraData: {
          'name': 'QA test 1',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MiJ9.vSCqAEbs2WVmMWsOsa7065Fsjq-rsTih6qsHPynl7XM':
          User(
        id: 'qatest2',
        extraData: {
          'name': 'QA test 2',
        },
      ),
    };

    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
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
                  color: StreamChatTheme.of(context).colorTheme.accentBlue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13.0),
              child: Text(
                'Welcome to Stream Chat',
                style: StreamChatTheme.of(context).textTheme.title,
              ),
            ),
            Text(
              'Select a user to try the Flutter SDK:',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ListView.separated(
                  separatorBuilder: (context, i) {
                    return Container(
                      height: 1,
                      color: StreamChatTheme.of(context).colorTheme.greyWhisper,
                    );
                  },
                  itemCount: users.length + 1,
                  itemBuilder: (context, i) {
                    return [
                      ...users.entries.map((entry) {
                        final token = entry.key;
                        final user = entry.value;
                        return ListTile(
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
                                        .white,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            );

                            final secureStorage = FlutterSecureStorage();
                            final client = StreamChat.of(context).client;
                            client.apiKey = kDefaultStreamApiKey;
                            await client.setUser(
                              user,
                              token,
                            );

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
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.HOME,
                              ModalRoute.withName(Routes.HOME),
                            );
                          },
                          leading: UserAvatar(
                            user: user,
                            constraints: BoxConstraints.tight(
                              Size.fromRadius(20),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style:
                                StreamChatTheme.of(context).textTheme.bodyBold,
                          ),
                          subtitle: Text(
                            'Stream test account',
                            style: StreamChatTheme.of(context)
                                .textTheme
                                .footnote
                                .copyWith(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .grey,
                                ),
                          ),
                          trailing: StreamSvgIcon.arrow_right(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentBlue,
                          ),
                        );
                      }),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.ADVANCED_OPTIONS);
                        },
                        leading: CircleAvatar(
                          child: StreamSvgIcon.settings(
                            color: StreamChatTheme.of(context).colorTheme.black,
                          ),
                          backgroundColor: StreamChatTheme.of(context)
                              .colorTheme
                              .greyWhisper,
                        ),
                        title: Text(
                          'Advanced Options',
                          style: StreamChatTheme.of(context).textTheme.bodyBold,
                        ),
                        subtitle: Text(
                          'Custom settings',
                          style: StreamChatTheme.of(context)
                              .textTheme
                              .footnote
                              .copyWith(
                                color:
                                    StreamChatTheme.of(context).colorTheme.grey,
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
            StreamVersion(),
          ],
        ),
      ),
    );
  }
}

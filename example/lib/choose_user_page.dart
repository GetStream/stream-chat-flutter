import 'package:example/advanced_options_page.dart';
import 'package:example/main.dart';
import 'package:example/stream_version.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'notifications_service.dart';
import 'routes/routes.dart';

const kStreamApiKey = 'STREAM_API_KEY';
const kStreamUserId = 'STREAM_USER_ID';
const kStreamToken = 'STREAM_TOKEN';
const kDefaultStreamApiKey = 'uj7qrdbfrzvg';

class ChooseUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = <String, User>{
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmlzaGFsIn0.lCz-idDgaZ-xszjnuB_hTfeIOhTFmJtTB2fEjhwrcCI':
          User(
        id: 'vishal',
        extraData: {
          'name': 'Vishal',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.1AvvK2TvEsfcxAlfOK2iUMFACucnk6N-Q8f5bbfnjCM':
          User(
        id: 'super-band-9',
        extraData: {
          'name': 'John Doe',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FsdmF0b3JlIn0.uQ-pz8e1_C-Df2rIFpkkvWf7g4M0aW2Zkr7pHVhmU1Y':
          User(
        id: 'salvatore',
        extraData: {
          'name': 'Salvatore',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.feLvMytd5_3-eETKrRdwtO3jcA0HxD8woFUbFU7gQCg':
          User(
        id: 'tommaso',
        extraData: {
          'name': 'Tommaso',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiamFhcCJ9.VLkLs6KH-jRRkPvhYMa4_lqN0R6WiK7JhJVmYvxcKz0':
          User(
        id: 'jaap',
        extraData: {
          'name': 'Jaap',
        },
      ),
    };

    users.updateAll(
        (_, value) => value..extraData['image'] = getRandomPicUrl(value));

    return Scaffold(
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
                      width: double.infinity,
                      color: Colors.black12,
                      height: 1,
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
                              builder: (context) => Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
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

                            if (!kIsWeb) {
                              initNotifications(client);
                            }
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
                          trailing: SvgPicture.asset(
                            'assets/icon_arrow_right.svg',
                            height: 24,
                            width: 24,
                          ),
                        );
                      }),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.ADVANCED_OPTIONS);
                        },
                        leading: CircleAvatar(
                          child: StreamSvgIcon.settings(
                            color: Colors.black,
                          ),
                          backgroundColor:
                              StreamChatTheme.of(context).secondaryColor,
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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'main.dart';
import 'notifications_service.dart';

class AdvancedOptionsPage extends StatefulWidget {
  @override
  _AdvancedOptionsPageState createState() => _AdvancedOptionsPageState();
}

class _AdvancedOptionsPageState extends State<AdvancedOptionsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _apiKeyController = TextEditingController();

  final TextEditingController _userIdController = TextEditingController();

  final TextEditingController _userTokenController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: StreamChatTheme.of(context).primaryColor,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Advanced Options',
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
          icon: Icon(
            StreamIcons.left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _apiKeyController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the Chat API Key';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(.5),
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Color(0xffF5F5F5),
                      filled: true,
                      labelText: 'Chat API Key',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _userIdController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the User ID';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color(0xffF5F5F5),
                        filled: true,
                        labelText: 'User ID',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _userTokenController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the user token';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color(0xffF5F5F5),
                        filled: true,
                        labelText: 'User Token',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color(0xffF5F5F5),
                        filled: true,
                        labelText: 'Username (optional)',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        color: StreamChatTheme.of(context).accentColor,
                        minWidth: double.infinity,
                        height: 48,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        onPressed: () async {
                          if (loading) {
                            return;
                          }
                          loading = true;
                          if (_formKey.currentState.validate()) {
                            final apiKey = _apiKeyController.text;
                            final userId = _userIdController.text;
                            final userToken = _userTokenController.text;
                            final username = _usernameController.text;

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

                            print('CREATE CLIENT');
                            final client = Client(
                              apiKey,
                              logLevel: Level.INFO,
                              showLocalNotification:
                                  (!kIsWeb && Platform.isAndroid)
                                      ? showLocalNotification
                                      : null,
                              persistenceEnabled: true,
                            );

                            try {
                              await client.setUser(
                                User(id: userId, extraData: {
                                  'name': username,
                                }),
                                userToken,
                              );
                            } catch (e) {
                              var errorText = 'Error connecting, retry';
                              if (e is Map) {
                                errorText = e['message'] ?? errorText;
                              }
                              Navigator.pop(context);
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorText),
                                ),
                              );
                              loading = false;
                              await client.disconnect();
                              return;
                            }

                            if (!kIsWeb) {
                              initNotifications(client);
                            }

                            Navigator.pop(context);
                            Navigator.pop(context);
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MaterialApp(
                                    theme: ThemeData.light(),
                                    darkTheme: ThemeData.dark(),
                                    //TODO change to system once dark theme is implemented
                                    themeMode: ThemeMode.light,
                                    builder: (context, widget) {
                                      return StreamChat(
                                        child: widget,
                                        client: client,
                                      );
                                    },
                                    home: ChannelListPage(),
                                  );
                                },
                              ),
                            );
                            loading = false;
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:example/stream_version.dart';
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
  String _apiKeyError;

  final TextEditingController _userIdController = TextEditingController();
  String _userIdError;

  final TextEditingController _userTokenController = TextEditingController();
  String _userTokenError;

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
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _apiKeyController,
                    onChanged: (_) {
                      if (_apiKeyError != null) {
                        setState(() {
                          _apiKeyError = null;
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _apiKeyError = 'Please enter the Chat API Key';
                        });
                        return _apiKeyError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 0),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _apiKeyError != null
                            ? Color(0xffff3742)
                            : Colors.black.withOpacity(.5),
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Color(0xffF5F5F5),
                      filled: true,
                      labelText:
                          'Chat API Key ${_apiKeyError != null ? ': $_apiKeyError' : ''}',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _userIdController,
                      onChanged: (_) {
                        if (_userIdError != null) {
                          setState(() {
                            _userIdError = null;
                          });
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _userIdError = 'Please enter the User ID';
                          });
                          return _userIdError;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 0),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _userIdError != null
                              ? Color(0xffff3742)
                              : Colors.black.withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color(0xffF5F5F5),
                        filled: true,
                        labelText:
                            'User ID ${_userIdError != null ? ': $_userIdError' : ''}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      onChanged: (_) {
                        if (_userTokenError != null) {
                          setState(() {
                            _userTokenError = null;
                          });
                        }
                      },
                      controller: _userTokenController,
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _userTokenError = 'Please enter the user token';
                          });
                          return _userTokenError;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 0),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _userTokenError != null
                              ? Color(0xffff3742)
                              : Colors.black.withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color(0xffF5F5F5),
                        filled: true,
                        labelText:
                            'User Token ${_userTokenError != null ? ': $_userTokenError' : ''}',
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
                          fontWeight: FontWeight.bold,
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
                          if (_formKey.currentState.validate()) {
                            final apiKey = _apiKeyController.text;
                            final userId = _userIdController.text;
                            final userToken = _userTokenController.text;
                            final username = _usernameController.text;

                            loading = true;
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
                              setState(() {
                                _apiKeyError = errorText;
                              });
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
                  ),
                  StreamVersion(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:example/routes/routes.dart';
import 'package:example/stream_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'choose_user_page.dart';
import 'main.dart';

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
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: StreamChatTheme.of(context).colorTheme.white,
        elevation: 1,
        centerTitle: true,
        brightness: Theme.of(context).brightness,
        title: Text(
          'Advanced Options',
          style: StreamChatTheme.of(context)
              .textTheme
              .headlineBold
              .copyWith(color: StreamChatTheme.of(context).colorTheme.black),
        ),
        leading: IconButton(
          icon: StreamSvgIcon.left(
            color: StreamChatTheme.of(context).colorTheme.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      color: StreamChatTheme.of(context).colorTheme.black,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _apiKeyError != null
                            ? StreamChatTheme.of(context).colorTheme.accentRed
                            : StreamChatTheme.of(context).colorTheme.grey,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          StreamChatTheme.of(context).colorTheme.whiteSmoke,
                      filled: true,
                      labelText:
                          'Chat API Key ${_apiKeyError != null ? ': $_apiKeyError' : ''}',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
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
                      color: StreamChatTheme.of(context).colorTheme.black,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userIdError != null
                            ? StreamChatTheme.of(context).colorTheme.accentRed
                            : StreamChatTheme.of(context).colorTheme.grey,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          StreamChatTheme.of(context).colorTheme.whiteSmoke,
                      filled: true,
                      labelText:
                          'User ID ${_userIdError != null ? ': $_userIdError' : ''}',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
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
                      color: StreamChatTheme.of(context).colorTheme.black,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userTokenError != null
                            ? StreamChatTheme.of(context).colorTheme.accentRed
                            : StreamChatTheme.of(context).colorTheme.grey,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          StreamChatTheme.of(context).colorTheme.whiteSmoke,
                      filled: true,
                      labelText:
                          'User Token ${_userTokenError != null ? ': $_userTokenError' : ''}',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: StreamChatTheme.of(context).colorTheme.grey,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          StreamChatTheme.of(context).colorTheme.whiteSmoke,
                      filled: true,
                      labelText: 'Username (optional)',
                    ),
                  ),
                  Spacer(),
                  RaisedButton(
                    color: Theme.of(context).brightness == Brightness.light
                        ? StreamChatTheme.of(context).colorTheme.accentBlue
                        : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness != Brightness.light
                            ? StreamChatTheme.of(context).colorTheme.accentBlue
                            : Colors.white,
                      ),
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
                          barrierColor:
                              StreamChatTheme.of(context).colorTheme.overlay,
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

                        final client = StreamChatClient(
                          apiKey,
                          logLevel: Level.INFO,
                        )..chatPersistenceClient = chatPersistentClient;

                        try {
                          await client.setUser(
                            User(id: userId, extraData: {
                              'name': username,
                            }),
                            userToken,
                          );

                          final secureStorage = FlutterSecureStorage();
                          secureStorage.write(
                            key: kStreamApiKey,
                            value: apiKey,
                          );
                          secureStorage.write(
                            key: kStreamUserId,
                            value: userId,
                          );
                          secureStorage.write(
                            key: kStreamToken,
                            value: userToken,
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
                        loading = false;
                        await Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.APP,
                          ModalRoute.withName(Routes.APP),
                          arguments: client,
                        );
                      }
                    },
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

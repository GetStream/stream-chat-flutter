import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/app.dart';
import 'package:sample_app/pages/choose_user_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/init_data.dart';
import 'package:sample_app/widgets/stream_version.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AdvancedOptionsPage extends StatefulWidget {
  const AdvancedOptionsPage({super.key});

  @override
  State<AdvancedOptionsPage> createState() => _AdvancedOptionsPageState();
}

class _AdvancedOptionsPageState extends State<AdvancedOptionsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _apiKeyController = TextEditingController();
  String? _apiKeyError;

  final TextEditingController _userIdController = TextEditingController();
  String? _userIdError;

  final TextEditingController _userTokenController = TextEditingController();
  String? _userTokenError;

  final TextEditingController _usernameController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    _userIdController.dispose();
    _userTokenController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (loading) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      final apiKey = _apiKeyController.text;
      final userId = _userIdController.text;
      final userToken = _userTokenController.text;
      final username = _usernameController.text;

      loading = true;
      showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: StreamChatTheme.of(context).colorTheme.overlay,
        builder: (context) => Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: StreamChatTheme.of(context).colorTheme.barsBg,
            ),
            height: 100,
            width: 100,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      final client = buildStreamChatClient(apiKey);
      final router = GoRouter.of(context);
      final initNotifier = context.read<InitNotifier>();

      try {
        await client.connectUser(
          User(
            id: userId,
            extraData: {
              'name': username,
            },
          ),
          userToken,
        );

        const secureStorage = FlutterSecureStorage();
        await Future.wait([
          secureStorage.write(
            key: kStreamApiKey,
            value: apiKey,
          ),
          secureStorage.write(
            key: kStreamUserId,
            value: userId,
          ),
          secureStorage.write(
            key: kStreamToken,
            value: userToken,
          ),
        ]);
      } catch (e) {
        debugPrint(e.toString());
        var errorText = 'Error connecting, retry';
        if (e is Map) {
          errorText = e['message'] ?? errorText;
        }
        Navigator.of(context).pop();
        setState(() {
          _apiKeyError = errorText.toUpperCase();
        });
        loading = false;
        return;
      }
      loading = false;
      initNotifier.initData = initNotifier.initData!.copyWith(client: client);

      router.goNamed(Routes.CHOOSE_USER.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: AppBar(
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Custom settings',
          style: StreamChatTheme.of(
            context,
          ).textTheme.headlineBold.copyWith(color: StreamChatTheme.of(context).colorTheme.textHighEmphasis),
        ),
        leading: IconButton(
          icon: Icon(context.streamIcons.chevronLeft20),
          color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
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
                      if (value!.isEmpty) {
                        setState(() {
                          _apiKeyError = 'Please enter the Chat API Key'.toUpperCase();
                        });
                        return _apiKeyError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                    ),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _apiKeyError != null
                            ? StreamChatTheme.of(context).colorTheme.accentError
                            : StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: StreamChatTheme.of(context).colorTheme.inputBg,
                      filled: true,
                      labelText: _apiKeyError != null
                          ? '${'Chat API Key'.toUpperCase()}: $_apiKeyError'
                          : 'Chat API Key',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
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
                      if (value!.isEmpty) {
                        setState(() {
                          _userIdError = 'Please enter the User ID'.toUpperCase();
                        });
                        return _userIdError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userIdError != null
                            ? StreamChatTheme.of(context).colorTheme.accentError
                            : StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: StreamChatTheme.of(context).colorTheme.inputBg,
                      filled: true,
                      labelText: _userIdError != null ? '${'User ID'.toUpperCase()}: $_userIdError' : 'User ID',
                    ),
                  ),
                  const SizedBox(height: 8),
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
                      if (value!.isEmpty) {
                        setState(() {
                          _userTokenError = 'Please enter the user token'.toUpperCase();
                        });
                        return _userTokenError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userTokenError != null
                            ? StreamChatTheme.of(context).colorTheme.accentError
                            : StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: StreamChatTheme.of(context).colorTheme.inputBg,
                      filled: true,
                      labelText: _userTokenError != null
                          ? '${'User Token'.toUpperCase()}: $_userTokenError'
                          : 'User Token',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: StreamChatTheme.of(context).colorTheme.inputBg,
                      filled: true,
                      labelText: 'Username (optional)',
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).brightness == Brightness.light
                            ? StreamChatTheme.of(context).colorTheme.accentPrimary
                            : Colors.white,
                      ),
                      elevation: WidgetStateProperty.all<double>(0),
                      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 16)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                    ),
                    onPressed: _login,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness != Brightness.light
                            ? StreamChatTheme.of(context).colorTheme.accentPrimary
                            : Colors.white,
                      ),
                    ),
                  ),
                  const StreamVersion(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

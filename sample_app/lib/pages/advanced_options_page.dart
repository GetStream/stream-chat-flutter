import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../auth/auth_controller.dart';
import '../routes/routes.dart';
import '../utils/app_config.dart';
import '../widgets/stream_version.dart';

class AdvancedOptionsPage extends StatefulWidget {
  const AdvancedOptionsPage({super.key});

  @override
  State<AdvancedOptionsPage> createState() => _AdvancedOptionsPageState();
}

class _AdvancedOptionsPageState extends State<AdvancedOptionsPage> {
  final _formKey = GlobalKey<FormState>();

  // Prefilled with the configured app so pointing the sample app at another
  // backend only needs a user id and token typed in.
  final TextEditingController _apiKeyController = TextEditingController(text: kDefaultStreamApiKey);
  String? _apiKeyError;

  final TextEditingController _userIdController = TextEditingController();
  String? _userIdError;

  final TextEditingController _userTokenController = TextEditingController();
  String? _userTokenError;

  final TextEditingController _usernameController = TextEditingController();

  // Lets an already-built deployment (the web demo) be pointed at another
  // environment without recompiling.
  final TextEditingController _baseUrlController = TextEditingController(text: kStreamBaseUrl);

  bool loading = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    _userIdController.dispose();
    _userTokenController.dispose();
    _usernameController.dispose();
    _baseUrlController.dispose();
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
      final baseUrl = _baseUrlController.text.trim();

      loading = true;
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
          apiKey: apiKey,
          user: User(
            id: userId,
            extraData: {
              'name': username,
            },
          ),
          token: userToken,
          baseUrl: baseUrl.isEmpty ? null : baseUrl,
        );
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
      router.goNamed(Routes.CHOOSE_USER.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamScaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Custom settings')),
      body: Builder(
        builder: (context) {
          final topInset = MediaQuery.paddingOf(context).top;
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 16 + topInset, 16, 0),
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
                      color: context.streamColorScheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _apiKeyError != null
                            ? context.streamColorScheme.accentError
                            : context.streamColorScheme.textSecondary,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: context.streamColorScheme.backgroundSurface,
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
                      color: context.streamColorScheme.textPrimary,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userIdError != null
                            ? context.streamColorScheme.accentError
                            : context.streamColorScheme.textSecondary,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: context.streamColorScheme.backgroundSurface,
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
                      color: context.streamColorScheme.textPrimary,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userTokenError != null
                            ? context.streamColorScheme.accentError
                            : context.streamColorScheme.textSecondary,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: context.streamColorScheme.backgroundSurface,
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
                        color: context.streamColorScheme.textSecondary,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: context.streamColorScheme.backgroundSurface,
                      filled: true,
                      labelText: 'Username (optional)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _baseUrlController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.streamColorScheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.streamColorScheme.textSecondary,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: context.streamColorScheme.backgroundSurface,
                      filled: true,
                      labelText: 'Base URL (optional)',
                      hintText: 'https://chat.stream-io-api.com',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: context.streamColorScheme.textTertiary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).brightness == Brightness.light
                            ? context.streamColorScheme.accentPrimary
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
                            ? context.streamColorScheme.accentPrimary
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

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../auth/auth_controller.dart';
import '../auth/users.dart';

/// The start page: picks the user to log in as.
class ChooseUserPage extends StatefulWidget {
  const ChooseUserPage({super.key});

  @override
  State<ChooseUserPage> createState() => _ChooseUserPageState();
}

class _ChooseUserPageState extends State<ChooseUserPage> {
  Object? _error;

  Future<void> _login(E2eUser user) async {
    setState(() => _error = null);
    try {
      await authController.connect(user: user.toUser(), token: user.token);
    } catch (error) {
      // Shown rather than rethrown: an uncaught error would fail whichever
      // test happens to be running when it lands.
      if (mounted) setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Welcome to Stream Chat', style: textTheme.headingLg),
            const SizedBox(height: 8),
            const Text('Select a user to log in as:'),
            const SizedBox(height: 16),
            for (final user in e2eUsers)
              ListTile(
                leading: StreamUserAvatar(size: .md, user: user.toUser(), showOnlineIndicator: false),
                title: Text(user.name),
                onTap: () => _login(user),
              ),
            if (_error case final error?) Text('Login failed: $error'),
          ],
        ),
      ),
    );
  }
}

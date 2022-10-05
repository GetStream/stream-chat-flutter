import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template errorAlertSheet}
/// A bottom sheet that displays when an error occurs.
///
/// Should only be used on mobile platforms.
/// {@endtemplate}
class ErrorAlertSheet extends StatelessWidget {
  /// {@macro errorAlertSheet}
  const ErrorAlertSheet({
    super.key,
    required this.errorDescription,
  });

  /// The description of the error.
  final String errorDescription;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 26,
        ),
        StreamSvgIcon.error(
          color: _streamChatTheme.colorTheme.accentError,
          size: 24,
        ),
        const SizedBox(
          height: 26,
        ),
        Text(
          context.translations.somethingWentWrongError,
          style: _streamChatTheme.textTheme.headlineBold,
        ),
        const SizedBox(
          height: 7,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            errorDescription,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        Container(
          color: _streamChatTheme.colorTheme.textHighEmphasis.withOpacity(0.08),
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                context.translations.okLabel,
                style: _streamChatTheme.textTheme.bodyBold.copyWith(
                  color: _streamChatTheme.colorTheme.accentPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
